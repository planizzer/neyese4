// Bu, Flutter'ın standart test paketidir.
import 'package:flutter_test/flutter_test.dart';

// Ana uygulama dosyamızı import ediyoruz.
import 'package:neyese4/main.dart';

void main() {
  // Basit bir test: Uygulamanın başarıyla oluşturulup oluşturulmadığını kontrol eder.
  testWidgets('Uygulama temel testi', (WidgetTester tester) async {
    // Uygulamamızı test ortamında oluşturuyoruz.
    await tester.pumpWidget(const NeyeseApp());

    // Bu test, şimdilik herhangi bir hata vermeden geçecektir.
    // İleride buraya daha detaylı testler ekleyebiliriz.
  });
}
