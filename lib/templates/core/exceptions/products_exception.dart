import 'package:saasfork_cli/utils/extensions/string_extension.dart';

const productsExceptionTemplate =
    '''import 'package:{{project_name}}/core/exceptions/app_exception.dart';

class ProductsException extends AppException {
  ProductsException(super.code, super.message, [super.cause]);
}''';

String generateProductsException(String projectName) {
  // Convertir project_name en snake_case pour les imports
  final projectNameSnakeCase = projectName.toSnakeCase();

  return productsExceptionTemplate.replaceAll(
    '{{project_name}}',
    projectNameSnakeCase,
  );
}
