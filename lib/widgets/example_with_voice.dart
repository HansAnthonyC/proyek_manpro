import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:characters/characters.dart';
import '../models/contoh_penggunaan_model.dart';

class ExampleWithVoice extends StatefulWidget {
  final ContohPenggunaanModel example;

  const ExampleWithVoice({super.key, required this.example});

  @override
  State<ExampleWithVoice> createState() => _ExampleWithVoiceState();
}

class _ExampleWithVoiceState extends State<ExampleWithVoice> {
  late AudioPlayer _audioPlayer;
  PlayerState _playerState = PlayerState.stopped;
  int _currentSyllableIndex = -1;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _stateSubscription;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    _stateSubscription = _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _playerState = state;
          if (state == PlayerState.completed || state == PlayerState.stopped) {
            _currentSyllableIndex = -1;
          }
        });
      }
    });

    _positionSubscription = _audioPlayer.onPositionChanged.listen((position) {
      if (mounted) {
        double currentSeconds = position.inMilliseconds / 1000.0;
        _updateHighlight(currentSeconds);
      }
    });
  }

  void _updateHighlight(double currentSeconds) {
    int newIndex = -1;
    for (int i = 0; i < widget.example.timestamps.length; i++) {
      double start = widget.example.timestamps[i].start;

      // Logika "Sticky Highlight" untuk mencegah jeda hitam
      double endBoundary;
      if (i < widget.example.timestamps.length - 1) {
        endBoundary = widget.example.timestamps[i + 1].start;
      } else {
        endBoundary = widget.example.timestamps[i].end + 0.5;
      }

      if (currentSeconds >= start && currentSeconds < endBoundary) {
        newIndex = i;
        break;
      }
    }

    if (newIndex != _currentSyllableIndex) {
      setState(() {
        _currentSyllableIndex = newIndex;
      });
    }
  }

  Future<void> _playAudio() async {
    if (_playerState == PlayerState.playing) {
      await _audioPlayer.stop();
    } else {
      await _audioPlayer.setPlaybackRate(0.5);
      await _audioPlayer.play(AssetSource('audio/${widget.example.audioPath}'));
    }
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _stateSubscription?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: _playAudio,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Icon(
                    _playerState == PlayerState.playing
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    color: Colors.grey.shade700,
                    size: 24,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Bagian Aksara Jawa dengan Animasi Halus ---
                    _buildSmoothJavaneseText(),

                    const SizedBox(height: 12), // Jarak sedikit diperlebar

                    Text(
                      widget.example.latin,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      widget.example.arti,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // FUNGSI BARU: Animasi Transisi Warna (AnimatedDefaultTextStyle)
  Widget _buildSmoothJavaneseText() {
    List<String> chars = widget.example.contohAksara.characters.toList();
    List<Widget> combinedWidgets = [];

    int timestampCounter = 0;
    for (int i = 0; i < chars.length; i++) {
      String char = chars[i];
      bool isHighlighted = false;
      String? currentSubtitle;

      if (char.trim().isNotEmpty) {
        if (timestampCounter == _currentSyllableIndex) {
          isHighlighted = true;
          currentSubtitle =
              widget.example.timestamps[_currentSyllableIndex].label;
        }
        timestampCounter++;
      }

      combinedWidgets.add(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. ANIMASI WARNA AKSARA (Kunci Kehalusan)
            AnimatedDefaultTextStyle(
              duration: const Duration(
                  milliseconds: 300), // Durasi transisi (0.3 detik)
              curve: Curves.easeInOut, // Kurva animasi agar "flow" enak
              style: TextStyle(
                fontFamily: 'TuladhaJejeg',
                fontSize: 24,
                // Warna berubah perlahan, bukan kaget
                color: isHighlighted ? Colors.orange.shade700 : Colors.black87,
                // SANGAT PENTING: Jangan ubah FontWeight (Bold/Normal) saat animasi
                // karena akan membuat teks bergeser/getar (layout shift).
                fontWeight: FontWeight.normal,
              ),
              child: Text(char),
            ),

            // 2. ANIMASI SUBTITLE (Fade In/Out)
            // Kita gunakan AnimatedOpacity agar munculnya pelan-pelan
            AnimatedOpacity(
              opacity: (isHighlighted && currentSubtitle != null) ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                      color: Colors.orange.shade200
                          .withOpacity(isHighlighted ? 1.0 : 0.0)),
                ),
                // Gunakan constrained box atau text agar height tetap terjaga
                // jika ingin layout tidak naik turun, bisa set minHeight.
                // Tapi untuk desain ini, naik turun sedikit tidak masalah karena di bawah wrap.
                child: Text(
                  currentSubtitle ??
                      " ", // Spasi kosong agar layout height tetap ada (opsional)
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.orange.shade800,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Wrap(
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 2, // Jarak horizontal antar huruf dirapatkan sedikit
      runSpacing: 8, // Jarak vertikal antar baris
      children: combinedWidgets,
    );
  }
}
