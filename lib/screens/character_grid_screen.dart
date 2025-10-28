import 'package:flutter/material.dart';
import 'package:hanacaraka_app/data/hanacaraka_data.dart';
import 'package:hanacaraka_app/utils/category_colors.dart';

// Diterjemahkan dari CharacterGrid.tsx
class CharacterGridScreen extends StatelessWidget {
  final String category;
  final List<HanacarakaChar> characters;
  final Function(HanacarakaChar) onCharacterSelect;

  const CharacterGridScreen({
    Key? key,
    required this.category,
    required this.characters,
    required this.onCharacterSelect,
  }) : super(key: key);

  String getCategoryInfo(String category) {
    const info = {
      'nglegena':
          'Aksara nglegena adalah huruf dasar dalam penulisan Jawa. Setiap huruf memiliki bunyi konsonan + vokal a.',
      'murda':
          'Aksara murda digunakan untuk menulis nama orang, tempat, atau hal-hal yang dianggap terhormat.',
      // ... tambahkan info lainnya ...
    };
    return info[category] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoryName = categoryNames[category]!;
    final colors = getCategoryColors(category);

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Header
        Column(
          children: [
            Text(
              categoryName,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colors.main,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Ketuk huruf untuk melihat detail',
              style: TextStyle(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: characters.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            final char = characters[index];
            return Card(
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => onCharacterSelect(char),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      char.char,
                      style: TextStyle(
                        fontSize: 32,
                        fontFamily: 'Javanese',
                        color: colors.main,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      char.latin,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        // Info Card
        Card(
          color: colors.light,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text('📖', style: TextStyle(fontSize: 24)),
                const SizedBox(height: 8),
                Text(
                  'Tentang $categoryName',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colors.main,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  getCategoryInfo(category),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
