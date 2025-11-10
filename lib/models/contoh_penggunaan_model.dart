class ContohPenggunaanModel {
  final String contohId;
  final String aksaraId;
  final String contohAksaraJawa;
  final String tulisanLatin;
  final String arti;
  final String pathAudio;
  final String timestampData; // [cite: 68] (diasumsikan string JSON)

  ContohPenggunaanModel({
    required this.contohId,
    required this.aksaraId,
    required this.contohAksaraJawa,
    required this.tulisanLatin,
    required this.arti,
    required this.pathAudio,
    required this.timestampData,
  });

  // Factory constructor untuk membuat instance dari baris CSV
  factory ContohPenggunaanModel.fromCsvList(List<dynamic> row) {
    return ContohPenggunaanModel(
      contohId: row[0].toString(),
      aksaraId: row[1].toString(),
      contohAksaraJawa: row[2].toString(),
      tulisanLatin: row[3].toString(),
      arti: row[4].toString(),
      pathAudio: row[5].toString(),
      timestampData: row[6].toString(), // [cite: 68]
    );
  }
}
