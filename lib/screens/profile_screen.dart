import 'package:flutter/material.dart';
import 'package:neyese4/core/theme/app_text_styles.dart';
import 'package:neyese4/screens/diet_selection_screen.dart';
import 'package:neyese4/screens/intolerance_selection_screen.dart';
// YENİ: Mutfak aletleri seçim sayfasını import ediyoruz.
import 'package:neyese4/screens/equipment_selection_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profilim ve Ayarlar'),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildProfileOption(
            icon: Icons.restaurant_menu_outlined,
            title: 'Diyet Tercihleri',
            subtitle: 'Vegan, Vejetaryen, Glutensiz...',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const DietSelectionScreen()),
              );
            },
          ),
          const Divider(),
          _buildProfileOption(
            icon: Icons.warning_amber_rounded,
            title: 'Alerjiler',
            subtitle: 'Fıstık, Süt ürünleri, Soya...',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const IntoleranceSelectionScreen()),
              );
            },
          ),
          const Divider(),
          _buildProfileOption(
            icon: Icons.kitchen_outlined,
            title: 'Mutfak Aletleri',
            subtitle: 'Fırın, Mikser, Airfryer...',
            onTap: () {
              // GÜNCELLENDİ: Mutfak aletleri seçim sayfasına yönlendirme.
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const EquipmentSelectionScreen()),
              );
            },
          ),
          const Divider(),
          _buildProfileOption(
            icon: Icons.info_outline,
            title: 'Uygulama Hakkında',
            subtitle: 'Versiyon 1.0.0',
            onTap: () {
              // TODO: Hakkında sayfası açılacak.
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, size: 28),
      title: Text(title, style: AppTextStyles.body),
      subtitle: Text(subtitle, style: AppTextStyles.caption),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
