const routerTemplate = '''import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mon_app/ui/pages/home_page.dart';

part 'router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Route')
class AppRouter extends RootStackRouter {
  final WidgetRef ref;

  AppRouter(this.ref);


  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: HomePageRoute.page, initial: true, path: HomePage.path),
      ];
}
''';

String generateRouter(String projectName) {
  return routerTemplate;
}
