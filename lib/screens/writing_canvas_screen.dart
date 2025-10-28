import 'package:flutter/material.dart';
import 'package:hanacaraka_app/data/hanacaraka_data.dart';
import 'package:hanacaraka_app/data/writing_steps_data.dart';
import 'package:hanacaraka_app/widgets/guided_writing_canvas.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

// Diterjemahkan dari WritingCanvas.tsx
class WritingCanvasScreen extends StatefulWidget {
  final HanacarakaChar character;
  const WritingCanvasScreen({Key? key, required this.character})
    : super(key: key);

  @override
  State<WritingCanvasScreen> createState() => _WritingCanvasScreenState();
}

class _WritingCanvasScreenState extends State<WritingCanvasScreen> {
  String _mode = 'guided';
  final _freeCanvasController = FreeCanvasController();
  List<WritingStep> _writingSteps = [];
  String? _evaluationResult;

  @override
  void initState() {
    super.initState();
    _writingSteps = getWritingSteps(widget.character.char);
    // Jika tidak ada langkah terpandu, langsung ke mode bebas
    if (_writingSteps.length <= 1) {
      _mode = 'free';
    }
  }

  void _evaluateWriting() {
    // Logika evaluasi (placeholder)
    // Di aplikasi nyata, ini akan menjadi perbandingan gambar
    final double pixelCount = _freeCanvasController.getPixelCount();
    String result;
    if (pixelCount == 0) {
      result = 'Belum ada tulisan.';
    } else if (pixelCount < 100) {
      // Angka arbiter
      result = '❌ Belum Benar. Goresan terlalu tipis.';
    } else if (pixelCount > 2000) {
      result = '⚡ Masih Kurang Tepat. Goresan terlalu tebal.';
    } else {
      result = '✅ Bagus Sekali! Bentuknya sudah tepat.';
    }
    setState(() {
      _evaluationResult = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Mode Toggle
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (_writingSteps.length > 1)
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => setState(() => _mode = 'guided'),
                          icon: const Icon(LucideIcons.bookOpen, size: 16),
                          label: const Text('Mode Terpandu'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _mode == 'guided'
                                ? theme.primaryColor
                                : theme.colorScheme.secondary,
                            foregroundColor: _mode == 'guided'
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => setState(() => _mode = 'free'),
                          icon: const Icon(LucideIcons.zap, size: 16),
                          label: const Text('Mode Bebas'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _mode == 'free'
                                ? theme.primaryColor
                                : theme.colorScheme.secondary,
                            foregroundColor: _mode == 'free'
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onSecondary,
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  Center(
                    child: Text(
                      'Latihan Mode Bebas',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                Text(
                  _mode == 'guided'
                      ? '🎯 Mode Terpandu: Belajar menulis dengan langkah-langkah yang benar'
                      : '✏️ Mode Bebas: Tulis sesuka hati dan evaluasi hasilnya',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.primaryColor,
                    backgroundColor: theme.primaryColor.withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Tampilkan Canvas yang sesuai
        if (_mode == 'guided' && _writingSteps.length > 1)
          GuidedWritingCanvas(
            key: ValueKey(
              widget.character.char,
            ), // Reset state saat char berubah
            targetChar: widget.character.char,
            targetLatin: widget.character.latin,
            writingSteps: _writingSteps,
          )
        else
          _buildFreeCanvas(context),
      ],
    );
  }

  Widget _buildFreeCanvas(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Tulis huruf: ${widget.character.char} (${widget.character.latin})',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: theme.primaryColor.withOpacity(0.3)),
              ),
              child: FreeWritingCanvas(
                controller: _freeCanvasController,
                targetChar: widget.character.char,
              ),
            ),
            const SizedBox(height: 12),
            if (_evaluationResult != null)
              Text(
                _evaluationResult!,
                style: TextStyle(
                  color: _evaluationResult!.startsWith('✅')
                      ? Colors.green
                      : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _freeCanvasController.clear();
                      setState(() => _evaluationResult = null);
                    },
                    icon: const Icon(LucideIcons.rotateCcw, size: 16),
                    label: const Text('Hapus'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _evaluateWriting,
                    icon: const Icon(LucideIcons.search, size: 16),
                    label: const Text('Cek Tulisan'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//--- Kanvas Mode Bebas ---
class FreeCanvasController {
  late VoidCallback clear;
  late double Function() getPixelCount;
}

class FreeWritingCanvas extends StatefulWidget {
  final FreeCanvasController controller;
  final String targetChar;

  const FreeWritingCanvas({
    Key? key,
    required this.controller,
    required this.targetChar,
  }) : super(key: key);

  @override
  _FreeWritingCanvasState createState() => _FreeWritingCanvasState();
}

class _FreeWritingCanvasState extends State<FreeWritingCanvas> {
  List<Offset?> _points = [];

  @override
  void initState() {
    super.initState();
    widget.controller.clear = _clear;
    widget.controller.getPixelCount = _getPixelCount;
  }

  void _clear() {
    setState(() => _points.clear());
  }

  double _getPixelCount() {
    return _points.where((p) => p != null).length.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        setState(() {
          _points.add(details.localPosition);
        });
      },
      onPanUpdate: (details) {
        setState(() {
          _points.add(details.localPosition);
        });
      },
      onPanEnd: (details) {
        setState(() {
          _points.add(null); // Penanda akhir goresan
        });
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: CustomPaint(
          size: const Size(double.infinity, 300), // Ukuran kanvas
          painter: _FreePainter(points: _points, targetChar: widget.targetChar),
        ),
      ),
    );
  }
}

class _FreePainter extends CustomPainter {
  final List<Offset?> points;
  final String targetChar;

  _FreePainter({required this.points, required this.targetChar});

  @override
  void paint(Canvas canvas, Size size) {
    // Latar belakang putih
    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.white);

    // Teks panduan transparan
    final textPainter = TextPainter(
      text: TextSpan(
        text: targetChar,
        style: TextStyle(
          color: const Color(0xFFEA580C).withOpacity(0.08),
          fontSize: size.height * 0.7,
          fontFamily: 'Javanese',
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size.width - textPainter.width) / 2,
        (size.height - textPainter.height) / 2,
      ),
    );

    // Cat untuk tulisan pengguna
    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
