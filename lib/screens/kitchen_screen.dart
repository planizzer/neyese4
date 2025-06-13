import 'package:flutter/material.dart';

class KitchenScreen extends StatelessWidget {
  const KitchenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // AppBar'ı daha sonra her sayfanın kendi ihtiyacına göre özelleştireceğiz.
      // Şimdilik sadece hangi sayfada olduğumuzu görmek için ekliyoruz.
      body: Center(
        child: Text(
          'Mutfak Sayfası',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
