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
  final AksaraModel character; // <-- Ganti dari HanacarakaChar
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
        _examples = dataService.getContohForAksara(widget.character.id);
      });
    });
  }

  void _playPronunciation() {
    final audioPath = widget.character.pathAudio;

    if (audioPath.isNotEmpty) {
      _mainAudioPlayer.play(AssetSource("audio/$audioPath"));
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
        // Kartu Karakter Utama
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Text(
                  widget.character.aksara,
                  style: TextStyle(
                    fontSize: 80,
                    fontFamily: 'Javanese',
                    color: colors.main,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.character.namaLatin,
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
                        label: Text('[${widget.character.namaLatin}]'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Kartu Deskripsi
        if (widget.character.deskripsi.isNotEmpty)
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
                          widget.character.deskripsi,
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

        if (_examples.isNotEmpty)
          // Anda perlu memodifikasi ExampleWithVoice untuk menerima List<ContohPenggunaanModel>
          // Untuk sementara, kita tampilkan placeholder:
          ExampleWithVoice(examples: _examples)
        else
          // Tampilkan 'example' placeholder jika ada
          Card(
            color: colors.light,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Contoh penggunaan tidak tersedia.',
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.main),
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

class ExampleWithVoicePlaceholder extends StatelessWidget {
  final List<ContohPenggunaanModel> examples;
  final CategoryColorSet colors;
  const ExampleWithVoicePlaceholder(
      {Key? key, required this.examples, required this.colors})
      : super(key: key);

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
                  fontSize: 16),
            ),
            const SizedBox(height: 16),
            ...examples.map((ex) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(ex.contohAksaraJawa,
                        style: TextStyle(fontFamily: 'Javanese', fontSize: 20)),
                    subtitle: Text("${ex.tulisanLatin} (${ex.arti})"),
                    trailing: Icon(LucideIcons.volume2, color: colors.main),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
