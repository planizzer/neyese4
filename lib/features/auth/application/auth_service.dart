// lib/features/auth/application/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart'; // YENİ IMPORT


class AuthService {
  // FirebaseAuth'in bir örneğini oluşturuyoruz.
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(); // YENİ NESNE

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();


  Future<String?> signInWithGoogle() async {
    try {
      // 1. Google Giriş penceresini tetikle
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // Kullanıcı pencereyi kapattı
        return 'Google ile giriş iptal edildi.';
      }

      // 2. Kullanıcının kimlik bilgilerini (token) al
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // 3. Bu bilgileri Firebase için bir kimlik bilgisine dönüştür
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Firebase'e bu kimlik bilgisiyle giriş yap
      await _firebaseAuth.signInWithCredential(credential);
      return null; // Başarılı
    } on FirebaseAuthException catch (e) {
      return e.message; // Hata varsa mesajı döndür
    } catch (e) {
      return 'Beklenmedik bir hata oluştu: $e';
    }
  }

  // E-posta ve şifre ile giriş yapma metodu
  Future<String?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Başarılı olursa null döndür
      return null;
    } on FirebaseAuthException catch (e) {
      // Hata olursa, kullanıcıya gösterilecek hata mesajını döndür
      return e.message;
    }
  }

  // E-posta ve şifre ile yeni kullanıcı kaydı oluşturma metodu
  Future<String?> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Başarılı olursa null döndür
      return null;
    } on FirebaseAuthException catch (e) {
      // Hata olursa, hata mesajını döndür
      return e.message;
    }
  }

  // Kullanıcı çıkış yapma metodu
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}