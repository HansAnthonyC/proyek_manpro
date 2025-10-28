// Diterjemahkan dari HanacarakaData.ts
import 'package:flutter/material.dart';

class HanacarakaChar {
  final String char;
  final String latin;
  final String pronunciation;
  final String category;
  final String? description;
  final String? example;
  final List<Map<String, String>>?
  examples; // javanese, latin, meaning, pronunciation

  const HanacarakaChar({
    required this.char,
    required this.latin,
    required this.pronunciation,
    required this.category,
    this.description,
    this.example,
    this.examples,
  });
}

// Kategori
const Map<String, String> categoryNames = {
  'nglegena': 'Aksara Nglegena',
  'murda': 'Aksara Murda',
  'swara': 'Aksara Swara',
  'sandhangan': 'Sandhangan',
  'rekan': 'Aksara Rekan',
  'wilangan': 'Wilangan',
  'pasangan': 'Pasangan',
};

// Data (Saya singkat agar ringkas, tapi Anda bisa copy-paste penuh dari file .ts)
const List<HanacarakaChar> aksaraNglegena = [
  HanacarakaChar(
    char: 'ꦲ',
    latin: 'ha',
    pronunciation: 'ha',
    category: 'nglegena',
    description: 'Huruf pertama dalam urutan Hanacaraka',
    example: 'ꦲꦤ (ana)',
    examples: [
      {
        'javanese': 'ꦲꦏꦸ',
        'latin': 'aku',
        'meaning': 'saya',
        'pronunciation': 'a-ku',
      },
      {
        'javanese': 'ꦲꦤ',
        'latin': 'ana',
        'meaning': 'ada',
        'pronunciation': 'a-na',
      },
      {
        'javanese': 'ꦲꦪꦸ',
        'latin': 'ayu',
        'meaning': 'cantik',
        'pronunciation': 'a-yu',
      },
      {
        'javanese': 'ꦲꦤꦏ꧀',
        'latin': 'anak',
        'meaning': 'anak',
        'pronunciation': 'a-nak',
      },
      {
        'javanese': 'ꦲꦶꦁ',
        'latin': 'ing',
        'meaning': 'di',
        'pronunciation': 'ing',
      },
    ],
  ),
  HanacarakaChar(
    char: 'ꦤ',
    latin: 'na',
    pronunciation: 'na',
    category: 'nglegena',
    description: 'Huruf kedua dalam urutan Hanacaraka',
    example: 'ꦤꦩ (nama)',
    examples: [
      {
        'javanese': 'ꦤꦩ',
        'latin': 'nama',
        'meaning': 'nama',
        'pronunciation': 'na-ma',
      },
      {
        'javanese': 'ꦤꦤ',
        'latin': 'nana',
        'meaning': 'nanas',
        'pronunciation': 'na-na',
      },
    ],
  ),
  // ... Tambahkan 18 aksara nglegena lainnya ...
  HanacarakaChar(
    char: 'ꦕ',
    latin: 'ca',
    pronunciation: 'cha',
    category: 'nglegena',
  ),
  HanacarakaChar(
    char: 'ꦫ',
    latin: 'ra',
    pronunciation: 'ra',
    category: 'nglegena',
  ),
  HanacarakaChar(
    char: 'ꦏ',
    latin: 'ka',
    pronunciation: 'ka',
    category: 'nglegena',
  ),
  HanacarakaChar(
    char: 'ꦢ',
    latin: 'da',
    pronunciation: 'da',
    category: 'nglegena',
  ),
  HanacarakaChar(
    char: 'ꦠ',
    latin: 'ta',
    pronunciation: 'ta',
    category: 'nglegena',
  ),
  HanacarakaChar(
    char: 'ꦱ',
    latin: 'sa',
    pronunciation: 'sa',
    category: 'nglegena',
  ),
  HanacarakaChar(
    char: 'ꦮ',
    latin: 'wa',
    pronunciation: 'wa',
    category: 'nglegena',
  ),
  HanacarakaChar(
    char: 'ꦭ',
    latin: 'la',
    pronunciation: 'la',
    category: 'nglegena',
  ),
  HanacarakaChar(
    char: 'ꦥ',
    latin: 'pa',
    pronunciation: 'pa',
    category: 'nglegena',
  ),
  HanacarakaChar(
    char: 'ꦝ',
    latin: 'dha',
    pronunciation: 'dha',
    category: 'nglegena',
  ),
  HanacarakaChar(
    char: 'ꦗ',
    latin: 'ja',
    pronunciation: 'ja',
    category: 'nglegena',
  ),
  HanacarakaChar(
    char: 'ꦪ',
    latin: 'ya',
    pronunciation: 'ya',
    category: 'nglegena',
  ),
  HanacarakaChar(
    char: 'ꦚ',
    latin: 'nya',
    pronunciation: 'nya',
    category: 'nglegena',
  ),
  HanacarakaChar(
    char: 'ꦩ',
    latin: 'ma',
    pronunciation: 'ma',
    category: 'nglegena',
  ),
  HanacarakaChar(
    char: 'ꦒ',
    latin: 'ga',
    pronunciation: 'ga',
    category: 'nglegena',
  ),
  HanacarakaChar(
    char: 'ꦧ',
    latin: 'ba',
    pronunciation: 'ba',
    category: 'nglegena',
  ),
  HanacarakaChar(
    char: 'ꦛ',
    latin: 'tha',
    pronunciation: 'tha',
    category: 'nglegena',
  ),
  HanacarakaChar(
    char: 'ꦔ',
    latin: 'nga',
    pronunciation: 'nga',
    category: 'nglegena',
  ),
];

