// Diterjemahkan dari GoogleTranslateStyle.tsx
import 'package:hanacaraka_app/data/hanacaraka_data.dart';

class TranslatorService {
  // Peta terbalik untuk Java -> Latin
  late Map<String, String> _javaToLatinMap;

  TranslatorService() {
    _javaToLatinMap = {};
    latinToHanacarakaMap.forEach((latin, java) {
      _javaToLatinMap[java] = latin;
    });
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
          if (latinToHanacarakaMap.containsKey(substr)) {
            result += latinToHanacarakaMap[substr]!;
            i += 3;
            found = true;
          }
        }
        // Cari 2-huruf
        if (!found && i + 2 <= word.length) {
          String substr = word.substring(i, i + 2);
          if (latinToHanacarakaMap.containsKey(substr)) {
            result += latinToHanacarakaMap[substr]!;
            i += 2;
            found = true;
          }
        }
        // Cari 1-huruf
        if (!found && i + 1 <= word.length) {
          String substr = word.substring(i, i + 1);
          if (latinToHanacarakaMap.containsKey(substr)) {
            result += latinToHanacarakaMap[substr]!;
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
