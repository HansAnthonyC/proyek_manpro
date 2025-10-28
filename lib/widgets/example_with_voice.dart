import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

// Diterjemahkan dari ExampleWithVoice.tsx
class ExampleWithVoice extends StatefulWidget {
  final List<Map<String, String>> examples;
  const ExampleWithVoice({Key? key, required this.examples}) : super(key: key);

  @override
  State<ExampleWithVoice> createState() => _ExampleWithVoiceState();
}

class _ExampleWithVoiceState extends State<ExampleWithVoice> {
  FlutterTts flutterTts = FlutterTts();
  int? _currentlyPlaying;
  String _highlightedSyllable = '';
  List<String> _syllables = [];
  int _currentSyllableIndex = 0;

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("id-ID");
    await flutterTts.setSpeechRate(0.5); // Lebih lambat
    await flutterTts.setPitch(1.1);

    flutterTts.setCompletionHandler(() {
      // Pindah ke suku kata berikutnya
      _currentSyllableIndex++;
      if (_currentSyllableIndex < _syllables.length) {
        _speakSyllable();
      } else {
        // Selesai
        if (mounted) {
          setState(() {
            _currentlyPlaying = null;
            _highlightedSyllable = '';
          });
        }
      }
    });

    flutterTts.setErrorHandler((_) {
      if (mounted) {
        setState(() {
          _currentlyPlaying = null;
          _highlightedSyllable = '';
        });
      }
    });
  }

  void _speakSyllable() {
    if (mounted) {
      setState(() {
        _highlightedSyllable = _syllables[_currentSyllableIndex];
      });
      flutterTts.speak(_syllables[_currentSyllableIndex]);
    }
  }

  void playPronunciation(Map<String, String> example, int index) {
    _syllables = example['pronunciation']!.split('-');
    _currentSyllableIndex = 0;

    if (mounted) {
      setState(() {
        _currentlyPlaying = index;
      });
      _speakSyllable();
    }
  }

  void stopPronunciation() {
    flutterTts.stop();
    if (mounted) {
      setState(() {
        _currentlyPlaying = null;
        _highlightedSyllable = '';
      });
    }
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: theme.primaryColor.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Contoh Penggunaan",
              style: TextStyle(
                color: theme.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            ...widget.examples.map((example) {
              int index = widget.examples.indexOf(example);
              bool isPlaying = _currentlyPlaying == index;
              return Card(
                color: theme.scaffoldBackgroundColor.withOpacity(0.5),
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Teks Jawa yang di-highlight
                      _buildHighlightedText(
                        example['javanese']!,
                        example['pronunciation']!.split('-'),
                        isPlaying,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Chip(
                                  label: Text(example['latin']!),
                                  backgroundColor: theme.colorScheme.secondary,
                                  labelStyle: TextStyle(
                                    color: theme.colorScheme.onBackground,
                                    fontSize: 12,
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  example['meaning']!,
                                  style: TextStyle(
                                    color: theme.colorScheme.onBackground
                                        .withOpacity(0.7),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.primaryColor.withOpacity(
                                0.1,
                              ),
                              foregroundColor: theme.primaryColor,
                              elevation: 0,
                              side: BorderSide(
                                color: theme.primaryColor.withOpacity(0.3),
                              ),
                            ),
                            onPressed: () {
                              isPlaying
                                  ? stopPronunciation()
                                  : playPronunciation(example, index);
                            },
                            icon: Icon(
                              isPlaying
                                  ? LucideIcons.pause
                                  : LucideIcons.volume2,
                              size: 16,
                            ),
                            label: Text(isPlaying ? 'Stop' : 'Play'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHighlightedText(
    String javanese,
    List<String> syllables,
    bool isPlaying,
  ) {
    // Logika highlight ini perlu disesuaikan dengan data Anda.
    // Ini asumsi sederhana: 1 suku kata = 1 karakter Jawa
    List<TextSpan> spans = [];
    for (int i = 0; i < javanese.length; i++) {
      String char = javanese[i];
      bool isHighlighted =
          isPlaying &&
          i < syllables.length &&
          syllables[i] == _highlightedSyllable;

      spans.add(
        TextSpan(
          text: char,
          style: TextStyle(
            fontSize: 28,
            fontFamily: 'Javanese', // Pastikan font ada
            backgroundColor: isHighlighted
                ? Colors.orange.withOpacity(0.3)
                : Colors.transparent,
            color: Colors.black,
          ),
        ),
      );
    }

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(children: spans),
    );
  }
}
