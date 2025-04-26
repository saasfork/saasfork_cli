const payementStateModelTemplate =
    '''import 'package:saasfork_core/saasfork_core.dart';

enum PaymentStatus {
  initiated,
  sessionComplete,
  subscriptionCreated,
  paymentConfirmed,
  failed,
}

class PayementStateModel implements AbstractModel<PayementStateModel> {
  final String? id;
  final String userId;
  final String paymentId;
  final PaymentStatus status;
  final bool checkoutComplete;
  final bool subscriptionCreated;
  final bool paymentConfirmed;
  final String productId;

  PayementStateModel({
    this.id,
    required this.userId,
    required this.paymentId,
    this.status = PaymentStatus.initiated,
    this.checkoutComplete = false,
    this.subscriptionCreated = false,
    this.paymentConfirmed = false,
    required this.productId,
  });

  @override
  factory PayementStateModel.fromMap(Map<String, dynamic> data, {String? id}) {
    return PayementStateModel(
      id: id ?? data['uid'],
      userId: data['userId'] ?? '',
      paymentId: data['paymentId'] ?? '',
      status: _parseStatus(data['status']),
      checkoutComplete: data['checkoutComplete'] ?? false,
      subscriptionCreated: data['subscriptionCreated'] ?? false,
      paymentConfirmed: data['paymentConfirmed'] ?? false,
      productId: data['productId'] ?? '',
    );
  }

  static PaymentStatus _parseStatus(String? statusStr) {
    if (statusStr == null) return PaymentStatus.initiated;

    try {
      return PaymentStatus.values.firstWhere(
        (e) => e.toString() == statusStr,
        orElse: () => PaymentStatus.initiated,
      );
    } catch (_) {
      return PaymentStatus.initiated;
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'uid': id,
      'userId': userId,
      'paymentId': paymentId,
      'status': status.toString(),
      'checkoutComplete': checkoutComplete,
      'subscriptionCreated': subscriptionCreated,
      'paymentConfirmed': paymentConfirmed,
      'productId': productId,
    };
  }

  @override
  PayementStateModel copyWith({
    String? id,
    String? userId,
    String? paymentId,
    PaymentStatus? status,
    bool? checkoutComplete,
    bool? subscriptionCreated,
    bool? paymentConfirmed,
    String? productId,
  }) {
    return PayementStateModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      paymentId: paymentId ?? this.paymentId,
      status: status ?? this.status,
      checkoutComplete: checkoutComplete ?? this.checkoutComplete,
      subscriptionCreated: subscriptionCreated ?? this.subscriptionCreated,
      paymentConfirmed: paymentConfirmed ?? this.paymentConfirmed,
      productId: productId ?? this.productId,
    );
  }

  @override
  Map<String, dynamic> toDebugMap() {
    return toMap();
  }

  bool processedComplete() {
    return paymentConfirmed && checkoutComplete && subscriptionCreated;
  }
}''';

String generatePayementStateModel(String projectName) {
  // Comme ce fichier n'a pas d'imports spécifiques à l'application qui nécessitent des remplacements,
  // la fonction retourne simplement le template sans modification
  return payementStateModelTemplate;
}
