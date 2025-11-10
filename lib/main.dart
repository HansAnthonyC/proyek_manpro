import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hanacaraka_app/app.dart';
import 'package:hanacaraka_app/app_state.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:hanacaraka_app/services/data_service.dart';

void main() async {
  // <-- UBAH JADI ASYNC
  WidgetsFlutterBinding.ensureInitialized(); // <-- TAMBAHKAN INI

  // Buat instance DataService
  final dataService = DataService();
  // Panggil fungsi loadData dan tunggu sampai selesai
  await dataService.loadData(); // <-- TAMBAHKAN INI

  // Mengatur warna status bar (kode Anda sebelumnya)
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  ));
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  runApp(
    // Kita butuh 2 provider: 1 untuk AppState, 1 untuk DataService
    MultiProvider(
      // <-- GUNAKAN MULTIPROVIDER
      providers: [
        ChangeNotifierProvider(create: (context) => AppState()),
        ChangeNotifierProvider.value(
            value: dataService), // <-- SEDIAKAN DATA SERVICE
      ],
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
