import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ekitabay/features/quran_reader/presentation/pages/home_page.dart';
import 'package:ekitabay/features/quran_reader/presentation/providers/quran_provider.dart';
import 'package:ekitabay/injection_container.dart';

void main() async {
  // Indispensable pour l'accès aux assets et aux plugins (Audio/PathProvider)
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation du Service Locator (GetIt)
  await init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // On récupère l'instance du Provider déjà injectée par GetIt
        ChangeNotifierProvider(create: (_) => sl<QuranProvider>()),
      ],
      child: MaterialApp(
        title: 'Ekitabay',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          // Couleur principale : Vert de Médine
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF006437),
            primary: const Color(0xFF006437),
            secondary: const Color(0xFFB8965B), // Or pour les ornements
          ),
          fontFamily: 'UthmanicHafs',
          // Amélioration du rendu des textes par défaut
          textTheme: const TextTheme(
            bodyLarge: TextStyle(fontSize: 18),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF006437),
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
          ),
        ),
        home: const HomePage(),
      ),
    );
  }
}
