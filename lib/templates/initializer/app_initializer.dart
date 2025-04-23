import 'package:saasfork_cli/utils/extensions/string_extension.dart';

const appInitializerTemplate =
    '''import 'package:{{project_name}}/app_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:saasfork_core/saasfork_core.dart';

class AppInitializer {
  static Future<void> initialize() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      const bool isDev = !kReleaseMode;

      Logger.configure(enable: isDev);

      if (kIsWeb) {
        if (isDev) {
          setUrlStrategy(const HashUrlStrategy());
        } else {
          setUrlStrategy(PathUrlStrategy());
        }
      }

      await AppConfig.initialize(
        environment: isDev ? SFConfig.dev : SFConfig.prod,
      );
    } catch (e) {
      debugPrint('Erreur lors de l\\'initialisation de l\\'application: \$e');
      rethrow;
    }
  }
}''';

String generateAppInitializer(String projectName) {
  // Assurer que le nom du projet pour les imports est en snake_case
  final projectNameSnakeCase = projectName.toSnakeCase();

  return appInitializerTemplate.replaceAll(
    '{{project_name}}',
    projectNameSnakeCase,
  );
}