const List<HanacarakaChar> aksaraMurda = [
  HanacarakaChar(
    char: 'ꦤ꦳',
    latin: 'Na',
    pronunciation: 'Na',
    category: 'murda',
  ),
  HanacarakaChar(
    char: 'ꦏ꦳',
    latin: 'Ka',
    pronunciation: 'Ka',
    category: 'murda',
  ),
  // ... etc
];
const List<HanacarakaChar> aksaraSwara = [
  HanacarakaChar(char: 'ꦄ', latin: 'a', pronunciation: 'a', category: 'swara'),
  HanacarakaChar(char: 'ꦆ', latin: 'i', pronunciation: 'i', category: 'swara'),
  // ... etc
];
const List<HanacarakaChar> sandhangan = [
  HanacarakaChar(
    char: 'ꦴ',
    latin: 'aa/o',
    pronunciation: 'aa',
    category: 'sandhangan',
  ),
  HanacarakaChar(
    char: 'ꦶ',
    latin: 'i',
    pronunciation: 'i',
    category: 'sandhangan',
  ),
  // ... etc
];
const List<HanacarakaChar> aksaraRekan = [
  HanacarakaChar(
    char: 'ꦥ꦳',
    latin: 'fa',
    pronunciation: 'fa',
    category: 'rekan',
  ),
  HanacarakaChar(
    char: 'ꦮ꦳',
    latin: 'va',
    pronunciation: 'va',
    category: 'rekan',
  ),
  // ... etc
];
const List<HanacarakaChar> wilangan = [
  HanacarakaChar(
    char: '꧐',
    latin: '0',
    pronunciation: 'nol',
    category: 'wilangan',
  ),
  HanacarakaChar(
    char: '꧑',
    latin: '1',
    pronunciation: 'siji',
    category: 'wilangan',
  ),
  // ... etc
];
const List<HanacarakaChar> pasangan = [
  HanacarakaChar(
    char: '꧀ꦲ',
    latin: '-ha',
    pronunciation: '',
    category: 'pasangan',
  ),
  HanacarakaChar(
    char: '꧀ꦤ',
    latin: '-na',
    pronunciation: '',
    category: 'pasangan',
  ),
  // ... etc
];

// Gabungkan semua
final List<HanacarakaChar> allHanacarakaChars = [
  ...aksaraNglegena,
  ...aksaraMurda,
  ...aksaraSwara,
  ...sandhangan,
  ...aksaraRekan,
  ...wilangan,
  ...pasangan,
];

// Peta untuk translator
const Map<String, String> latinToHanacarakaMap = {
  'ha': 'ꦲ', 'na': 'ꦤ', 'ca': 'ꦕ', 'ra': 'ꦫ', 'ka': 'ꦏ',
  'da': 'ꦢ', 'ta': 'ꦠ', 'sa': 'ꦱ', 'wa': 'ꦮ', 'la': 'ꦭ',
  'pa': 'ꦥ', 'dha': 'ꦝ', 'ja': 'ꦗ', 'ya': 'ꦪ', 'nya': 'ꦚ',
  'ma': 'ꦩ', 'ga': 'ꦒ', 'ba': 'ꦧ', 'tha': 'ꦛ', 'nga': 'ꦔ',
  '0': '꧐', '1': '꧑', '2': '꧒', '3': '꧓', '4': '꧔',
  '5': '꧕', '6': '꧖', '7': '꧗', '8': '꧘', '9': '꧙',
  // ... tambahkan pemetaan yang lebih kompleks jika perlu
};
