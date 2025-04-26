import 'package:saasfork_cli/utils/extensions/string_extension.dart';

const userSubscriptionModelTemplate =
    '''import 'package:{{project_name}}/core/models/products/product_details_model.dart';
import 'package:saasfork_core/saasfork_core.dart';

class UserSubscriptionModel implements AbstractModel<UserSubscriptionModel> {
  final String? id;
  final bool isActive;
  final String productId;
  final DateTime currentPeriodEnd;
  final bool cancelAtPeriodEnd;
  final String subscriptionId;
  final String customerId;
  final String userId;
  final ProductDetailsModel? product;

  UserSubscriptionModel({
    this.id,
    required this.isActive,
    required this.productId,
    required this.currentPeriodEnd,
    required this.subscriptionId,
    required this.customerId,
    required this.userId,
    this.product,
    this.cancelAtPeriodEnd = false,
  });

  @override
  UserSubscriptionModel copyWith({
    String? id,
    bool? isActive,
    String? productId,
    DateTime? currentPeriodEnd,
    String? subscriptionId,
    String? userId,
    ProductDetailsModel? product,
    String? customerId,
    bool? cancelAtPeriodEnd,
  }) {
    return UserSubscriptionModel(
      id: id ?? this.id,
      isActive: isActive ?? this.isActive,
      productId: productId ?? this.productId,
      currentPeriodEnd: currentPeriodEnd ?? this.currentPeriodEnd,
      subscriptionId: subscriptionId ?? this.subscriptionId,
      userId: userId ?? this.userId,
      customerId: customerId ?? this.customerId,
      product: product ?? this.product,
      cancelAtPeriodEnd: cancelAtPeriodEnd ?? this.cancelAtPeriodEnd,
    );
  }

  @override
  Map<String, dynamic> toDebugMap() {
    return {...toMap(), 'product': product?.toMap()};
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'is_active': isActive,
      'product_id': productId,
      'current_period_end': currentPeriodEnd.toIso8601String(),
      'subscription_id': subscriptionId,
      'user_id': userId,
      'customer_id': customerId,
      'cancel_at_period_end': cancelAtPeriodEnd,
    };
  }

  factory UserSubscriptionModel.fromMap(
    Map<String, dynamic> data, {
    String? id,
  }) {
    return UserSubscriptionModel(
      id: id,
      isActive: data['is_active'] as bool,
      productId: data['product_id'] as String,
      currentPeriodEnd: DateTime.fromMillisecondsSinceEpoch(
        (data['current_period_end'] as int) * 1000,
      ),
      subscriptionId: data['subscription_id'] as String,
      userId: data['user_id'] as String,
      customerId: data['customer_id'] as String,
      cancelAtPeriodEnd: data['cancel_at_period_end'] as bool? ?? false,
    );
  }
}''';

String generateUserSubscriptionModel(String projectName) {
  // Convertir project_name en snake_case pour les imports
  final projectNameSnakeCase = projectName.toSnakeCase();

  return userSubscriptionModelTemplate.replaceAll(
    '{{project_name}}',
    projectNameSnakeCase,
  );
}
