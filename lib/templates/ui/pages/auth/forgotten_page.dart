import 'package:saasfork_cli/utils/extensions/string_extension.dart';

const forgottenPageTemplate =
    '''import 'package:{{project_name}}/app_config.dart';
import 'package:{{project_name}}/core/extensions/app_localizations_extension.dart';
import 'package:{{project_name}}/core/extensions/build_context_localizations_extension.dart';
import 'package:{{project_name}}/ui/layouts/username_layout.dart';
import 'package:{{project_name}}/ui/pages/home_page.dart';
import 'package:{{project_name}}/ui/pages/auth/shared/auth_link_footer.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saasfork_core/saasfork_core.dart';
import 'package:saasfork_design_system/saasfork_design_system.dart';
import 'package:saasfork_firebase_service/saasfork_firebase_service.dart';

@RoutePage()
class ForgottenPage extends ConsumerWidget {
  static const String path = '/forgotten';
  
  const ForgottenPage({super.key});

  void _handleAuthResult(BuildContext context, AuthStateModel authStateModel) {
    if (authStateModel.hasError) {
      context.showErrorMessage(
        message: context.l10n.getString(authStateModel.errorMessage!) ?? 
            context.l10n.unknown,
        title: context.l10n.forgottenPageErrorTitle,
      );
    } else {
      context.showSuccessMessage(
        message: context.l10n.forgottenPageSuccessMessage,
        title: context.l10n.forgottenPageSuccessTitle,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return UsernameLayout(
      seoModel: SFSEOModel(
        title:
            "\${context.l10n.forgottenPageTitle} | \${AppConfig.get<String>('app.name')}",
      ),
      onPressedLogo: () => context.router.pushPath(HomePage.path),
      urlImageBackground:
          'https://cdn.pixabay.com/photo/2020/11/06/07/42/girl-5717067_960_720.jpg',
      title: context.l10n.forgottenPageTitle,
      subtitle: context.l10n.forgottenPageSubtitle,
      content: Column(
        spacing: AppSpacing.md,
        children: [
          SFForgotPasswordForm(
            additionalData: {
              'label_email': context.l10n.forgottenLabelEmail,
              'placeholder_email': context.l10n.forgottenPlaceholderEmail,
              'error_email_invalid': context.l10n.forgottenErrorEmailInvalid,
              'forgot_password_button': context.l10n.forgottenButton,
            },
            onSubmit: (Map<String, dynamic> data) async {
              final String email = data['email'];

              final AuthStateModel authStateModel = await ref
                  .read(authProvider.notifier)
                  .resetPassword(email);

              if (context.mounted) {
                _handleAuthResult(context, authStateModel);
              }
            },
          ),
          const AuthLinksFooter(currentPage: AuthPageType.forgotPassword),
        ],
      ),
    );
  }
}''';

String generateForgottenPage(String projectName) {
  // Convertir project_name en snake_case pour les imports
  final projectNameSnakeCase = projectName.toSnakeCase();

  String content = forgottenPageTemplate.replaceAll(
    '{{project_name}}',
    projectNameSnakeCase,
  );

  return content;
}

// Traductions pour la page de mot de passe oublié
Map<String, Function()> generateTranslateForgottenPage() {
  return {
    'fr':
        () => '''"forgottenPageTitle": "Mot de passe oublié",
  "forgottenPageSubtitle": "Entrez votre adresse e-mail et nous vous enverrons un lien pour réinitialiser votre mot de passe",
  "forgottenPageErrorTitle": "Erreur",
  "forgottenPageSuccessTitle": "Email envoyé",
  "forgottenPageSuccessMessage": "Un email a été envoyé à l'adresse fournie avec les instructions pour réinitialiser votre mot de passe",
  "forgottenLabelEmail": "E-mail",
  "forgottenPlaceholderEmail": "Entrez votre email",
  "forgottenErrorEmailInvalid": "Adresse e-mail invalide.",
  "forgottenButton": "Réinitialiser le mot de passe",''',
    'en':
        () => '''"forgottenPageTitle": "Forgot Password",
  "forgottenPageSubtitle": "Enter your email address and we'll send you a link to reset your password",
  "forgottenPageErrorTitle": "Error",
  "forgottenPageSuccessTitle": "Email Sent",
  "forgottenPageSuccessMessage": "An email has been sent to the provided address with instructions to reset your password",
  "forgottenLabelEmail": "Email",
  "forgottenPlaceholderEmail": "Enter your email",
  "forgottenErrorEmailInvalid": "Invalid email address.",
  "forgottenButton": "Reset Password",''',
  };
}
