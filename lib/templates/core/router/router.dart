import 'package:saasfork_cli/utils/extensions/string_extension.dart';

const routerTemplate = '''import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:{{project_name}}/ui/pages/home_page.dart';
import 'package:{{project_name}}/ui/pages/dashboard_page.dart';
import 'package:{{project_name}}/ui/pages/auth/login_page.dart';
import 'package:{{project_name}}/ui/pages/auth/register_page.dart';
import 'package:{{project_name}}/ui/pages/auth/forgotten_page.dart';
import 'package:{{project_name}}/core/router/guards/auth_guard.dart';
import 'package:{{project_name}}/core/router/guards/unauthenticated_guard.dart';

part 'router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Route')
class AppRouter extends RootStackRouter {
  final WidgetRef ref;

  AppRouter(this.ref);

  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  List<AutoRoute> get routes => [
         AutoRoute(
          page: HomePageRoute.page,
          initial: true,
          path: HomePage.path,
        ),
        AutoRoute(
          page: LoginPageRoute.page,
          path: LoginPage.path,
          guards: [UnauthenticatedGuard(ref)],
        ),
        AutoRoute(
          page: RegisterPageRoute.page,
          path: RegisterPage.path,
          guards: [UnauthenticatedGuard(ref)],
        ),
        AutoRoute(
          page: ForgottenPageRoute.page,
          path: ForgottenPage.path,
          guards: [UnauthenticatedGuard(ref)],
        ),
        AutoRoute(
          page: DashboardPageRoute.page,
          path: DashboardPage.path,
          guards: [AuthGuard(ref)],
        ),
      ];
}
''';

String generateRouter(String projectName) {
  final String snakeCaseProjectName = projectName.toSnakeCase();

  return routerTemplate.replaceAll('{{project_name}}', snakeCaseProjectName);
}
