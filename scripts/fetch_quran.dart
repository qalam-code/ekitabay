import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

void main() async {
  const reciterId = 7; // 7 = Alafasy

  for (int i = 1; i <= 114; i++) {
    print('⏳ Traitement Sourate $i...');

    // 1. Récupérer le texte Uthmani
    final textRes = await http.get(
      Uri.parse('https://api.alquran.cloud/v1/surah/$i/quran-uthmani'),
    );

    // 2. Récupérer les timings (Quran.com)
    final timeRes = await http.get(
      Uri.parse(
        'https://api.qurancdn.com/api/qdc/audio/reciters/$reciterId/audio_files?chapter=$i&segments=true',
      ),
    );

    if (textRes.statusCode == 200 && timeRes.statusCode == 200) {
      final textData = jsonDecode(textRes.body)['data']['ayahs'];
      final timeData = jsonDecode(
        timeRes.body,
      )['audio_files'][0]['verse_timings'];

      List finalAyahs = [];

      for (int j = 0; j < textData.length; j++) {
        finalAyahs.add({
          "id": textData[j]['number'],
          "surah_number": i,
          "ayah_number": textData[j]['numberInSurah'],
          "text_uthmani": textData[j]['text'],
          // Quran.com donne timestamp_from et timestamp_to en ms
          "start_time": timeData[j]['timestamp_from'],
          "end_time": timeData[j]['timestamp_to'],
        });
      }

      final file = File('assets/data/surah_$i.json');
      await file.create(recursive: true);
      await file.writeAsString(jsonEncode(finalAyahs));
      print('✅ Sourate $i enregistrée avec succès.');
    }
  }
}
