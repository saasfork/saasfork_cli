import 'package:saasfork_cli/utils/extensions/string_extension.dart';

const referencielControllerTemplate =
    '''import 'package:{{project_name}}/core/models/products/product_details_model.dart';
import 'package:{{project_name}}/core/models/products/product_feature_model.dart';
import 'package:{{project_name}}/core/services/referenciel_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Providers pour les états de chargement
final productsLoadingProvider = StateProvider<bool>((ref) => false);
final productByIdLoadingProvider = StateProvider<bool>((ref) => false);
final featuresLoadingProvider = StateProvider<bool>((ref) => false);
final socialProofsLoadingProvider = StateProvider<bool>((ref) => false);

final referencielControllerProvider = Provider<ReferencielController>((ref) {
  final referencielService = ref.read(referencielServiceProvider);

  return ReferencielController(referencielService, ref);
});

class ReferencielController {
  final ReferencielService _referencielService;
  final Ref _ref;

  ReferencielController(this._referencielService, this._ref);

  Future<List<ProductDetailsModel>?> fetchProductDetails() async {
    try {
      // Mise à jour de l'état de chargement
      _ref.read(productsLoadingProvider.notifier).state = true;

      final details = await _referencielService.getProductDetails();
      return details;
    } finally {
      // Mise à jour de l'état de chargement à la fin (succès ou erreur)
      _ref.read(productsLoadingProvider.notifier).state = false;
    }
  }

  Future<ProductDetailsModel?> fetchProductById(String id) async {
    try {
      _ref.read(productByIdLoadingProvider.notifier).state = true;

      return await _referencielService.getProductById(id);
    } finally {
      _ref.read(productByIdLoadingProvider.notifier).state = false;
    }
  }

  Future<ProductDetailsModel?> fetchDefaultProduct() async {
    try {
      _ref.read(productByIdLoadingProvider.notifier).state = true;

      return await _referencielService.getDefaultProduct();
    } finally {
      _ref.read(productByIdLoadingProvider.notifier).state = false;
    }
  }

  Future<List<ProductFeatureModel>?> fetchFeature() async {
    try {
      _ref.read(featuresLoadingProvider.notifier).state = true;

      final features = await _referencielService.getProductFeature();
      return features;
    } finally {
      _ref.read(featuresLoadingProvider.notifier).state = false;
    }
  }

  // Méthode utilitaire pour vérifier si un chargement est en cours
  bool isLoading(LoadingResource resource) {
    switch (resource) {
      case LoadingResource.products:
        return _ref.read(productsLoadingProvider);
      case LoadingResource.productById:
        return _ref.read(productByIdLoadingProvider);
      case LoadingResource.features:
        return _ref.read(featuresLoadingProvider);
      case LoadingResource.socialProofs:
        return _ref.read(socialProofsLoadingProvider);
      case LoadingResource.any:
        return _ref.read(productsLoadingProvider) ||
            _ref.read(productByIdLoadingProvider) ||
            _ref.read(featuresLoadingProvider) ||
            _ref.read(socialProofsLoadingProvider);
    }
  }
}

// Énumération pour faciliter l'utilisation des différents états de chargement
enum LoadingResource {
  products,
  productById,
  features,
  socialProofs,
  any, // Pour vérifier si au moins une ressource est en cours de chargement
}''';

String generateReferencielController(String projectName) {
  // Convertir project_name en snake_case pour les imports
  final projectNameSnakeCase = projectName.toSnakeCase();

  return referencielControllerTemplate.replaceAll(
    '{{project_name}}',
    projectNameSnakeCase,
  );
}
