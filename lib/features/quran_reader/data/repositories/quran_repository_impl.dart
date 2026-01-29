import 'package:ekitabay/features/quran_reader/domain/datasources/quran_remote_data_source.dart';
import 'package:ekitabay/features/quran_reader/domain/entities/ayah_entity.dart';
import 'package:ekitabay/features/quran_reader/domain/repositories/quran_repository.dart';

class QuranRepositoryImpl implements QuranRepository {
  final QuranRemoteDataSource remoteDataSource;

  QuranRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<AyahEntity>> getSurah(int surahNumber) async {
    return await remoteDataSource.getSurah(surahNumber);
  }
}
