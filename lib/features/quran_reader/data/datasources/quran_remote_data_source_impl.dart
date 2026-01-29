import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/datasources/quran_remote_data_source.dart';
import '../models/ayah_model.dart';

class QuranRemoteDataSourceImpl implements QuranRemoteDataSource {
  @override
  Future<List<AyahModel>> getSurah(int surahNumber) async {
    // Simulation d'un délai réseau
    await Future.delayed(const Duration(milliseconds: 500));

    // Lecture du fichier JSON local
    final String response = await rootBundle.loadString(
      'assets/data/surah_$surahNumber.json',
    );
    final List<dynamic> data = json.decode(response);

    return data.map((json) => AyahModel.fromJson(json)).toList();
  }
}
