import 'package:saasfork_cli/utils/extensions/string_extension.dart';

const checkoutPricePageTemplate =
    '''import 'package:{{project_name}}/core/controllers/payment_controller.dart';
import 'package:{{project_name}}/core/controllers/products_controller.dart';
import 'package:{{project_name}}/core/controllers/user_subscription_controller.dart';
import 'package:{{project_name}}/core/extensions/app_localizations_extension.dart';
import 'package:{{project_name}}/core/extensions/build_context_localizations_extension.dart';
import 'package:{{project_name}}/core/models/products/product_details_model.dart';
import 'package:{{project_name}}/core/models/products/product_item_details_model.dart';
import 'package:{{project_name}}/ui/layouts/username_layout.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saasfork_core/saasfork_core.dart';
import 'package:saasfork_design_system/atoms/inputs/radio_field.dart';
import 'package:saasfork_design_system/saasfork_design_system.dart';
import 'package:signals/signals_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class PricePage extends ConsumerStatefulWidget {
  static const String path = '/price';

  const PricePage({super.key});

  @override
  ConsumerState<PricePage> createState() => _PricePageState();
}

class _PricePageState extends ConsumerState<PricePage> with SignalsMixin {
  late final product = createSignal<ProductDetailsModel?>(null);
  late final loadingStripeLink = createSignal<bool>(false);
  late final period = createSignal(SFPricePeriod.month);
  late final itemSelected = createSignal<ProductItemDetailsModel?>(null);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  Future<void> _initializeData() async {
    final productsController = ref.watch(productsControllerProvider);
    product.value = await productsController.getDefaultProduct();
    itemSelected.value = product.value?.items.first;
  }

  @override
  Widget build(BuildContext context) {
    final paymentController = ref.watch(paymentControllerProvider);
    final userSubscriptionController = ref.watch(
      userSubscriptionControllerProvider,
    );

    final hasActiveSubscription =
        userSubscriptionController.hasActiveSubscription;

    final isLoading = product.value == null;

    return UsernameLayout(
      seoModel: SFSEOModel(title: context.l10n.pricePageTitle),
      urlImageBackground:
          'https://cdn.pixabay.com/photo/2020/11/06/07/42/girl-5717067_960_720.jpg',
      content: Column(
        spacing: AppSpacing.xl,
        children: [
          Skeletonizer(
            enabled: isLoading,
            child: Column(
              spacing: AppSpacing.md,
              children: [
                Column(
                  children: [
                    Text(
                      context.l10n.pricePageHeading,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      context.l10n.pricePageSubHeading,
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        fontSize: 32,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                Text(
                  context.l10n.pricePageDescription,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Skeletonizer(
            enabled: isLoading,
            child:
                product.value == null
                    ? SFRadioFieldSkeleton(options: 2, size: ComponentSize.xs)
                    : SFRadioField<ProductItemDetailsModel>(
                      size: ComponentSize.xs,
                      options: product.value!.items,
                      groupValue: itemSelected.value!,
                      onChanged: (value) => itemSelected.value = value,
                      labelBuilder:
                          (option) =>
                              context.l10n
                                  .getString(option.period.label)!
                                  .capitalize(),
                    ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400),
            child: Skeletonizer(
              enabled: isLoading,
              child:
                  product.value == null
                      ? SFPriceCardSkeleton(
                        featuresCount: 4,
                        hasDiscountBadge: true,
                      )
                      : SFPriceCard(
                        title:
                            context.l10n.getString(product.value!.productName)!,
                        description: context.l10n.getString(
                          product.value!.description,
                        ),
                        itemPrice: SFPriceCardModel(
                          unitAmount: itemSelected.value!.unitAmount,
                          currency: itemSelected.value!.currency,
                          pricePeriod: itemSelected.value!.period,
                        ),
                        features: [
                          ...product.value!.features.map(
                            (feature) => context.l10n.getString(feature.name)!,
                          ),
                        ],
                        comparePrice:
                            itemSelected.value!.period == SFPricePeriod.year
                                ? SFPriceCardModel(
                                  unitAmount:
                                      product.value!.items
                                          .firstWhere(
                                            (item) =>
                                                item.period ==
                                                SFPricePeriod.month,
                                          )
                                          .unitAmount,
                                  currency: itemSelected.value!.currency,
                                  pricePeriod: SFPricePeriod.month,
                                )
                                : null,
                        savingsLabel:
                            itemSelected.value!.period == SFPricePeriod.year
                                ? (value) =>
                                    context.l10n.priceSavingsLabel(value!)
                                : null,
                        periodLabel: (period) {
                          return context.l10n
                              .getString(period!.label)!
                              .capitalize();
                        },
                        onPressed:
                            !hasActiveSubscription
                                ? () async {
                                  loadingStripeLink.value = true;
                                  try {
                                    final paymentLink = await paymentController
                                        .getPaymentLink(product.value!, 0);

                                    final url = Uri.parse(paymentLink);

                                    if (!await launchUrl(
                                          url,
                                          webOnlyWindowName: '_self',
                                        ) &&
                                        context.mounted) {
                                      context.showErrorMessage(
                                        message:
                                            context
                                                .l10n
                                                .pricePageLaunchUrlError,
                                        title: context.l10n.pricePageErrorTitle,
                                      );
                                    }
                                  } catch (e) {
                                    error(e.toString());
                                  }

                                  loadingStripeLink.value = false;
                                }
                                : null,
                        buttonLabel: context.l10n.pricePageContinueButton,
                      ),
            ),
          ),
        ],
      ),
    );
  }
}

class EmptyWidget extends StatelessWidget {
  final String title;

  const EmptyWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.payments_outlined,
            size: 48,
            color: Theme.of(context).colorScheme.primary.withAlpha(170),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}''';

