import 'package:saasfork_cli/utils/extensions/string_extension.dart';

const subscriptionServiceTemplate =
    '''import 'package:{{project_name}}/core/models/user_subscription_model.dart';
import 'package:{{project_name}}/core/repositories/subscription_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final subscriptionServiceProvider = Provider<SubscriptionService>((ref) {
  final subscriptionRepository = SubscriptionRepository();
  return SubscriptionService(subscriptionRepository: subscriptionRepository);
});

class SubscriptionService {
  final SubscriptionRepository subscriptionRepository;

  SubscriptionService({required this.subscriptionRepository});

  Future<UserSubscriptionModel?> getActiveUserSubscription(
    String userId,
  ) async {
    final subscriptions = await subscriptionRepository.query(
      equals: {'user_id': userId, 'is_active': true},
      limit: 1,
    );

    final subscription = subscriptions.isNotEmpty ? subscriptions.first : null;

    if (subscription == null) {
      return null;
    }

    final currentPeriodEnd = subscription.currentPeriodEnd;

    if (currentPeriodEnd.isBefore(DateTime.now())) {
      return null;
    }

    return await subscriptionRepository.findById(
      subscription.id!,
      loadRelations: true,
    );
  }
}''';

String generateSubscriptionService(String projectName) {
  // Convertir project_name en snake_case pour les imports
  final projectNameSnakeCase = projectName.toSnakeCase();

  return subscriptionServiceTemplate.replaceAll(
    '{{project_name}}',
    projectNameSnakeCase,
  );
}
