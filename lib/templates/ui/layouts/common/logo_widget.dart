import 'package:saasfork_cli/utils/extensions/string_extension.dart';

const logoWidgetTemplate = '''import 'package:{{project_name}}/app_config.dart';
import 'package:{{project_name}}/core/extensions/build_context_localizations_extension.dart';
import 'package:flutter/material.dart';
import 'package:saasfork_design_system/saasfork_design_system.dart';

Widget logo(BuildContext context, Function()? onTap) => MouseRegion(
  cursor: onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
  child: GestureDetector(
    onTap: onTap,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacing.md,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.indigo,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Icon(
              Icons.bolt, 
              color: Colors.white, 
              size: 20, 
              semanticLabel: context.l10n.logoIconSemanticLabel,
            )
          ),
        ),
        Text(
          AppConfig.get<String>('app.name')!,
          style: AppTypography.titleMedium,
          semanticsLabel: context.l10n.logoAppNameSemanticLabel,
        ),
      ],
    ),
  ),
);''';

String generateLogoWidget(String projectName) {
  // Convertir project_name en snake_case pour les imports
  final projectNameSnakeCase = projectName.toSnakeCase();

  String content = logoWidgetTemplate.replaceAll(
    '{{project_name}}',
    projectNameSnakeCase,
  );

  return content;
}

// Ajouter des traductions pour logo_widget
Map<String, Function()> generateTranslateLogoWidget() {
  return {
    'fr':
        () => '''"logoIconSemanticLabel": "Icône de l'application",
  "logoAppNameSemanticLabel": "Nom de l'application",''',
    'en':
        () => '''"logoIconSemanticLabel": "App icon",
  "logoAppNameSemanticLabel": "App name",''',
  };
}
