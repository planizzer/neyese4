import 'package:flutter/material.dart';
import 'package:neyese4/core/theme/app_colors.dart';

// Uygulama genelinde kullanılacak olan sabit metin stilleri.
class AppTextStyles {
  AppTextStyles._();

  // H1 - Ekran Ana Başlığı
  static const TextStyle h1 = TextStyle(
    fontFamily: 'Nunito',
    fontWeight: FontWeight.w900, // Black
    fontSize: 28,
    color: AppColors.primaryText,
  );

  // H2 - Bölüm Başlığı
  static const TextStyle h2 = TextStyle(
    fontFamily: 'Nunito',
    fontWeight: FontWeight.w700, // Bold
    fontSize: 22,
    color: AppColors.primaryText,
  );

  // Gövde Metni
  static const TextStyle body = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400, // Regular
    fontSize: 16,
    color: AppColors.primaryText,
  );

  // Buton Metni
  static const TextStyle button = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500, // Medium
    fontSize: 16,
    color: Colors.white, // Buton renkleri genelde açık olur
  );

  // Küçük Metin / Altyazı
  static const TextStyle caption = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400, // Regular
    fontSize: 14,
    color: AppColors.neutralGrey,
  );

  // Giriş Alanı Metni
  static const TextStyle input = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400, // Regular
    fontSize: 16,
    color: AppColors.primaryText,
  );
}
