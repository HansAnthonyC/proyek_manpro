import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:hanacaraka_app/models/aksara_model.dart';
import 'package:hanacaraka_app/models/contoh_penggunaan_model.dart';

// --- (Fungsi _parseAksaraCsv dan _parseContohCsv tetap sama) ---
List<AksaraModel> _parseAksaraCsv(String csvString) {
  List<List<dynamic>> aksaraList =
      const CsvToListConverter().convert(csvString);

  if (aksaraList.isNotEmpty) {
    aksaraList.removeAt(0); // Hapus header
  }

  return aksaraList.map((row) => AksaraModel.fromCsvList(row)).toList();
}

List<ContohPenggunaanModel> _parseContohCsv(String csvString) {
  List<List<dynamic>> contohList =
      const CsvToListConverter().convert(csvString);

  if (contohList.isNotEmpty) {
    contohList.removeAt(0); // Hapus header
  }

  return contohList
      .map((row) => ContohPenggunaanModel.fromCsvList(row))
      .toList();
}
// --- (Akhir fungsi parse) ---

class DataService with ChangeNotifier {
  List<AksaraModel> _allAksara = [];
  List<ContohPenggunaanModel> _allContoh = [];
  Map<String, List<AksaraModel>> _kategoriMap = {};
  Map<String, String> _javaToLatinMap = {};
  Map<String, String> get javaToLatinMap => _javaToLatinMap;

  // Getters publik untuk UI
  List<AksaraModel> get allAksara => _allAksara;
  List<String> get kategoriKeys => _kategoriMap.keys.toList();

  List<AksaraModel> getAksaraByCategory(String kategori) {
    return _kategoriMap[kategori] ?? [];
  }

  List<ContohPenggunaanModel> getContohForAksara(String aksaraId) {
    return _allContoh.where((c) => c.aksaraId == aksaraId).toList();
  }

  // Fungsi untuk memuat data saat aplikasi dimulai
  Future<void> loadData() async {
    // 1. Muat Aksara.csv
    final aksaraRaw = await rootBundle.loadString('assets/data/aksara.csv');
    _allAksara = await compute(_parseAksaraCsv, aksaraRaw);

    // 2. Muat contoh_penggunaan.csv
    final contohRaw =
        await rootBundle.loadString('assets/data/contoh_penggunaan.csv');
    _allContoh = await compute(_parseContohCsv, contohRaw);

    // 3. Proses data ke dalam map untuk akses cepat
    _kategoriMap = {};
    _javaToLatinMap = {};
    for (var aksara in _allAksara) {
      if (!_kategoriMap.containsKey(aksara.kategori)) {
        _kategoriMap[aksara.kategori] = [];
      }
      _kategoriMap[aksara.kategori]!.add(aksara);

      // --- PERBAIKAN UTAMA DI SINI ---
      // Ganti blok 'if' yang rumit dengan yang ini
      if (aksara.namaLatin.isNotEmpty) {
        _javaToLatinMap[aksara.aksara] = aksara.namaLatin;
      }
      // --- AKHIR PERBAIKAN ---
    }

    // Beri tahu UI bahwa data sudah siap
    notifyListeners();
  }
}
