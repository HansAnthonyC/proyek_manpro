import 'package:hanacaraka_app/services/data_service.dart';

class TranslatorService {
  // Peta akan dibangun oleh DataService
  late Map<String, String> _latinToJavaMap;
  late Map<String, String> _javaToLatinMap;

  // Ubah constructor untuk MENERIMA DataService
  TranslatorService(DataService dataService) {
    _latinToJavaMap = {};
    _javaToLatinMap = {};

    // Bangun peta dari data yang sudah dimuat
    for (var aksara in dataService.allAksara) {
      // Hanya petakan kategori dasar untuk transliterasi sederhana
      if (aksara.kategori == 'nglegena' || aksara.kategori == 'wilangan') {
        // Peta Latin -> Jawa
        _latinToJavaMap[aksara.namaLatin.toLowerCase()] = aksara.aksara;
        // Peta Jawa -> Latin
        _javaToLatinMap[aksara.aksara] = aksara.namaLatin;
      }
    }

    // // Anda mungkin perlu menambahkan pemetaan manual untuk 'nga', 'nya', 'dha', 'tha'
    // // jika tidak ada di CSV sebagai 'namaLatin' yang unik
    // _latinToJavaMap['nga'] = 'ꦔ';
    // _latinToJavaMap['nya'] = 'ꦚ';
    // _latinToJavaMap['dha'] = 'ꦝ';
    // _latinToJavaMap['tha'] = 'ꦛ';
    // // ... etc
  }

  String translateLatinToJava(String text) {
    // Logika ini disederhanakan. Untuk aplikasi nyata, Anda perlu
    // logika yang lebih kompleks untuk menangani 'pangkon' (paten)
    // dan 'pasangan' secara otomatis.
    final words = text.toLowerCase().split(' ');
    final translatedWords = words.map((word) {
      if (word.isEmpty) return '';
      String result = '';
      int i = 0;
      while (i < word.length) {
        bool found = false;
        // Cari 3-huruf (nga, nya, dll)
        if (i + 3 <= word.length) {
          String substr = word.substring(i, i + 3);
          if (_latinToJavaMap.containsKey(substr)) {
            // <-- Gunakan peta dinamis
            result += _latinToJavaMap[substr]!;
            i += 3;
            found = true;
          }
        }
        // Cari 2-huruf
        if (!found && i + 2 <= word.length) {
          String substr = word.substring(i, i + 2);
          if (_latinToJavaMap.containsKey(substr)) {
            // <-- Gunakan peta dinamis
            result += _latinToJavaMap[substr]!;
            i += 2;
            found = true;
          }
        }
        // Cari 1-huruf
        if (!found && i + 1 <= word.length) {
          String substr = word.substring(i, i + 1);
          if (_latinToJavaMap.containsKey(substr)) {
            // <-- Gunakan peta dinamis
            result += _latinToJavaMap[substr]!;
            i += 1;
            found = true;
          }
        }
        // Jika tidak ada, salin huruf aslinya
        if (!found) {
          result += word[i];
          i++;
        }
      }
      return result;
    });
    return translatedWords.join(' ');
  }

  String translateJavaToLatin(String text) {
    String result = '';
    for (int i = 0; i < text.length; i++) {
      String char = text[i];
      if (_javaToLatinMap.containsKey(char)) {
        result += _javaToLatinMap[char]!;
      } else if (char == ' ') {
        result += ' ';
      } else {
        result += char; // Salin karakter yang tidak dikenal
      }
    }
    return result;
  }
}
