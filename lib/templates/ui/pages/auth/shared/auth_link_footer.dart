import 'package:saasfork_cli/utils/extensions/string_extension.dart';

const authLinkFooterTemplate =
    '''import 'package:{{project_name}}/core/extensions/build_context_localizations_extension.dart';
import 'package:{{project_name}}/ui/pages/auth/forgotten_page.dart';
import 'package:{{project_name}}/ui/pages/auth/login_page.dart';
import 'package:{{project_name}}/ui/pages/auth/register_page.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:saasfork_design_system/saasfork_design_system.dart';

enum AuthPageType { login, register, forgotPassword }

class AuthLinksFooter extends StatelessWidget {
  final AuthPageType currentPage;

  const AuthLinksFooter({super.key, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: _buildLinksForPage(context),
    );
  }

  List<Widget> _buildLinksForPage(BuildContext context) {
    final links = <Widget>[];

    switch (currentPage) {
      case AuthPageType.login:
        links.add(
          _LinkText(
            text: context.l10n.authLinkNoAccount,
            link: context.l10n.authLinkCreateAccount,
            onTap: () => context.router.pushPath(RegisterPage.path),
          ),
        );
      case AuthPageType.register:
      case AuthPageType.forgotPassword:
        links.add(
          _LinkText(
            text: context.l10n.authLinkHaveAccount,
            link: context.l10n.authLinkLogin,
            onTap: () => context.router.pushPath(LoginPage.path),
          ),
        );
    }

    if (currentPage == AuthPageType.login) {
      links.add(
        _LinkText(
          link: context.l10n.authLinkForgotPassword,
          onTap: () => context.router.pushPath(ForgottenPage.path),
        ),
      );
    }

    return links.separatedBy(const SizedBox(height: AppSpacing.xs));
  }
}

class _LinkText extends StatelessWidget {
  final String? text;
  final String link;
  final VoidCallback onTap;

  const _LinkText({required this.link, required this.onTap, this.text});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium,
        children: [
          if (text != null) TextSpan(text: text),
          TextSpan(
            text: link,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).primaryColor,
            ),
            recognizer: TapGestureRecognizer()..onTap = onTap,
          ),
        ],
      ),
    );
  }
}

extension WidgetListExtension on List<Widget> {
  List<Widget> separatedBy(Widget separator) {
    if (length <= 1) return this;

    final result = <Widget>[];
    for (var i = 0; i < length; i++) {
      result.add(this[i]);
      if (i < length - 1) {
        result.add(separator);
      }
    }
    return result;
  }
}''';

String generateAuthLinkFooter(String projectName) {
  // Convertir project_name en snake_case pour les imports
  final projectNameSnakeCase = projectName.toSnakeCase();

  String content = authLinkFooterTemplate.replaceAll(
    '{{project_name}}',
    projectNameSnakeCase,
  );

  return content;
}

// Ajouter des traductions pour auth_link_footer
Map<String, Function()> generateTranslateAuthLinkFooter() {
  return {
    'fr':
        () => '''"authLinkNoAccount": "Vous n'avez pas de compte ? ",
  "authLinkCreateAccount": "Créez un compte",
  "authLinkHaveAccount": "Vous avez déjà un compte ? ",
  "authLinkLogin": "Se connecter",
  "authLinkForgotPassword": "Mot de passe oublié ?",
  "authLinkOr": "ou "''',
    'en':
        () => '''"authLinkNoAccount": "Don't have an account? ",
  "authLinkCreateAccount": "Create an account",
  "authLinkHaveAccount": "Already have an account? ",
  "authLinkLogin": "Login",
  "authLinkForgotPassword": "Forgot password?",
  "authLinkOr": "or "''',
  };
}
