import 'package:ekitabay/features/quran_reader/presentation/pages/home_page.dart'; // Import de la HomePage
import 'package:ekitabay/features/quran_reader/presentation/providers/quran_provider.dart';
import 'package:ekitabay/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation des dépendances (GetIt)
  await init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => sl<QuranProvider>())],
      child: MaterialApp(
        title: 'ekitabay',
        debugShowCheckedModeBanner: false, // On enlève la bannière debug
        theme: ThemeData(
          primarySwatch: Colors.green,
          useMaterial3: true,
          fontFamily: 'UthmanicHafs', // Police globale pour l'arabe
        ),
        // On définit la HomePage comme écran de démarrage
        home: const HomePage(),
      ),
    );
  }
}
