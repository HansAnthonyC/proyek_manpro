// lib/widgets/example_with_voice.dart (KODE LENGKAP DIPERBAIKI)
import 'dart:async';
import 'dart:convert'; // Untuk jsonDecode
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:characters/characters.dart'; // Untuk split aksara
import 'package:provider/provider.dart';
import 'package:hanacaraka_app/models/contoh_penggunaan_model.dart';
import 'package:hanacaraka_app/services/data_service.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

class ExampleWithVoice extends StatefulWidget {
  final List<ContohPenggunaanModel> examples;
  const ExampleWithVoice({Key? key, required this.examples}) : super(key: key);

  @override
  State<ExampleWithVoice> createState() => _ExampleWithVoiceState();
}

class _ExampleWithVoiceState extends State<ExampleWithVoice> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  StreamSubscription? _positionSubscription;
  String? _playingExampleId;
  int _highlightIndex = -1; // Indeks suku kata yang di-highlight (0, 1, 2, ...)
  String _highlightName = ""; // Nama Latin dari suku kata ("Ha", "Pa", dll)
  late Map<String, String> _javaToLatinMap;

  // Daftar suku kata (tanpa spasi) yang akan di-highlight
  List<String> _parsedSyllables = [];
  List<Map<String, dynamic>> _parsedTimestamps = [];
  bool _canHighlight = false;

  @override
  void initState() {
    super.initState();
    _javaToLatinMap = context.read<DataService>().javaToLatinMap;

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.completed) {
        if (mounted) {
          setState(() {
            _playingExampleId = null;
            _highlightIndex = -1;
            _highlightName = "";
            _positionSubscription?.cancel();
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _positionSubscription?.cancel();
    super.dispose();
  }

  // --- 1. FUNGSI BARU: Mem-parse string Jawa menjadi suku kata (tanpa spasi) ---
  List<String> _splitJavaneseSyllables(String javaneseText) {
    // "ꦲꦤ ꦲꦥ" -> ["ꦲ", "ꦤ", "ꦲ", "ꦥ"]
    // "ꦲꦶꦏꦶ ꦲꦺꦴꦩꦃꦏꦸ" -> ["ꦲꦶ", "ꦏꦶ", "ꦲꦺꦴ", "ꦩꦃ", "ꦏꦸ"]
    return javaneseText.characters
        .where((c) => c != ' ') // Filter/hapus spasi
        .map((c) => c.toString())
        .toList();
  }
  // --- AKHIR FUNGSI BARU ---

  List<Map<String, dynamic>> _parseTimestampData(String timestampJson) {
    if (timestampJson.isEmpty || timestampJson.toLowerCase() == 'na') {
      return [];
    }
    try {
      final List<dynamic> parsed = jsonDecode(timestampJson);
      return List<Map<String, dynamic>>.from(parsed);
    } catch (e) {
      List<double> times = timestampJson
          .split(' ')
          .map((t) => double.tryParse(t))
          .where((t) => t != null && t > 0)
          .cast<double>()
          .toList();

      List<Map<String, dynamic>> generatedData = [];
      double lastTime = 0.0;
      for (var time in times) {
        generatedData.add({"start": lastTime, "end": time});
        lastTime = time;
      }
      return generatedData;
    }
  }

  void _stopAudio() {
    _audioPlayer.stop();
    _positionSubscription?.cancel();
    if (mounted) {
      setState(() {
        _playingExampleId = null;
        _highlightIndex = -1;
        _highlightName = "";
      });
    }
  }

  void _playAudio(ContohPenggunaanModel example) async {
    if (_playingExampleId == example.contohId) {
      _stopAudio();
      return;
    }
    _stopAudio();
    if (example.pathAudio.isEmpty) {
      print("Path audio kosong.");
      return;
    }

    _parsedTimestamps = _parseTimestampData(example.timestampData);
    // --- 2. GUNAKAN FUNGSI BARU ---
    _parsedSyllables = _splitJavaneseSyllables(example.contohAksaraJawa);
    // ----------------------------

    // Pastikan jumlah timestamp cocok dengan jumlah suku kata
    _canHighlight = _parsedTimestamps.isNotEmpty &&
        _parsedSyllables.isNotEmpty &&
        _parsedTimestamps.length == _parsedSyllables.length;

    if (mounted) {
      setState(() {
        _playingExampleId = example.contohId;
        _highlightIndex = -1;
        _highlightName = "";
      });
    }

    if (_canHighlight) {
      _positionSubscription = _audioPlayer.onPositionChanged.listen((duration) {
        double currentSeconds = duration.inMilliseconds / 1000.0;
        int newIndex = -1;
        for (int i = 0; i < _parsedTimestamps.length; i++) {
          final double start = _parsedTimestamps[i]['start'] ?? 0.0;
          final double end = _parsedTimestamps[i]['end'] ?? 0.0;
          if (currentSeconds >= start && currentSeconds < end) {
            newIndex = i;
            break;
          }
        }

        // --- 3. PERBAIKI LOGIKA HIGHLIGHT ---
        if (newIndex != _highlightIndex && newIndex < _parsedSyllables.length) {
          // Ambil suku kata (misal: "ꦏꦸ")
          String syllable = _parsedSyllables[newIndex];
          // Ambil karakter dasar (misal: "ꦏ")
          String baseChar = syllable.characters.first;
          // Cari nama latin (misal: "ka")
          String charName = _javaToLatinMap[baseChar] ?? "";

          if (mounted) {
            setState(() {
              _highlightIndex = newIndex;
              // Ubah "ka" -> "Ka"
              _highlightName = charName.isNotEmpty
                  ? (charName[0].toUpperCase() + charName.substring(1))
                  : "";
            });
          }
        }
        // --- AKHIR PERBAIKAN ---
      });
    } else {
      _positionSubscription?.cancel();
    }

    try {
      await _audioPlayer.play(AssetSource('audio/${example.pathAudio}'));
    } catch (e) {
      print("Error memutar audio: $e");
      final String fullPath = "assets/audio/${example.pathAudio}";
      print("GAGAL MEMUAT: $fullPath");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memuat file audio: $fullPath")),
      );
      _stopAudio();
    }
  }

  // --- 4. MODIFIKASI TOTAL _buildHighlightableText ---
  // Sekarang me-return Wrap, bukan RichText
  Widget _buildHighlightableText(ContohPenggunaanModel example) {
    final theme = Theme.of(context);
    bool isPlayingThis = _playingExampleId == example.contohId;
    bool shouldHighlight = isPlayingThis && _canHighlight;

    // Ambil SEMUA karakter, TERMASUK spasi
    List<String> allCharacters =
        example.contohAksaraJawa.characters.map((c) => c.toString()).toList();

    int syllableIndex = -1; // Counter untuk suku kata (non-spasi)

    return Wrap(
      // Gunakan Wrap agar bisa pindah baris
      spacing: 4.0, // Spasi horizontal antar widget
      runSpacing: 2.0, // Spasi vertikal jika pindah baris
      alignment: WrapAlignment.center, // Pusatkan
      children: allCharacters.map((char) {
        // Jika karakter adalah spasi, render spasi
        if (char == ' ') {
          return const SizedBox(width: 10);
        }

        // Jika bukan spasi, ini adalah suku kata
        syllableIndex++;
        final int currentSyllableIndex =
            syllableIndex; // Simpan indeks saat ini

        // Cek apakah suku kata ini yang sedang di-highlight
        final bool isHighlighted =
            shouldHighlight && currentSyllableIndex == _highlightIndex;

        return Column(
          // Widget baru: Kolom berisi Teks dan Chip
          children: [
            // 1. Teks Aksara Jawa
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              decoration: BoxDecoration(
                color: isHighlighted
                    ? theme.primaryColor.withOpacity(0.2)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                char,
                style: TextStyle(
                  fontFamily: 'Javanese',
                  fontSize: 28,
                  color: isHighlighted
                      ? theme.primaryColor
                      : theme.colorScheme.onSurface,
                  fontWeight:
                      isHighlighted ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),

            // 2. "Subtitle" Chip (hanya muncul saat di-highlight)
            AnimatedOpacity(
              opacity: isHighlighted ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 150),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                height: isHighlighted ? 30.0 : 0.0, // Animasikan tinggi
                padding: const EdgeInsets.only(top: 4.0),
                // Jangan tampilkan chip jika nama kosong (mencegah error)
                child: _highlightName.isEmpty
                    ? const SizedBox()
                    : Chip(
                        label: Text(_highlightName,
                            style: TextStyle(
                                color: theme.primaryColor, fontSize: 12)),
                        backgroundColor: theme.primaryColor.withOpacity(0.1),
                        avatar: Icon(LucideIcons.mousePointer,
                            size: 14, color: theme.primaryColor),
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 0),
                      ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
  // --- AKHIR MODIFIKASI ---

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
              final isPlayingThis = _playingExampleId == example.contohId;

              return Card(
                color: theme.cardColor.withOpacity(0.8),
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHighlightableText(example),
                      // Hapus Chip dari sini
                      const SizedBox(height: 8),
                      Text(
                        example.tulisanLatin,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Text(
                        "(${example.arti})",
                        style: TextStyle(
                            color: theme.textTheme.bodyMedium?.color
                                ?.withOpacity(0.7),
                            fontSize: 12),
                      ),
                      const Divider(height: 16),
                      // --- 5. PERBAIKI ROW BAWAH ---
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.end, // Tombol ke kanan
                        children: [
                          // Hapus AnimatedOpacity/Chip dari sini

                          // Selalu tampilkan tombol play jika ada path audio
                          if (example.pathAudio.isNotEmpty)
                            IconButton(
                              style: IconButton.styleFrom(
                                backgroundColor:
                                    theme.primaryColor.withOpacity(0.1),
                                foregroundColor: theme.primaryColor,
                              ),
                              icon: Icon(
                                isPlayingThis
                                    ? LucideIcons.pause // Ikon Pause
                                    : LucideIcons.play,
                                size: 20,
                              ),
                              onPressed: () => _playAudio(example),
                            ),
                        ],
                      ),
                      // --- AKHIR PERBAIKAN ---
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
}
