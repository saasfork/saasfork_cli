import 'package:saasfork_cli/utils/extensions/string_extension.dart';

const paymentRepositoryTemplate =
    '''import 'package:{{project_name}}/core/models/payement_state_model.dart';
import 'package:saasfork_firebase_service/saasfork_firebase_service.dart';

class PaymentRepository extends FirestoreRepository<PayementStateModel> {
  PaymentRepository() : super(collectionName: 'payment_states');

  @override
  PayementStateModel assignId(PayementStateModel entity, String id) {
    return entity.copyWith(id: id);
  }

  @override
  PayementStateModel fromDocument(FirestoreDocument document) {
    return PayementStateModel.fromMap(document.data, id: document.id);
  }

  @override
  String? getId(PayementStateModel entity) {
    return entity.id;
  }

  @override
  Map<String, dynamic> toMap(PayementStateModel entity) {
    return entity.toMap();
  }

  /// Trouver les paiements par ID utilisateur
  Future<List<PayementStateModel>> findByUserId(String userId) async {
    return await query(equals: {'userId': userId});
  }

  /// Trouver un paiement spécifique
  Future<PayementStateModel?> findUserPayementById(
    String paymentId,
    String userId,
  ) async {
    final payments = await query(
      equals: {'paymentId': paymentId, 'userId': userId},
    );
    return payments.isNotEmpty ? payments.first : null;
  }

  /// Trouver les paiements ayant un statut spécifique
  Future<List<PayementStateModel>> findByStatus(PaymentStatus status) async {
    return await query(equals: {'status': status.toString()});
  }

  Future<bool> deletePayment(String paymentId, String userId) async {
    final payment = await findUserPayementById(paymentId, userId);

    if (payment == null) {
      return false;
    }

    return await delete(payment);
  }
}''';

String generatePaymentRepository(String projectName) {
  // Convertir project_name en snake_case pour les imports
  final projectNameSnakeCase = projectName.toSnakeCase();

  return paymentRepositoryTemplate.replaceAll(
    '{{project_name}}',
    projectNameSnakeCase,
  );
}
