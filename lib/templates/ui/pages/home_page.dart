import 'package:saasfork_cli/utils/extensions/string_extension.dart';

const homePageTemplate =
    '''import 'package:{{project_name}}/ui/layouts/default_layout.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:saasfork_core/saasfork_core.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  static const String path = '/';
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultLayout(
      seoModel: SFSEOModel(
        title: '{{ProjectName}}',
        description: 'Bienvenue dans votre application {{ProjectName}}',
      ),
      content: const Center(
        child: Text('Bienvenue dans votre application {{ProjectName}}!'),
      ),
    );
  }
}
''';

String generateHomePage(String projectName) {
  // Convertir project_name en snake_case pour les imports
  final projectNameSnakeCase = projectName.toSnakeCase();

  // Convertir project_name en PascalCase pour le nom de la classe
  final projectNamePascalCase = projectName.toPascalCase();

  return homePageTemplate
      .replaceAll('{{project_name}}', projectNameSnakeCase)
      .replaceAll('{{ProjectName}}', projectNamePascalCase);
}
