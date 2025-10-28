import 'package:flutter/material.dart';
import 'package:hanacaraka_app/data/writing_steps_data.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

// Diterjemahkan dari GuidedWritingCanvas.tsx
class GuidedWritingCanvas extends StatefulWidget {
  final String targetChar;
  final String targetLatin;
  final List<WritingStep> writingSteps;

  const GuidedWritingCanvas({
    Key? key,
    required this.targetChar,
    required this.targetLatin,
    required this.writingSteps,
  }) : super(key: key);

  @override
  State<GuidedWritingCanvas> createState() => _GuidedWritingCanvasState();
}

class _GuidedWritingCanvasState extends State<GuidedWritingCanvas> {
  int _currentStep = 0;
  List<String> _stepStatuses = [];
  List<List<Offset>> _completedStrokes = [];
  List<Offset> _currentStroke = [];
  bool _isDrawing = false;

  @override
  void initState() {
    super.initState();
    _reset();
  }

  void _reset() {
    setState(() {
      _currentStep = 0;
      _stepStatuses = List.generate(
        widget.writingSteps.length,
        (i) => i == 0 ? 'active' : 'pending',
      );
      _completedStrokes = [];
      _currentStroke = [];
      _isDrawing = false;
    });
  }

  void _evaluateStroke() {
    if (_currentStroke.length < 2) return;

    final step = widget.writingSteps[_currentStep];
    final firstPoint = _currentStroke.first;
    final lastPoint = _currentStroke.last;

    // Logika evaluasi sederhana dari file .tsx
    // Menggunakan jarak 40 piksel sebagai toleransi
    const tolerance = 40.0;

    // Perlu scaling point dari canvas ke data 0-100
    // Asumsi canvas 300x300 untuk simple math
    final canvasSize = 300.0;

    final startDistance =
        (firstPoint - (step.startPoint / 100.0) * canvasSize).distance;
    final endDistance =
        (lastPoint - (step.endPoint / 100.0) * canvasSize).distance;

    if (startDistance < tolerance && endDistance < tolerance) {
      // Benar
      setState(() {
        _completedStrokes.add(_currentStroke);
        _stepStatuses[_currentStep] = 'completed';
        if (_currentStep < widget.writingSteps.length - 1) {
          _currentStep++;
          _stepStatuses[_currentStep] = 'active';
        } else {
          // Selesai!
          _currentStep++;
        }
      });
    } else {
      // Salah
      setState(() {
        _stepStatuses[_currentStep] = 'incorrect';
      });
      // Reset setelah 1.5 detik
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          setState(() {
            _stepStatuses[_currentStep] = 'active';
          });
        }
      });
    }
    setState(() {
      _currentStroke = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = (_currentStep / widget.writingSteps.length) * 100;

    return Column(
      children: [
        // Kartu Info
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Latihan: ${widget.targetChar} (${widget.targetLatin})',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: progress / 100,
                  backgroundColor: theme.primaryColor.withOpacity(0.2),
                ),
                const SizedBox(height: 8),
                Text(
                  'Langkah $_currentStep dari ${widget.writingSteps.length}',
                ),
                const SizedBox(height: 12),
                if (_currentStep < widget.writingSteps.length)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      widget.writingSteps[_currentStep].instruction,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Kanvas
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                GestureDetector(
                  onPanStart: (details) {
                    if (_currentStep >= widget.writingSteps.length) return;
                    setState(() {
                      _isDrawing = true;
                      _currentStroke = [details.localPosition];
                    });
                  },
                  onPanUpdate: (details) {
                    if (!_isDrawing) return;
                    setState(() {
                      _currentStroke.add(details.localPosition);
                    });
                  },
                  onPanEnd: (details) {
                    if (!_isDrawing) return;
                    setState(() {
                      _isDrawing = false;
                    });
                    _evaluateStroke();
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: CustomPaint(
                      size: const Size(double.infinity, 300),
                      painter: _GuidedPainter(
                        targetChar: widget.targetChar,
                        steps: widget.writingSteps,
                        currentStep: _currentStep,
                        stepStatus: _stepStatuses[_currentStep],
                        completedStrokes: _completedStrokes,
                        currentStroke: _currentStroke,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: _reset,
                  icon: const Icon(LucideIcons.rotateCcw, size: 16),
                  label: const Text('Mulai Ulang'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Painter untuk Mode Terpandu
class _GuidedPainter extends CustomPainter {
  final String targetChar;
  final List<WritingStep> steps;
  final int currentStep;
  final String stepStatus;
  final List<List<Offset>> completedStrokes;
  final List<Offset> currentStroke;

  _GuidedPainter({
    required this.targetChar,
    required this.steps,
    required this.currentStep,
    required this.stepStatus,
    required this.completedStrokes,
    required this.currentStroke,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Skala (data 0-100, canvas size.width/size.height)
    final scaleX = size.width / 100.0;
    final scaleY = size.height / 100.0;

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

    // Cat untuk goresan selesai
    final completedPaint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;
    for (final stroke in completedStrokes) {
      for (int i = 0; i < stroke.length - 1; i++) {
        canvas.drawLine(stroke[i], stroke[i + 1], completedPaint);
      }
    }

    // Cat untuk panduan langkah
    if (currentStep < steps.length) {
      final step = steps[currentStep];
      final start = Offset(
        step.startPoint.dx * scaleX,
        step.startPoint.dy * scaleY,
      );
      final end = Offset(step.endPoint.dx * scaleX, step.endPoint.dy * scaleY);

      Color guideColor = Colors.blue;
      if (stepStatus == 'incorrect') guideColor = Colors.red;

      final guidePaint = Paint()
        ..color = guideColor.withOpacity(0.5)
        ..strokeWidth = 3.0
        ..style = PaintingStyle.stroke;

      // Gambar garis panduan (contoh: garis lurus)
      canvas.drawLine(start, end, guidePaint);

      // Titik mulai (hijau)
      canvas.drawCircle(start, 8.0, Paint()..color = Colors.green);
      // Titik akhir (merah)
      canvas.drawCircle(end, 6.0, Paint()..color = Colors.red);
    }

    // Cat untuk goresan pengguna saat ini
    final currentPaint = Paint()
      ..color = Colors.black87
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;
    for (int i = 0; i < currentStroke.length - 1; i++) {
      canvas.drawLine(currentStroke[i], currentStroke[i + 1], currentPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
