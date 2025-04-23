import 'package:saasfork_cli/utils/extensions/string_extension.dart';

const registerPageTemplate =
    '''import 'package:{{project_name}}/app_config.dart';
import 'package:{{project_name}}/core/extensions/app_localizations_extension.dart';
import 'package:{{project_name}}/core/extensions/build_context_localizations_extension.dart';
import 'package:{{project_name}}/ui/layouts/username_layout.dart';
import 'package:{{project_name}}/ui/pages/dashboard_page.dart';
import 'package:{{project_name}}/ui/pages/auth/shared/auth_link_footer.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saasfork_core/saasfork_core.dart';
import 'package:saasfork_design_system/saasfork_design_system.dart';
import 'package:saasfork_firebase_service/saasfork_firebase_service.dart';
import 'package:signals/signals_flutter.dart';

@RoutePage()
class RegisterPage extends ConsumerStatefulWidget {
  static const String path = '/register';

  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> with SignalsMixin {
  late final _isLoading = createSignal<bool>(false);

  void _handleAuthResult(BuildContext context, AuthStateModel authStateModel) {
    if (authStateModel.hasError) {
      context.showErrorMessage(
        message: context.l10n.getString(authStateModel.errorMessage!) ?? 
            context.l10n.unknown,
        title: context.l10n.registerPageErrorTitle,
      );
    } else {
      context.router.pushPath(DashboardPage.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return UsernameLayout(
      seoModel: SFSEOModel(
        title:
            "\${context.l10n.registerPageTitle} | \${AppConfig.get<String>('app.name')}",
      ),
      urlImageBackground:
          'https://cdn.pixabay.com/photo/2020/11/06/07/42/girl-5717067_960_720.jpg',
      title: context.l10n.registerPageTitle,
      subtitle: context.l10n.registerPageSubtitle,
      content: Column(
        spacing: AppSpacing.md,
        children: [
          SFRegisterForm(
            additionalData: {
              'label_email': context.l10n.registerLabelEmail,
              'placeholder_email': context.l10n.registerPlaceholderEmail,
              'error_email_invalid': context.l10n.registerErrorEmailInvalid,
              'label_password': context.l10n.registerLabelPassword,
              'placeholder_password': context.l10n.registerPlaceholderPassword,
              'error_password_length': context.l10n.registerErrorPasswordLength,
              'register_button': context.l10n.registerButton,
            },
            isLoading: _isLoading.value,
            onSubmit: (Map<String, dynamic> data) async {
              final String email = data['email'];
              final String password = data['password'];

              _isLoading.value = true;

              final AuthStateModel authStateModel = await ref
                  .read(authProvider.notifier)
                  .register(email, password);

              _isLoading.value = false;

              if (context.mounted) {
                _handleAuthResult(context, authStateModel);
              }
            },
          ),
          const AuthLinksFooter(currentPage: AuthPageType.register),
        ],
      ),
    );
  }
}''';

String generateRegisterPage(String projectName) {
  // Convertir project_name en snake_case pour les imports
  final projectNameSnakeCase = projectName.toSnakeCase();

  String content = registerPageTemplate.replaceAll(
    '{{project_name}}',
    projectNameSnakeCase,
  );

  return content;
}

// Traductions pour la page d'inscription
Map<String, Function()> generateTranslateRegisterPage() {
  return {
    'fr':
        () => '''"registerPageTitle": "Créez un compte",
  "registerPageSubtitle": "Commencez à utiliser notre application en créant un compte",
  "registerPageErrorTitle": "Erreur d'inscription",
  "registerLabelEmail": "E-mail",
  "registerPlaceholderEmail": "Entrez votre email",
  "registerErrorEmailInvalid": "Adresse e-mail invalide.",
  "registerLabelPassword": "Mot de passe",
  "registerPlaceholderPassword": "Créez un mot de passe",
  "registerErrorPasswordLength": "Le mot de passe doit contenir au moins 6 caractères.",
  "registerButton": "S'inscrire",''',
    'en':
        () => '''"registerPageTitle": "Create an account",
  "registerPageSubtitle": "Start using our application by creating an account",
  "registerPageErrorTitle": "Registration Error",
  "registerLabelEmail": "Email",
  "registerPlaceholderEmail": "Enter your email",
  "registerErrorEmailInvalid": "Invalid email address.",
  "registerLabelPassword": "Password",
  "registerPlaceholderPassword": "Create a password",
  "registerErrorPasswordLength": "Password must be at least 6 characters.",
  "registerButton": "Register",''',
  };
}
