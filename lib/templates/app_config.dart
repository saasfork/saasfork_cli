import 'package:saasfork_cli/utils/extensions/string_extension.dart';

const appConfigTemplate = '''import 'package:saasfork_core/utils/config.dart';

class AppConfig {
  static T? get<T>(String key, {T? defaultValue}) {
    return SFConfig.get<T>(key, defaultValue: defaultValue);
  }

  static Map<String, dynamic> getDefaultConfig() {
    return {
      'app.name': '{{ProjectName}}',
      'app.version': '1.0.0',
      'app.defaultLanguage': 'en',
    };
  }

  static Future<void> initialize({String environment = 'dev'}) async {
    final defaultConfig = getDefaultConfig();

    if (defaultConfig.containsKey(environment)) {
      final envSpecificConfig =
          defaultConfig[environment] as Map<String, dynamic>;

      // Remplacer les valeurs par défaut
      defaultConfig.addAll(envSpecificConfig);

      // Supprimer la section d'environnement après fusion
      defaultConfig.remove(environment);
      defaultConfig.remove('dev');
      defaultConfig.remove('prod');
    }

    await SFConfig.initialize(
      defaultConfig: defaultConfig,
      environment: environment,
    );
  }
}''';

String generateAppConfig(String projectName) {
  // Convertir project_name en PascalCase pour le nom de la classe
  final projectNamePascalCase = projectName.toPascalCase();

  return appConfigTemplate.replaceAll('{{ProjectName}}', projectNamePascalCase);
}
