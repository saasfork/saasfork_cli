import 'package:saasfork_cli/utils/extensions/string_extension.dart';

const usernameLayoutTemplate =
    '''import 'package:{{project_name}}/core/extensions/build_context_localizations_extension.dart';
import 'package:{{project_name}}/ui/layouts/common/logo_widget.dart';
import 'package:flutter/material.dart';
import 'package:saasfork_core/models/seo_model.dart';
import 'package:saasfork_design_system/saasfork_design_system.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UsernameLayout extends StatefulWidget {
  final Widget content;
  final String? urlImageBackground;
  final String? title;
  final String? subtitle;
  final VoidCallback? onPressedLogo;
  final SFSEOModel? seoModel;

  const UsernameLayout({
    super.key,
    required this.content,
    this.urlImageBackground,
    this.title,
    this.subtitle,
    this.onPressedLogo,
    this.seoModel,
  });

  @override
  State<UsernameLayout> createState() => _UsernameLayoutState();
}

class _UsernameLayoutState extends State<UsernameLayout> {
  @override
  Widget build(BuildContext context) {
    return SFDefaultLayout(
      seoModel: widget.seoModel,
      builder: SFLayoutBuilder(
        contentBuilder:
            (context, ref) => SFResponsiveRow(
              children: [
                SFResponsiveColumn(
                  xs: 12,
                  sm: 6,
                  md: 8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SFNavBar(
                        leading: logo(context, widget.onPressedLogo),
                        links: [],
                        actions: [],
                      ),
                      Expanded(
                        child: SFResponsiveContainer(
                          maxWidth: 600,
                          child: SingleChildScrollView(
                            physics: const ClampingScrollPhysics(),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              spacing: AppSpacing.xl,
                              children: [
                                if (widget.title != null &&
                                    widget.title!.isNotEmpty &&
                                    widget.subtitle != null &&
                                    widget.subtitle!.isNotEmpty)
                                  _buildHeader(context),
                                widget.content,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (context.isDesktopOrLarger)
                  SFResponsiveColumn(
                    xs: 12,
                    sm: 6,
                    md: 4,
                    child: LayoutBuilder(
                      builder:
                          (context, constraints) => _buildImage(context, constraints),
                    ),
                  ),
              ],
            ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.sm,
      children: [
        Text(widget.title!, style: Theme.of(context).textTheme.displayLarge),
        Text(widget.subtitle!, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }

  Container _imageContainer(BuildContext context, BoxConstraints constraints, Widget? child) =>
      Container(
        width: constraints.maxWidth * 2,
        alignment: Alignment.centerLeft,
        color: Theme.of(context).colorScheme.primary.withAlpha(10),
        child: child,
      );

  Column _buildImage(BuildContext context, BoxConstraints constraints) {
    final defaultImage = 'https://cdn.pixabay.com/photo/2020/11/06/07/42/girl-5717067_960_720.jpg';
    
    return Column(
      children: [
        Expanded(
          child: ClipRect(
            child: OverflowBox(
              maxWidth: constraints.maxWidth * 2,
              alignment: Alignment.centerLeft,
              child: CachedNetworkImage(
                imageUrl: widget.urlImageBackground ?? defaultImage,
                width: constraints.maxWidth * 2,
                filterQuality: FilterQuality.medium,
                fit: BoxFit.cover,
                placeholder:
                    (context, url) => _imageContainer(context, constraints, null),
                errorWidget:
                    (context, url, error) => _imageContainer(
                      context,
                      constraints,
                      Center(child: Icon(Icons.error, semanticLabel: context.l10n.imageLoadError)),
                    ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}''';

String generateUsernameLayout(String projectName) {
  // Convertir project_name en snake_case pour les imports
  final projectNameSnakeCase = projectName.toSnakeCase();

  String content = usernameLayoutTemplate.replaceAll(
    '{{project_name}}',
    projectNameSnakeCase,
  );

  return content;
}

// Ajouter des traductions pour username_layout
Map<String, Function()> generateTranslateUsernameLayout() {
  return {
    'fr': () => '''"imageLoadError": "Erreur de chargement de l'image"''',
    'en': () => '''"imageLoadError": "Image loading error"''',
  };
}
