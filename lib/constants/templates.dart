import '../templates/main.dart' as main_template;
import '../templates/app_config.dart' as app_config_template;
import '../templates/initializer/app_initializer.dart' as initializer_template;
import '../templates/core/router/router.dart' as router_template;
import '../templates/core/router/router_initialize.dart'
    as router_initialize_template;
import '../templates/core/providers.dart' as providers_template;
import '../templates/ui/pages/home_page.dart' as home_page_template;
import '../templates/ui/pages/error_page.dart' as error_page_template;

/// Structure des fichiers template à générer
final Map<String, String Function(String)> templateGenerators = {
  'main.dart': main_template.generateMain,
  'app_config.dart': app_config_template.generateAppConfig,
  'initializer/app_initializer.dart':
      initializer_template.generateAppInitializer,
  'core/router/router.dart': router_template.generateRouter,
  'core/router/router_initialize.dart':
      router_initialize_template.generateRouterInitialize,
  'core/providers.dart': providers_template.generateProviders,
  'ui/pages/home_page.dart': home_page_template.generateHomePage,
  'ui/pages/error_page.dart': error_page_template.generateErrorPage,
};
