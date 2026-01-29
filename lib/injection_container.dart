import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'features/quran_reader/domain/usecases/get_surah_usecase.dart';
import 'features/quran_reader/presentation/providers/quran_provider.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // --- Presentation Layer (Providers) ---
  // On utilise factory pour que le provider soit recréé si nécessaire
  sl.registerFactory(
    () => QuranProvider(
      getSurahUseCase: sl(),
      audioPlayer: sl(),
    ),
  );

  // --- Domain Layer (Use Cases) ---
  // Le UseCase s'occupe maintenant de la lecture des assets JSON
  sl.registerLazySingleton(() => GetSurahUseCase());

  // --- External ---
  // Instance unique d'AudioPlayer pour toute l'application
  sl.registerLazySingleton(() => AudioPlayer());
}
