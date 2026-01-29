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
        title: Text(
          widget.surahName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF006437),
        centerTitle: true,
        elevation: 0,
      ),
      body: Consumer<QuranProvider>(
        builder: (context, provider, child) {
          if (provider.state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF006437)),
            );
          }

          // 1. Organisation des données par page
          final Map<int, List<dynamic>> pagesMap = {};
          for (var ayah in provider.state.ayahs) {
            pagesMap.putIfAbsent(ayah.page, () => []).add(ayah);
          }
          final pageKeys = pagesMap.keys.toList()..sort();

          // 2. Synchronisation automatique du PageView avec l'audio
          if (provider.state.currentAyahId != null) {
            try {
              final currentAyah = provider.state.ayahs.firstWhere(
                (a) => a.id == provider.state.currentAyahId,
              );
              final targetPageIndex = pageKeys.indexOf(currentAyah.page);

              if (_pageController.hasClients &&
                  _pageController.page?.round() != targetPageIndex &&
                  targetPageIndex != -1) {
                Future.microtask(() {
                  _pageController.animateToPage(
                    targetPageIndex,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeInOut,
                  );
                });
              }
            } catch (e) {
              // Ayah non trouvée dans la liste actuelle
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
                      pagesMap[pageNumber]!,
                      pageNumber,
                      provider,
                    );
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

  Widget _buildMushafPageFrame(
    List<dynamic> ayahs,
    int pageNumber,
    QuranProvider provider,
  ) {
    final bool isFirstPageOfSurah = ayahs.any((a) => a.ayahNumber == 1);

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFB8965B), width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFB8965B), width: 1),
        ),
        child: Column(
          children: [
            _buildPageHeader(ayahs.first.surahNumber, pageNumber),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (isFirstPageOfSurah)
                          _buildBismillah(ayahs.first.surahNumber),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 0,
                          runSpacing: 12,
                          children: ayahs.map((ayah) {
                            final isCurrent =
                                provider.state.currentAyahId == ayah.id;
                            return _buildAyahItem(ayah, isCurrent, provider);
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                _toArabicNumbers(pageNumber),
                style: const TextStyle(
                  fontFamily: 'UthmanicHafs',
                  fontSize: 16,
                  color: Color(0xFFB8965B),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAyahItem(dynamic ayah, bool isCurrent, QuranProvider provider) {
    return GestureDetector(
      onTap: () => provider.seekToAyah(ayah.id),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: isCurrent
              ? const Color(0xFF006437).withOpacity(0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "${ayah.text_uthmani} ",
                style: const TextStyle(
                  fontFamily: 'UthmanicHafs',
                  fontSize: 24,
                  height: 2.2,
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: "\uFD3F${_toArabicNumbers(ayah.ayahNumber)}\uFD3E ",
                style: const TextStyle(
                  fontFamily: 'UthmanicHafs',
                  fontSize: 20,
                  color: Color(0xFFB8965B),
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildBismillah(int surahNumber) {
    if (surahNumber == 1 || surahNumber == 9) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF4EDE2).withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFB8965B).withOpacity(0.3)),
      ),
      child: const Text(
        "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'UthmanicHafs',
          fontSize: 24,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildPageHeader(int surahNum, int pageNum) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: const BoxDecoration(color: Color(0xFFF4EDE2)),
      child: Text(
        "Sūrat ${widget.surahName}",
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFF8B6E3D),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildControlBar(QuranProvider provider) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Center(
        child: IconButton(
          icon: Icon(
            provider.audioPlayer.playing
                ? Icons.pause_circle_filled
                : Icons.play_circle_filled,
          ),
          iconSize: 64,
          color: const Color(0xFF006437),
          onPressed: provider.playPause,
        ),
      ),
    );
  }

  String _toArabicNumbers(int input) {
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return input.toString().split('').map((e) => arabic[int.parse(e)]).join();
  }
}
