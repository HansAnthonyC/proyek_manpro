import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:hanacaraka_app/models/aksara_model.dart';
import 'package:hanacaraka_app/models/contoh_penggunaan_model.dart';

// --- Fungsi Parsing ---

List<AksaraModel> _parseAksaraCsv(String csvString) {
  List<List<dynamic>> aksaraList =
      const CsvToListConverter().convert(csvString);

  if (aksaraList.isNotEmpty) {
    aksaraList.removeAt(0); // Hapus header
  }
  // Pastikan AksaraModel punya fromCsvList
  return aksaraList.map((row) => AksaraModel.fromCsvList(row)).toList();
}

List<ContohPenggunaanModel> _parseContohCsv(String csvString) {
  List<List<dynamic>> contohList =
      const CsvToListConverter().convert(csvString);

  if (contohList.isNotEmpty) {
    contohList.removeAt(0); // Hapus header
  }
  // FIX: Menggunakan factory .fromCsv sesuai update Model sebelumnya
  return contohList.map((row) => ContohPenggunaanModel.fromCsv(row)).toList();
}

// --- Data Service ---

class DataService with ChangeNotifier {
  List<AksaraModel> _allAksara = [];
  List<ContohPenggunaanModel> _allContoh = [];
  Map<String, List<AksaraModel>> _kategoriMap = {};
  Map<String, String> _javaToLatinMap = {};

  // Getters
  Map<String, String> get javaToLatinMap => _javaToLatinMap;
  List<AksaraModel> get allAksara => _allAksara;
  List<String> get kategoriKeys => _kategoriMap.keys.toList();

  List<AksaraModel> getAksaraByCategory(String kategori) {
    return _kategoriMap[kategori] ?? [];
  }

  // FIX: Parameter diubah ke int agar cocok dengan ID di database/model
  List<ContohPenggunaanModel> getContohForAksara(int aksaraId) {
    return _allContoh.where((c) => c.aksaraId == aksaraId).toList();
  }

  Future<void> loadData() async {
    try {
      // 1. Muat Aksara
      final aksaraRaw = await rootBundle.loadString('assets/data/aksara.csv');
      _allAksara = await compute(_parseAksaraCsv, aksaraRaw);

      // 2. Muat Contoh Penggunaan
      final contohRaw =
          await rootBundle.loadString('assets/data/contoh_penggunaan.csv');
      _allContoh = await compute(_parseContohCsv, contohRaw);

      // 3. Proses Mapping
      _kategoriMap = {};
      _javaToLatinMap = {};

      for (var aksara in _allAksara) {
        if (!_kategoriMap.containsKey(aksara.kategori)) {
          _kategoriMap[aksara.kategori] = [];
        }
        _kategoriMap[aksara.kategori]!.add(aksara);

        if (aksara.namaLatin.isNotEmpty) {
          _javaToLatinMap[aksara.aksara] = aksara.namaLatin;
        }
      }

      notifyListeners();
    } catch (e) {
      print("Error loading data: $e");
    }
  }
}
