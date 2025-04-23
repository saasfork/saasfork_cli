import 'package:saasfork_cli/utils/extensions/string_extension.dart';

const defaultLayoutTemplate =
    '''import 'package:{{project_name}}/app_config.dart';
import 'package:{{project_name}}/ui/layouts/common/logo_widget.dart';
import 'package:app_youtube/ui/pages/home_page.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saasfork_core/saasfork_core.dart';
import 'package:saasfork_design_system/saasfork_design_system.dart';
import 'package:signals/signals_flutter.dart';

class DefaultLayout extends ConsumerStatefulWidget {
  final Widget content;
  final SFSEOModel? seoModel;

  const DefaultLayout({super.key, required this.content, this.seoModel});

  @override
  DefaultLayoutState createState() => DefaultLayoutState();
}

class DefaultLayoutState extends ConsumerState<DefaultLayout>
    with SignalsMixin {
  static const double dropdownWidth = 200;
  late final _links = createSignal<List<SFNavLink>>([]);
  late final SFSEOModel seoParams;

  @override
  void initState() {
    super.initState();

    seoParams = SFSEOModel.fromMap({
      ...(SFSEOModel(title: AppConfig.get<String>('app.name') ?? '')).toMap(),
      ...widget.seoModel?.toMap() ?? {},
    });
  }

  late final _actions = createComputed<List<Widget>>(() {
    // Add dynamic menu
    return [];
  });

  @override
  Widget build(BuildContext context) {
    return SFDefaultLayout(
      seoModel: seoParams,
      builder: SFLayoutBuilder(
        headerBuilder:
            (context, ref) => SFNavBar(
              leading: logo(context, () => context.router.pushPath(HomePage.path)),
              links: _links.value,
              actions: _actions.watch(context),
            ),
        contentBuilder:
            (context, ref) => SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: widget.content,
            ),
      ),
    );
  }
}''';

String generateDefaultLayout(String projectName) {
  // Convertir project_name en snake_case pour les imports
  final projectNameSnakeCase = projectName.toSnakeCase();

  String content = defaultLayoutTemplate.replaceAll(
    '{{project_name}}',
    projectNameSnakeCase,
  );

  return content;
}

// Ajouter des traductions pour default_layout
Map<String, Function()> generateTranslateDefaultLayout() {
  return {
    'fr':
        () => '''"defaultLayoutLoginButton": "Se connecter",
    "defaultLayoutDashboardButton": "Tableau de bord",
    "languageOptionFrench": "Français",
    "languageOptionEnglish": "Anglais"''',
    'en':
        () => '''"defaultLayoutLoginButton": "Login",
    "defaultLayoutDashboardButton": "Dashboard",
    "languageOptionFrench": "French",
    "languageOptionEnglish": "English"''',
  };
}
