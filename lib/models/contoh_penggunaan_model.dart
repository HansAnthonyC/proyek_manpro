// lib/models/contoh_penggunaan_model.dart

class SyllableTimestamp {
  final double start;
  final double end;
  final String label;

  SyllableTimestamp({
    required this.start,
    required this.end,
    required this.label,
  });
}

class ContohPenggunaanModel {
  final int id;
  final int aksaraId;
  final String contohAksara;
  final String latin;
  final String arti;
  final String audioPath;
  final List<SyllableTimestamp> timestamps; // Field baru

  ContohPenggunaanModel({
    required this.id,
    required this.aksaraId,
    required this.contohAksara,
    required this.latin,
    required this.arti,
    required this.audioPath,
    required this.timestamps,
  });

  factory ContohPenggunaanModel.fromCsv(List<dynamic> row) {
    // Parsing Timestamp Data (Format: "0.8 1.3 a")
    List<SyllableTimestamp> parsedTimestamps = [];
    try {
      // Pastikan kolom ke-6 ada dan tidak kosong (sesuai urutan di CSV Anda)
      if (row.length > 6 && row[6] != null && row[6].toString().isNotEmpty) {
        String rawData = row[6].toString();
        List<String> lines = rawData.split('\n');

        for (var line in lines) {
          // Split berdasarkan spasi: "0.8" "1.3" "a"
          List<String> parts = line.trim().split(' ');
          if (parts.length >= 3) {
            parsedTimestamps.add(SyllableTimestamp(
              start: double.parse(parts[0]),
              end: double.parse(parts[1]),
              label: parts.sublist(2).join(' '), // Gabung jika label ada spasi
            ));
          }
        }
      }
    } catch (e) {
      print("Error parsing timestamp for ID ${row[0]}: $e");
    }

    return ContohPenggunaanModel(
      id: int.parse(row[0].toString()),
      aksaraId: int.parse(row[1].toString()),
      contohAksara: row[2].toString(),
      latin: row[3].toString(),
      arti: row[4].toString(),
      audioPath: row[5].toString(),
      timestamps: parsedTimestamps,
    );
  }
}
