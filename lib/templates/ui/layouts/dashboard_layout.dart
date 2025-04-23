import 'package:saasfork_cli/utils/extensions/string_extension.dart';

const dashboardLayoutTemplate =
    '''import 'package:{{project_name}}/ui/layouts/common/logo_widget.dart';
import 'package:{{project_name}}/ui/pages/dashboard_page.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saasfork_core/saasfork_core.dart';
import 'package:saasfork_design_system/saasfork_design_system.dart';

class DashboardLayout extends ConsumerStatefulWidget {
  final Widget content;
  final SFSEOModel? seoModel;

  const DashboardLayout({super.key, required this.content, this.seoModel});

  @override
  ConsumerState<DashboardLayout> createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends ConsumerState<DashboardLayout> {
  late List<SFNavLink> _links;

  @override
  void initState() {
    super.initState();
    _links = [];
  }

  @override
  Widget build(BuildContext context) {
    return SFDefaultLayout(
      seoModel: widget.seoModel,
      builder: SFLayoutBuilder(
        headerBuilder:
            (context, ref) => SFNavBar(
              leading: logo(context, () => context.router.pushPath(DashboardPage.path)),
              links: _links,
              actions: [],
            ),
        contentBuilder: (context, ref) => widget.content,
      ),
    );
  }
}''';

String generateDashboardLayout(String projectName) {
  // Convertir project_name en snake_case pour les imports
  final projectNameSnakeCase = projectName.toSnakeCase();

  String content = dashboardLayoutTemplate.replaceAll(
    '{{project_name}}',
    projectNameSnakeCase,
  );

  return content;
}
