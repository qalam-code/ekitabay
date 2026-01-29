import 'package:ekitabay/features/quran_reader/data/models/surah_model.dart';
import 'package:flutter/material.dart';

class SurahTile extends StatelessWidget {
  final SurahModel surah;
  final VoidCallback onTap;

  const SurahTile({super.key, required this.surah, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          // Une forme qui rappelle le Rub el Hizb
          color: const Color(0xFF006437).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF006437), width: 1),
        ),
        child: Center(
          child: Text(
            '${surah.number}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF006437),
            ),
          ),
        ),
      ),
      title: Text(
        surah.frenchName,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
      subtitle: Text(
        "${surah.revelationType} • ${surah.numberOfAyahs} versets",
        style: TextStyle(color: Colors.grey[600], fontSize: 12),
      ),
      trailing: Text(
        surah.name,
        style: const TextStyle(
          fontFamily: 'UthmanicHafs',
          fontSize: 20,
          color: Color(0xFF006437),
        ),
      ),
    );
  }
}
