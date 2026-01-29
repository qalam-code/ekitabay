import 'dart:convert';
import 'package:flutter/services.dart';
import '../entities/ayah_entity.dart';
import '../../data/models/ayah_model.dart';

class GetSurahUseCase {
  // Cette fonction charge le fichier JSON depuis les assets
  Future<List<AyahEntity>> execute(int surahNumber) async {
    try {
      // 1. Charger le contenu du fichier JSON correspondant à la sourate
      final String response =
          await rootBundle.loadString('assets/data/surah_$surahNumber.json');

      // 2. Décoder le JSON
      final List<dynamic> data = json.decode(response);

      // 3. Convertir chaque élément du JSON en AyahModel (qui hérite de AyahEntity)
      return data.map((json) => AyahModel.fromJson(json)).toList();
    } catch (e) {
      print("Erreur lors du chargement de la sourate $surahNumber: $e");
      // En cas d'erreur (ex: fichier manquant), on retourne une liste vide
      return [];
    }
  }
}
