// lib/screens/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // YENİ: import
import 'package:neyese4/core/theme/app_text_styles.dart';
import 'package:neyese4/features/profile/application/xp_provider.dart'; // YENİ: import
import 'package:neyese4/screens/diet_selection_screen.dart';
import 'package:neyese4/screens/equipment_selection_screen.dart';
import 'package:neyese4/screens/intolerance_selection_screen.dart';

import '../core/theme/app_colors.dart';

// GÜNCELLENDİ: StatelessWidget -> ConsumerWidget
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  // GÜNCELLENDİ: build metoduna WidgetRef eklendi
  Widget build(BuildContext context, WidgetRef ref) {
    // YENİ: XP provider'ını dinliyoruz.
    final userXp = ref.watch(userXpProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profilim ve Ayarlar'),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // YENİ: XP Puanını gösteren kart
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.star_rounded, color: Colors.amber, size: 32),
              title: Text('Deneyim Puanı (XP)', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
              trailing: Text('$userXp XP', style: AppTextStyles.h2.copyWith(color: AppColors.primaryAction)),
            ),
          ),
          const SizedBox(height: 16),
          // Kalan kısım aynı
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
            onTap: () {},
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