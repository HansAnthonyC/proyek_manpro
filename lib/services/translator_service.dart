import 'package:flutter/foundation.dart';

class TranslatorService {
  // --- 1. DATABASE AKSARA (DIPERLENGKAPI) ---

  static const Map<String, String> HURUF = {
    'h': 'ꦲ', 'n': 'ꦤ', 'c': 'ꦕ', 'r': 'ꦫ', 'k': 'ꦏ',
    'd': 'ꦢ', 't': 'ꦠ', 's': 'ꦱ', 'w': 'ꦮ', 'l': 'ꦭ',
    'p': 'ꦥ', 'dh': 'ꦝ', 'j': 'ꦗ', 'y': 'ꦪ', 'ny': 'ꦚ',
    'm': 'ꦩ', 'g': 'ꦒ', 'b': 'ꦧ', 'th': 'ꦛ', 'ng': 'ꦔ',
    // Tambahan Aksara Rekan & Ganten (untuk f, v, z, x, q)
    'f': 'ꦥ꦳', 'v': 'ꦥ꦳', // Fa/Va (Pa + Cecak Telu)
    'z': 'ꦗ꦳', // Za (Ja + Cecak Telu)
    'q': 'ꦏ꧀', // Qa (Ka) - pendekatan
    'x': 'ꦏ꧀ꦱ', // X (Ksa)
    'kh': 'ꦏ꦳', // Kha
    'sy': 'ꦯ', // Sya (Sa Murda)
    'dz': 'ꦢ꦳', // Dza
    ',': '꧈', '.': '꧉', ' ': ' '
  };

  // --- ANGKA JAWA ---
  static const Map<String, String> ANGKA = {
    '0': '꧐',
    '1': '꧑',
    '2': '꧒',
    '3': '꧓',
    '4': '꧔',
    '5': '꧕',
    '6': '꧖',
    '7': '꧗',
    '8': '꧘',
    '9': '꧙',
  };

  // Reverse mapping untuk Jawa ke Latin
  static const Map<String, String> ANGKA_TO_LATIN = {
    '꧐': '0',
    '꧑': '1',
    '꧒': '2',
    '꧓': '3',
    '꧔': '4',
    '꧕': '5',
    '꧖': '6',
    '꧗': '7',
    '꧘': '8',
    '꧙': '9',
  };

  static const Map<String, String> PASANGAN = {
    'h': '꧀ꦲ', 'n': '꧀ꦤ', 'c': '꧀ꦕ', 'r': '꧀ꦫ', 'k': '꧀ꦏ',
    'd': '꧀ꦢ', 't': '꧀ꦠ', 's': '꧀ꦱ', 'w': '꧀ꦮ', 'l': '꧀ꦭ',
    'p': '꧀ꦥ', 'dh': '꧀ꦝ', 'j': '꧀ꦗ', 'y': '꧀ꦪ', 'ny': '꧀ꦚ',
    'm': '꧀ꦩ', 'g': '꧀ꦒ', 'b': '꧀ꦧ', 'th': '꧀ꦛ', 'ng': '꧀ꦔ',
    // Pasangan untuk huruf tambahan (fallback ke pangkon jika tidak ada pasangan asli)
    'f': '꧀ꦥ꦳', 'v': '꧀ꦥ꦳', 'z': '꧀ꦗ꦳'
  };

  static const Map<String, String> SANDHANGAN = {
    'wulu': 'ꦶ',
    'suku': 'ꦸ',
    'pepet': 'ꦼ',
    'taling': 'ꦺ',
    'taling-tarung': 'ꦺꦴ',
    'cecak': 'ꦁ',
    'wignyan': 'ꦃ',
    'layar': 'ꦂ',
    'cakra': 'ꦿ',
    'keret': 'ꦽ',
    'pengkal': 'ꦾ',
    'pangkon': '꧀'
  };

  static const List<String> VOWELS = [
    'a',
    'i',
    'u',
    'e',
    'o',
    'é',
    'è',
    'ê',
    'A',
    'I',
    'U',
    'E',
    'O'
  ];

