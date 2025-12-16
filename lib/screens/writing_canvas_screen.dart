import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:hanacaraka_app/models/aksara_model.dart';
import 'package:hanacaraka_app/data/writing_steps_data.dart';
import 'package:hanacaraka_app/widgets/guided_writing_canvas.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

// Diterjemahkan dari WritingCanvas.tsx
class WritingCanvasScreen extends StatefulWidget {
  final AksaraModel character;
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
    // Coba parse dari strokeOrderData di CSV terlebih dahulu
    // Jika tidak ada, gunakan data hardcoded legacy
    _writingSteps = getWritingStepsFromData(
      widget.character.strokeOrderData,
      widget.character.namaLatin,
    );

    // Jika masih 1 langkah (fallback), cek data hardcoded legacy
    if (_writingSteps.length <= 1) {
      final legacySteps = getWritingSteps(widget.character.aksara);
      if (legacySteps.length > 1) {
        _writingSteps = legacySteps;
      }
    }

    // Jika tidak ada langkah terpandu (hanya 1 fallback step), langsung ke mode bebas
    if (_writingSteps.length <= 1) {
      _mode = 'free';
    }
  }

  void _evaluateWriting() {
    // Evaluasi berbasis analisis goresan pengguna
    final points = _freeCanvasController.getPoints();
    final canvasSize = _freeCanvasController.getCanvasSize();

    // Hitung metrik dasar
    final validPoints = points.where((p) => p != null).cast<Offset>().toList();

    if (validPoints.isEmpty) {
      setState(() {
        _evaluationResult =
            '📝 Belum ada tulisan. Silakan gambar aksara terlebih dahulu.';
      });
      return;
    }

    // Analisis 1: Coverage - seberapa luas area yang digambar
    final minX = validPoints.map((p) => p.dx).reduce((a, b) => a < b ? a : b);
    final maxX = validPoints.map((p) => p.dx).reduce((a, b) => a > b ? a : b);
    final minY = validPoints.map((p) => p.dy).reduce((a, b) => a < b ? a : b);
    final maxY = validPoints.map((p) => p.dy).reduce((a, b) => a > b ? a : b);

    final drawingWidth = maxX - minX;
    final drawingHeight = maxY - minY;
    final coverage =
        (drawingWidth * drawingHeight) / (canvasSize.width * canvasSize.height);

    // Analisis 2: Centering - apakah gambar berada di tengah canvas
    final centerX = (minX + maxX) / 2;
    final centerY = (minY + maxY) / 2;
    final idealCenterX = canvasSize.width / 2;
    final idealCenterY = canvasSize.height / 2;
    final centerOffset =
        ((centerX - idealCenterX).abs() + (centerY - idealCenterY).abs()) /
            (canvasSize.width + canvasSize.height);

    // Analisis 3: Stroke count - berapa banyak goresan (dipisah oleh null)
    int strokeCount = 0;
    bool inStroke = false;
    for (final point in points) {
      if (point != null && !inStroke) {
        strokeCount++;
        inStroke = true;
      } else if (point == null) {
        inStroke = false;
      }
    }

    // Analisis 4: Proporsi - apakah bentuknya proporsional
    final aspectRatio = drawingWidth / (drawingHeight > 0 ? drawingHeight : 1);

    // Scoring
    int score = 0;
    List<String> feedback = [];

    // Coverage scoring (ideal: 10-40% of canvas)
    if (coverage >= 0.08 && coverage <= 0.50) {
      score += 30;
    } else if (coverage < 0.08) {
      feedback.add('Goresan terlalu kecil');
    } else {
      feedback.add('Goresan terlalu besar');
    }

    // Centering scoring (tolerance: 20% offset)
    if (centerOffset < 0.20) {
      score += 30;
    } else if (centerOffset < 0.35) {
      score += 15;
      feedback.add('Posisi agak geser dari tengah');
    } else {
      feedback.add('Posisi terlalu jauh dari tengah');
    }

    // Stroke complexity scoring (minimal strokes for detail)
    if (strokeCount >= 2) {
      score += 20;
    } else {
      feedback.add('Coba tambah detail goresan');
    }

    // Aspect ratio scoring (aksara Jawa cenderung vertikal atau 1:1)
    if (aspectRatio >= 0.5 && aspectRatio <= 2.0) {
      score += 20;
    } else {
      feedback.add('Proporsi bentuk kurang pas');
    }

    // Generate result message
    String result;
    if (score >= 80) {
      result =
          '✅ Bagus Sekali! (Skor: $score/100)\nBentuk dan posisi sudah tepat.';
    } else if (score >= 60) {
      result = '👍 Lumayan Bagus! (Skor: $score/100)\n${feedback.join(", ")}.';
    } else if (score >= 40) {
      result =
          '⚡ Masih Perlu Latihan (Skor: $score/100)\n${feedback.join(", ")}.';
    } else {
      result = '❌ Coba Lagi (Skor: $score/100)\n${feedback.join(", ")}.';
    }

    setState(() {
      _evaluationResult = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Use NeverScrollableScrollPhysics when in free mode to prevent scroll conflict
    return SingleChildScrollView(
      physics: _mode == 'free' ? const NeverScrollableScrollPhysics() : null,
      padding: const EdgeInsets.all(16.0),
      child: Column(
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
              key: ValueKey(widget.character.aksara), // <-- Ganti dari .char
              targetChar: widget.character.aksara, // <-- Ganti dari .char
              targetLatin: widget.character.namaLatin, // <-- Ganti dari .latin
              writingSteps: _writingSteps,
            )
          else
            _buildFreeCanvas(context),
        ],
      ),
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
              'Tulis huruf: ${widget.character.aksara} (${widget.character.namaLatin})',
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
                targetChar: widget.character.aksara,
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
  late List<Offset?> Function() getPoints;
  late Size Function() getCanvasSize;
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
  Size _canvasSize = const Size(300, 300);

  @override
  void initState() {
    super.initState();
    widget.controller.clear = _clear;
    widget.controller.getPixelCount = _getPixelCount;
    widget.controller.getPoints = () => List.from(_points);
    widget.controller.getCanvasSize = () => _canvasSize;
  }

  void _clear() {
    setState(() => _points.clear());
  }

  double _getPixelCount() {
    return _points.where((p) => p != null).length.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Store actual canvas size for evaluation
        _canvasSize = Size(constraints.maxWidth, 300);

        // Simple GestureDetector with AbsorbPointer behavior
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
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
              painter:
                  _FreePainter(points: _points, targetChar: widget.targetChar),
            ),
          ),
        );
      },
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
