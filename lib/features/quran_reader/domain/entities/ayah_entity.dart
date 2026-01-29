class AyahEntity {
  final int id;
  final int surahNumber;
  final int ayahNumber;
  final String text;
  final Duration startTime;
  final Duration endTime;

  AyahEntity({
    required this.id,
    required this.surahNumber,
    required this.ayahNumber,
    required this.text,
    required this.startTime,
    required this.endTime,
  });
}
