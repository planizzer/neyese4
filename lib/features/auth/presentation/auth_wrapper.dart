// lib/features/auth/presentation/auth_wrapper.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neyese4/data/providers.dart';
import 'package:neyese4/features/auth/presentation/screens/login_screen.dart';
import 'package:neyese4/main_screen.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Giriş durumundaki değişiklikleri dinliyoruz.
    final authState = ref.watch(authStateChangesProvider);

    return authState.when(
      data: (user) {
        // Veri geldiğinde (kullanıcı durumu belli olduğunda)
        if (user != null) {
          // Eğer kullanıcı nesnesi varsa (giriş yapmışsa), ana ekranı göster.
          return const MainScreen();
        } else {
          // Eğer kullanıcı nesnesi null ise (giriş yapmamışsa), giriş ekranını göster.
          return const LoginScreen();
        }
      },
      // Veri yüklenirken (kullanıcı durumu kontrol edilirken) bekleme ekranı göster.
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      // Hata olursa bir hata ekranı göster.
      error: (err, stack) => Scaffold(body: Center(child: Text('Bir hata oluştu: $err'))),
    );
  }
}