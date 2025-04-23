import 'package:args/args.dart';
import 'package:saasfork_cli/saasfork_cli.dart';

Future<void> main(List<String> arguments) async {
  final parser = ArgParser()..addFlag('help', abbr: 'h', negatable: false);

  parser
      .addCommand('create')
      .addFlag('dev', abbr: 'd', negatable: false, help: 'Mode développement');

  final result = parser.parse(arguments);
  final command = result.command;

  if (result['help'] == true || result.command == null) {
    print('Commandes disponibles : create');
    print('Utilise --help pour l’aide');
    return;
  }

  switch (command!.name) {
    case 'create':
      final name =
          command.arguments.isNotEmpty ? command.arguments.first : 'mon_app';
      final isDev = command['dev'] as bool;
      await runCreateCommand(name, isDev: isDev);
      break;
    default:
      print('Commande inconnue.');
  }
}
