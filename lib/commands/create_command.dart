import 'package:saasfork_cli/utils/extensions/string_extension.dart';

import '../constants/packages.dart';
import '../constants/templates.dart';
import '../services/package_service.dart';
import '../services/project_service.dart';
import '../services/template_service.dart';

/// Exécute la commande de création d'un nouveau projet Flutter
Future<void> runCreateCommand(
  String projectName, {
  String? sourceFolderPath,
  bool isDev = false,
}) async {
  // Instancier les services nécessaires
  final packageService = PackageService();
  final templateService = TemplateService();
  final projectService = ProjectService();

  // Assurer que le nom du projet est en snake_case
  final projectNameSnakeCase = projectName.toSnakeCase();
  final projectNamePascal = projectNameSnakeCase.toPascalCase();

  // Afficher le mode de création
  print(
    '🚀 Création du projet $projectNameSnakeCase ${isDev ? "en mode développement" : ""}',
  );

  try {
    // Créer le projet Flutter
    final projectCreated = await projectService.createFlutterProject(
      projectNameSnakeCase,
    );
    if (!projectCreated) return;

    // Obtenir le chemin du projet
    final projectPath = projectService.getProjectPath(projectNameSnakeCase);
    final targetLibDir = projectService.getLibDirectory(projectPath);

    // Installer les packages standard
    await packageService.installPackages(
      defaultPackages,
      projectPath: projectPath,
    );

    // Installer les packages de développement
    await packageService.installPackages(
      devPackages,
      projectPath: projectPath,
      isDev: true,
    );

    if (isDev) {
      await projectService.updatePubspecWithLocalPackages(projectPath);
    }

    // Générer tous les fichiers de template
    await templateService.generateAllTemplates(
      targetLibDir,
      templateGenerators,
      projectNamePascal,
      isDev: isDev,
    );

    // Copier les autres templates
    final templateDir = await projectService.findTemplateDirectory();
    if (templateDir != null) {
      await templateService.copyAdditionalTemplates(
        templateDir,
        targetLibDir,
        projectNamePascal,
        templateGenerators,
        isDev: isDev,
      );
    }

    // Exécuter build_runner
    await packageService.runBuildRunner(projectPath);

    // Message de fin
    print('✅ Projet créé avec succès ${isDev ? "en mode développement" : ""}');
  } catch (e) {
    print('❌ Erreur lors de la création du projet:');
    print(e);
  }
}
