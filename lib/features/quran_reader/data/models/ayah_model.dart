import '../../domain/entities/ayah_entity.dart';

class AyahModel extends AyahEntity {
  AyahModel({
    required super.id,
    required super.surahNumber,
    required super.ayahNumber,
    required super.text_uthmani,
    required super.audioUrl,
    required super.page,
  });

  factory AyahModel.fromJson(Map<String, dynamic> json) {
    return AyahModel(
      id: json['id'] as int,
      surahNumber: json['surah_number'] as int,
      ayahNumber: json['ayah_number'] as int,
      text_uthmani: json['text_uthmani'] as String,
      audioUrl: json['audio_url'] as String,
      page: json['page'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'surah_number': surahNumber,
      'ayah_number': ayahNumber,
      'text_uthmani': text_uthmani,
      'audio_url': audioUrl,
      'page': page,
    };
  }
}
