import 'package:dio/dio.dart';

class ProductRepository {
  // Open Food Facts API'si için yeni bir Dio istemcisi
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://world.openfoodfacts.org'));

  Future<Map<String, dynamic>?> fetchProductByBarcode(String barcode) async {
    try {
      final response = await _dio.get('/api/v2/product/$barcode.json');
      if (response.statusCode == 200 && response.data['status'] == 1) {
        // Ürün bulunduysa, verileri bir harita olarak döndür
        final product = response.data['product'];
        // --- TEST İÇİN BU SATIRLARI EKLEYELİM ---
        print('--- OPEN FOOD FACTS RAW DATA ---');
        print(product);
        // ------------------------------------
        return {
          'productName': product['product_name'] ?? '',
          'brand': product['brands'] ?? '',
          'quantity': product['quantity'] != null ? double.tryParse(product['quantity'].toString().split(' ').first) ?? 1 : 1.0,
          'unit': product['quantity'] != null ? product['quantity'].toString().split(' ').last ?? 'adet' : 'adet',
          'category': (product['categories_tags'] as List<dynamic>?)?.first?.toString().substring(3) ?? 'Diğer',
        };
      }
      return null;
    } catch (e) {
      print('Open Food Facts API hatası: $e');
      return null;
    }
  }
}