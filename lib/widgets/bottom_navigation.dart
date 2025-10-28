// widgets/bottom_navigation.dart (Pastikan seperti ini, tanpa padding bawah manual)
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

class BottomNavigation extends StatelessWidget {
  final String activeTab;
  final ValueChanged<String> onTabChange;

  const BottomNavigation({
    Key? key,
    required this.activeTab,
    required this.onTabChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // HAPUS -> final double bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      // HAPUS -> padding: EdgeInsets.only(bottom: bottomPadding),
      height: 64, // Tinggi asli
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor.withOpacity(0.95), // Warna latar
        border: Border(
          top: BorderSide(color: theme.primaryColor.withOpacity(0.3), width: 1),
        ),
        // Bisa tambahkan shadow jika mau
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTabItem(context,
              id: 'home',
              label: 'Beranda',
              icon: LucideIcons.house), // Pastikan ikon benar
          _buildTabItem(context,
              id: 'learn', label: 'Belajar', icon: LucideIcons.bookOpen),
          _buildTabItem(context,
              id: 'write', label: 'Latih', icon: LucideIcons.penTool),
          _buildTabItem(context,
              id: 'translate', label: 'Terjemah', icon: LucideIcons.languages),
        ],
      ),
    );
  }

  Widget _buildTabItem(
    BuildContext context, {
    required String id,
    required String label,
    required IconData icon,
  }) {
    // ... (kode _buildTabItem Anda tidak berubah)
    final bool isActive = activeTab == id;
    final theme = Theme.of(context);
    final color = isActive
        ? theme.primaryColor
        : theme.textTheme.bodyMedium!.color!.withOpacity(0.7);

    return Expanded(
      child: InkWell(
        onTap: () => onTabChange(id),
        child: Container(
          decoration: BoxDecoration(
            color: isActive
                ? theme.primaryColor.withOpacity(0.1)
                : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: isActive ? theme.primaryColor : Colors.transparent,
                width: 2.0,
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(height: 4),
              Text(label,
                  style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight:
                          FontWeight.normal // Ubah ke normal jika medium error
                      )),
            ],
          ),
        ),
      ),
    );
  }
}
