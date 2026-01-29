import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../../domain/entities/ayah_entity.dart';
import '../../domain/usecases/get_surah_usecase.dart';
import 'quran_state.dart';

class QuranProvider extends ChangeNotifier {
  final GetSurahUseCase getSurahUseCase;
  final AudioPlayer audioPlayer;
  double _fontSize = 22.0; // Taille par défaut
  double get fontSize => _fontSize;

  QuranState _state = QuranState();
  QuranState get state => _state;

  QuranProvider({required this.getSurahUseCase, required this.audioPlayer}) {
    _initAudioListeners();
  }

  void updateFontSize(double newSize) {
    _fontSize = newSize;
    notifyListeners();
  }

  void _initAudioListeners() {
    // Synchronise le surlignage avec l'index de la playlist
    audioPlayer.currentIndexStream.listen((index) {
      if (index != null && _state.ayahs.isNotEmpty) {
        final currentAyah = _state.ayahs[index];
        _state = _state.copyWith(currentAyahId: currentAyah.id);
        notifyListeners();
      }
    });

    // Notifie les changements d'état (play/pause) pour l'UI
    audioPlayer.playerStateStream.listen((_) => notifyListeners());
  }

  Future<void> loadSurah(int surahNumber) async {
    _state = _state.copyWith(isLoading: true, ayahs: []);
    notifyListeners();

    try {
      final ayahs = await getSurahUseCase.execute(surahNumber);

      // Préparation des sources audio avec Cache intelligent
      List<AudioSource> audioSources = [];
      for (var ayah in ayahs) {
        // Vérifie si le fichier est déjà en cache, sinon LockCaching le télécharge pendant l'écoute
        audioSources.add(LockCachingAudioSource(Uri.parse(ayah.audioUrl)));
      }

      // Utilisation de la méthode non-dépréciée pour définir la playlist
      final playlist = ConcatenatingAudioSource(
        useLazyPreparation: true,
        children: audioSources,
      );

      await audioPlayer.setAudioSource(playlist);

      _state = _state.copyWith(ayahs: ayahs, isLoading: false);
      notifyListeners();
    } catch (e) {
      _state = _state.copyWith(isLoading: false);
      notifyListeners();
      debugPrint("Erreur chargement sourate: $e");
    }
  }

  void playPause() {
    audioPlayer.playing ? audioPlayer.pause() : audioPlayer.play();
  }

  void seekToAyah(int ayahId) {
    final index = _state.ayahs.indexWhere((a) => a.id == ayahId);
    if (index != -1) {
      audioPlayer.seek(Duration.zero, index: index);
      audioPlayer.play();
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  void nextAyah() {
    if (audioPlayer.hasNext) {
      audioPlayer.seekToNext();
    }
  }

  void previousAyah() {
    if (audioPlayer.hasPrevious) {
      audioPlayer.seekToPrevious();
    }
  }

  void stopAudio() {
    audioPlayer.stop();
    _state = _state.copyWith(
        currentAyahId: null); // Optionnel : enlève le surlignage
    notifyListeners();
  }
}
