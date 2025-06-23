// lib/core/api/dio_client.dart

import 'package:dio/dio.dart';
import 'package:neyese4/core/config/api_keys.dart'; // Yeni import

class DioClient {
  late final Dio _dio;
  Dio get dio => _dio;

  DioClient() {
    const apiKey = ApiKeys.spoonacular; // Yeni kullanım şekli

    if (apiKey.isEmpty) {
      throw Exception("SPOONACULAR_API_KEY derleme anında sağlanmadı!");
    }

    // 3. _dio nesnesini burada, constructor içinde oluşturuyoruz.
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.spoonacular.com',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 6),
        // Artık güvenli bir şekilde apiKey değişkenini kullanabiliriz.
        queryParameters: {
          'apiKey': apiKey,
        },
      ),
    );
  }
}