  // --- REVERSE LOOKUP MAPS (Jawa -> Latin) ---

  // Map aksara dasar ke Latin (reverse of HURUF)
  static const Map<String, String> JAWA_TO_LATIN = {
    'ꦲ': 'ha', 'ꦤ': 'na', 'ꦕ': 'ca', 'ꦫ': 'ra', 'ꦏ': 'ka',
    'ꦢ': 'da', 'ꦠ': 'ta', 'ꦱ': 'sa', 'ꦮ': 'wa', 'ꦭ': 'la',
    'ꦥ': 'pa', 'ꦝ': 'dha', 'ꦗ': 'ja', 'ꦪ': 'ya', 'ꦚ': 'nya',
    'ꦩ': 'ma', 'ꦒ': 'ga', 'ꦧ': 'ba', 'ꦛ': 'tha', 'ꦔ': 'nga',
    'ꦯ': 'sa', // Sa Murda
    '꧈': ',', '꧉': '.', ' ': ' ',
  };

  // Map sandhangan ke vokal Latin
  static const Map<String, String> SANDHANGAN_TO_VOWEL = {
    'ꦶ': 'i', // wulu
    'ꦸ': 'u', // suku
    'ꦼ': 'e', // pepet
    'ꦺ': 'é', // taling
    'ꦴ': 'o', // tarung (setelah taling jadi 'o')
    'ꦁ': 'ng', // cecak
    'ꦃ': 'h', // wignyan
    'ꦂ': 'r', // layar
    'ꦿ': 'ra', // cakra
    'ꦽ': 're', // keret
    'ꦾ': 'ya', // pengkal
    '꧀': '', // pangkon (mati, hapus vokal default)
  };

  // --- MAIN FUNCTION ---

  String translate(String text) {
    if (text.isEmpty) return "";
    String normalized = text.toLowerCase().trim();
    // Hilangkan karakter yang tidak didukung agar tidak crash, tapi biarkan spasi/tanda baca
    // Atau biarkan, nanti di-handle sebagai 'unknown' (huruf latin asli)
    return _doTransliterate(normalized);
  }

  /// Terjemahkan Aksara Jawa ke Latin
  String translateToLatin(String javaText) {
    if (javaText.isEmpty) return "";
    return _doTransliterateToLatin(javaText);
  }

  String _doTransliterateToLatin(String text) {
    StringBuffer result = StringBuffer();
    List<String> chars = text.runes.map((r) => String.fromCharCode(r)).toList();

    int i = 0;
    while (i < chars.length) {
      String char = chars[i];

      // Skip spasi
      if (char == ' ') {
        result.write(' ');
        i++;
        continue;
      }

      // Cek apakah angka Jawa
      if (ANGKA_TO_LATIN.containsKey(char)) {
        result.write(ANGKA_TO_LATIN[char]);
        i++;
        continue;
      }

      // Cek apakah aksara dasar
      if (JAWA_TO_LATIN.containsKey(char)) {
        String latin = JAWA_TO_LATIN[char]!;

        // Default vokal adalah 'a', tapi bisa di-override oleh sandhangan
        String baseConsonant = latin.replaceAll('a', ''); // Hapus vokal default
        String vowel = 'a'; // Default
        bool hasPangkon = false;

        // Cek sandhangan setelah aksara
        int j = i + 1;
        while (j < chars.length && SANDHANGAN_TO_VOWEL.containsKey(chars[j])) {
          String sandhanganChar = chars[j];
          String sandhanganValue = SANDHANGAN_TO_VOWEL[sandhanganChar]!;

          if (sandhanganChar == '꧀') {
            // Pangkon = konsonan mati
            hasPangkon = true;
            vowel = '';
          } else if (sandhanganChar == 'ꦴ') {
            // Tarung - jika sebelumnya taling, jadi 'o'
            if (vowel == 'é') vowel = 'o';
          } else if (sandhanganChar == 'ꦺ') {
            // Taling
            vowel = 'é';
          } else if (['ꦁ', 'ꦃ', 'ꦂ'].contains(sandhanganChar)) {
            // Cecak, wignyan, layar - akhiran konsonan
            result.write(baseConsonant + vowel + sandhanganValue);
            vowel = ''; // Sudah ditulis
            baseConsonant = '';
          } else if (['ꦿ', 'ꦽ', 'ꦾ'].contains(sandhanganChar)) {
            // Cakra, keret, pengkal - sisipan
            baseConsonant += sandhanganValue;
          } else {
            // Vokal biasa (wulu, suku, pepet)
            vowel = sandhanganValue;
          }
          j++;
        }

        // FIX: Jika karakter berikutnya (setelah sandhangan) adalah pangkon (꧀),
        // maka aksara ini kehilangan vokal default karena itu bagian dari pasangan berikutnya
        if (j < chars.length && chars[j] == '꧀') {
          vowel = ''; // Konsonan mati karena diikuti pasangan
        }

        // Tulis hasil
        if (baseConsonant.isNotEmpty || vowel.isNotEmpty) {
          result.write(baseConsonant + vowel);
        }

        i = j;
      }
      // Cek apakah pangkon (untuk pasangan)
      else if (char == '꧀') {
        // Pangkon di awal biasanya bagian dari pasangan, skip
        i++;
      }
      // Karakter tidak dikenal, tulis apa adanya
      else {
        result.write(char);
        i++;
      }
    }

    return result.toString();
  }

