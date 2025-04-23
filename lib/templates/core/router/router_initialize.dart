import 'package:saasfork_cli/utils/extensions/string_extension.dart';

const routerInitializeTemplate =
    '''/// import 'package:{{project_name}}/generated/l10n/app_localizations.dart';
import 'package:{{project_name}}/core/router/router.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saasfork_design_system/saasfork_design_system.dart';

class RouterInitialize extends ConsumerStatefulWidget {
  const RouterInitialize({super.key});

  @override
  ConsumerState<RouterInitialize> createState() => _RouterInitializeState();
}

class _RouterInitializeState extends ConsumerState<RouterInitialize> {
  late final AppRouter appRouter = AppRouter(ref);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeToggleProvider);
    
    return MaterialApp.router(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      localizationsDelegates: const [
///        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
///      supportedLocales: AppLocalizations.supportedLocales,
///      locale: locale,
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter.config(),
    );
  }
}''';

String generateRouterInitialize(String projectName) {
  final String snakeCaseProjectName = projectName.toSnakeCase();

  return routerInitializeTemplate.replaceAll(
    '{{project_name}}',
    snakeCaseProjectName,
  );
}
