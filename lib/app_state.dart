import 'package:flutter/material.dart';
import 'package:hanacaraka_app/data/hanacaraka_data.dart';

// Enum untuk semua layar yang mungkin
enum Screen {
  main,
  learnCategories,
  learnCharacters,
  learnDetail,
  writeCategories,
  writeCharacters,
  writeCanvas,
  translate,
}

class AppState extends ChangeNotifier {
  Screen _currentScreen = Screen.main;
  String _activeTab = 'home';
  String _selectedCategory = '';
  HanacarakaChar? _selectedCharacter;

  // Getters
  Screen get currentScreen => _currentScreen;
  String get activeTab => _activeTab;
  String get selectedCategory => _selectedCategory;
  HanacarakaChar? get selectedCharacter => _selectedCharacter;

  // Mendapatkan judul berdasarkan layar saat ini
  String getScreenTitle() {
    switch (_currentScreen) {
      case Screen.main:
        return 'Hanacaraka';
      case Screen.learnCategories:
        return 'Pilih Kategori';
      case Screen.learnCharacters:
        return 'Daftar Aksara';
      case Screen.learnDetail:
        return 'Detail Aksara';
      case Screen.writeCategories:
        return 'Kategori Latihan';
      case Screen.writeCharacters:
        return 'Pilih Aksara';
      case Screen.writeCanvas:
        return 'Latihan Menulis';
      case Screen.translate:
        return 'Penerjemah';
      default:
        return 'Hanacaraka';
    }
  }

  // Mendapatkan subjudul
  String getScreenSubtitle() {
    switch (_currentScreen) {
      case Screen.main:
        return 'Belajar Aksara Jawa';
      case Screen.learnCategories:
        return 'Pengenalan Aksara';
      case Screen.learnCharacters:
        return categoryNames[_selectedCategory] ?? '';
      case Screen.learnDetail:
        return _selectedCharacter?.latin ?? '';
      case Screen.writeCategories:
        return 'Latihan Menulis';
      case Screen.writeCharacters:
        return 'Kategori ${categoryNames[_selectedCategory] ?? ''}';
      case Screen.writeCanvas:
        return _selectedCharacter?.latin ?? '';
      case Screen.translate:
        return 'Latin ↔ Aksara Jawa';
      default:
        return '';
    }
  }

  bool shouldShowBack() {
    return _currentScreen != Screen.main;
  }

  // Aksi Navigasi
  void handleBack() {
    switch (_currentScreen) {
      case Screen.learnCategories:
      case Screen.writeCategories:
      case Screen.translate:
        _currentScreen = Screen.main;
        _activeTab = 'home';
        break;
      case Screen.learnCharacters:
        _currentScreen = Screen.learnCategories;
        _selectedCategory = '';
        break;
      case Screen.learnDetail:
        _currentScreen = _selectedCategory.isEmpty
            ? Screen.main
            : Screen.learnCharacters;
        if (_selectedCategory.isEmpty) _activeTab = 'home';
        _selectedCharacter = null;
        break;
      case Screen.writeCharacters:
        _currentScreen = Screen.writeCategories;
        _selectedCategory = '';
        break;
      case Screen.writeCanvas:
        _currentScreen = Screen.writeCharacters;
        _selectedCharacter = null;
        break;
      default:
        _currentScreen = Screen.main;
        _activeTab = 'home';
    }
    notifyListeners();
  }

  void handleTabChange(String tab) {
    _activeTab = tab;
    _selectedCategory = '';
    _selectedCharacter = null;

    switch (tab) {
      case 'home':
        _currentScreen = Screen.main;
        break;
      case 'learn':
        _currentScreen = Screen.learnCategories;
        break;
      case 'write':
        _currentScreen = Screen.writeCategories;
        break;
      case 'translate':
        _currentScreen = Screen.translate;
        break;
    }
    notifyListeners();
  }

  void handleCategorySelect(String category) {
    _selectedCategory = category;
    if (_currentScreen == Screen.learnCategories) {
      _currentScreen = Screen.learnCharacters;
    } else if (_currentScreen == Screen.writeCategories) {
      _currentScreen = Screen.writeCharacters;
    }
    notifyListeners();
  }

  void handleCharacterSelect(
    HanacarakaChar character, {
    bool fromMainMenu = false,
  }) {
    _selectedCharacter = character;
    if (fromMainMenu) {
      _currentScreen = Screen.learnDetail;
      _activeTab = 'learn';
    } else if (_currentScreen == Screen.learnCharacters) {
      _currentScreen = Screen.learnDetail;
    } else if (_currentScreen == Screen.writeCharacters) {
      _currentScreen = Screen.writeCanvas;
    }
    notifyListeners();
  }
}
