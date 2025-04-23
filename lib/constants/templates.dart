import '../templates/main.dart' as main_template;
import '../templates/app_config.dart' as app_config_template;
import '../templates/core/initializer/app_initializer.dart'
    as initializer_template;
import '../templates/core/router/router.dart' as router_template;
import '../templates/core/router/router_initialize.dart'
    as router_initialize_template;
import '../templates/core/router/guards/auth_guard.dart' as auth_guard_template;
import '../templates/core/router/guards/unauthenticated_guard.dart'
    as unauthenticated_guard_template;
import '../templates/core/providers.dart' as providers_template;
import '../templates/core/extensions/build_context_localizations_extension.dart'
    as build_context_localizations_extension_template;
import '../templates/core/extensions/app_localizations_extension.dart'
    as app_localizations_extension_template;
import '../templates/ui/pages/home_page.dart' as home_page_template;
import '../templates/ui/pages/dashboard_page.dart' as dashboard_page_template;
import '../templates/ui/pages/error_page.dart' as error_page_template;
import '../templates/ui/pages/auth/login_page.dart' as login_page_template;
import '../templates/ui/pages/auth/register_page.dart'
    as register_page_template;
import '../templates/ui/pages/auth/forgotten_page.dart'
    as forgotten_page_template;
import '../templates/ui/pages/auth/shared/auth_link_footer.dart'
    as auth_link_footer_template;
import '../templates/ui/layouts/username_layout.dart'
    as username_layout_template;
import '../templates/ui/layouts/default_layout.dart' as default_layout_template;
import '../templates/ui/layouts/common/logo_widget.dart'
    as logo_widget_template;

// Import des traductions
import '../templates/ui/pages/auth/login_page.dart' as login_page_translate;
import '../templates/ui/pages/auth/register_page.dart'
    as register_page_translate;
import '../templates/ui/pages/auth/forgotten_page.dart'
    as forgotten_page_translate;
import '../templates/ui/pages/auth/shared/auth_link_footer.dart'
    as auth_link_footer_translate;
import '../templates/ui/layouts/username_layout.dart'
    as username_layout_translate;
import '../templates/ui/layouts/default_layout.dart'
    as default_layout_translate;
import '../templates/ui/layouts/common/logo_widget.dart'
    as logo_widget_translate;
import '../templates/core/extensions/app_localizations_extension.dart'
    as app_localizations_extension_translate;

/// Structure des fichiers template à générer
final Map<String, String Function(String)> templateGenerators = {
  'main.dart': main_template.generateMain,
  'app_config.dart': app_config_template.generateAppConfig,
  'core/initializer/app_initializer.dart':
      initializer_template.generateAppInitializer,
  'core/router/router.dart': router_template.generateRouter,
  'core/router/router_initialize.dart':
      router_initialize_template.generateRouterInitialize,
  'core/router/guards/auth_guard.dart': auth_guard_template.generateAuthGuard,
  'core/router/guards/unauthenticated_guard.dart':
      unauthenticated_guard_template.generateUnauthenticatedGuard,
  'core/providers.dart': providers_template.generateProviders,
  'core/extensions/build_context_localizations_extension.dart':
      build_context_localizations_extension_template
          .generateBuildContextLocalizationsExtension,
  'core/extensions/app_localizations_extension.dart':
      app_localizations_extension_template.generateAppLocalizationsExtension,
  'ui/pages/home_page.dart': home_page_template.generateHomePage,
  'ui/pages/dashboard_page.dart': dashboard_page_template.generateDashboardPage,
  'ui/pages/error_page.dart': error_page_template.generateErrorPage,
  'ui/pages/auth/login_page.dart': login_page_template.generateLoginPage,
  'ui/pages/auth/register_page.dart':
      register_page_template.generateRegisterPage,
  'ui/pages/auth/forgotten_page.dart':
      forgotten_page_template.generateForgottenPage,
  'ui/pages/auth/shared/auth_link_footer.dart':
      auth_link_footer_template.generateAuthLinkFooter,
  'ui/layouts/username_layout.dart':
      username_layout_template.generateUsernameLayout,
  'ui/layouts/default_layout.dart':
      default_layout_template.generateDefaultLayout,
  'ui/layouts/common/logo_widget.dart': logo_widget_template.generateLogoWidget,
};

/// Structure des traductions à générer par langue
final Map<String, Map<String, Function()>> translateGenerators = {
  'login_page': login_page_translate.generateTranslate(),
  'register_page': register_page_translate.generateTranslateRegisterPage(),
  'forgotten_page': forgotten_page_translate.generateTranslateForgottenPage(),
  'auth_link_footer':
      auth_link_footer_translate.generateTranslateAuthLinkFooter(),
  'username_layout':
      username_layout_translate.generateTranslateUsernameLayout(),
  'default_layout': default_layout_translate.generateTranslateDefaultLayout(),
  'logo_widget': logo_widget_translate.generateTranslateLogoWidget(),
  'app_localizations_extension':
      app_localizations_extension_translate
          .generateTranslateAppLocalizationsExtension(),
};
