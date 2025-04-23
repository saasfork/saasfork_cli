import 'dart:io';
import 'package:path/path.dart' as path;

/// Service responsable de la création et gestion de projets Flutter
class ProjectService {
  /// Crée un nouveau projet Flutter avec le nom spécifié
  Future<bool> createFlutterProject(String projectName) async {
    print('🚀 Création du projet Flutter "$projectName"...');

    final result = await Process.run('flutter', ['create', projectName]);

    if (result.exitCode == 0) {
      print('✅ Projet "$projectName" créé avec succès !');
      return true;
    } else {
      print('❌ Erreur lors de la création :');
      print(result.stderr);
      return false;
    }
  }

  /// Détermine le chemin complet du projet à partir du répertoire courant
  String getProjectPath(String projectName) {
    final currentDir = Directory.current.path;
    return '$currentDir/$projectName';
  }

  /// Obtient le chemin du répertoire racine du projet
  String getProjectDirectory(String projectPath) {
    return projectPath;
  }

  /// Obtient le chemin vers le répertoire lib du projet
  String getLibDirectory(String projectPath) {
    return '$projectPath/lib';
  }

  /// Localise le répertoire des templates à partir du script courant
  Future<String?> findTemplateDirectory() async {
    try {
      final scriptFile = File(Platform.script.toFilePath());
      final commandsDir = scriptFile.parent;
      final libDir = commandsDir.parent;
      final templateDir = Directory(path.join(libDir.path, 'templates'));

      if (await templateDir.exists()) {
        return templateDir.path;
      }
      return null;
    } catch (e) {
      print('❌ Erreur lors de la recherche du répertoire de templates:');
      print(e);
      return null;
    }
  }

  /// Génère un nouveau pubspec.yaml basé sur le nom du projet et remplace le fichier existant
  Future<bool> generateValidPubspec(
    String projectPath,
    String projectName,
  ) async {
    print('🔄 Génération d\'un fichier pubspec.yaml valide...');

    try {
      final pubspecFile = File('$projectPath/pubspec.yaml');

      // Création du contenu du pubspec.yaml
      final pubspecContent = '''name: $projectName
description: A new Flutter project.

# The following line prevents the package from being accidentally published to
# pub.dev using `flutter pub publish`. This is preferred for private packages.
publish_to: 'none' # Remove this line if you wish to publish to pub.dev

# The following defines the version and build number for your application.
# A version number is three numbers separated by dots, like 1.2.43
# followed by an optional build number separated by a +.
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

# Dependencies specify other packages that your package needs in order to work.
# To automatically upgrade your package dependencies to the latest versions
# consider running `flutter pub upgrade --major-versions`.
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
    
  # The following adds the Cupertino Icons font to your application.
  cupertino_icons: ^1.0.2

dev_dependencies:
  flutter_test:
    sdk: flutter

  # The "flutter_lints" package below contains a set of recommended lints to
  # encourage good coding practices.
  flutter_lints: ^2.0.0

# The following section is specific to Flutter packages.
flutter:
  # The following line ensures that the Material Icons font is
  # included with your application, so that you can use the icons in
  # the material Icons class.
  uses-material-design: true
  generate: true
''';

      // Écriture du fichier
      await pubspecFile.writeAsString(pubspecContent);
      print('✅ Fichier pubspec.yaml généré avec succès!');

      return true;
    } catch (e) {
      print('❌ Erreur lors de la génération du fichier pubspec.yaml:');
      print(e);
      return false;
    }
  }

  /// Met à jour le fichier pubspec.yaml pour ajouter les imports locaux des packages SaasFork
  Future<bool> updatePubspecWithLocalPackages(String projectPath) async {
    try {
      print('📝 Ajout des imports de packages SaasFork locaux...');

      final pubspecFile = File('$projectPath/pubspec.yaml');
      if (!await pubspecFile.exists()) {
        print('❌ Fichier pubspec.yaml introuvable !');
        return false;
      }

      String content = await pubspecFile.readAsString();

      // Ajouter la section dependency_overrides s'il n'y a pas déjà
      if (!content.contains('dependency_overrides:')) {
        content += '\n\ndependency_overrides:\n';
        content += '  saasfork_design_system:\n';
        content += '    path: ../packages/saasfork_design_system\n\n';
        content += '  saasfork_firebase_service:\n';
        content += '    path: ../packages/saasfork_firebase_service\n\n';
        content += '  saasfork_core:\n';
        content += '    path: ../packages/saasfork_core\n';
      } else {
        print(
          '⚠️ Une section dependency_overrides existe déjà dans le fichier pubspec.yaml',
        );
      }

      await pubspecFile.writeAsString(content);
      print('✅ Imports locaux ajoutés au fichier pubspec.yaml');
      return true;
    } catch (e) {
      print('❌ Erreur lors de la mise à jour du fichier pubspec.yaml:');
      print(e);
      return false;
    }
  }

  /// Configure pubspec.yaml pour la génération des fichiers de localisation
  Future<void> configurePubspecForLocalizations(String projectPath) async {
    print(
      '🔄 Configuration du pubspec.yaml pour les fichiers de localisation...',
    );

    try {
      // Créer le fichier l10n.yaml s'il n'existe pas
      final File l10nFile = File('$projectPath/l10n.yaml');
      if (!l10nFile.existsSync()) {
        await l10nFile.writeAsString('''synthetic-package: false
output-dir: lib/generated/l10n
template-arb-file: intl_en.arb
output-localization-file: app_localizations.dart''');
        print('✅ Fichier l10n.yaml créé avec succès !');
      }

      print('✅ Pubspec.yaml configuré pour les fichiers de localisation !');
    } catch (e) {
      print(
        '❌ Erreur lors de la configuration pour les fichiers de localisation: $e',
      );
    }
  }
}
