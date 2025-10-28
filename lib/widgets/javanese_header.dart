// widgets/javanese_header.dart (MODIFIKASI: Teks Aksara Jawa)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

class JavaneseHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final bool showBack;
  final VoidCallback onBack;

  // Ganti karakter ini sesuai dengan yang ada di Figma
  final String aksaraKiri = 'ꦲ';
  final String aksaraKananAtas = 'ꦤ';
  final String aksaraKananBawah = 'ꦕ';

  const JavaneseHeader({
    Key? key,
    required this.title,
    this.subtitle,
    required this.showBack,
    required this.onBack,
  }) : super(key: key);

  @override
  // Kustomisasi tinggi agar ada ruang untuk teks aksara dan title/subtitle
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight + 15.0); // Sesuaikan jika perlu

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color headerColor =
        theme.primaryColor; // Warna oranye solid dari theme

    // Style umum untuk teks aksara dekoratif
    final aksaraStyle = TextStyle(
      fontFamily: 'Javanese', // Pastikan font aktif dan bisa render aksara ini
      fontSize: 36, // Ukuran font aksara (sesuaikan)
      color: Colors.white.withOpacity(0.3), // Warna putih transparan
    );

    return AppBar(
      backgroundColor: headerColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: showBack
          ? IconButton(
              icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
              onPressed: onBack,
              tooltip: 'Kembali',
            )
          : Container(
              width:
                  16), // Beri sedikit padding kiri jika tidak ada tombol back

      leadingWidth: showBack ? kToolbarHeight : 16.0, // Sesuaikan lebar leading

      // flexibleSpace untuk latar belakang dan penempatan teks aksara
      flexibleSpace: Container(
        decoration:
            BoxDecoration(color: headerColor), // Latar belakang oranye solid
        child: Stack(
          alignment: Alignment.center, // Pusatkan title/subtitle
          children: [
            // Teks Aksara Kiri (Agak Besar, di Tengah Vertikal)
            Positioned(
              left: 40, // Jarak dari kiri
              top: 40,
              bottom: 0, // Agar berada di tengah vertikal
              child: Center(
                child: Text(
                  aksaraKiri,
                  style:
                      aksaraStyle.copyWith(fontSize: 48), // Sedikit lebih besar
                ),
              ),
            ),

            // Teks Aksara Kanan Atas (Kecil & Serong)
            Positioned(
              right: 30, // Jarak dari kanan
              top: 18, // Jarak dari atas
              child: Transform.rotate(
                angle: 0, // Sedikit serong (sesuaikan sudut)
                child: Text(
                  aksaraKananAtas,
                  style: aksaraStyle.copyWith(fontSize: 35), // Lebih kecil
                ),
              ),
            ),

            // Teks Aksara Kanan Bawah (Kecil & Serong)
            Positioned(
              right: 70, // Jarak dari kanan
              bottom: -5, // Jarak dari bawah
              child: Transform.rotate(
                angle: 0, // Serong ke arah berlawanan (sesuaikan sudut)
                child: Text(
                  aksaraKananBawah,
                  style: aksaraStyle.copyWith(fontSize: 30), // Lebih kecil
                ),
              ),
            ),

            // Konten AppBar (Title & Subtitle) - tetap di tengah di atas semua teks aksara
            // Diberi sedikit padding vertikal agar tidak terlalu mepet
            Padding(
              padding: const EdgeInsets.only(
                  top: 8.0), // Padding atas untuk title/subtitle
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (subtitle != null && subtitle!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 2.0), // Jarak antara title dan subtitle
                        child: Text(
                          subtitle!,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.2),
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // Action kosong karena semua elemen visual ditangani di flexibleSpace
      actions: const [
        SizedBox(width: kToolbarHeight)
      ], // Beri ruang kosong selebar tombol back di kanan
      // Title dihapus dari AppBar karena sudah ditangani di flexibleSpace
      title: null,
      centerTitle: false, // Penting karena title: null
      systemOverlayStyle: SystemUiOverlayStyle.light,
    );
  }
}
