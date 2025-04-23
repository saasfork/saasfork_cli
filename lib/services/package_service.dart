import 'dart:io';

/// Service responsable de l'installation des packages dans un projet Flutter
class PackageService {
  /// Installe un package Flutter dans le projet spécifié
  Future<bool> installPackage(
    String packageName, {
    required String projectPath,
    bool isDev = false,
  }) async {
    print(
      '📦 Installation du package${isDev ? ' de développement' : ''}: $packageName',
    );

    final result = await Process.run('flutter', [
      'pub',
      'add',
      if (isDev) '-d',
      packageName,
    ], workingDirectory: projectPath);

    if (result.exitCode == 0) {
      print(
        '✅ Package${isDev ? ' de développement' : ''} "$packageName" installé avec succès !',
      );
      return true;
    } else {
      print('❌ Erreur lors de l\'installation de "$packageName":');
      print(result.stderr);
      return false;
    }
  }

  /// Installe une liste de packages Flutter dans le projet spécifié
  Future<void> installPackages(
    List<String> packages, {
    required String projectPath,
    bool isDev = false,
  }) async {
    for (final package in packages) {
      await installPackage(package, projectPath: projectPath, isDev: isDev);
    }
  }

  /// Exécute build_runner pour générer le code
  Future<bool> runBuildRunner(String projectPath) async {
    print('🔨 Exécution de build_runner...');
    final buildResult = await Process.run('flutter', [
      'pub',
      'run',
      'build_runner',
      'build',
      '--delete-conflicting-outputs',
    ], workingDirectory: projectPath);

    if (buildResult.exitCode == 0) {
      print('✅ Code généré avec succès par build_runner!');
      return true;
    } else {
      print('⚠️ Attention lors de l\'exécution de build_runner:');
      print(buildResult.stderr);
      return false;
    }
  }

  /// Génère les fichiers de localisation
  Future<bool> generateLocalizations(String projectPath) async {
    print('🌐 Génération des fichiers de localisation...');
    final genL10nResult = await Process.run('flutter', [
      'gen-l10n',
    ], workingDirectory: projectPath);

    if (genL10nResult.exitCode == 0) {
      print('✅ Fichiers de localisation générés avec succès!');
      return true;
    } else {
      print('⚠️ Attention lors de la génération des fichiers de localisation:');
      print(genL10nResult.stderr);
      return false;
    }
  }
}
