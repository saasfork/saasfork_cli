import 'dart:io';
import 'dart:convert';
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
    String targetDirPath,
    Map<String, String Function(String)> templateGenerators,
    String projectNamePascal, {
    bool isDev = false,
  }) async {
    for (final entry in templateGenerators.entries) {
      final templatePath = entry.key;
      final generator = entry.value;
      final targetFilePath = path.join(targetDirPath, templatePath);

      await generateTemplateFile(
        targetFilePath,
        generator,
        projectNamePascal,
        isDev: isDev,
      );
    }
  }

  /// Génère les fichiers de traduction à partir des traductions des templates
  Future<void> generateTranslationFiles(
    String targetDirPath,
    Map<String, Map<String, Function()>> translateGenerators, {
    bool isDev = false,
  }) async {
    print('🌐 Génération des fichiers de traduction...');

    // Initialiser les maps pour chaque langue supportée
    final Map<String, Map<String, dynamic>> translations = {'fr': {}, 'en': {}};

    // Fusionner toutes les traductions des templates
    for (final templateEntry in translateGenerators.entries) {
      final templateTranslations = templateEntry.value;

      // Pour chaque langue (fr, en)
      for (final langEntry in templateTranslations.entries) {
        final lang = langEntry.key;
        final translationFunction = langEntry.value;
        // Exécuter la fonction pour obtenir le contenu de traduction
        final translationContent = translationFunction();

        // Parse les chaînes JSON partielles en un JSON complet pour la fusion
        final translationLines = translationContent.trim().split('\n');
        final Map<String, dynamic> parsed = {};

        // Traitement de chaque ligne pour extraire les paires clé-valeur
        for (final line in translationLines) {
          final trimmedLine = line.trim();
          if (trimmedLine.isEmpty || !trimmedLine.contains(':')) continue;

          // Extraire la clé et la valeur
          final parts = trimmedLine.split(':');
          if (parts.length < 2) continue;

          // Récupérer la clé en enlevant les guillemets
          final key = parts[0].trim().replaceAll('"', '');

          // Récupérer la valeur en la rejoignant (au cas où elle contient des :)
          var value = parts.sublist(1).join(':').trim();

          // Enlever la virgule à la fin si présente
          if (value.endsWith(',')) {
            value = value.substring(0, value.length - 1).trim();
          }

          // Extraire la valeur entre guillemets
          final valueMatch = RegExp(r'"([^"]*)"').firstMatch(value);
          if (valueMatch != null && valueMatch.groupCount >= 1) {
            parsed[key] = valueMatch.group(1);
          } else {
            // Fallback si le pattern ne correspond pas
            parsed[key] = value.replaceAll('"', '');
          }
        }

        // Ajouter au dictionnaire correspondant à la langue
        if (translations.containsKey(lang)) {
          translations[lang]!.addAll(parsed);
        }
      }
    }

    // Créer les fichiers de traduction pour chaque langue
    for (final langEntry in translations.entries) {
      final lang = langEntry.key;
      final translationData = langEntry.value;

      // Créer le répertoire cible si nécessaire
      final l10nDir = Directory(path.join(targetDirPath, 'lib', 'l10n'));
      if (!await l10nDir.exists()) {
        await l10nDir.create(recursive: true);
      }

      // Chemin du fichier de traduction
      final translationFilePath = path.join(l10nDir.path, 'intl_$lang.arb');

      // Lire le fichier existant s'il existe pour fusionner les traductions
      Map<String, dynamic> existingTranslations = {};
      final translationFile = File(translationFilePath);
      if (await translationFile.exists()) {
        try {
          existingTranslations = json.decode(
            await translationFile.readAsString(),
          );
        } catch (e) {
          print(
            '⚠️ Erreur lors de la lecture du fichier de traduction existant: $e',
          );
        }
      }

      // Fusionner les traductions existantes avec les nouvelles
      final mergedTranslations = {...existingTranslations, ...translationData};

      // Écrire le fichier de traduction
      await translationFile.writeAsString(
        const JsonEncoder.withIndent('  ').convert(mergedTranslations),
      );

      print('✅ Fichier de traduction intl_$lang.arb généré avec succès!');
    }
  }

  /// Copie les fichiers templates additionnels avec substitution de variables
  Future<void> copyAdditionalTemplates(
    String sourceDirPath,
    String targetDirPath,
    String projectName,
    Map<String, String Function(String)> templateGenerators, {
    bool isDev = false,
  }) async {
    print('📋 Copie des templates additionnels...');

    final sourceDir = Directory(sourceDirPath);
    final targetDir = Directory(targetDirPath);

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
