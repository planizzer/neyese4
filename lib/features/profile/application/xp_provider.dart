// lib/features/profile/application/xp_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

// Kullanıcının toplam XP'sini tutan basit bir StateProvider.
// Uygulama açıldığında 0'dan başlar. (Daha sonra bu Hive'da saklanabilir)
final userXpProvider = StateProvider<int>((ref) => 0);