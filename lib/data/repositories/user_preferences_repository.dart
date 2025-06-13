import 'package:hive_flutter/hive_flutter.dart';
import 'package:neyese4/data/models/user_preferences.dart';

// Veritabanı kutusunun adını tanımlıyoruz.
const String kUserPreferencesBox = 'user_preferences_box';

class UserPreferencesRepository {
  Box<UserPreferences> get _box => Hive.box<UserPreferences>(kUserPreferencesBox);

  // Kullanıcı tercihlerini kaydeder veya günceller.
  // Sadece tek bir tercih nesnesi olacağı için, sabit bir anahtar (0) kullanıyoruz.
  Future<void> savePreferences(UserPreferences prefs) async {
    await _box.put(0, prefs);
  }

  // Kaydedilmiş tercihleri getirir. Eğer hiç kaydedilmemişse, boş bir nesne döndürür.
  UserPreferences getPreferences() {
    return _box.get(0, defaultValue: UserPreferences(intolerances: []))!;
  }

  // Kutudaki değişiklikleri dinlemek için bir Stream.
  Stream<BoxEvent> watchPreferences() {
    return _box.watch();
  }
}
