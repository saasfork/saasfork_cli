const productFeatureModelTemplate =
    '''import 'package:saasfork_core/saasfork_core.dart';

class ProductFeatureModel implements AbstractModel<ProductFeatureModel> {
  final String? id;
  final String name;
  final String description;

  ProductFeatureModel({this.id, required this.name, required this.description});

  factory ProductFeatureModel.fromMap(Map<String, dynamic> data, {String? id}) {
    return ProductFeatureModel(
      id: id ?? data['id'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {'name': name, 'description': description};
  }

  @override
  Map<String, dynamic> toDebugMap() {
    return toMap();
  }

  @override
  ProductFeatureModel copyWith({
    String? id,
    String? name,
    String? description,
  }) {
    return ProductFeatureModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }
}''';

String generateProductFeatureModel(String projectName) {
  // Pas besoin de remplacer les imports car ce modèle n'utilise que des packages externes
  return productFeatureModelTemplate;
}
