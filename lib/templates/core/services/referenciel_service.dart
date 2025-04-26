import 'package:saasfork_cli/utils/extensions/string_extension.dart';

const referencielServiceTemplate =
    '''import 'package:{{project_name}}/core/models/products/product_details_model.dart';
import 'package:{{project_name}}/core/models/products/product_feature_model.dart';
import 'package:{{project_name}}/core/repositories/feature_repository.dart';
import 'package:{{project_name}}/core/repositories/product_details_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final referencielServiceProvider = Provider<ReferencielService>((ref) {
  final featureRepository = FeatureRepository();
  final productDetailsRepository = ProductDetailsRepository();

  return ReferencielService(
    featureRepository: featureRepository,
    productDetailsRepository: productDetailsRepository,
  );
});

class ReferencielService {
  final FeatureRepository featureRepository;
  final ProductDetailsRepository productDetailsRepository;

  ReferencielService({
    required this.featureRepository,
    required this.productDetailsRepository,
  });

  Future<List<ProductDetailsModel>> getProductDetails() async {
    return await productDetailsRepository.findAll(loadRelations: true);
  }

  Future<List<ProductFeatureModel>> getProductFeature() async {
    return await featureRepository.findAll();
  }

  Future<ProductDetailsModel?> getProductById(String id) async {
    return await productDetailsRepository.findById(id, loadRelations: true);
  }

  Future<ProductDetailsModel?> getDefaultProduct() async {
    final product = await productDetailsRepository.query(
      equals: {'selected': true},
      limit: 1,
      loadRelations: true,
    );

    return product.isNotEmpty ? product.first : null;
  }
}''';

String generateReferencielService(String projectName) {
  // Convertir project_name en snake_case pour les imports
  final projectNameSnakeCase = projectName.toSnakeCase();

  return referencielServiceTemplate.replaceAll(
    '{{project_name}}',
    projectNameSnakeCase,
  );
}
