import 'package:saasfork_cli/utils/extensions/string_extension.dart';

const buildContextLocalizationsExtensionTemplate =
    '''import 'package:flutter/widgets.dart';
import 'package:{{project_name}}/generated/l10n/app_localizations.dart';

extension BuildContextLocalizationsExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}''';

String generateBuildContextLocalizationsExtension(String projectName) {
  // Convertir project_name en snake_case pour les imports
  final projectNameSnakeCase = projectName.toSnakeCase();

  String content = buildContextLocalizationsExtensionTemplate.replaceAll(
    '{{project_name}}',
    projectNameSnakeCase,
  );

  return content;
}
