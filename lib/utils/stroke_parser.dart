import 'package:flutter/material.dart';

/// Model untuk satu langkah goresan dalam Mode Terpandu
class StrokeStep {
  final int index;
  final Offset startPoint; // Koordinat 0-100
  final Offset endPoint; // Koordinat 0-100
  final String instruction;

  const StrokeStep({
    required this.index,
    required this.startPoint,
    required this.endPoint,
    required this.instruction,
  });

  /// Parse dari format string: "index|start_x,start_y|end_x,end_y|instruction"
  factory StrokeStep.fromString(String data) {
    final parts = data.split('|');
    if (parts.length < 4) {
      throw FormatException('Invalid stroke step format: $data');
    }

    final index = int.parse(parts[0].trim());

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

    return StrokeStep(
      index: index,
      startPoint: startPoint,
      endPoint: endPoint,
      instruction: instruction,
    );
  }
}

/// Parse stroke order data dari CSV ke list of StrokeStep
List<StrokeStep> parseStrokeOrderData(String? strokeOrderData) {
  if (strokeOrderData == null || strokeOrderData.isEmpty) {
    return [];
  }

  try {
    // Split by newline untuk setiap langkah
    final lines = strokeOrderData
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    return lines.map((line) => StrokeStep.fromString(line)).toList();
  } catch (e) {
    print('[StrokeParser] Error parsing stroke data: $e');
    return [];
  }
}
