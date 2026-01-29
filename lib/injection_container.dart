import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'features/quran_reader/data/datasources/quran_remote_data_source_impl.dart';
import 'features/quran_reader/data/repositories/quran_repository_impl.dart';
import 'features/quran_reader/domain/datasources/quran_remote_data_source.dart';
import 'features/quran_reader/domain/repositories/quran_repository.dart';
import 'features/quran_reader/domain/usecases/get_surah_usecase.dart';
import 'features/quran_reader/presentation/providers/quran_provider.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Provider
  sl.registerFactory(
    () => QuranProvider(getSurahUseCase: sl(), audioPlayer: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetSurahUseCase(sl()));

  // Repository
  sl.registerLazySingleton<QuranRepository>(
    () => QuranRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Source
  sl.registerLazySingleton<QuranRemoteDataSource>(
    () => QuranRemoteDataSourceImpl(),
  );

  // External
  sl.registerLazySingleton(() => AudioPlayer());
}
