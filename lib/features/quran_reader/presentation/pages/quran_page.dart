import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quran_provider.dart';

class QuranPage extends StatefulWidget {
  final int surahId;
  final String surahName;

  const QuranPage({super.key, required this.surahId, required this.surahName});

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  @override
  void initState() {
    super.initState();
    // Charge la sourate spécifique passée depuis la HomePage
    Future.microtask(
      () => context.read<QuranProvider>().loadSurah(widget.surahId),
    );
  }

  // Fonction pour convertir les chiffres en Arabe (pour les fins de versets)
  String _toArabicNumbers(int input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    String str = input.toString();
    for (int i = 0; i < english.length; i++) {
      str = str.replaceAll(english[i], arabic[i]);
    }
    return str;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF8), // Couleur papier crème léger
      appBar: AppBar(
        title: Text(
          widget.surahName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF006437),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Consumer<QuranProvider>(
        builder: (context, provider, child) {
          if (provider.state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF006437)),
            );
          }

          return Column(
            children: [
              // Zone de texte du Mushaf
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 30,
                  ),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        style: const TextStyle(
                          fontFamily: 'UthmanicHafs',
                          fontSize: 26,
                          color: Colors.black87,
                          height: 2.3,
                        ),
                        children: provider.state.ayahs.map((ayah) {
                          final isCurrent =
                              provider.state.currentAyahId == ayah.id;

                          return TextSpan(
                            // Utilisation de text_uthmani et ayahNumber
                            text:
                                "${ayah.text} \uFD3F${_toArabicNumbers(ayah.ayahNumber)}\uFD3E ",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => provider.seekToAyah(ayah.id),
                            style: TextStyle(
                              backgroundColor: isCurrent
                                  ? const Color(0xFF006437).withOpacity(0.2)
                                  : Colors.transparent,
                              fontWeight: isCurrent
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),

              // Barre de contrôle audio
              _buildControlBar(provider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildControlBar(QuranProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Affichage du verset actuel
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "VERSET",
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  _toArabicNumbers(provider.state.currentAyahId ?? 1),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF006437),
                  ),
                ),
              ],
            ),

            // Bouton Play/Pause
            GestureDetector(
              onTap: () => provider.playPause(),
              child: Container(
                height: 60,
                width: 60,
                decoration: const BoxDecoration(
                  color: Color(0xFF006437),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  provider.audioPlayer.playing
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),

            // Bouton pour revenir à la liste
            IconButton(
              icon: const Icon(Icons.format_list_bulleted, color: Colors.grey),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
