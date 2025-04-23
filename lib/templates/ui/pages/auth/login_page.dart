import 'package:saasfork_cli/utils/extensions/string_extension.dart';

const loginPageTemplate = '''import 'package:{{project_name}}/app_config.dart';
import 'package:{{project_name}}/core/extensions/app_localizations_extension.dart';
import 'package:{{project_name}}/core/extensions/build_context_localizations_extension.dart';
import 'package:{{project_name}}/ui/layouts/username_layout.dart';
import 'package:{{project_name}}/ui/pages/auth/shared/auth_link_footer.dart';
import 'package:{{project_name}}/ui/pages/dashboard_page.dart';
import 'package:{{project_name}}/ui/pages/home_page.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saasfork_core/saasfork_core.dart';
import 'package:saasfork_design_system/saasfork_design_system.dart';
import 'package:saasfork_firebase_service/saasfork_firebase_service.dart';
import 'package:signals/signals_flutter.dart';

@RoutePage()
class LoginPage extends ConsumerStatefulWidget {
  static const String path = '/login';

  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> with SignalsMixin {
  late final _isLoading = createSignal<bool>(false);

  void _handleAuthResult(BuildContext context, AuthStateModel authStateModel) {
    if (authStateModel.hasError) {
      context.showErrorMessage(
        message:
            context.l10n.getString(authStateModel.errorMessage!) ??
            context.l10n.unknown,
        title: context.l10n.loginPageErrorTitle,
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
            "\${context.l10n.loginPageTitle} | \${AppConfig.get<String>('app.name')}",
      ),
      onPressedLogo: () => context.router.pushPath(HomePage.path),
      urlImageBackground:
          'https://cdn.pixabay.com/photo/2020/11/06/07/42/girl-5717067_960_720.jpg',
      title: context.l10n.loginPageTitle,
      subtitle: context.l10n.loginPageSubtitle,
      content: Column(
        spacing: AppSpacing.md,
        children: [
          SFLoginForm(
            isLoading: _isLoading.value,
            additionalData: {
              'label_email': context.l10n.loginLabelEmail,
              'placeholder_email': context.l10n.loginPlaceholderEmail,
              'error_email_invalid': context.l10n.loginErrorEmailInvalid,
              'label_password': context.l10n.loginLabelPassword,
              'placeholder_password': context.l10n.loginPlaceholderPassword,
              'error_password_length': context.l10n.loginErrorPasswordLength,
              'login_button': context.l10n.loginButton,
            },
            onSubmit: (Map<String, dynamic> data) async {
              final String email = data['email'];
              final String password = data['password'];

              _isLoading.value = true;

              final AuthStateModel authStateModel = await ref
                  .read(authProvider.notifier)
                  .login(email, password);

              _isLoading.value = false;

              if (context.mounted) {
                _handleAuthResult(context, authStateModel);
              }
            },
          ),
          const AuthLinksFooter(currentPage: AuthPageType.login),
        ],
      ),
    );
  }
}''';

String generateLoginPage(String projectName) {
  // Convertir project_name en snake_case pour les imports
  final projectNameSnakeCase = projectName.toSnakeCase();

  String content = loginPageTemplate.replaceAll(
    '{{project_name}}',
    projectNameSnakeCase,
  );

  return content;
}

// Modifié pour retourner Map<String, Function>
Map<String, Function()> generateTranslate() {
  return {
    'fr':
        () => '''"loginPageTitle": "Connectez-vous",
  "loginPageSubtitle": "Accédez à votre espace en renseignant vos identifiants ci-dessous",
  "loginPageErrorTitle": "Erreur",
  "loginLabelEmail": "E-mail",
  "loginPlaceholderEmail": "Entrez votre email",
  "loginErrorEmailInvalid": "Adresse e-mail invalide.",
  "loginLabelPassword": "Mot de passe",
  "loginPlaceholderPassword": "Entrez votre mot de passe",
  "loginErrorPasswordLength": "Le mot de passe doit contenir au moins 6 caractères.",
  "loginButton": "Se connecter",
''',
    'en':
        () => '''"loginPageTitle": "Login",
  "loginPageSubtitle": "Access your space by entering your credentials below",
  "loginPageErrorTitle": "Error",
  "loginLabelEmail": "Email",
  "loginPlaceholderEmail": "Enter your email",
  "loginErrorEmailInvalid": "Invalid email address.",
  "loginLabelPassword": "Password",
  "loginPlaceholderPassword": "Enter your password",
  "loginErrorPasswordLength": "Password must be at least 6 characters.",
  "loginButton": "Login",''',
  };
}
