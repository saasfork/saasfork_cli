import 'dart:io';
import 'package:path/path.dart' as path;

/// Service responsable de la génération et de la copie des templates
class TemplateService {
  /// Génère un fichier template à partir d'un générateur de contenu
  Future<void> generateTemplateFile(
    String targetPath,
    String Function(String) generator,
    String projectNamePascal, {
    bool isDev = false,
  }) async {
    final targetFile = File(targetPath);
    final parentDir = Directory(path.dirname(targetPath));

    if (!await parentDir.exists()) {
      await parentDir.create(recursive: true);
    }

    final content = generator(projectNamePascal);
    await targetFile.writeAsString(content);

    final fileName = path.basename(targetPath);
    print('✅ Fichier $fileName généré avec succès!');
  }

  /// Génère tous les fichiers de template à partir d'une map de générateurs
  Future<void> generateAllTemplates(
    Directory targetDir,
    Map<String, String Function(String)> templateGenerators,
    String projectNamePascal, {
    bool isDev = false,
  }) async {
    for (final entry in templateGenerators.entries) {
      final templatePath = entry.key;
      final generator = entry.value;
      final targetFilePath = path.join(targetDir.path, templatePath);

      await generateTemplateFile(
        targetFilePath,
        generator,
        projectNamePascal,
        isDev: isDev,
      );
    }
  }

  /// Copie les fichiers templates additionnels avec substitution de variables
  Future<void> copyAdditionalTemplates(
    Directory sourceDir,
    Directory targetDir,
    String projectName,
    Map<String, String Function(String)> templateGenerators, {
    bool isDev = false,
  }) async {
    print('📋 Copie des templates additionnels...');

    try {
      await for (final entity in sourceDir.list(recursive: true)) {
        // Ignorer les fichiers qui ont déjà des générateurs
        final relativePath = path.relative(entity.path, from: sourceDir.path);
        if (entity is File && templateGenerators.containsKey(relativePath)) {
          continue;
        }

        final targetPath = path.join(targetDir.path, relativePath);

        if (entity is File) {
          // Créer le dossier parent si nécessaire
          final parentDir = Directory(path.dirname(targetPath));
          if (!await parentDir.exists()) {
            await parentDir.create(recursive: true);
          }

          // Lire et traiter le contenu
          String content = await entity.readAsString();
          content = content.replaceAll('{{projectName}}', projectName);
          content = content.replaceAll('{{isDev}}', isDev.toString());

          // Écrire le contenu traité
          await File(targetPath).writeAsString(content);
          print('✅ Fichier template traité et copié: $relativePath');
        } else if (entity is Directory) {
          // Créer le dossier cible s'il n'existe pas déjà
          final targetSubDir = Directory(targetPath);
          if (!await targetSubDir.exists()) {
            await targetSubDir.create(recursive: true);
          }
        }
      }
    } catch (e) {
      print('❌ Erreur lors de la copie des templates additionnels:');
      print(e);
    }
  }
}
