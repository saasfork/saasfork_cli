import 'package:saasfork_cli/utils/extensions/string_extension.dart';

const productDetailsRepositoryTemplate =
    '''import 'package:{{project_name}}/core/models/products/product_details_model.dart';
import 'package:{{project_name}}/core/models/products/product_feature_model.dart';
import 'package:saasfork_firebase_service/saasfork_firebase_service.dart';

class ProductDetailsRepository
    extends FirestoreRepository<ProductDetailsModel> {
  ProductDetailsRepository({super.firestore})
    : super(collectionName: 'products');

  @override
  void initializeRelations() {
    addArrayRelation<ProductFeatureModel>(
      'features', // Nom de la relation
      'features', // Collection des features
      'features', // Champ dans le produit qui contient le tableau d'IDs
      (doc) => ProductFeatureModel.fromMap(doc.data, id: doc.id),
      autoLoad: true,
    );
  }

  @override
  ProductDetailsModel fromDocument(FirestoreDocument document) {
    return ProductDetailsModel.fromMap(document.data, id: document.id);
  }

  @override
  Map<String, dynamic> toMap(ProductDetailsModel entity) {
    return entity.toMap();
  }

  @override
  String? getId(ProductDetailsModel entity) {
    return entity.id.isEmpty ? null : entity.id;
  }

  @override
  ProductDetailsModel assignId(ProductDetailsModel entity, String id) {
    return entity.copyWith(id: id);
  }

  @override
  Future<ProductDetailsModel> updateEntityWithRelation(
    ProductDetailsModel entity,
    String relationName,
    List<dynamic> relatedEntities,
  ) async {
    switch (relationName) {
      case 'features':
        return entity.copyWith(
          features: relatedEntities.cast<ProductFeatureModel>(),
        );
      default:
        return entity;
    }
  }
}''';

String generateProductDetailsRepository(String projectName) {
  // Convertir project_name en snake_case pour les imports
  final projectNameSnakeCase = projectName.toSnakeCase();

  return productDetailsRepositoryTemplate.replaceAll(
    '{{project_name}}',
    projectNameSnakeCase,
  );
}
