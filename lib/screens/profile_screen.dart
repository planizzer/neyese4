// lib/screens/profile_screen.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neyese4/core/theme/app_colors.dart';
import 'package:neyese4/core/theme/app_text_styles.dart';
import 'package:neyese4/data/providers.dart';
import 'package:neyese4/screens/diet_selection_screen.dart';
import 'package:neyese4/screens/equipment_selection_screen.dart';
import 'package:neyese4/screens/intolerance_selection_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  // Profili düzenlemek için diyalog penceresini gösteren metot
  Future<void> _showEditProfileDialog() async {
    final user = ref.read(authStateChangesProvider).value;
    if (user == null) return;

    final nameController = TextEditingController(text: user.displayName);

    final newName = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('İsmini Düzenle'),
          content: TextField(
            controller: nameController,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Görünen Ad'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(nameController.text.trim());
              },
              child: const Text('Kaydet'),
            ),
          ],
        );
      },
    );

    if (newName != null && newName.isNotEmpty && newName != user.displayName) {
      try {
        await user.updateDisplayName(newName);
        final userDocRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
        await userDocRef.set({'displayName': newName, 'email': user.email}, SetOptions(merge: true));

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profilin başarıyla güncellendi!')),
          );
        }
        ref.invalidate(authStateChangesProvider);

      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Bir hata oluştu: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateChangesProvider).value;
    final userXp = ref.watch(userXpProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profilim'),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (user != null)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 12, bottom: 12, right: 4),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColors.primaryBackground,
                        backgroundImage: user.photoURL != null ? NetworkImage(user.photoURL!) : null,
                        child: user.photoURL == null
                            ? const Icon(Icons.person_outline, size: 30, color: AppColors.primaryAction)
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.displayName ?? 'İsim Belirtilmemiş',
                              style: AppTextStyles.h2.copyWith(fontSize: 20),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user.email ?? 'E-posta bulunamadı',
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, color: AppColors.neutralGrey),
                        onPressed: _showEditProfileDialog,
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 24),
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

            // GÜNCELLENDİ: Ayarları gruplayan Card Widget
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  _buildProfileOption(
                    context: context,
                    icon: Icons.restaurant_menu_outlined,
                    title: 'Diyet Tercihleri',
                    subtitle: 'Vegan, Vejetaryen, Glutensiz...',
                    targetScreen: const DietSelectionScreen(),
                  ),
                  const Divider(height: 1, indent: 72, endIndent: 16),
                  _buildProfileOption(
                    context: context,
                    icon: Icons.warning_amber_rounded,
                    title: 'Alerjiler ve Hassasiyetler',
                    subtitle: 'Süt, Yumurta, Gluten...',
                    targetScreen: const IntoleranceSelectionScreen(),
                  ),
                  const Divider(height: 1, indent: 72, endIndent: 16),
                  _buildProfileOption(
                    context: context,
                    icon: Icons.kitchen_outlined,
                    title: 'Mutfak Aletleri',
                    subtitle: 'Fırın, Mikser, Airfryer...',
                    targetScreen: const EquipmentSelectionScreen(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ÇIKIŞ YAP BUTONU
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              clipBehavior: Clip.antiAlias,
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('Çıkış Yap', style: TextStyle(color: Colors.red)),
                onTap: () async {
                  await ref.read(authServiceProvider).signOut();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget targetScreen,
  }) {
    return ListTile(
      leading: Icon(icon, size: 28, color: AppColors.primaryText.withOpacity(0.8)),
      title: Text(title, style: AppTextStyles.body),
      subtitle: Text(subtitle, style: AppTextStyles.caption),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.neutralGrey),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => targetScreen),
        );
      },
    );
  }
}