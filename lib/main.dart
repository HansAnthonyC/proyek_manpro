import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hanacaraka_app/app.dart';
import 'package:hanacaraka_app/app_state.dart';
import 'package:provider/provider.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Mengatur warna status bar agar sesuai tema
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // Membuat status bar transparan
    statusBarIconBrightness: Brightness
        .dark, // Untuk ikon (jam, baterai) agar terlihat di latar terang
    statusBarBrightness: Brightness.light, // Untuk iOS, agar teksnya gelap
  ));
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor:
        Colors.white, // Sesuaikan dengan warna nav bar Anda
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Tema berdasarkan globals.css
    final ThemeData theme = ThemeData(
      fontFamily: 'Roboto', // Ganti ke 'Javanese' jika Anda menambahkannya
      scaffoldBackgroundColor: const Color(0xFFFEF7ED),
      primaryColor: const Color(0xFFEA580C),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFEA580C),
        primary: const Color(0xFFEA580C),
        secondary: const Color(0xFFFB923C), // orange-400
        background: const Color(0xFFFEF7ED), // cream
        onBackground: const Color(0xFF451A03), // dark brown
        surface: const Color(0xFFFFFFFF), // card
        onSurface: const Color(0xFF451A03),
      ),
      cardTheme: CardThemeData(
        // <-- BENAR: Ini Data
        elevation: 0,
        color: const Color(0xFFFFFFFF).withOpacity(0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(color: Color(0xFFEA580C).withOpacity(0.2)),
        ),
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Color(0xFF451A03)),
        titleLarge:
            TextStyle(color: Color(0xFF451A03), fontWeight: FontWeight.bold),
        titleMedium:
            TextStyle(color: Color(0xFF451A03), fontWeight: FontWeight.bold),
        headlineSmall:
            TextStyle(color: Color(0xFF451A03), fontWeight: FontWeight.bold),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: Color(0xFFEA580C),
      ),
    );

    return MaterialApp(
      title: 'Hanacaraka App',
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: const HanacarakaApp(),
    );
  }
}
