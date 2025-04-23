import 'package:saasfork_cli/utils/extensions/string_extension.dart';

const dashboardPageTemplate =
    '''import 'package:{{project_name}}/ui/layouts/dashboard_layout.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:saasfork_core/saasfork_core.dart';

@RoutePage()
class DashboardPage extends StatelessWidget {
  static const String path = '/dashboard';

  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DashboardLayout(
      seoModel: SFSEOModel(
        title: 'AppYoutube',
        description: 'Bienvenue dans votre dashboard AppYoutube',
      ),
      content: Center(
        child: Text('Bienvenue dans votre dashboard AppYoutube!'),
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
