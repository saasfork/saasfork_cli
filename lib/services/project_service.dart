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

  /// Obtient le chemin vers le répertoire lib du projet
  Directory getLibDirectory(String projectPath) {
    return Directory('$projectPath/lib');
  }

  /// Localise le répertoire des templates à partir du script courant
  Future<Directory?> findTemplateDirectory() async {
    try {
      final scriptFile = File(Platform.script.toFilePath());
      final commandsDir = scriptFile.parent;
      final libDir = commandsDir.parent;
      final templateDir = Directory(path.join(libDir.path, 'templates'));

      if (await templateDir.exists()) {
        return templateDir;
      }
      return null;
    } catch (e) {
      print('❌ Erreur lors de la recherche du répertoire de templates:');
      print(e);
      return null;
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
}
