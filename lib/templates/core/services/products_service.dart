import 'package:saasfork_cli/utils/extensions/string_extension.dart';

const productsServiceTemplate =
    '''import 'package:{{project_name}}/core/models/products/product_details_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productsServiceProvider = Provider<ProductsService>((ref) {
  return ProductsService();
});

class ProductsService {
  Future<List<ProductDetailsModel>> fetchProducts() async {
    return [];
  }

  Future<ProductDetailsModel> fetchProductById(String id) async {
    return ProductDetailsModel.fromMap({
      'id': id,
      'productName': 'Plan Essentiel',
      'description': 'This is a basic plan offering essential features.',
      'items': [
        {
          'unit_amount': 2999,
          'currency': 'SFCurrency.eur',
          'period': 'SFPricePeriod.month',
        },
        {
          'unit_amount': 29900,
          'currency': 'SFCurrency.eur',
          'period': 'SFPricePeriod.year',
        },
      ],
      'features': [
        {'feature': '24/7 Support'},
        {'feature': 'Free Trial'},
      ],
      'trialPerdiodDays': 7,
    });
  }
}''';

String generateProductsService(String projectName) {
  // Convertir project_name en snake_case pour les imports
  final projectNameSnakeCase = projectName.toSnakeCase();

  return productsServiceTemplate.replaceAll(
    '{{project_name}}',
    projectNameSnakeCase,
  );
}
