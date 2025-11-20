import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart'; // <-- 1. HAPUS IMPORT INI
import 'package:audioplayers/audioplayers.dart'; // <-- 2. TAMBAHKAN IMPORT INI
import 'package:hanacaraka_app/data/hanacaraka_data.dart';
import 'package:hanacaraka_app/models/aksara_model.dart';
import 'package:hanacaraka_app/models/contoh_penggunaan_model.dart';
import 'package:hanacaraka_app/services/data_service.dart';
import 'package:hanacaraka_app/utils/category_colors.dart';
import 'package:hanacaraka_app/widgets/example_with_voice.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:provider/provider.dart';

class CharacterDetailScreen extends StatefulWidget {
  final AksaraModel character;

  const CharacterDetailScreen({Key? key, required this.character})
      : super(key: key);

  @override
  State<CharacterDetailScreen> createState() => _CharacterDetailScreenState();
}

class _CharacterDetailScreenState extends State<CharacterDetailScreen> {
  final AudioPlayer _mainAudioPlayer = AudioPlayer();
  List<ContohPenggunaanModel> _examples = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dataService = Provider.of<DataService>(context, listen: false);
      setState(() {
        // FIX: Menggunakan ID (int) sesuai tipe data di model
        _examples =
            dataService.getContohForAksara(int.parse(widget.character.id));
      });
    });
  }

  void _playPronunciation() async {
    final audioPath = widget.character.pathAudio;
    if (audioPath.isNotEmpty) {
      await _mainAudioPlayer.stop();
      await _mainAudioPlayer.play(AssetSource("audio/$audioPath"));
    }
  }

  @override
  void dispose() {
    _mainAudioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoryName =
        categoryNames[widget.character.kategori] ?? widget.character.kategori;
    final colors = getCategoryColors(widget.character.kategori);

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // --- Kartu Karakter Utama ---
        Card(
          elevation: 4,
          shadowColor: colors.main.withOpacity(0.3),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Text(
                  widget.character.aksara,
                  style: TextStyle(
                    fontSize: 80,
                    fontFamily: 'TuladhaJejeg', // Pastikan font benar
                    color: colors.main,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.character.namaLatin,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
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
                    if (widget.character.pathAudio.isNotEmpty)
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.light,
                          foregroundColor: colors.main,
                          elevation: 0,
                          side: BorderSide(color: colors.border),
                        ),
                        onPressed: _playPronunciation,
                        icon: const Icon(LucideIcons.volume2, size: 16),
                        label: Text('Dengar'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // --- Kartu Penjelasan ---
        if (widget.character.deskripsi.isNotEmpty)
          Card(
            color: Colors.white,
            surfaceTintColor: colors.light,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: colors.border.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(12),
            ),
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
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.character.deskripsi,
                          style: TextStyle(
                            color: Colors.black87,
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
        const SizedBox(height: 20),

        // --- Bagian Contoh Penggunaan (FIX ERROR DISINI) ---
        Text(
          "Contoh Penggunaan",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),

        if (_examples.isNotEmpty)
          // FIX: Kita melakukan looping (map) untuk membuat widget bagi SETIAP item
          Column(
            children:
                _examples.map((ex) => ExampleWithVoice(example: ex)).toList(),
          )
        else
          Card(
            color: theme.colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'Contoh penggunaan belum tersedia.',
                  style: TextStyle(color: colors.main),
                ),
              ),
            ),
          ),
        const SizedBox(height: 16),

        // --- Kartu Tips ---
        Card(
          color: theme.primaryColor.withOpacity(0.05),
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: theme.primaryColor.withOpacity(0.1))),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(LucideIcons.info,
                    size: 20, color: theme.primaryColor.withOpacity(0.7)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Gunakan tab "Latih" untuk belajar menulis aksara ini.',
                    style: TextStyle(
                      color:
                          theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                      fontSize: 13,
                    ),
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
