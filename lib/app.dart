import 'package:flutter/material.dart';
import 'package:hanacaraka_app/app_state.dart';
import 'package:hanacaraka_app/screens/category_menu_screen.dart';
import 'package:hanacaraka_app/screens/character_detail_screen.dart';
import 'package:hanacaraka_app/screens/character_grid_screen.dart';
import 'package:hanacaraka_app/screens/main_menu_screen.dart';
import 'package:hanacaraka_app/screens/translator_screen.dart';
import 'package:hanacaraka_app/screens/writing_canvas_screen.dart';
import 'package:hanacaraka_app/services/data_service.dart';
import 'package:hanacaraka_app/widgets/bottom_navigation.dart';
import 'package:hanacaraka_app/widgets/javanese_header.dart';
import 'package:provider/provider.dart';

class HanacarakaApp extends StatelessWidget {
  const HanacarakaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final dataService = Provider.of<DataService>(context, listen: false);

    // Bungkus Scaffold dengan SafeArea
    return SafeArea(
      top:
          false, // Jangan beri padding di atas karena AppBar akan mengisi area status bar
      bottom:
          true, // Beri padding di bawah untuk menghindari system navigation bar
      child: Scaffold(
        // JavaneseHeader sekarang adalah AppBar biasa
        appBar: JavaneseHeader(
          title: appState.getScreenTitle(),
          subtitle: appState.getScreenSubtitle(),
          showBack: appState.shouldShowBack(),
          onBack: appState.handleBack,
        ),

        // Konten Layar (renderScreen())
        body: _renderScreen(appState, dataService),

        // Navigasi Bawah
        // Pastikan BottomNavigation TIDAK punya padding bottom manual lagi
        // karena SafeArea sudah menanganinya.
        bottomNavigationBar: BottomNavigation(
          activeTab: appState.activeTab,
          onTabChange: appState.handleTabChange,
        ),
      ),
    );
  }

  // Logic renderScreen() dari App.tsx (Tidak berubah)
  Widget _renderScreen(AppState appState, DataService dataService) {
    // <-- UBAH DI SINI
    switch (appState.currentScreen) {
      case Screen.main:
        return MainMenuScreen(
          onCharacterSelect: (char) =>
              appState.handleCharacterSelect(char, fromMainMenu: true),
        );
      case Screen.learnCategories:
      case Screen.writeCategories:
        return CategoryMenuScreen(
          onCategorySelect: appState.handleCategorySelect,
        );
      case Screen.learnCharacters:
      case Screen.writeCharacters:
        // --- GANTI LOGIKA PENGAMBILAN DATA ---
        final characters = dataService
            .getAksaraByCategory(appState.selectedCategory); // <-- GANTI INI
        // ------------------------------------
        return CharacterGridScreen(
          category: appState.selectedCategory,
          characters:
              characters, // characters sekarang bertipe List<AksaraModel>
          onCharacterSelect: appState.handleCharacterSelect,
        );
      case Screen.learnDetail:
        return appState.selectedCharacter != null
            ? CharacterDetailScreen(character: appState.selectedCharacter!)
            : const Center(child: Text("Karakter tidak ditemukan"));
      case Screen.writeCanvas:
        return appState.selectedCharacter != null
            ? WritingCanvasScreen(character: appState.selectedCharacter!)
            : const Center(child: Text("Karakter tidak ditemukan"));
      case Screen.translate:
        return TranslatorScreen(); // Hapus const jika TranslatorScreen adalah StatefulWidget
      default:
        return MainMenuScreen(
          onCharacterSelect: (char) =>
              appState.handleCharacterSelect(char, fromMainMenu: true),
        );
    }
  }
}
