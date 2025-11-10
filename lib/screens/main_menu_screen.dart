import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hanacaraka_app/data/hanacaraka_data.dart'; // Masih perlu untuk categoryNames
import 'package:hanacaraka_app/models/aksara_model.dart'; // <-- TAMBAHKAN INI
import 'package:hanacaraka_app/services/data_service.dart'; // <-- TAMBAHKAN INI
import 'package:hanacaraka_app/utils/category_colors.dart';
import 'package:hanacaraka_app/widgets/chat_bubble.dart';
import 'package:provider/provider.dart'; // <-- TAMBAHKAN INI

class MainMenuScreen extends StatefulWidget {
  final Function(AksaraModel)
      onCharacterSelect; // <-- Ganti dari HanacarakaChar

  const MainMenuScreen({Key? key, required this.onCharacterSelect})
      : super(key: key);

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  List<AksaraModel> _randomChars = []; // <-- Ganti dari HanacarakaChar
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Kita perlu 'context' untuk Provider, jadi panggil di post frame callback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateRandomChars();
    });

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
    if (!mounted) return;

    // Pastikan context masih valid sebelum digunakan
    try {
      final allAksara = context.read<DataService>().allAksara;
      if (allAksara.isEmpty)
        return; // Jangan lakukan apa-apa jika data belum siap

      final shuffled = [...allAksara]
        ..removeWhere((c) => c.kategori == 'pasangan')
        ..shuffle(Random());

      setState(() {
        // --- UBAH 8 MENJADI 10 ---
        _randomChars = shuffled.take(10).toList();
      });
    } catch (e) {
      // Menangkap error jika context/provider tidak tersedia
      print("Error updating random chars: $e");
    }
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
                  shrinkWrap: true, // Wajib untuk GridView di dalam ListView
                  physics: const NeverScrollableScrollPhysics(), // Wajib
                  itemCount:
                      _randomChars.length, // Ini akan 10 (atau 0 saat loading)
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 kolom
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

  Widget _buildAksaraCard(BuildContext context, AksaraModel char) {
    final colors = getCategoryColors(char.kategori);
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
              char.aksara,
              style: TextStyle(
                color: colors.main,
                fontSize: 36,
                fontFamily: 'Javanese',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              char.namaLatin,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              categoryNames[char.kategori] ??
                  char.kategori, // <-- Gunakan fallback
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
