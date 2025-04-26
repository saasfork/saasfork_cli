import 'package:saasfork_cli/utils/extensions/string_extension.dart';

const productDetailsModelTemplate =
    '''import 'package:{{project_name}}/core/models/products/product_feature_model.dart';
import 'package:{{project_name}}/core/models/products/product_item_details_model.dart';
import 'package:saasfork_core/saasfork_core.dart';

final class ProductDetailsModel implements AbstractModel<ProductDetailsModel> {
  final String id;
  final String productName;
  final String description;
  final List<ProductItemDetailsModel> items;
  final List<ProductFeatureModel> features;
  final int? trialPerdiodDays;

  ProductDetailsModel({
    required this.id,
    required this.productName,
    required this.description,
    required this.items,
    required this.features,
    this.trialPerdiodDays,
  });

  @override
  factory ProductDetailsModel.fromMap(Map<String, dynamic> data, {String? id}) {
    // Extraire le tableau d'IDs des features, mais les features elles-mêmes
    // seront chargées par le repository
    final featureIds = <String>[];
    if (data['features'] is List) {
      featureIds.addAll(
        (data['features'] as List).map((e) => e.toString()).toList(),
      );
    }

    // Traitement plus robuste pour les items
    List<ProductItemDetailsModel> itemsList = [];
    if (data['items'] is List) {
      itemsList =
          (data['items'] as List)
              .whereType<Map>()
              .map(
                (item) => ProductItemDetailsModel.fromMap(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList();
    }

    // Conversion sécurisée de trialPerdiodDays
    int? trialDays;
    if (data['trial_period_days'] != null) {
      if (data['trial_period_days'] is int) {
        trialDays = data['trial_period_days'] as int;
      } else if (data['trial_period_days'] is String) {
        trialDays = int.tryParse(data['trial_period_days'] as String);
      }
    }

    return ProductDetailsModel(
      id: id ?? data['uid'] ?? '',
      productName: data['product_name'] ?? '',
      description: data['description'] ?? '',
      // Ne pas essayer de convertir les IDs en objets ici
      // Juste stocker une liste vide, les features seront chargées ultérieurement
      features: [],
      items: itemsList,
      trialPerdiodDays: trialDays,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'uid': id,
      'product_name': productName,
      'description': description,
      'trial_period_days': trialPerdiodDays,
      'features': features.map((f) => f.id).where((id) => id != null).toList(),
      'items': items.map((item) => item.toMap()).toList(),
    };
  }

  @override
  Map<String, dynamic> toDebugMap() {
    return {
      'uid': id,
      'product_name': productName,
      'description': description,
      'trial_period_days': trialPerdiodDays,
      'features': features.map((f) => f.toDebugMap()).toList(),
      'items': items.map((item) => item.toDebugMap()).toList(),
    };
  }

  @override
  ProductDetailsModel copyWith({
    String? id,
    String? productName,
    String? description,
    List<ProductItemDetailsModel>? items,
    List<ProductFeatureModel>? features,
    int? trialPerdiodDays,
  }) {
    return ProductDetailsModel(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      description: description ?? this.description,
      items: items ?? this.items,
      features: features ?? this.features,
      trialPerdiodDays: trialPerdiodDays ?? this.trialPerdiodDays,
    );
  }
}''';

String generateProductDetailsModel(String projectName) {
  // Convertir project_name en snake_case pour les imports
  final projectNameSnakeCase = projectName.toSnakeCase();

  return productDetailsModelTemplate.replaceAll(
    '{{project_name}}',
    projectNameSnakeCase,
  );
}
