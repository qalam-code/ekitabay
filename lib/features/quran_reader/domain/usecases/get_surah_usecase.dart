import '../entities/ayah_entity.dart';
import '../repositories/quran_repository.dart';

class GetSurahUseCase {
  final QuranRepository repository;

  GetSurahUseCase(this.repository);

  Future<List<AyahEntity>> execute(int surahNumber) {
    return repository.getSurah(surahNumber);
  }
}
