import 'package:ekitabay/features/quran_reader/domain/entities/ayah_entity.dart';

/// Le Domaine définit ce dont il a besoin.
/// La couche Data devra retourner des modèles qui héritent de AyahEntity.
abstract class QuranRemoteDataSource {
  Future<List<AyahEntity>> getSurah(int surahNumber);
}
