import 'package:saasfork_cli/utils/extensions/string_extension.dart';

const checkoutCancelledPageTemplate =
    '''import 'package:{{project_name}}/core/controllers/payment_controller.dart';
import 'package:{{project_name}}/core/extensions/build_context_localizations_extension.dart';
import 'package:{{project_name}}/ui/layouts/username_layout.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saasfork_core/saasfork_core.dart';
import 'package:saasfork_design_system/saasfork_design_system.dart';

@RoutePage()
class CancelledPage extends ConsumerStatefulWidget {
  static const String path = '/cancelled';
  final String? paymentId;

  const CancelledPage({super.key, @QueryParam('payment_id') this.paymentId});

  @override
  ConsumerState<CancelledPage> createState() => _CancelledPageState();
}

class _CancelledPageState extends ConsumerState<CancelledPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  Future<void> _initializeData() async {
    if (widget.paymentId != null) {
      try {
        final paymentController = ref.read(paymentControllerProvider);
        await paymentController.deletePayment(widget.paymentId!);
      } catch (e) {
        error("Error deleting payment: \$e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return UsernameLayout(
      seoModel: SFSEOModel(title: context.l10n.cancelledPageTitle),
      urlImageBackground:
          'https://cdn.pixabay.com/photo/2020/11/06/07/42/girl-5717067_960_720.jpg',
      title: context.l10n.cancelledPageTitle,
      subtitle: context.l10n.cancelledPageSubtitle,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SFMainButton(
            label: context.l10n.cancelledPageButton,
            onPressed: () => context.router.pushPath(DashboardPage.path),
          ),
        ],
      ),
    );
  }
}''';

String generateCheckoutCancelledPage(String projectName) {
  // Convertir project_name en snake_case pour les imports
  final projectNameSnakeCase = projectName.toSnakeCase();

  // Convertir project_name en PascalCase pour le nom de la classe
  final projectNamePascalCase = projectName.toPascalCase();

  return checkoutCancelledPageTemplate
      .replaceAll('{{project_name}}', projectNameSnakeCase)
      .replaceAll('{{ProjectName}}', projectNamePascalCase);
}

Map<String, Function()> generateTranslateCheckoutCancelledPage() {
  return {
    'fr':
        () => '''"cancelledPageTitle": "Paiement annulé",
  "cancelledPageSubtitle": "Votre transaction a été annulée. Aucun montant n'a été débité de votre compte.",
  "cancelledPageButton": "Retourner à mon espace personnel",''',
    'en':
        () => '''"cancelledPageTitle": "Payment cancelled",
  "cancelledPageSubtitle": "Your transaction has been cancelled. No amount has been charged to your account.",
  "cancelledPageButton": "Return to my personal space",''',
  };
}