String generateCheckoutPricePage(String projectName) {
  // Convertir project_name en snake_case pour les imports
  final projectNameSnakeCase = projectName.toSnakeCase();

  // Convertir project_name en PascalCase pour le nom de la classe
  final projectNamePascalCase = projectName.toPascalCase();

  return checkoutPricePageTemplate
      .replaceAll('{{project_name}}', projectNameSnakeCase)
      .replaceAll('{{ProjectName}}', projectNamePascalCase);
}

Map<String, Function()> generateTranslateCheckoutPricePage() {
  return {
    'fr':
        () => '''"pricePageTitle": "Tarification",
  "pricePageHeading": "Tarification",
  "pricePageSubHeading": "Tout ce qu'il faut pour te lancer",
  "pricePageDescription": "Accède à toutes les fonctionnalités essentielles pour construire ta page et attirer ton audience, sans te prendre la tête",
  "pricePageContinueButton": "Continuer",
  "pricePageSkipButton": "Passer",
  "pricePageLaunchUrlError": "Impossible d'ouvrir le lien de paiement",
  "pricePageErrorTitle": "Erreur",
  "pricePageAlreadySubscribed": "Vous avez déjà un abonnement actif",
  "priceSavingsLabel": "Économisez {value}%",
  "pricePagePricesSoonMessage": "Les prix arrivent bientôt..."''',
    'en':
        () => '''"pricePageTitle": "Pricing",
  "pricePageHeading": "Pricing",
  "pricePageSubHeading": "Everything you need to get started",
  "pricePageDescription": "Access all essential features to build your page and attract your audience, hassle-free",
  "pricePageContinueButton": "Continue",
  "pricePageSkipButton": "Skip",
  "pricePageLaunchUrlError": "Unable to open the payment link",
  "pricePageErrorTitle": "Error",
  "pricePageAlreadySubscribed": "You already have an active subscription",
  "priceSavingsLabel": "Save {value}%",
  "pricePagePricesSoonMessage": "Prices coming soon..."''',
  };
}