  // --- CORE LOGIC ---

  String _doTransliterate(String text) {
    String result = '';
    List<String> tokens = _tokenizeSentence(text);

    print('[Translator] Input: "$text"');
    print('[Translator] Tokens: $tokens');

    for (int i = 0; i < tokens.length; i++) {
      String token = tokens[i];
      String? prevToken = (i > 0) ? tokens[i - 1] : null;
      String? nextToken = (i < tokens.length - 1) ? tokens[i + 1] : null;

      // Deteksi AKHIR KALIMAT sesungguhnya (bukan spasi!)
      // FIX: Hapus ' ' dari kondisi isEnd - pangkon hanya di akhir kalimat/titik/koma
      bool isEnd = (nextToken == null || nextToken == ',' || nextToken == '.');

      // Abaikan spasi di processing token, tapi masukkan ke result jika perlu
      if (token == ' ') {
        result += ' ';
        continue;
      }

      // FIX: Jika prev adalah spasi, cari token sebelum spasi untuk deteksi pasangan
      // Aturan: Kata setelah kata yg berakhir konsonan mati harus pakai pasangan
      String? effectivePrev = prevToken;
      if (prevToken == ' ' && i >= 2) {
        effectivePrev = tokens[i - 2]; // Token sebelum spasi
      }

      // Cek apakah token adalah angka
      if (RegExp(r'^\d+$').hasMatch(token)) {
        // Konversi setiap digit ke angka Jawa
        for (var digit in token.split('')) {
          result += ANGKA[digit] ?? digit;
        }
        continue;
      }

      String translated =
          _transliterateToken(token, isEnd, effectivePrev, nextToken);
      print('[Translator] Token "$token" -> "$translated"');
      result += translated;
    }
    print('[Translator] Result: "$result"');
    return result;
  }

  List<String> _tokenizeSentence(String text) {
    List<String> allTokens = [];

    // Regex split dengan tetap menyimpan delimiter (spasi, koma, titik)
    RegExp delimiter = RegExp(r'([\s,\.])');
    List<String> parts = text
        .splitMapJoin(delimiter,
            onMatch: (m) => '\uFFFF${m.group(0)}\uFFFF', // Marker unik
            onNonMatch: (n) => n)
        .split('\uFFFF');

    for (String part in parts) {
      if (part.isEmpty) continue;
      if ([' ', ',', '.'].contains(part)) {
        allTokens.add(part);
      } else if (RegExp(r'^\d+$').hasMatch(part)) {
        // Angka: tambahkan langsung tanpa parse ke suku kata
        allTokens.add(part);
      } else {
        allTokens.addAll(_parseWordToSyllables(part));
      }
    }
    return allTokens;
  }

