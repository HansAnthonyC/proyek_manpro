// Diterjemahkan dari CategoryColors.ts
import 'package:flutter/material.dart';

class CategoryColorSet {
  final Color main;
  final Color light;
  final Color border;
  final Color text;

  const CategoryColorSet({
    required this.main,
    required this.light,
    required this.border,
    required this.text,
  });
}

CategoryColorSet getCategoryColors(String category) {
  final Map<String, CategoryColorSet> colors = {
    'nglegena': CategoryColorSet(
      main: Color(0xFFF97316), // Orange
      light: Color(0xFFF97316).withOpacity(0.1),
      border: Color(0xFFF97316).withOpacity(0.3),
      text: Color(0xFFF97316),
    ),
    'murda': CategoryColorSet(
      main: Color(0xFFDC2626), // Red
      light: Color(0xFFDC2626).withOpacity(0.1),
      border: Color(0xFFDC2626).withOpacity(0.3),
      text: Color(0xFFDC2626),
    ),
    'swara': CategoryColorSet(
      main: Color(0xFF2563EB), // Blue
      light: Color(0xFF2563EB).withOpacity(0.1),
      border: Color(0xFF2563EB).withOpacity(0.3),
      text: Color(0xFF2563EB),
    ),
    'sandhangan': CategoryColorSet(
      main: Color(0xFF059669), // Green
      light: Color(0xFF059669).withOpacity(0.1),
      border: Color(0xFF059669).withOpacity(0.3),
      text: Color(0xFF059669),
    ),
    'rekan': CategoryColorSet(
      main: Color(0xFF7C3AED), // Purple
      light: Color(0xFF7C3AED).withOpacity(0.1),
      border: Color(0xFF7C3AED).withOpacity(0.3),
      text: Color(0xFF7C3AED),
    ),
    'wilangan': CategoryColorSet(
      main: Color(0xFFEA580C), // Dark Orange
      light: Color(0xFFEA580C).withOpacity(0.1),
      border: Color(0xFFEA580C).withOpacity(0.3),
      text: Color(0xFFEA580C),
    ),
    'pasangan': CategoryColorSet(
      main: Color(0xFF0891B2), // Cyan
      light: Color(0xFF0891B2).withOpacity(0.1),
      border: Color(0xFF0891B2).withOpacity(0.3),
      text: Color(0xFF0891B2),
    ),
  };

  return colors[category] ?? colors['nglegena']!;
}
