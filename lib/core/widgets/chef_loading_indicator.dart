// lib/core/widgets/chef_loading_indicator.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:neyese4/core/theme/app_text_styles.dart';

class ChefLoadingIndicator extends StatefulWidget {
  const ChefLoadingIndicator({super.key});

  @override
  State<ChefLoadingIndicator> createState() => _ChefLoadingIndicatorState();
}

class _ChefLoadingIndicatorState extends State<ChefLoadingIndicator> {
  // Kullanıcıya göstereceğimiz keyifli mesajların listesi
  static const List<String> _loadingMessages = [
    'Önlük giyiliyor...',
    'Bıçaklar bileniyor...',
    'Malzemeler hazırlanıyor...',
    'Fırın önceden ısıtılıyor...',
    'Lezzet sırları fısıldanıyor...',
    'Mutfakta harikalar yaratılıyor...',
  ];

  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Her 3 saniyede bir mesajı değiştirecek bir zamanlayıcı başlatıyoruz.
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          // Bir sonraki mesaja geç (listenin sonuna gelince başa dön)
          _currentIndex = (_currentIndex + 1) % _loadingMessages.length;
        });
      }
    });
  }

  @override
  void dispose() {
    // Widget ekrandan kaldırıldığında zamanlayıcıyı iptal et.
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(), // Klasik yükleme animasyonu
        const SizedBox(height: 24),
        // Yazılar arasında yumuşak bir geçiş (fade) sağlayan widget
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: Text(
            // Key parametresi, AnimatedSwitcher'a hangi widget'ın değiştiğini anlatır.
            // Bu sayede animasyonu doğru bir şekilde tetikler.
            _loadingMessages[_currentIndex],
            key: ValueKey<int>(_currentIndex),
            style: AppTextStyles.body,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}