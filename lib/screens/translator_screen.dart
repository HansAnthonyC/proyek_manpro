import 'package:flutter/material.dart';
import 'package:hanacaraka_app/services/translator_service.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:flutter/services.dart';

// Diterjemahkan dari GoogleTranslateStyle.tsx
class TranslatorScreen extends StatefulWidget {
  const TranslatorScreen({Key? key}) : super(key: key);

  @override
  State<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  final TextEditingController _sourceController = TextEditingController();
  String _targetText = '';
  bool _isLatinToJava = true;
  final TranslatorService _translator = TranslatorService();

  void _handleTranslate() {
    final text = _sourceController.text;
    if (text.isEmpty) {
      setState(() => _targetText = '');
      return;
    }
    setState(() {
      _targetText = _isLatinToJava
          ? _translator.translateLatinToJava(text)
          : _translator.translateJavaToLatin(text);
    });
  }

  void _handleSwap() {
    final source = _sourceController.text;
    final target = _targetText;
    setState(() {
      _isLatinToJava = !_isLatinToJava;
      _sourceController.text = target;
      _targetText = source;
    });
  }

  void _handleClear() {
    _sourceController.clear();
    setState(() {
      _targetText = '';
    });
  }

  void _handleCopy() {
    Clipboard.setData(ClipboardData(text: _targetText));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Teks disalin ke clipboard!')));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Language Selector
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _languageChip(
                  context,
                  _isLatinToJava ? 'Latin' : 'ꦲꦤꦕꦫꦏ',
                  true,
                ),
                IconButton(
                  icon: Icon(
                    LucideIcons.arrowRightLeft,
                    color: theme.primaryColor,
                  ),
                  onPressed: _handleSwap,
                ),
                _languageChip(
                  context,
                  !_isLatinToJava ? 'Latin' : 'ꦲꦤꦕꦫꦏ',
                  true,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Input Card
        Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              _headerBox(
                context,
                _isLatinToJava ? 'Latin' : 'Aksara Jawa',
                _sourceController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(LucideIcons.trash2, size: 18),
                        onPressed: _handleClear,
                      )
                    : null,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _sourceController,
                  decoration: InputDecoration(
                    hintText: 'Ketik teks di sini...',
                    border: InputBorder.none,
                  ),
                  maxLines: 5,
                  minLines: 3,
                  style: TextStyle(
                    fontSize: _isLatinToJava ? 16 : 24,
                    fontFamily: _isLatinToJava ? null : 'Javanese',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: _handleTranslate,
                      child: const Text('Terjemahkan'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Output Card
        Card(
          clipBehavior: Clip.antiAlias,
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
                      )
                    : null,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _targetText.isEmpty
                      ? 'Terjemahan akan muncul di sini...'
                      : _targetText,
                  style: TextStyle(
                    fontSize: !_isLatinToJava ? 16 : 24,
                    fontFamily: !_isLatinToJava ? null : 'Javanese',
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

        // Tips Card
        Card(
          color: theme.primaryColor.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '💡 Penerjemahan otomatis mungkin tidak sempurna. Gunakan sebagai panduan awal untuk belajar aksara Jawa.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _languageChip(BuildContext context, String label, bool isActive) {
    final theme = Theme.of(context);
    return Chip(
      label: Text(label, style: TextStyle(fontFamily: 'Javanese')),
      backgroundColor: isActive
          ? theme.primaryColor
          : theme.colorScheme.secondary,
      labelStyle: TextStyle(
        color: isActive
            ? theme.colorScheme.onPrimary
            : theme.colorScheme.onSecondary,
      ),
    );
  }

  Widget _headerBox(BuildContext context, String title, Widget? action) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: theme.primaryColor.withOpacity(0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: theme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (action != null) action,
        ],
      ),
    );
  }
}
