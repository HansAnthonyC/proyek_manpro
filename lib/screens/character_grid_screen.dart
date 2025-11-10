import 'package:flutter/material.dart';
import 'package:hanacaraka_app/data/hanacaraka_data.dart'; // Masih perlu untuk categoryNames
import 'package:hanacaraka_app/models/aksara_model.dart'; // <-- TAMBAHKAN INI
import 'package:hanacaraka_app/utils/category_colors.dart';

// Diterjemahkan dari CharacterGrid.tsx
class CharacterGridScreen extends StatelessWidget {
  final String category;
  final List<AksaraModel> characters; // <-- Ganti dari HanacarakaChar
  final Function(AksaraModel) onCharacterSelect;

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
      'pasangan':
          'Pasangan adalah bentuk konsonan yang digunakan untuk menutup suku kata tanpa vokal a.',
      'sandhangan':
          'Sandhangan adalah tanda yang digunakan untuk mengubah bunyi vokal atau menambah konsonan akhir.',
      'murda':
          'Aksara murda digunakan untuk menulis nama orang, tempat, atau hal-hal yang dianggap terhormat.',
      'rekan':
          'Aksara rekan adalah huruf tambahan untuk menulis kata-kata asing yang tidak ada dalam bahasa Jawa.',
      'swara':
          'Aksara swara adalah huruf vokal yang dapat berdiri sendiri tanpa konsonan.',
      'wilangan':
          'Wilangan adalah angka dalam sistem penulisan Jawa, dari 0 hingga 9.',
    };
    return info[category] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoryName = categoryNames[category] ?? category;
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
                      char.aksara,
                      style: TextStyle(
                        fontSize: 32,
                        fontFamily: 'Javanese',
                        color: colors.main,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      char.namaLatin,
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
