import 'package:ekitabay/features/quran_reader/domain/entities/ayah_entity.dart';

class QuranState {
  final List<AyahEntity> ayahs;
  final int currentAyahId; // L'ID du verset à colorer
  final bool isLoading;

  QuranState({
    this.ayahs = const [],
    this.currentAyahId = -1,
    this.isLoading = false,
  });

  // Pour mettre à jour l'état sans perdre les données précédentes
  QuranState copyWith({
    List<AyahEntity>? ayahs,
    int? currentAyahId,
    bool? isLoading,
  }) {
    return QuranState(
      ayahs: ayahs ?? this.ayahs,
      currentAyahId: currentAyahId ?? this.currentAyahId,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
