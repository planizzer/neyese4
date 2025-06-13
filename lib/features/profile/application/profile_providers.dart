import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neyese4/data/models/user_preferences.dart';
import 'package:neyese4/data/repositories/user_preferences_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Veritabanı repository'sine erişim için bir provider.
final userPreferencesRepositoryProvider = Provider<UserPreferencesRepository>((ref) {
  return UserPreferencesRepository();
});

// Veritabanındaki değişiklikleri dinleyen bir StreamProvider.
// Bu, alttaki provider'ın anında güncellenmesini sağlar.
final userPreferencesStreamProvider = StreamProvider.autoDispose<BoxEvent>((ref) {
  return ref.watch(userPreferencesRepositoryProvider).watchPreferences();
});

// Kullanıcının mevcut tercihlerini tutan ve güncelleyen ana provider.
final userPreferencesProvider = StateProvider.autoDispose<UserPreferences>((ref) {
  // Veritabanı değişikliklerini dinle.
  ref.watch(userPreferencesStreamProvider);
  // En güncel tercihleri repository'den al.
  return ref.read(userPreferencesRepositoryProvider).getPreferences();
});
