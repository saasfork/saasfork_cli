import 'package:saasfork_cli/utils/extensions/string_extension.dart';

const profileServiceExceptionTemplate =
    '''import 'package:{{project_name}}/core/exceptions/app_exception.dart';

class ProfileServiceException extends AppException {
  ProfileServiceException(super.code, super.message, [super.cause]);
}''';

String generateProfileServiceException(String projectName) {
  // Convertir project_name en snake_case pour les imports
  final projectNameSnakeCase = projectName.toSnakeCase();

  return profileServiceExceptionTemplate.replaceAll(
    '{{project_name}}',
    projectNameSnakeCase,
  );
}
