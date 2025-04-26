import 'package:saasfork_cli/utils/extensions/string_extension.dart';

const userSubscriptionControllerTemplate =
    '''import 'package:{{project_name}}/core/controllers/profile_controller.dart';
import 'package:{{project_name}}/core/models/user_subscription_model.dart';
import 'package:{{project_name}}/core/services/subscription_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saasfork_firebase_service/saasfork_firebase_service.dart';

class SubscriptionState {
  final bool isLoading;
  final UserSubscriptionModel? subscription;
  final String? error;

  const SubscriptionState({
    this.isLoading = false,
    this.subscription,
    this.error,
  });

  bool get hasActiveSubscription =>
      subscription != null &&
      subscription!.currentPeriodEnd.isAfter(DateTime.now());

  bool get hasCancelAtPeriodEnd => subscription?.cancelAtPeriodEnd ?? false;

  DateTime? get currentPeriodEnd => subscription?.currentPeriodEnd;
}

final userSubscriptionControllerProvider =
    StateNotifierProvider<UserSubscriptionController, SubscriptionState>((ref) {
      final subscriptionService = ref.read(subscriptionServiceProvider);
      final authState = ref.read(authProvider);

      return UserSubscriptionController(
        subscriptionService: subscriptionService,
        authState: authState,
      );
    });

/// Extension sur WidgetRef pour faciliter l'utilisation de canUse
extension CanUseFeatureExtension on WidgetRef {
  bool canUse(String featureId) {
    final userSubscriptionController = read(
      userSubscriptionControllerProvider.notifier,
    );
    return userSubscriptionController.canUse(featureId);
  }
}

class UserSubscriptionController extends StateNotifier<SubscriptionState> {
  final SubscriptionService subscriptionService;
  final AuthStateModel authState;

  UserSubscriptionController({
    required this.subscriptionService,
    required this.authState,
  }) : super(const SubscriptionState(isLoading: true)) {
    loadSubscription();
  }

  bool get hasActiveSubscription => state.hasActiveSubscription;

  bool get hasCancelAtPeriodEnd =>
      state.subscription?.cancelAtPeriodEnd ?? false;

  UserSubscriptionModel? get getActiveSubscription => state.subscription;

  Future<void> loadSubscription() async {
    try {
      state = SubscriptionState(isLoading: true);

      final String? userId = authState.user?.uid;

      if (userId == null) {
        state = const SubscriptionState();
        return;
      }

      final subscription = await subscriptionService.getActiveUserSubscription(
        userId,
      );

      state = SubscriptionState(subscription: subscription);
    } catch (e) {
      state = SubscriptionState(error: e.toString());
    }
  }

  bool canUse(String featureId) {
    if (!hasActiveSubscription) {
      return false;
    }

    return state.subscription!.product!.features.firstWhereOrNull(
          (feature) => feature.id == featureId,
        ) !=
        null;
  }
}

// Extension pour firstWhereOrNull (intégration depuis le blocks_controller)
extension IterableExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}''';

String generateUserSubscriptionController(String projectName) {
  // Convertir project_name en snake_case pour les imports
  final projectNameSnakeCase = projectName.toSnakeCase();

  return userSubscriptionControllerTemplate.replaceAll(
    '{{project_name}}',
    projectNameSnakeCase,
  );
}
