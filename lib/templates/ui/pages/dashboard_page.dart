import 'package:saasfork_cli/utils/extensions/string_extension.dart';

const dashboardPageTemplate = '''import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class DashboardPage extends StatelessWidget {
  static const String path = '/dashboard';
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('{{ProjectName}}'),
      ),
      body: const Center(
        child: Text('Bienvenue dans votre dashboard {{ProjectName}}!'),
      ),
    );
  }
}
''';

String generateDashboardPage(String projectName) {
  // Convertir project_name en snake_case pour les imports
  final projectNameSnakeCase = projectName.toSnakeCase();

  // Convertir project_name en PascalCase pour le nom de la classe
  final projectNamePascalCase = projectName.toPascalCase();

  return dashboardPageTemplate
      .replaceAll('{{project_name}}', projectNameSnakeCase)
      .replaceAll('{{ProjectName}}', projectNamePascalCase);
}
