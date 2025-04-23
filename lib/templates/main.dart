import 'package:saasfork_cli/utils/extensions/string_extension.dart';

const mainTemplate = '''import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:{{project_name}}/core/initializer/app_initializer.dart';
import 'package:{{project_name}}/core/router/router_initialize.dart';  
import 'package:{{project_name}}/ui/pages/error_page.dart';

Future<void> main() async {
  try {
    await AppInitializer.initialize();
    runApp(const ProviderScope(child: {{ProjectName}}App()));
  } catch (e) {
    debugPrint('Erreur dans main(): \$e');
    runApp(const ErrorPage());
  }
}

class {{ProjectName}}App extends ConsumerWidget {
  const {{ProjectName}}App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const RouterInitialize();
  }
}''';

String generateMain(String projectName) {
  // Convertir project_name en snake_case pour les imports
  final projectNameSnakeCase = projectName.toSnakeCase();

  // Convertir project_name en PascalCase pour le nom de la classe
  final projectNamePascalCase = projectName.toPascalCase();

  String content = mainTemplate
      .replaceAll('{{project_name}}', projectNameSnakeCase)
      .replaceAll('{{ProjectName}}', projectNamePascalCase);

  return content;
}
