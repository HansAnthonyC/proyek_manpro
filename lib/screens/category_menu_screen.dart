// screens/category_menu_screen.dart (MODIFIKASI v3: Atasi Tumpukan)
import 'package:flutter/material.dart';
import 'package:hanacaraka_app/data/hanacaraka_data.dart';
import 'package:hanacaraka_app/utils/category_colors.dart';

class CategoryMenuScreen extends StatelessWidget {
  final Function(String) onCategorySelect;

  const CategoryMenuScreen({Key? key, required this.onCategorySelect})
      : super(key: key);

  // Fungsi helper deskripsi dan ikon (tetap sama)
  String getCategoryDescription(String category) {
    const descriptions = {
      'nglegena': 'Huruf dasar aksara Jawa (20 huruf)',
      'murda': 'Huruf kapital untuk nama dan tempat',
      'swara': 'Huruf vokal mandiri (a, i, u, e, o)',
      'sandhangan': 'Tanda vokal dan konsonan akhir',
      'rekan': 'Huruf untuk kata-kata asing',
      'wilangan': 'Angka Jawa (0 sampai 9)',
      'pasangan': 'Konsonan penutup suku kata'
    };
    return descriptions[category] ?? '';
  }

  String getCategoryIcon(String category) {
    const icons = {
      'nglegena': 'ꦲ', // Ha
      'murda': 'ꦤ꦳', // Na Murda
      'swara': 'ꦄ', // A Swara
      'sandhangan': 'ꦶ', // Wulu
      'rekan': 'ꦥ꦳', // Fa
      'wilangan': '꧕', // Limo
      'pasangan': '꧀ꦤ' // Pasangan Na
    };
    return icons[category] ?? 'ꦲ';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categories = categoryNames.keys.toList();

    return ListView(
      // Gunakan ListView
      padding: const EdgeInsets.fromLTRB(
          16.0, 24.0, 16.0, 16.0), // Padding atas lebih besar
      children: [
        // --- Header Halaman --- (Sama seperti sebelumnya)
        Column(
          children: [
            Text(
              'Pilih Kategori Aksara',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.primaryColor, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Pilih jenis aksara yang ingin Anda pelajari',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24), // Jarak antara judul dan kartu pertama

        // --- Daftar Kartu Kategori ---
        ...categories.map((category) {
          // Gunakan map langsung di children ListView
          final categoryName = categoryNames[category]!;
          final colors = getCategoryColors(category);
          final charCount =
              allHanacarakaChars.where((c) => c.category == category).length;
          final iconChar = getCategoryIcon(category);

          return Card(
            margin: const EdgeInsets.only(bottom: 12.0),
            clipBehavior:
                Clip.antiAlias, // Penting agar Stack tidak keluar Card
            elevation: 1, // Beri sedikit shadow
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0), // Lebih bulat
              side: BorderSide(
                  color: colors.border.withOpacity(0.5)), // Border lebih halus
            ),
            child: InkWell(
              onTap: () => onCategorySelect(category),
              child: Container(
                // Beri tinggi minimum agar layout konsisten
                constraints: const BoxConstraints(
                    minHeight: 120), // Sesuaikan tinggi jika perlu
                padding: const EdgeInsets.all(16.0),
                child: Stack(
                  // Gunakan Stack untuk menumpuk elemen
                  children: [
                    // --- Konten Utama (Lapisan Bawah) ---
                    // Dibungkus Padding agar tidak terlalu mepet ke ikon bawah
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 60.0,
                          right: 30.0), // Beri ruang bawah & kanan
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Judul Kategori (ambil ruang lebih banyak)
                              Expanded(
                                child: Text(
                                  categoryName,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.onBackground),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Badge Jumlah Huruf (Kanan Atas)
                              Chip(
                                label: Text('$charCount huruf',
                                    style: TextStyle(
                                        fontSize: 11, color: colors.text)),
                                backgroundColor: colors.light,
                                side: BorderSide(color: colors.border),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                visualDensity:
                                    VisualDensity.compact, // Lebih kecil
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          // Deskripsi
                          Text(
                            getCategoryDescription(category),
                            style: TextStyle(
                              color: theme.textTheme.bodyMedium?.color
                                  ?.withOpacity(0.7),
                              fontSize: 13, // Sedikit lebih kecil
                              height: 2, // Jarak antar baris
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    // --- Ikon & Panah (Lapisan Atas) ---
                    // Ikon Aksara Solid (Kiri Bawah)
                    Positioned(
                      left: 0,
                      bottom: 0,
                      child: Text(
                        iconChar,
                        style: TextStyle(
                          fontSize: 36, // Ukuran dari Figma
                          fontFamily: 'Javanese', // Pastikan font aktif
                          color: colors.main, // Warna solid
                        ),
                      ),
                    ),

                    // Ikon Aksara Background (Kanan Bawah)
                    Positioned(
                      right:
                          30, // Geser sedikit ke kiri agar tidak terlalu keluar
                      bottom: -10, // Geser sedikit ke atas
                      child: Text(
                        iconChar,
                        style: TextStyle(
                          fontSize: 50, // Kecilkan sedikit
                          fontFamily: 'Javanese', // Pastikan font aktif
                          color: colors.main
                              .withOpacity(0.08), // Sangat transparan
                        ),
                      ),
                    ),

                    // Ikon Panah (Kanan Bawah)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Icon(
                        Icons.chevron_right, // Ikon panah > sederhana
                        color: theme.textTheme.bodyMedium?.color
                            ?.withOpacity(0.4), // Warna abu-abu
                        size: 28, // Ukuran ikon
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(), // Akhir dari map

        // Kartu Tips Belajar (tetap sama)
        Card(
          margin: const EdgeInsets.only(top: 12), // Jarak dari kartu terakhir
          color: theme.primaryColor.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text('💡', style: TextStyle(fontSize: 24)),
                const SizedBox(height: 8),
                Text(
                  'Tips Belajar',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(color: theme.primaryColor),
                ),
                const SizedBox(height: 4),
                Text(
                  'Mulai dari Aksara Nglegena untuk memahami dasar-dasar huruf Jawa',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
