import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hanacaraka_app/data/hanacaraka_data.dart';
import 'package:hanacaraka_app/utils/category_colors.dart';
import 'package:hanacaraka_app/widgets/chat_bubble.dart';

// Diterjemahkan dari MainMenu.tsx
class MainMenuScreen extends StatefulWidget {
  final Function(HanacarakaChar) onCharacterSelect;

  const MainMenuScreen({Key? key, required this.onCharacterSelect})
    : super(key: key);

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  List<HanacarakaChar> _randomChars = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateRandomChars();
    // Ganti aksara setiap 10 detik
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _updateRandomChars();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateRandomChars() {
    final shuffled = [...allHanacarakaChars]
      ..removeWhere((c) => c.category == 'pasangan')
      ..shuffle(Random());
    setState(() {
      _randomChars = shuffled.take(8).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Header
        Text(
          'Sinau Aksara',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Kenali dasar-dasar Aksara Jawa dengan mudah dan menyenangkan',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),

        // Chat Bubble
        const ChatBubble(
          message:
              "Sugeng rawuh! Mari kita pelajari aksara Jawa bersama. Mulai dengan aksara legena sebagai dasar penulisan.",
        ),
        const SizedBox(height: 24),

        // Ragam Aksara
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '✨ Ragam Aksara Jawa',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _randomChars.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.2,
                  ),
                  itemBuilder: (context, index) {
                    final char = _randomChars[index];
                    return _buildAksaraCard(context, char);
                  },
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: _updateRandomChars,
                    child: Text(
                      '🔄 Tampilkan aksara lainnya',
                      style: TextStyle(color: theme.primaryColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Info Card
        Card(
          color: theme.primaryColor.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Aksara Jawa memiliki berbagai jenis huruf: 20 aksara nglegena, aksara murda, swara, sandhangan, dan lainnya. Aksara di atas berganti setiap 10 detik untuk inspirasi belajar!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAksaraCard(BuildContext context, HanacarakaChar char) {
    final colors = getCategoryColors(char.category);
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => widget.onCharacterSelect(char),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: colors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              char.char,
              style: TextStyle(
                color: colors.main,
                fontSize: 36,
                fontFamily: 'Javanese',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              char.latin,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              categoryNames[char.category] ?? char.category,
              style: TextStyle(
                color: colors.main.withOpacity(0.7),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
