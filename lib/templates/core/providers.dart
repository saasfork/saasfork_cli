import 'package:saasfork_cli/utils/extensions/string_extension.dart';

const providersTemplate =
    '''import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:{{project_name}}/core/router/router.dart';

/// Provider pour le router de l'application
final routerProvider = Provider.family<AppRouter, WidgetRef>((ref, widgetRef) {
  return AppRouter(widgetRef);
});
/// Ajoutez ici vos autres providers globaux
''';

String generateProviders(String projectName) {
  // Assurer que le nom du projet pour les imports est en snake_case
  final projectNameSnakeCase = projectName.toSnakeCase();

  return providersTemplate.replaceAll('{{project_name}}', projectNameSnakeCase);
}
