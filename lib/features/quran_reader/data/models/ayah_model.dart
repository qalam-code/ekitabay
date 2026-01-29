// lib/features/quran_reader/data/models/ayah_model.dart
import '../../domain/entities/ayah_entity.dart';

class AyahModel extends AyahEntity {
  AyahModel({
    required super.id,
    required super.surahNumber,
    required super.ayahNumber,
    required super.text,
    required super.startTime,
    required super.endTime,
  });

  factory AyahModel.fromJson(Map<String, dynamic> json) {
    return AyahModel(
      id: json['id'],
      surahNumber: json['surah_number'],
      ayahNumber: json['ayah_number'],
      text: json['text_uthmani'],
      // On convertit les millisecondes du JSON en Duration
      startTime: Duration(milliseconds: json['start_time']),
      endTime: Duration(milliseconds: json['end_time']),
    );
  }
}
