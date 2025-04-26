const appExceptionTemplate = '''class AppException implements Exception {
  final String code;
  final String message;
  final Object? originalError;

  AppException(this.code, this.message, [this.originalError]);

  @override
  String toString() => message;
}''';

String generateAppException(String projectName) {
  // Pas besoin de remplacements car ce fichier n'a pas d'imports spécifiques au projet
  return appExceptionTemplate;
}
