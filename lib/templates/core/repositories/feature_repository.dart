import 'package:saasfork_cli/utils/extensions/string_extension.dart';

const featureRepositoryTemplate =
    '''import 'package:{{project_name}}/core/models/products/product_feature_model.dart';
import 'package:saasfork_firebase_service/saasfork_firebase_service.dart';

class FeatureRepository extends FirestoreRepository<ProductFeatureModel> {
  FeatureRepository() : super(collectionName: 'features');

  @override
  ProductFeatureModel assignId(ProductFeatureModel entity, String id) {
    return entity.copyWith(id: id);
  }

  @override
  ProductFeatureModel fromDocument(FirestoreDocument document) {
    return ProductFeatureModel.fromMap(document.data, id: document.id);
  }

  @override
  String? getId(ProductFeatureModel entity) {
    return entity.id;
  }

  @override
  Map<String, dynamic> toMap(ProductFeatureModel entity) {
    return {
      'id': entity.id,
      'name': entity.name,
      'description': entity.description,
    };
  }
}''';

String generateFeatureRepository(String projectName) {
  // Convertir project_name en snake_case pour les imports
  final projectNameSnakeCase = projectName.toSnakeCase();

  return featureRepositoryTemplate.replaceAll(
    '{{project_name}}',
    projectNameSnakeCase,
  );
}