  List<String> _parseWordToSyllables(String word) {
    List<String> ltr = [];
    int start = 0;
    int wordLen = word.length;

    // Daftar konsonan diperluas
    const consonants = [
      'c',
      'k',
      's',
      'w',
      'l',
      'p',
      'j',
      'm',
      'b',
      'f',
      'v',
      'z',
      'q',
      'x'
    ];
    const specials = ['t', 'd'];
    const dobel = [
      'th',
      'dh',
      'ny',
      'ng',
      'kh',
      'sy',
      'dz'
    ]; // Tambah kh, sy, dz
    const insert = ['h', 'y', 'g', 'n'];

    // --- 1. Cek Awalan Ganda (ng, ny, kh, sy...) ---
    bool handledStart = false;
    for (String dob in dobel) {
      if (word.startsWith(dob)) {
        if (wordLen >= dob.length + 1 && _isVowel(word[dob.length])) {
          // e.g. nga
          ltr.add(dob + word[dob.length]);
          start = dob.length + 1;
          handledStart = true;
        } else if (wordLen >= dob.length + 2 &&
            word[dob.length] == 'r' &&
            _isVowel(word[dob.length + 1])) {
          // e.g. ngra
          ltr.add(dob + 'r' + word[dob.length + 1]);
          start = dob.length + 2;
          handledStart = true;
        }
        if (handledStart) break;
      }
    }

    if (!handledStart) {
      for (String ins in insert) {
        if (word.startsWith(ins)) {
          if (wordLen >= 2 && _isVowel(word[1])) {
            ltr.add(ins + word[1]);
            start = 2;
            handledStart = true;
          }
          if (handledStart) break;
        }
      }
    }

    // Jika awalan vokal (e.g. "a-ku") -> tambahkan 'h' implisit untuk vokal awal
    if (!handledStart && word.isNotEmpty && _isVowel(word[0])) {
      ltr.add('h' + word[0]);
      start = 1;
    }

    // --- 2. Loop Parsing Suku Kata ---
    int i = start;
    int safetyCounter = 0; // Mencegah infinite loop

    while (i < wordLen) {
      if (safetyCounter++ > 1000) break; // Break jika loop macet

      String char = word[i];

      if (consonants.contains(char)) {
        if (i + 1 < wordLen) {
          String next = word[i + 1];
          // FIX: Hapus kondisi 'char != l' yang menyebabkan bug
          if (_isVowel(next)) {
            ltr.add(char + next); // Ka, Ba, La, Lo
            i += 2;
          } else if (['l', 'r', 'y'].contains(next) && char != 'l') {
            // Cluster consonant (kra, kla, kya) - tapi 'l' tidak bisa cluster dengan dirinya sendiri
            if (i + 2 < wordLen && _isVowel(word[i + 2])) {
              ltr.add(char + next + word[i + 2]); // Kra, Kla
              i += 3;
            } else {
              ltr.add(char + next); // Kr (mati)
              i += 2;
            }
          } else {
            ltr.add(char); // Konsonan mati
            i += 1;
          }
        } else {
          ltr.add(char); // Akhir kata
          i += 1;
        }
      } else if (specials.contains(char)) {
        // t, d
        if (i + 1 < wordLen) {
          String next = word[i + 1];
          if (next == 'h') {
            // th, dh
            if (i + 2 < wordLen && _isVowel(word[i + 2])) {
              ltr.add(char + 'h' + word[i + 2]); // tha
              i += 3;
            } else {
              ltr.add(char + 'h'); // th mati
              i += 2;
            }
          } else if (['l', 'r'].contains(next)) {
            if (i + 2 < wordLen && _isVowel(word[i + 2])) {
              ltr.add(char + next + word[i + 2]); // tra
              i += 3;
            } else {
              ltr.add(char + next);
              i += 2;
            }
          } else if (_isVowel(next)) {
            ltr.add(char + next); // ta
            i += 2;
          } else {
            ltr.add(char);
            i += 1;
          }
        } else {
          ltr.add(char);
          i += 1;
        }
      } else if (char == 'n') {
        bool matched = false;
        if (i + 1 < wordLen) {
          String next = word[i + 1];
          if (['g', 'y'].contains(next)) {
            // ng, ny
            if (i + 2 < wordLen && _isVowel(word[i + 2])) {
              ltr.add(char + next + word[i + 2]); // nga
              i += 3;
              matched = true;
            } else if (i + 2 < wordLen && !VOWELS.contains(word[i + 2])) {
              ltr.add(char + next); // ng (mati) + konsonan
              i += 2;
              matched = true;
            } else if (i + 2 >= wordLen) {
              ltr.add(char + next); // ng (mati) di akhir
              i += 2;
              matched = true;
            }
          } else if (_isVowel(next)) {
            ltr.add(char + next); // na
            i += 2;
            matched = true;
          }
        }
        if (!matched) {
          ltr.add(char);
          i += 1;
        }
      } else if (['r', 'y', 'g', 'h'].contains(char)) {
        if (i + 1 < wordLen && _isVowel(word[i + 1])) {
          ltr.add(char + word[i + 1]);
          i += 2;
        } else {
          ltr.add(char);
          i += 1;
        }
      } else {
        // Karakter lain (vokal di tengah / simbol asing)
        ltr.add(char);
        i += 1;
      }
    }
    return ltr;
  }

