import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:collection/collection.dart';
import '../../domain/usecases/get_surah_usecase.dart';
import 'quran_state.dart';

class QuranProvider extends ChangeNotifier {
  final GetSurahUseCase getSurahUseCase;
  final AudioPlayer audioPlayer;

  QuranState _state = QuranState();
  QuranState get state => _state;

  QuranProvider({required this.getSurahUseCase, required this.audioPlayer}) {
    _initAudioListener();
  }

  void _initAudioListener() {
    // Écoute la position de l'audio pour le surlignage
    audioPlayer.positionStream.listen((position) {
      _updateHighlight(position);
    });

    // Écoute l'état de lecture (pour mettre à jour l'icône Play/Pause automatiquement)
    audioPlayer.playerStateStream.listen((playerState) {
      notifyListeners();
    });
  }

  Future<void> loadSurah(int surahNumber) async {
    // 1. Reset l'état et arrêter l'audio précédent
    if (audioPlayer.playing) await audioPlayer.stop();

    _state = _state.copyWith(
      isLoading: true,
      currentAyahId: null, // Reset du surlignage
      ayahs: [],
    );
    notifyListeners();

    try {
      // 2. Charger les données JSON via le UseCase
      final result = await getSurahUseCase.execute(surahNumber);

      // 3. Formater le numéro de sourate en 3 chiffres (ex: 1 -> 001)
      String audioId = surahNumber.toString().padLeft(3, '0');

      // 4. Configurer l'URL audio dynamique (Recitateur Al-Afasy)
      await audioPlayer.setUrl(
        "https://download.quranicaudio.com/qdc/mishari_rashid_al_afasy/murattal/$audioId.mp3",
      );

      _state = _state.copyWith(ayahs: result, isLoading: false);
      notifyListeners();
    } catch (e) {
      debugPrint("Erreur chargement sourate: $e");
      _state = _state.copyWith(isLoading: false);
      notifyListeners();
    }
  }

  void _updateHighlight(Duration currentPosition) {
    // On cherche l'ayah dont l'intervalle startTime/endTime englobe la position actuelle
    final activeAyah = _state.ayahs.firstWhereOrNull(
      (a) => currentPosition >= a.startTime && currentPosition <= a.endTime,
    );

    if (activeAyah != null && activeAyah.id != _state.currentAyahId) {
      _state = _state.copyWith(currentAyahId: activeAyah.id);
      notifyListeners();
    }
  }

  void playPause() {
    if (audioPlayer.playing) {
      audioPlayer.pause();
    } else {
      audioPlayer.play();
    }
    // notifyListeners() est déjà appelé par le playerStateStream
  }

  void seekToAyah(int ayahId) {
    final target = _state.ayahs.firstWhereOrNull((a) => a.id == ayahId);
    if (target != null) {
      audioPlayer.seek(target.startTime);
      audioPlayer.play();
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }
}
