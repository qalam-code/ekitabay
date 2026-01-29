class AyahEntity {
  final int id;
  final int surahNumber;
  final int ayahNumber;
  final String text_uthmani;
  final String audioUrl; // Nouvelle propriété
  final int page; // Pour le rendu par page plus tard

  AyahEntity({
    required this.id,
    required this.surahNumber,
    required this.ayahNumber,
    required this.text_uthmani,
    required this.audioUrl,
    required this.page,
  });
}