  String _transliterateToken(
      String hrf, bool isEnd, String? prev, String? next) {
    String ltr = '';
    bool isKeret = false;

    // --- 1. HANDLE DOUBLE CHARACTERS (ng, ny, th, dh, kh, sy, dz) ---
    // Gunakan startsWith untuk menangkap variasi vokal (nga, ngi, etc)

    if (hrf.startsWith('ng')) {
      if (hrf.length == 2)
        ltr += SANDHANGAN['cecak'] ?? '';
      else
        ltr += HURUF['ng'] ?? '';

      if (hrf.length > 2) {
        // ngra, ngla
        if (hrf.contains('l'))
          ltr += PASANGAN['l'] ?? '';
        else if (hrf.contains('y'))
          ltr += SANDHANGAN['pengkal'] ?? '';
        else if (hrf.contains('r')) {
          if (hrf.contains('e') && !hrf.contains('é')) {
            ltr += SANDHANGAN['keret'] ?? '';
            isKeret = true;
          } else
            ltr += SANDHANGAN['cakra'] ?? '';
        }
      }
    } else if (hrf.startsWith('ny')) {
      if (prev != null &&
          prev.length == 1 &&
          ![' ', 'h', 'r', 'ng'].contains(prev))
        ltr += PASANGAN['ny'] ?? '';
      else
        ltr += HURUF['ny'] ?? '';
      // Handle sisipan ny-
      if (hrf.length > 2) {
        if (hrf.contains('l'))
          ltr += PASANGAN['l'] ?? '';
        else if (hrf.contains('y'))
          ltr += SANDHANGAN['pengkal'] ?? '';
        else if (hrf.contains('r')) ltr += SANDHANGAN['cakra'] ?? '';
      }
    } else if (hrf.startsWith('th')) {
      if (prev != null && prev.length == 1 && prev != ' ')
        ltr += PASANGAN['th'] ?? '';
      else
        ltr += HURUF['th'] ?? '';
      if (hrf.length > 2 && hrf.contains('r')) ltr += SANDHANGAN['cakra'] ?? '';
    } else if (hrf.startsWith('dh')) {
      if (prev != null && prev.length == 1 && prev != ' ')
        ltr += PASANGAN['dh'] ?? '';
      else
        ltr += HURUF['dh'] ?? '';
      if (hrf.length > 2 && hrf.contains('r')) ltr += SANDHANGAN['cakra'] ?? '';
    }
    // Tambahan Rekan: kh, sy, dz
    else if (hrf.startsWith('kh'))
      ltr += HURUF['kh'] ?? 'kh';
    else if (hrf.startsWith('sy'))
      ltr += HURUF['sy'] ?? 'sy';
    else if (hrf.startsWith('dz'))
      ltr += HURUF['dz'] ?? 'dz';

    // --- 2. HANDLE BASIC SYLLABLES (len 2: ba, ka, fa, va, za) ---
    else if (hrf.length == 2) {
      // Cek apakah kena pasangan dari huruf sebelumnya
      // FIX: Tambah ' ' (spasi) ke exclusion list agar kata setelah spasi tidak kena pasangan
      if (prev != null &&
          prev.length == 1 &&
          ![' ', 'h', 'r', 'ng'].contains(prev)) {
        // Cek apakah ada pasangan untuk huruf ini
        if (PASANGAN.containsKey(hrf[0])) {
          ltr += PASANGAN[hrf[0]]!;
        } else {
          // Jika tidak ada pasangan (misal huruf asing), fallback ke Huruf biasa
          // (Biasanya harusnya dipangkon huruf sebelumnya, tapi logika ini kompleks)
          // Kita pakai Pangkon manual untuk huruf sebelumnya?
          // Utk simplifikasi: Tampilkan huruf biasa
          ltr += HURUF[hrf[0]] ?? hrf[0];
        }
      } else {
        ltr += HURUF[hrf[0]] ?? hrf[0];
      }
    }

    // --- 3. HANDLE MATI (len 1: k, n, f, z) ---
    else if (hrf.length == 1) {
      if (['.', ',', ' '].contains(hrf)) {
        ltr += HURUF[hrf] ?? hrf;
      } else if (hrf == 'r') {
        ltr += SANDHANGAN['layar'] ?? 'r';
      } else if (hrf == 'h') {
        ltr += SANDHANGAN['wignyan'] ?? 'h';
      } else if (hrf == 'ng') {
        ltr += SANDHANGAN['cecak'] ?? 'ng';
      } else {
        // Huruf mati biasa
        String baseChar = HURUF[hrf] ?? hrf;
        if (isEnd) {
          // Di akhir kalimat -> Pangkon
          ltr += baseChar + (SANDHANGAN['pangkon'] ?? '');
        } else {
          // Di tengah -> Tunggu pasangan (tulis huruf saja)
          ltr += baseChar;
        }
      }
    }

    // --- 4. HANDLE CLUSTER > 2 (kra, tra, fla) ---
    else if (hrf.length > 2) {
      String c1 = hrf[0];
      // FIX: Tambah ' ' (spasi) ke exclusion list
      if (prev != null &&
          prev.length == 1 &&
          ![' ', 'h', 'r', 'ng'].contains(prev)) {
        ltr += PASANGAN[c1] ?? (HURUF[c1] ?? c1);
      } else {
        ltr += HURUF[c1] ?? c1;
      }

      if (hrf.contains('l') && hrf.indexOf('l') == 1)
        ltr += PASANGAN['l'] ?? '';
      else if (hrf.contains('y') && hrf.indexOf('y') == 1)
        ltr += SANDHANGAN['pengkal'] ?? '';
      else if (hrf.contains('r') && hrf.indexOf('r') == 1) {
        if (hrf.contains('e') && !hrf.contains('é')) {
          ltr += SANDHANGAN['keret'] ?? '';
          isKeret = true;
        } else
          ltr += SANDHANGAN['cakra'] ?? '';
      }
    }

    // --- 5. APPLY VOWELS (Akhiran) ---
    if (hrf.endsWith('u') || hrf.endsWith('U'))
      ltr += SANDHANGAN['suku'] ?? '';
    else if (hrf.endsWith('i') || hrf.endsWith('I'))
      ltr += SANDHANGAN['wulu'] ?? '';
    else if (hrf.endsWith('o') || hrf.endsWith('O'))
      ltr += SANDHANGAN['taling-tarung'] ?? '';
    else if (hrf.contains('é') || hrf.contains('è'))
      ltr += SANDHANGAN['taling'] ?? '';
    else if ((hrf.endsWith('e') || hrf.endsWith('E')) &&
        !hrf.contains('é') &&
        !hrf.contains('è') &&
        !isKeret) {
      ltr += SANDHANGAN['pepet'] ?? '';
    }

    return ltr;
  }

  bool _isVowel(String char) {
    return VOWELS.contains(char) || VOWELS.contains(char.toLowerCase());
  }
}
