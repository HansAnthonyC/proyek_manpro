import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hanacaraka_app/data/hanacaraka_data.dart';
import 'package:hanacaraka_app/utils/category_colors.dart';
import 'package:hanacaraka_app/widgets/example_with_voice.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

// Diterjemahkan dari CharacterDetail.tsx
class CharacterDetailScreen extends StatefulWidget {
  final HanacarakaChar character;
  const CharacterDetailScreen({Key? key, required this.character})
    : super(key: key);

  @override
  State<CharacterDetailScreen> createState() => _CharacterDetailScreenState();
}

class _CharacterDetailScreenState extends State<CharacterDetailScreen> {
  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("id-ID");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1.1);
  }

  void _playPronunciation() {
    if (widget.character.pronunciation.isNotEmpty) {
      flutterTts.speak(widget.character.pronunciation);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoryName = categoryNames[widget.character.category]!;
    final colors = getCategoryColors(widget.character.category);

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Kartu Karakter Utama
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Text(
                  widget.character.char,
                  style: TextStyle(
                    fontSize: 80,
                    fontFamily: 'Javanese',
                    color: colors.main,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.character.latin,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: colors.main,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Chip(
                      label: Text(categoryName),
                      backgroundColor: colors.light,
                      labelStyle: TextStyle(color: colors.text, fontSize: 12),
                      side: BorderSide(color: colors.border),
                    ),
                    const SizedBox(width: 8),
                    if (widget.character.pronunciation.isNotEmpty)
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.light,
                          foregroundColor: colors.main,
                          elevation: 0,
                          side: BorderSide(color: colors.border),
                        ),
                        onPressed: _playPronunciation,
                        icon: const Icon(LucideIcons.volume2, size: 16),
                        label: Text('[${widget.character.pronunciation}]'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Kartu Deskripsi
        if (widget.character.description != null)
          Card(
            color: colors.light,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(LucideIcons.bookOpen, color: colors.main, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Penjelasan',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colors.main,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.character.description!,
                          style: TextStyle(
                            color: theme.textTheme.bodyMedium?.color
                                ?.withOpacity(0.8),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 16),

        // Kartu Contoh Penggunaan
        if (widget.character.examples != null &&
            widget.character.examples!.isNotEmpty)
          ExampleWithVoice(examples: widget.character.examples!)
        else if (widget.character.example != null)
          Card(
            color: colors.light,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Contoh Penggunaan',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colors.main,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.character.example!,
                    style: TextStyle(
                      fontSize: 32,
                      fontFamily: 'Javanese',
                      color: colors.main,
                    ),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 16),

        // Kartu Tips Belajar
        Card(
          color: theme.primaryColor.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Untuk berlatih menulis aksara ini, gunakan tab "Latih" di menu bawah. Pelajari bentuk dan cara penulisannya dengan seksama.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
