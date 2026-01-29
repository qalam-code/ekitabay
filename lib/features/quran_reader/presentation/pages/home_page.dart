import 'dart:convert';
import 'package:ekitabay/features/quran_reader/data/models/surah_model.dart';
import 'package:ekitabay/features/quran_reader/presentation/widgets/surah_tile.dart';
import 'package:ekitabay/features/quran_reader/presentation/pages/quran_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<List<SurahModel>> _loadSurahs() async {
    final String response = await rootBundle.loadString(
      'assets/data/surahs.json',
    );
    final List data = json.decode(response);
    return data.map((s) => SurahModel.fromJson(s)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ekitabay', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF006437), // Vert Médine
        centerTitle: true,
      ),
      body: FutureBuilder<List<SurahModel>>(
        future: _loadSurahs(),
        builder: (context, snapshot) {
          // 1. Gestion du chargement
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF006437)),
            );
          }

          // 2. Gestion des erreurs (très important pour le debug)
          if (snapshot.hasError) {
            return Center(
              child: Text("Erreur de chargement : ${snapshot.error}"),
            );
          }

          // 3. Vérification de la présence effective de données
          if (!snapshot.hasData ||
              snapshot.data == null ||
              snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "Aucune sourate trouvée. Vérifiez le fichier surahs.json",
              ),
            );
          }

          // 4. Si tout est OK, on peut utiliser le "!" en toute sécurité
          final surahs = snapshot.data!;

          return ListView.separated(
            itemCount: surahs.length,
            separatorBuilder: (context, index) =>
                const Divider(height: 1, color: Colors.black12),
            itemBuilder: (context, index) {
              return SurahTile(
                surah: surahs[index],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuranPage(
                        surahId: surahs[index].number,
                        surahName: surahs[index].frenchName,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
