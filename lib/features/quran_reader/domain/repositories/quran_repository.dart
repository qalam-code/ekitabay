import '../entities/ayah_entity.dart';

abstract class QuranRepository {
  Future<List<AyahEntity>> getSurah(int surahNumber);
}
