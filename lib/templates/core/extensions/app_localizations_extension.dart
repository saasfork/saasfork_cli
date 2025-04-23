import 'package:saasfork_cli/utils/extensions/string_extension.dart';

const appLocalizationsExtensionTemplate =
    '''import 'package:{{project_name}}/generated/l10n/app_localizations.dart';

extension AppLocalizationsExtension on AppLocalizations {
  /// Retrieves a localized string by its key dynamically.
  /// Returns null if the key doesn't exist.
  String? getString(String key) {
    switch (key) {
      case 'user_not_found':
        return user_not_found;
      case 'invalid_credentials':
        return invalid_credentials;
      case 'email_already_in_use':
        return email_already_in_use;
      case 'recent_login_required':
        return recent_login_required;
      case 'invalid_email':
        return invalid_email;
      case 'unknown':
        return unknown;
      case 'productStarterName':
        return productStarterName;
      case 'productStarterDescription':
        return productStarterDescription;
      case 'productFeatureHidePromoBannerName':
        return productFeatureHidePromoBannerName;
      case 'productFeatureHidePromoBannerDescription':
        return productFeatureHidePromoBannerDescription;
      case 'productFeaturePersonnalisationProfileName':
        return productFeaturePersonnalisationProfileName;
      case 'productFeaturePersonnalisationProfileDescription':
        return productFeaturePersonnalisationProfileDescription;
      case 'day':
        return day;
      case 'week':
        return week;
      case 'month':
        return month;
      case 'year':
        return year;
      default:
        return null;
    }
  }
}''';

String generateAppLocalizationsExtension(String projectName) {
  // Convertir project_name en snake_case pour les imports
  final projectNameSnakeCase = projectName.toSnakeCase();

  String content = appLocalizationsExtensionTemplate.replaceAll(
    '{{project_name}}',
    projectNameSnakeCase,
  );

  return content;
}

// Ajouter des traductions pour les clés utilisées dans l'extension
Map<String, Function()> generateTranslateAppLocalizationsExtension() {
  return {
    'fr':
        () => '''"user_not_found": "Utilisateur non trouvé",
  "invalid_credentials": "Identifiants invalides",
  "email_already_in_use": "Cette adresse e-mail est déjà utilisée",
  "recent_login_required": "Une connexion récente est requise pour cette opération",
  "invalid_email": "Adresse e-mail invalide",
  "unknown": "Une erreur inconnue est survenue",
  "day": "jour",
  "week": "semaine",
  "month": "mois",
  "year": "année",
  "productStarterName": "Démarrage",
  "productStarterDescription": "Plan de démarrage",
  "productFeatureHidePromoBannerName": "Masquer les bannières promotionnelles",
  "productFeatureHidePromoBannerDescription": "Masquez les bannières promotionnelles dans l'application",
  "productFeaturePersonnalisationProfileName": "Personnalisation du profil",
  "productFeaturePersonnalisationProfileDescription": "Personnalisez votre profil avec des options avancées"''',
    'en':
        () => '''"user_not_found": "User not found",
  "invalid_credentials": "Invalid credentials",
  "email_already_in_use": "This email address is already in use",
  "recent_login_required": "A recent login is required for this operation",
  "invalid_email": "Invalid email address",
  "unknown": "An unknown error occurred",
  "day": "day",
  "week": "week",
  "month": "month",
  "year": "year",
  "productStarterName": "Starter",
  "productStarterDescription": "Starter plan",
  "productFeatureHidePromoBannerName": "Hide promotional banners",
  "productFeatureHidePromoBannerDescription": "Hide promotional banners in the application",
  "productFeaturePersonnalisationProfileName": "Profile personalization",
  "productFeaturePersonnalisationProfileDescription": "Customize your profile with advanced options"''',
  };
}
