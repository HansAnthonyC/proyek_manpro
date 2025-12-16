import 'dart:convert';
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
      print("[DataService] Starting to load aksara.csv...");
      final aksaraRaw = await rootBundle.loadString('assets/data/aksara.csv');
      print(
          "[DataService] aksara.csv loaded, raw length: ${aksaraRaw.length} chars");

      _allAksara = await compute(_parseAksaraCsv, aksaraRaw);
      print("[DataService] Parsed ${_allAksara.length} aksara entries");

      // Debug: Print first 5 aksara to see ID, kategori, namaLatin
      print("[DataService] First 5 aksara:");
      for (int i = 0; i < _allAksara.length && i < 5; i++) {
        final a = _allAksara[i];
        print(
            "[DataService]   [$i] id='${a.id}' kategori='${a.kategori}' namaLatin='${a.namaLatin}'");
      }

      // 2. Proses Mapping SEGERA setelah aksara dimuat (sebelum load contoh)
      _kategoriMap = {};
      _javaToLatinMap = {};

      for (var aksara in _allAksara) {
        if (aksara.kategori.isNotEmpty) {
          if (!_kategoriMap.containsKey(aksara.kategori)) {
            _kategoriMap[aksara.kategori] = [];
          }
          _kategoriMap[aksara.kategori]!.add(aksara);
        }

        if (aksara.namaLatin.isNotEmpty) {
          _javaToLatinMap[aksara.aksara] = aksara.namaLatin;
        }
      }

      print(
          "[DataService] Created ${_kategoriMap.keys.length} categories: ${_kategoriMap.keys.toList()}");
      for (var key in _kategoriMap.keys) {
        print("[DataService]   - $key: ${_kategoriMap[key]!.length} items");
      }

      // 3. Muat Contoh Penggunaan (dalam try-catch terpisah agar tidak gagalkan seluruh loading)
      try {
        print("[DataService] Starting to load contoh_penggunaan.csv...");
        final contohBytes =
            await rootBundle.load('assets/data/contoh_penggunaan.csv');
        // FIX: Use utf8.decode for proper multi-byte character decoding (Javanese script)
        final contohRaw = utf8.decode(
          contohBytes.buffer.asUint8List(),
          allowMalformed: true,
        );
        print(
            "[DataService] contoh_penggunaan.csv loaded, raw length: ${contohRaw.length} chars");

        _allContoh = await compute(_parseContohCsv, contohRaw);
        print("[DataService] Parsed ${_allContoh.length} contoh entries");
      } catch (e) {
        print(
            "[DataService] WARNING: Failed to load contoh_penggunaan.csv: $e");
        print("[DataService] Contoh penggunaan will not be available.");
        _allContoh = [];
      }

      notifyListeners();
      print("[DataService] Data loading complete!");
    } catch (e, stackTrace) {
      print("[DataService] ERROR loading data: $e");
      print("[DataService] Stack trace: $stackTrace");
    }
  }
}
