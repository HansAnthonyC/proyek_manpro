class AksaraModel {
  final String id;
  final String kategori;
  final String aksara;
  final String namaLatin;
  final String deskripsi;
  final String pathAudio;
  final String strokeOrderData; //  ( diasumsikan string JSON)

  AksaraModel({
    required this.id,
    required this.kategori,
    required this.aksara,
    required this.namaLatin,
    required this.deskripsi,
    required this.pathAudio,
    required this.strokeOrderData,
  });

  // Factory constructor untuk membuat instance dari baris CSV
  factory AksaraModel.fromCsvList(List<dynamic> row) {
    return AksaraModel(
      id: row[0].toString(),
      kategori: row[1].toString(),
      aksara: row[2].toString(),
      namaLatin: row[3].toString(),
      deskripsi: row[4].toString(),
      pathAudio: row[5].toString(),
      strokeOrderData: row[6].toString(), //
    );
  }
}
