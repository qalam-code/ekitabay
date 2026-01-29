import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

void main() async {
  print('📚 Génération de l\'index des sourates...');

  final response = await http.get(
    Uri.parse('https://api.alquran.cloud/v1/surah'),
  );

  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body)['data'];

    final List surahIndex = data.map((s) {
      return {
        "number": s['number'],
        "name": s['name'], // Nom en arabe (ex: سُورَةُ ٱلْفَاتِحَةِ)
        "englishName": s['englishName'], // Nom translittéré (ex: Al-Faatiha)
        "frenchName": s['englishNameTranslation'], // À défaut, on prend la trad
        "revelationType": s['revelationType'] == 'Meccan'
            ? 'Mecquoise'
            : 'Médinoise',
        "numberOfAyahs": s['numberOfAyahs'],
      };
    }).toList();

    final file = File('assets/data/surahs.json');
    await file.writeAsString(jsonEncode(surahIndex));
    print('✅ Index généré dans assets/data/surahs.json');
  } else {
    print('❌ Erreur lors de la récupération de l\'index');
  }
}
