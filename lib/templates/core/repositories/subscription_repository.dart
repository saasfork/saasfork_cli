import 'package:saasfork_cli/utils/extensions/string_extension.dart';

const subscriptionRepositoryTemplate =
    '''import 'package:{{project_name}}/core/models/products/product_details_model.dart';
import 'package:{{project_name}}/core/models/user_subscription_model.dart';
import 'package:{{project_name}}/core/repositories/product_details_repository.dart';
import 'package:saasfork_core/saasfork_core.dart';
import 'package:saasfork_firebase_service/saasfork_firebase_service.dart';

class SubscriptionRepository
    extends FirestoreRepository<UserSubscriptionModel> {
  SubscriptionRepository() : super(collectionName: 'subscriptions');

  @override
  void initializeRelations() {
    // Ajouter une relation entre souscription et produit
    // La relation utilise le champ "productId" dans la souscription
    // et fait référence à un document dans la collection "products"
    addReferenceRelation<ProductDetailsModel>(
      'product', // Nom de la relation
      'products', // Collection des produits
      'product_id', // Le champ dans la souscription qui contient l'ID du produit
      (doc) => ProductDetailsModel.fromMap(doc.data, id: doc.id),
      autoLoad: true, // Charger automatiquement cette relation
    );
  }

  @override
  UserSubscriptionModel assignId(UserSubscriptionModel entity, String id) {
    return entity.copyWith(id: id);
  }

  @override
  UserSubscriptionModel fromDocument(FirestoreDocument document) {
    return UserSubscriptionModel.fromMap(document.data, id: document.id);
  }

  @override
  String? getId(UserSubscriptionModel entity) {
    return entity.id;
  }

  @override
  Map<String, dynamic> toMap(UserSubscriptionModel entity) {
    return entity.toMap();
  }

  @override
  Future<UserSubscriptionModel> updateEntityWithRelation(
    UserSubscriptionModel entity,
    String relationName,
    List<dynamic> relatedEntities,
  ) async {
    log(
      'Updating relation: \$relationName, found \${relatedEntities.length} entities',
    );

    switch (relationName) {
      case 'product':
        // Si nous avons un produit, l'ajouter à l'entité
        if (relatedEntities.isNotEmpty) {
          final product = relatedEntities.first as ProductDetailsModel;

          // Créer une instance de ProductDetailsRepository pour charger les features
          final productRepo = ProductDetailsRepository();

          // Charger le produit avec ses relations (features)
          final productWithFeatures = await productRepo.findById(
            product.id,
            loadRelations: true,
          );

          if (productWithFeatures != null) {
            log(
              'Product loaded with features: \${productWithFeatures.features.length}',
            );
            return entity.copyWith(product: productWithFeatures);
          }

          // Si le chargement avec features a échoué, utiliser le produit original
          return entity.copyWith(product: product);
        }
        return entity;
      default:
        return entity;
    }
  }
}''';

String generateSubscriptionRepository(String projectName) {
  // Convertir project_name en snake_case pour les imports
  final projectNameSnakeCase = projectName.toSnakeCase();

  return subscriptionRepositoryTemplate.replaceAll(
    '{{project_name}}',
    projectNameSnakeCase,
  );
}
