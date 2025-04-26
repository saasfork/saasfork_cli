import 'package:saasfork_cli/utils/extensions/string_extension.dart';

const checkoutConfirmationPageTemplate =
    '''import 'package:{{project_name}}/constants.dart';
import 'package:{{project_name}}/core/controllers/payment_controller.dart';
import 'package:{{project_name}}/core/extensions/build_context_localizations_extension.dart';
import 'package:{{project_name}}/core/models/payement_state_model.dart';
import 'package:{{project_name}}/ui/layouts/username_layout.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saasfork_core/saasfork_core.dart';
import 'package:saasfork_design_system/saasfork_design_system.dart';
import 'package:signals/signals_flutter.dart';

@RoutePage()
class ConfirmationPage extends ConsumerStatefulWidget {
  static const String path = '/confirmation';
  final String? paymentId;

  const ConfirmationPage({super.key, @QueryParam('payment_id') this.paymentId});

  @override
  ConsumerState<ConfirmationPage> createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends ConsumerState<ConfirmationPage>
    with SignalsMixin {
  late final _paymentState = createSignal<PayementStateModel?>(null);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  void _initializeData() {
    final paymentController = ref.watch(paymentControllerProvider);

    paymentController.listenPaymentState(widget.paymentId!).listen((state) {
      _paymentState.value = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = _paymentState.value;

    return UsernameLayout(
      seoModel: SFSEOModel(title: context.l10n.confirmationPageTitle),
      urlImageBackground:
          'https://cdn.pixabay.com/photo/2020/11/06/07/42/girl-5717067_960_720.jpg',
      title: context.l10n.confirmationPageTitle,
      subtitle: context.l10n.confirmationPageSubtitle,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.md,
        children: [
          SFItemList(
            items: [
              SFItemListData(
                label: context.l10n.confirmationPageStripeSession,
                icon: _doneStatus(state?.checkoutComplete ?? false),
              ),
              SFItemListData(
                label: context.l10n.confirmationPageSubscriptionCreated,
                icon: _doneStatus(state?.subscriptionCreated ?? false),
              ),
              SFItemListData(
                label: context.l10n.confirmationPagePaymentConfirmed,
                icon: _doneStatus(state?.paymentConfirmed ?? false),
              ),
            ],
          ),
          SFMainButton(
            label: context.l10n.confirmationPageDashboardButton,
            onPressed: () => context.router.pushPath(dashboardPath),
          ),
        ],
      ),
    );
  }

  IconData _doneStatus(bool done) =>
      done ? Icons.check_circle : Icons.timelapse;
}''';

String generateCheckoutConfirmationPage(String projectName) {
  // Convertir project_name en snake_case pour les imports
  final projectNameSnakeCase = projectName.toSnakeCase();

  // Convertir project_name en PascalCase pour le nom de la classe
  final projectNamePascalCase = projectName.toPascalCase();

  return checkoutConfirmationPageTemplate
      .replaceAll('{{project_name}}', projectNameSnakeCase)
      .replaceAll('{{ProjectName}}', projectNamePascalCase);
}

Map<String, Function()> generateTranslateCheckoutConfirmationPage() {
  return {
    'fr':
        () => '''"confirmationPageTitle": "Traitement du paiement en cours...",
  "confirmationPageSubtitle": "Merci pour votre patience, nous finalisons votre paiement sécurisé.",
  "confirmationPageStripeSession": "Session Stripe initiée",
  "confirmationPageSubscriptionCreated": "Abonnement créé",
  "confirmationPagePaymentConfirmed": "Paiement confirmé",
  "confirmationPageDashboardButton": "Accéder au tableau de bord",''',
    'en':
        () => '''"confirmationPageTitle": "Processing payment...",
  "confirmationPageSubtitle": "Thank you for your patience, we are finalizing your secure payment.",
  "confirmationPageStripeSession": "Stripe session initiated",
  "confirmationPageSubscriptionCreated": "Subscription created",
  "confirmationPagePaymentConfirmed": "Payment confirmed",
  "confirmationPageDashboardButton": "Access dashboard",''',
  };
}
