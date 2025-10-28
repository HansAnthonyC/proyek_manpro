// Diterjemahkan dari WritingStepsData.ts
import 'package:flutter/material.dart';

class WritingStep {
  final int id;
  final String instruction;
  final Offset startPoint; // Diubah ke Offset (x, y)
  final Offset endPoint;
  final String strokeType;

  const WritingStep({
    required this.id,
    required this.instruction,
    required this.startPoint,
    required this.endPoint,
    required this.strokeType,
  });
}

// Data langkah-langkah
const Map<String, List<WritingStep>> writingStepsData = {
  // Aksara Ha (ꦲ)
  'ꦲ': [
    WritingStep(
      id: 1,
      instruction:
          "Mulai dari kiri atas, buat lengkungan ke kanan (seperti kepala)",
      startPoint: Offset(25, 25),
      endPoint: Offset(65, 25),
      strokeType: 'curve',
    ),
    WritingStep(
      id: 2,
      instruction:
          "Dari ujung kanan, lengkung turun ke tengah kiri membentuk perut",
      startPoint: Offset(65, 25),
      endPoint: Offset(30, 45),
      strokeType: 'curve',
    ),
    WritingStep(
      id: 3,
      instruction:
          "Dari tengah kiri, lengkung kembali ke kanan membentuk bagian bawah",
      startPoint: Offset(30, 45),
      endPoint: Offset(70, 50),
      strokeType: 'curve',
    ),
    WritingStep(
      id: 4,
      instruction: "Dari ujung kanan bawah, lengkung turun ke tengah bawah",
      startPoint: Offset(70, 50),
      endPoint: Offset(45, 65),
      strokeType: 'curve',
    ),
    WritingStep(
      id: 5,
      instruction: "Dari tengah bawah, tarik ekor pendek ke bawah di tengah",
      startPoint: Offset(45, 65),
      endPoint: Offset(50, 80),
      strokeType: 'vertical',
    ),
  ],
  // Aksara Na (ꦤ)
  'ꦤ': [
    WritingStep(
      id: 1,
      instruction: "Mulai dari kiri atas, tarik garis melengkung ke tengah",
      startPoint: Offset(30, 20),
      endPoint: Offset(50, 40),
      strokeType: 'curve',
    ),
    // ... etc
  ],
  // ... Tambahkan data langkah lainnya ...
};

// Fungsi helper
List<WritingStep> getWritingSteps(String character) {
  return writingStepsData[character] ??
      [
        WritingStep(
          id: 1,
          instruction:
              "Tulis karakter ini dengan hati-hati mengikuti bentuk dasarnya",
          startPoint: Offset(25, 25),
          endPoint: Offset(75, 75),
          strokeType: 'curve',
        ),
      ];
}
