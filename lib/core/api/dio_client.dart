import 'package:dio/dio.dart';

class DioClient {
  // Spoonacular API anahtarını buraya yapıştır.
  // Unutma: Bu API anahtarını normalde daha güvenli bir yerde saklamalıyız,
  // ancak MVP aşaması için şimdilik burada tutabiliriz.
  static const String _apiKey = '4695b3d661ea4101929f03eea74a5327';

  // Dio istemcisini başlangıç ayarlarıyla oluşturuyoruz.
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.spoonacular.com',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      // Tüm isteklere otomatik olarak API anahtarını ekliyoruz.
      queryParameters: {
        'apiKey': _apiKey,
      },
    ),
  );

  // Dışarıdan Dio istemcisine erişmek için bir getter.
  Dio get dio => _dio;
}
