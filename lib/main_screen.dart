import 'package:flutter/material.dart';
import 'package:neyese4/screens/home_screen.dart';
import 'package:neyese4/screens/kitchen_screen.dart';
import 'package:neyese4/screens/profile_screen.dart';
import 'package:neyese4/screens/recipes_screen.dart';


// MainScreen'i bir StatefulWidget yapıyoruz çünkü seçili olan sekmenin
// durumunu (yani index'ini) hafızada tutmamız ve değiştirmemiz gerekiyor.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Seçili olan sayfanın index'ini tutan değişken. Başlangıçta 0 (Akış).
  int _selectedIndex = 0;

  // BottomNavigationBar'daki her sekmeye karşılık gelen sayfaların listesi.
  // Bu sayfaları bir sonraki adımda boş olarak oluşturacağız.
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),    // Index 0
    RecipesScreen(), // Index 1
    KitchenScreen(), // Index 2
    ProfileScreen(), // Index 3
  ];

  // Bir sekmeye tıklandığında bu fonksiyon çalışacak.
  void _onItemTapped(int index) {
    // setState, Flutter'a bu widget'ın durumunun değiştiğini ve
    // ekranı yeni index'e göre yeniden çizmesi gerektiğini söyler.
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold'un body'si olarak, o an seçili olan index'teki sayfayı gösteriyoruz.
      body: _widgetOptions.elementAt(_selectedIndex),

      // Ve alt navigasyon bar'ını oluşturuyoruz.
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Akış',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            activeIcon: Icon(Icons.book),
            label: 'Tariflerim',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.kitchen_outlined),
            activeIcon: Icon(Icons.kitchen),
            label: 'Mutfağım',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profilim',
          ),
        ],
        currentIndex: _selectedIndex, // O an hangi sekmenin aktif olduğunu belirtir.
        onTap: _onItemTapped,       // Tıklanma olayını dinler.

        // Barların görünüm ayarları. Tasarımcının renklerine sonra geçeceğiz.
        selectedItemColor: Colors.deepOrange, // Seçili olan ikon ve yazının rengi
        unselectedItemColor: Colors.grey,     // Seçili olmayanların rengi
        showUnselectedLabels: true,           // Seçili olmayanların yazılarını göster
        type: BottomNavigationBarType.fixed,  // 4 veya daha az item için ideal. Barların yerinde sabit kalmasını sağlar.
      ),
    );
  }
}
