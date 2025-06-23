// lib/features/auth/presentation/screens/login_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Ekle
import 'package:neyese4/core/theme/app_colors.dart';
import 'package:neyese4/core/theme/app_text_styles.dart';
import 'package:neyese4/data/providers.dart'; // Ekle
import 'package:neyese4/features/auth/presentation/screens/register_screen.dart'; // Ekle

class LoginScreen extends ConsumerStatefulWidget { // Değiştir
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState(); // Değiştir
}


class _LoginScreenState extends ConsumerState<LoginScreen> { // Değiştir
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      final authService = ref.read(authServiceProvider);
      final result = await authService.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (result != null && mounted) {
        // Hata varsa SnackBar göster
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result)),
        );
      }
      // Başarılı giriş durumunda AuthWrapper bizi otomatik olarak MainScreen'e yönlendirecek.
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Neyese\'ye Hoş Geldin!',
                  style: AppTextStyles.h1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Giriş yaparak tariflerini kaydet ve mutfağını yönet.',
                  style: AppTextStyles.body.copyWith(color: AppColors.neutralGrey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'E-posta'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || !value.contains('@')) {
                      return 'Lütfen geçerli bir e-posta adresi girin.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Şifre'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'Şifreniz en az 6 karakter olmalıdır.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _signIn,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.primaryAction,
                  ),
                  child: const Text('Giriş Yap', style: AppTextStyles.button),
                ),// --- YENİ EKLENEN GOOGLE GİRİŞ BUTONU ---
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: Image.asset('assets/google_logo.png', height: 24.0), // Google logosu için bir asset eklemen gerekebilir
                  label: const Text('Google ile Giriş Yap'),
                  onPressed: () {
                    ref.read(authServiceProvider).signInWithGoogle();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: AppColors.primaryText,
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: AppColors.neutralGrey),
                  ),
                ),
                // ------------------------------------
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const RegisterScreen()),
                  );
                    },
                  child: const Text('Hesabın yok mu? Kayıt Ol'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}