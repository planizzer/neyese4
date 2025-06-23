import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:neyese4/data/models/pantry_item.dart';
import 'package:neyese4/data/models/saved_recipe.dart';
import 'package:neyese4/data/models/user_preferences.dart'; // Yeni modelimizi import ediyoruz
import 'package:neyese4/data/repositories/saved_recipe_repository.dart';
import 'package:neyese4/data/repositories/user_preferences_repository.dart'; // Repository'yi import ediyoruz
import 'package:neyese4/data/repositories/pantry_repository.dart'; // kitchen_box sabitini buraya taşıyacağız
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // FlutterFire CLI'ın oluşturduğu dosya
import 'package:neyese4/features/auth/presentation/auth_wrapper.dart'; // Yeni import

import 'package:firebase_app_check/firebase_app_check.dart'; // Bu satırı ekle




Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Geliştirme ortamında olduğumuzu belirtmek için "debug" sağlayıcısını kullanıyoruz.
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('6Le3pWUrAAAAA0gROpIJynF_Z-Zu61wJIZEYLbQ'),
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug, // iOS için de ekleyelim
  );



  // Hive'ı Flutter için başlatıyoruz.
  await Hive.initFlutter();

  // Tüm adaptörlerimizi kaydediyoruz.
  Hive.registerAdapter(SavedRecipeAdapter());
  Hive.registerAdapter(PantryItemAdapter());
  Hive.registerAdapter(UserPreferencesAdapter()); // YENİ EKLENDİ

  // Tüm kutularımızı açıyoruz.
  await Hive.openBox<SavedRecipe>(kSavedRecipesBox);
  await Hive.openBox<PantryItem>(kPantryBoxName);
  await Hive.openBox<UserPreferences>(kUserPreferencesBox); // YENİ EKLENDİ

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
      // ... (theme ayarları aynı)
      home: const AuthWrapper(), // DEĞİŞİKLİK: Uygulama artık AuthWrapper ile başlayacak.
      debugShowCheckedModeBanner: false,
    );
  }
}
