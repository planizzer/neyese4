import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:neyese4/core/theme/app_colors.dart';
import 'package:neyese4/core/theme/app_text_styles.dart';
import 'package:neyese4/data/models/saved_recipe.dart';
import 'package:neyese4/data/repositories/saved_recipe_repository.dart'; // Repository'yi import ediyoruz
import 'package:neyese4/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(SavedRecipeAdapter());

  // YENİ EKLENDİ: Uygulama başlamadan önce kaydedilmiş tarifler kutusunu açıyoruz.
  await Hive.openBox<SavedRecipe>(kSavedRecipesBox);

  runApp(
    const ProviderScope(
      child: NeyeseApp(),
    ),
  );
}

class NeyeseApp extends StatelessWidget {
  const NeyeseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neyese',
      theme: ThemeData(
        fontFamily: 'Inter',
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryAction,
          primary: AppColors.primaryAction,
          secondary: AppColors.accent,
          background: AppColors.background,
        ),
        textTheme: const TextTheme(
          displayLarge: AppTextStyles.h1,
          displayMedium: AppTextStyles.h2,
          bodyLarge: AppTextStyles.body,
          bodyMedium: AppTextStyles.body,
          labelLarge: AppTextStyles.button,
          bodySmall: AppTextStyles.caption,
        ),
        useMaterial3: true,
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
