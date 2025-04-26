import 'package:saasfork_cli/utils/extensions/string_extension.dart';

const paymentControllerTemplate =
    '''import 'package:{{project_name}}/core/controllers/user_subscription_controller.dart';
import 'package:{{project_name}}/core/models/payement_state_model.dart';
import 'package:{{project_name}}/core/models/products/product_details_model.dart';
import 'package:{{project_name}}/core/repositories/payment_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saasfork_core/saasfork_core.dart';
import 'package:saasfork_firebase_service/saasfork_firebase_service.dart';
import 'package:uuid/uuid.dart';

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepository();
});

final paymentControllerProvider = Provider<PaymentController>((ref) {
  final currentUser = ref.watch(currentUserProvider);
  final paymentRepository = ref.watch(paymentRepositoryProvider);
  final userSubscriptionController = ref.watch(
    userSubscriptionControllerProvider.notifier,
  );

  if (currentUser == null) {
    throw Exception("User is not logged in");
  }

  return PaymentController(
    currentUser: currentUser,
    paymentRepository: paymentRepository,
    userSubscriptionController: userSubscriptionController,
  );
});

class PaymentController {
  final UserModel currentUser;
  final PaymentRepository paymentRepository;
  final UserSubscriptionController userSubscriptionController;

  PaymentController({
    required this.currentUser,
    required this.paymentRepository,
    required this.userSubscriptionController,
  });

  Future<String> getPaymentLink(
    ProductDetailsModel productDetails,
    int indexItem,
  ) async {
    // Générer un UUID pour le paiement
    final paymentId = const Uuid().v4();

    // Créer un nouveau modèle de paiement
    final paymentState = PayementStateModel(
      id: paymentId,
      userId: currentUser.uid!,
      paymentId: paymentId,
      status: PaymentStatus.initiated,
      productId: productDetails.id,
    );

    // Sauvegarder le paiement en utilisant le repository
    await paymentRepository.save(paymentState);

    // Créer le lien de paiement Stripe
    final paymentLink = await StripeFunctions.createStripePaymentLink({
      ...productDetails.toMap(),
      ...productDetails.items[indexItem].toMap(),
      'email': currentUser.email,
      'payment_id': paymentId,
    });

    return paymentLink;
  }

  Future<String> getPortalLink() async {
    final activeSubscription = userSubscriptionController.getActiveSubscription;

    if (activeSubscription == null) {
      throw Exception("No active subscription found");
    }

    final portalLink = await StripeFunctions.createStripePortalLink(
      customerId: activeSubscription.customerId,
    );

    return portalLink;
  }

  Stream<PayementStateModel?> listenPaymentState(String paymentId) {
    return paymentRepository.listenDocument(paymentId);
  }

  Future<void> deletePayment(String paymentId) async {
    try {
      final result = await paymentRepository.deletePayment(
        paymentId,
        currentUser.uid!,
      );

      if (!result) {
        warn("Payment deletion failed for paymentId: \$paymentId");
      }
    } catch (e) {
      error(e.toString());
      throw Exception("Failed to delete payment: \$e");
    }
  }
}''';

String generatePaymentController(String projectName) {
  // Convertir project_name en snake_case pour les imports
  final projectNameSnakeCase = projectName.toSnakeCase();

  return paymentControllerTemplate.replaceAll(
    '{{project_name}}',
    projectNameSnakeCase,
  );
}
