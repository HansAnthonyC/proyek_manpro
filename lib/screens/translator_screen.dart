import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:hanacaraka_app/services/translator_service.dart';

class TranslatorScreen extends StatefulWidget {
  const TranslatorScreen({Key? key}) : super(key: key);

  @override
  State<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  final TextEditingController _sourceController = TextEditingController();
  String _targetText = '';
  bool _isLatinToJava = true;

  // Instance TranslatorService
  late final TranslatorService _translator;

  @override
  void initState() {
    super.initState();
    // Inisialisasi langsung, tidak butuh Provider/DataService lagi
    _translator = TranslatorService();
  }

  @override
  void dispose() {
    _sourceController.dispose();
    super.dispose();
  }

  void _handleTranslate() {
    final text = _sourceController.text;
    if (text.isEmpty) {
      setState(() => _targetText = '');
      return;
    }

    setState(() {
      if (_isLatinToJava) {
        // Panggil fungsi translate dari service baru
        _targetText = _translator.translate(text);
      } else {
        // Terjemahkan Aksara Jawa ke Latin
        _targetText = _translator.translateToLatin(text);
      }
    });
  }

  void _handleSwap() {
    final source = _sourceController.text;
    final target = _targetText;

    setState(() {
      _isLatinToJava = !_isLatinToJava;
      // Logika swap teks opsional, seringkali lebih baik dikosongkan
      // karena hasil translate tidak selalu bisa dibalik sempurna
      _sourceController.clear();
      _targetText = '';
    });
  }

  void _handleClear() {
    _sourceController.clear();
    setState(() {
      _targetText = '';
    });
  }

  void _handleCopy() {
    if (_targetText.isEmpty) return;

    Clipboard.setData(ClipboardData(text: _targetText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Teks disalin ke clipboard!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Pastikan nama font sesuai dengan pubspec.yaml ('TuladhaJejeg' atau 'Javanese')
    final String javaneseFont = 'TuladhaJejeg';

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // --- Language Selector ---
        Card(
          elevation: 2,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _languageChip(
                  context,
                  _isLatinToJava ? 'Latin' : 'Aksara Jawa',
                  true,
                  null,
                ),
                IconButton(
                  icon: Icon(
                    LucideIcons.arrowRightLeft,
                    color: theme.primaryColor,
                  ),
                  onPressed: _handleSwap,
                  tooltip: 'Tukar Bahasa',
                ),
                _languageChip(
                  context,
                  !_isLatinToJava ? 'Latin' : 'Aksara Jawa',
                  true,
                  null,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // --- Input Card ---
        Card(
          clipBehavior: Clip.antiAlias,
          elevation: 2,
          child: Column(
            children: [
              _headerBox(
                context,
                _isLatinToJava ? 'Latin' : 'Aksara Jawa',
                _sourceController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(LucideIcons.trash2, size: 18),
                        onPressed: _handleClear,
                        tooltip: 'Hapus Teks',
                      )
                    : null,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _sourceController,
                  decoration: const InputDecoration(
                    hintText: 'Ketik teks di sini...',
                    border: InputBorder.none,
                  ),
                  maxLines: 5,
                  minLines: 3,
                  style: TextStyle(
                    fontSize: _isLatinToJava ? 18 : 22,
                    fontFamily: _isLatinToJava ? null : javaneseFont,
                    height: 1.5,
                  ),
                  onChanged: (val) {
                    // Opsional: Realtime translate
                    // _handleTranslate();
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _handleTranslate,
                      icon: const Icon(LucideIcons.languages, size: 18),
                      label: const Text('Terjemahkan'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // --- Output Card ---
        Card(
          clipBehavior: Clip.antiAlias,
          elevation: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _headerBox(
                context,
                !_isLatinToJava ? 'Latin' : 'Aksara Jawa',
                _targetText.isNotEmpty
                    ? IconButton(
                        icon: const Icon(LucideIcons.copy, size: 18),
                        onPressed: _handleCopy,
                        tooltip: 'Salin Hasil',
                      )
                    : null,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                constraints: const BoxConstraints(minHeight: 100),
                child: SelectableText(
                  _targetText.isEmpty
                      ? 'Terjemahan akan muncul di sini...'
                      : _targetText,
                  style: TextStyle(
                    fontSize: !_isLatinToJava ? 18 : 20, // Font Jawa diperbesar
                    fontFamily: !_isLatinToJava ? null : javaneseFont,
                    height: 1.5,
                    color: _targetText.isEmpty
                        ? theme.textTheme.bodyMedium?.color?.withOpacity(0.5)
                        : theme.textTheme.bodyMedium?.color,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // --- Tips Card ---
        Card(
          color: theme.primaryColor.withOpacity(0.1),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: theme.primaryColor.withOpacity(0.2)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(LucideIcons.lightbulb,
                    color: theme.primaryColor, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Fitur ini menggunakan algoritma transliterasi (Latin ke Jawa). Hasil mungkin tidak 100% akurat untuk nama orang atau kata serapan.',
                    style: TextStyle(
                      color:
                          theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _languageChip(
      BuildContext context, String label, bool isActive, String? fontFamily) {
    final theme = Theme.of(context);
    return Chip(
      label: Text(label,
          style: TextStyle(
            fontFamily: fontFamily,
            fontWeight: FontWeight.bold,
          )),
      backgroundColor:
          isActive ? theme.primaryColor : theme.colorScheme.surface,
      side: isActive ? BorderSide.none : BorderSide(color: theme.dividerColor),
      labelStyle: TextStyle(
        color: isActive ? Colors.white : theme.colorScheme.onSurface,
      ),
    );
  }

  Widget _headerBox(BuildContext context, String title, Widget? action) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: theme.dividerColor.withOpacity(0.5)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: theme.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          if (action != null) action,
        ],
      ),
    );
  }
}
