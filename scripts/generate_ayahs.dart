import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

void main() async {
  // On boucle sur les 114 sourates
  for (int i = 1; i <= 114; i++) {
    print('⏳ Téléchargement de la sourate $i...');

    // On utilise l'édition 'ar.alafasy' pour avoir les URLs audio par verset directement
    final response = await http.get(
      Uri.parse('https://api.alquran.cloud/v1/surah/$i/ar.alafasy'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      final List ayahsData = data['ayahs'];

      final List finalAyahs = ayahsData.map((ayah) {
        return {
          "id": ayah['number'], // ID unique dans tout le Coran
          "surah_number": i,
          "ayah_number": ayah['numberInSurah'],
          "text_uthmani": ayah['text'],
          "audio_url": ayah['audio'], // URL MP3 individuelle pour ce verset
          "page": ayah['page'], // Numéro de page (Crucial pour le rendu Médine)
        };
      }).toList();

      // Sauvegarde dans un fichier séparé pour chaque sourate
      final file = File('assets/data/surah_$i.json');
      await file.create(recursive: true);
      await file.writeAsString(jsonEncode(finalAyahs));

      print('✅ Sourate $i générée !');
    } else {
      print('❌ Erreur pour la sourate $i');
    }

    // Petite pause pour ne pas saturer l'API
    await Future.delayed(const Duration(milliseconds: 500));
  }
  print('🚀 Terminé ! Tous les fichiers de versets sont prêts.');
}
