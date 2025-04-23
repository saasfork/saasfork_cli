extension StringExtension on String {
  /// Convertit une chaîne en format PascalCase
  /// Exemple: "mon_app" devient "MonApp"
  String toPascalCase() {
    if (isEmpty) return this;

    // Diviser la chaîne aux underscores
    final parts = split('_');

    // Capitaliser la première lettre de chaque partie
    final capitalizedParts = parts.map((part) {
      if (part.isEmpty) return '';
      return part[0].toUpperCase() + part.substring(1);
    });

    // Joindre toutes les parties
    return capitalizedParts.join();
  }

  /// Convertit une chaîne en format snake_case
  /// Exemple: "MonApp" devient "mon_app"
  String toSnakeCase() {
    if (isEmpty) return this;

    // Si le nom est déjà en snake_case, le retourner tel quel
    if (contains('_') && toLowerCase() == this) {
      return this;
    }

    // Sinon, le convertir de PascalCase ou camelCase en snake_case
    final result =
        replaceAllMapped(
              RegExp(r'([A-Z])'),
              (match) => '_${match.group(0)!.toLowerCase()}',
            )
            // Supprimer l'underscore au début s'il existe
            .replaceFirst(RegExp(r'^_'), '')
            // Remplacer les espaces par des underscores
            .replaceAll(' ', '_')
            .toLowerCase();

    return result;
  }
}
