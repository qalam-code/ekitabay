import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quran_provider.dart';
import 'package:collection/collection.dart'; // Import indispensable

class QuranPage extends StatefulWidget {
  final int surahId;
  final String surahName;

  const QuranPage({super.key, required this.surahId, required this.surahName});

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    Future.microtask(
      () => context.read<QuranProvider>().loadSurah(widget.surahId),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF8),
      appBar: AppBar(
        title: Text(widget.surahName,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF006437),
        elevation: 0,
      ),
      body: Consumer<QuranProvider>(
        builder: (context, provider, child) {
          if (provider.state.isLoading) {
            return const Center(
                child: CircularProgressIndicator(color: Color(0xFF006437)));
          }

          // Regroupement par page
          final Map<int, List<dynamic>> pagesMap = {};
          for (var ayah in provider.state.ayahs) {
            pagesMap.putIfAbsent(ayah.page, () => []).add(ayah);
          }
          final pageKeys = pagesMap.keys.toList()..sort();

          // Auto-Sync PageView avec l'audio
          if (provider.state.currentAyahId != null &&
              provider.state.ayahs.isNotEmpty) {
            // firstWhereOrNull est parfait ici : il renvoie null si rien n'est trouvé sans planter
            final currentAyah = provider.state.ayahs.firstWhereOrNull(
              (a) => a.id == provider.state.currentAyahId,
            );

            if (currentAyah != null) {
              final targetPageIndex = pageKeys.indexOf(currentAyah.page);

              if (_pageController.hasClients &&
                  targetPageIndex != -1 &&
                  _pageController.page?.round() != targetPageIndex) {
                Future.microtask(() {
                  if (_pageController.hasClients) {
                    // Double vérification par sécurité
                    _pageController.animateToPage(
                      targetPageIndex,
                      duration: const Duration(milliseconds: 700),
                      curve: Curves.easeInOut,
                    );
                  }
                });
              }
            }
          }
          return Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  reverse: true,
                  itemCount: pageKeys.length,
                  itemBuilder: (context, index) {
                    final pageNumber = pageKeys[index];
                    return _buildMushafPageFrame(
                        pagesMap[pageNumber]!, pageNumber, provider);
                  },
                ),
              ),
              _buildControlBar(provider),
            ],
          );
        },
      ),
    );
  }

  // --- RENDU DU CADRE ET TEXTE ---

  Widget _buildMushafPageFrame(
      List<dynamic> ayahs, int pageNumber, QuranProvider provider) {
    final bool isFirstPageOfSurah = ayahs.any((a) => a.ayahNumber == 1);

    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFB8965B), width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFB8965B), width: 0.5),
        ),
        child: Column(
          children: [
            _buildSuraHeader(widget.surahName),
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    children: [
                      if (isFirstPageOfSurah)
                        _buildBismillah(ayahs.first.surahNumber),
                      Text.rich(
                        TextSpan(
                          children: ayahs.map((ayah) {
                            final isCurrent =
                                provider.state.currentAyahId == ayah.id;
                            return TextSpan(
                              children: [
                                TextSpan(
                                  text: "${ayah.text_uthmani} ",
                                  style: TextStyle(
                                    fontFamily: 'UthmanicHafs',
                                    fontSize: provider.fontSize,
                                    height: 2.3,
                                    color: Colors.black,
                                    backgroundColor: isCurrent
                                        ? const Color(0xFF006437)
                                            .withOpacity(0.15)
                                        : Colors.transparent,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap =
                                        () => provider.seekToAyah(ayah.id),
                                ),
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Text(
                                    " \uFD3F${_toArabicNumbers(ayah.ayahNumber)}\uFD3E ",
                                    style: TextStyle(
                                      fontFamily: 'UthmanicHafs',
                                      fontSize: provider.fontSize * 0.8,
                                      color: const Color(0xFFB8965B),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(_toArabicNumbers(pageNumber),
                  style:
                      const TextStyle(color: Color(0xFFB8965B), fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }

  // --- ELEMENTS ORNEMENTAUX ---

  Widget _buildSuraHeader(String name) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      padding: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFF4EDE2),
        border: Border.symmetric(
            horizontal: BorderSide(color: const Color(0xFFB8965B), width: 1)),
      ),
      child: Text(
        "سُورَةُ $name",
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontFamily: 'UthmanicHafs', fontSize: 18, color: Color(0xFF8B6E3D)),
      ),
    );
  }

  Widget _buildBismillah(int surahNum) {
    if (surahNum == 1 || surahNum == 9) return const SizedBox.shrink();
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Text(
        "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ",
        textAlign: TextAlign.center,
        style: TextStyle(fontFamily: 'UthmanicHafs', fontSize: 26),
      ),
    );
  }

  // --- BARRE DE CONTROLE ---

  Widget _buildControlBar(QuranProvider provider) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20, top: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                const Icon(Icons.text_format, size: 18, color: Colors.grey),
                Expanded(
                  child: Slider(
                    value: provider.fontSize,
                    min: 18,
                    max: 34,
                    activeColor: const Color(0xFF006437),
                    onChanged: (v) => provider.updateFontSize(v),
                  ),
                ),
                Text(provider.fontSize.toInt().toString(),
                    style: const TextStyle(fontSize: 10)),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  icon: const Icon(Icons.skip_previous_rounded, size: 35),
                  onPressed: provider.previousAyah),
              IconButton(
                  icon: const Icon(Icons.stop_rounded,
                      size: 35, color: Colors.red),
                  onPressed: provider.stopAudio),
              IconButton(
                icon: Icon(provider.audioPlayer.playing
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_filled),
                iconSize: 65,
                color: const Color(0xFF006437),
                onPressed: provider.playPause,
              ),
              IconButton(
                  icon: const Icon(Icons.skip_next_rounded, size: 35),
                  onPressed: provider.nextAyah),
            ],
          ),
        ],
      ),
    );
  }

  String _toArabicNumbers(int input) {
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return input.toString().split('').map((e) => arabic[int.parse(e)]).join();
  }
}
