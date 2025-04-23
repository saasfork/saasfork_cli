import 'package:saasfork_cli/utils/extensions/string_extension.dart';

const authGuardTemplate =
    '''import 'package:{{project_name}}/core/router/router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saasfork_core/saasfork_core.dart';
import 'package:saasfork_firebase_service/saasfork_firebase_service.dart';

class AuthGuard extends AutoRouteGuard {
  final WidgetRef ref;

  AuthGuard(this.ref);

  @override
  Future<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    log('AuthGuard checking route: \${resolver.route.name}');
    await ref.read(authProvider.notifier).initialize();
    final authState = ref.read(authProvider);

    if (authState.isAuthenticated || authState.hasError) {
      resolver.next(true);
      return;
    }

    resolver.redirectUntil(const LoginPageRoute());
  }
}
''';

String generateAuthGuard(String projectName) {
  final String snakeCaseProjectName = projectName.toSnakeCase();

  return authGuardTemplate.replaceAll('{{project_name}}', snakeCaseProjectName);
}
