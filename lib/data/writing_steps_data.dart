// Diterjemahkan dari WritingStepsData.ts
// UPDATED: Now supports parsing from AksaraModel.strokeOrderData
import 'package:flutter/material.dart';

class WritingStep {
  final int id;
  final String instruction;
  final Offset startPoint; // Koordinat 0-100
  final Offset endPoint; // Koordinat 0-100
  final String strokeType;

  const WritingStep({
    required this.id,
    required this.instruction,
    required this.startPoint,
    required this.endPoint,
    required this.strokeType,
  });

  /// Parse dari format string: "index|start_x,start_y|end_x,end_y|instruction"
  factory WritingStep.fromStrokeData(String data) {
    final parts = data.split('|');
    if (parts.length < 4) {
      throw FormatException('Invalid stroke step format: $data');
    }

    final id = int.parse(parts[0].trim());

    final startCoords = parts[1].split(',');
    final startPoint = Offset(
      double.parse(startCoords[0].trim()),
      double.parse(startCoords[1].trim()),
    );

    final endCoords = parts[2].split(',');
    final endPoint = Offset(
      double.parse(endCoords[0].trim()),
      double.parse(endCoords[1].trim()),
    );

    final instruction = parts[3].trim();

    return WritingStep(
      id: id,
      instruction: instruction,
      startPoint: startPoint,
      endPoint: endPoint,
      strokeType: 'curve', // Default stroke type
    );
  }
}

/// Parse stroke order data dari AksaraModel.strokeOrderData
/// Format: "1|x1,y1|x2,y2|instruction\n2|x1,y1|x2,y2|instruction\n..."
List<WritingStep> parseStrokeOrderData(String? strokeOrderData) {
  if (strokeOrderData == null || strokeOrderData.isEmpty) {
    return [];
  }

  try {
    // Split by newline untuk setiap langkah
    final lines = strokeOrderData
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty && line.contains('|'))
        .toList();

    if (lines.isEmpty) {
      return [];
    }

    return lines.map((line) => WritingStep.fromStrokeData(line)).toList();
  } catch (e) {
    print('[WritingStepsData] Error parsing stroke data: $e');
    return [];
  }
}

/// Fungsi helper - dapatkan writing steps dari strokeOrderData string
/// atau gunakan fallback step jika data tidak tersedia
List<WritingStep> getWritingStepsFromData(
    String? strokeOrderData, String characterName) {
  final steps = parseStrokeOrderData(strokeOrderData);

  if (steps.isNotEmpty) {
    return steps;
  }

  // Fallback: satu langkah generik jika data tidak tersedia
  return [
    WritingStep(
      id: 1,
      instruction:
          "Tulis karakter '$characterName' dengan mengikuti bentuk dasarnya",
      startPoint: const Offset(25, 25),
      endPoint: const Offset(75, 75),
      strokeType: 'curve',
    ),
  ];
}

// DEPRECATED: Legacy function - kept for backward compatibility
// Hardcoded data - will be replaced by CSV data
const Map<String, List<WritingStep>> writingStepsData = {
  // Aksara Ha (ꦲ) - dengan format baru
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
};

// Legacy function - uses hardcoded data
List<WritingStep> getWritingSteps(String character) {
  return writingStepsData[character] ??
      [
        WritingStep(
          id: 1,
          instruction:
              "Tulis karakter ini dengan hati-hati mengikuti bentuk dasarnya",
          startPoint: const Offset(25, 25),
          endPoint: const Offset(75, 75),
          strokeType: 'curve',
        ),
      ];
}
