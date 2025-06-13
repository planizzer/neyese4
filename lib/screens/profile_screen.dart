import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // AppBar'ı daha sonra her sayfanın kendi ihtiyacına göre özelleştireceğiz.
      // Şimdilik sadece hangi sayfada olduğumuzu görmek için ekliyoruz.
      body: Center(
        child: Text(
          'Profil Sayfası',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
