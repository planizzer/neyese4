// lib/core/api/dio_client.dart

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DioClient {
  // 1. _dio değişkenini "late final" olarak işaretliyoruz.
  // Bu, Dart'a "bu değişkeni daha sonra, ama kesinlikle kullanmadan önce başlatacağım" demektir.
  late final Dio _dio;

  // Dışarıdan Dio istemcisine erişmek için getter (değişiklik yok).
  Dio get dio => _dio;

  // 2. Sınıf için bir kurucu metot (constructor) ekliyoruz.
  DioClient() {
    // API anahtarını .env dosyasından alıyoruz.
    final apiKey = dotenv.env['SPOONACULAR_API_KEY'];

    // Anahtarın .env dosyasında bulunduğundan emin olalım.
    if (apiKey == null) {
      throw Exception("SPOONACULAR_API_KEY .env dosyasında bulunamadıysa!");
    }

    // 3. _dio nesnesini burada, constructor içinde oluşturuyoruz.
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.spoonacular.com',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
        // Artık güvenli bir şekilde apiKey değişkenini kullanabiliriz.
        queryParameters: {
          'apiKey': apiKey,
        },
      ),
    );
  }
}