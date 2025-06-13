import 'package:flutter/material.dart';

// Bu sınıf, uygulama genelinde kullanılacak olan sabit renkleri barındırır.
// Bu sayede renkleri tek bir yerden yönetebilir ve tutarlılık sağlarız.
class AppColors {
  // Bu sınıfın doğrudan örneklenmesini (instantiate) engelliyoruz.
  AppColors._();

  // Tasarımcının verdiği HEX kodlarını Flutter'ın Color formatına çeviriyoruz.
  // 0xFF -> saydam olmadığını belirtir, ardından 6 haneli HEX kodu gelir.
  static const Color primaryAction = Color(0xFFFF7A5A); // Canlı Mercan
  static const Color accent = Color(0xFF4CAF50);       // Taze Yeşil
  static const Color primaryText = Color(0xFF2D3748);   // Koyu Kurşun
  static const Color background = Color(0xFFF7FAFC);   // Çok Açık Gri
  static const Color neutralGrey = Color(0xFFA0AEC0);   // Nötr Gri
}
