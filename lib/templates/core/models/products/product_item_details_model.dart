const productItemDetailsModelTemplate =
    '''import 'package:saasfork_core/saasfork_core.dart';
import 'package:saasfork_design_system/saasfork_design_system.dart';

class ProductItemDetailsModel
    implements AbstractModel<ProductItemDetailsModel> {
  final String? id;
  final int unitAmount;
  final SFCurrency currency;
  final SFPricePeriod period;

  ProductItemDetailsModel({
    required this.unitAmount,
    required this.currency,
    required this.period,
    this.id,
  });

  @override
  ProductItemDetailsModel copyWith({
    String? id,
    int? unitAmount,
    SFCurrency? currency,
    SFPricePeriod? period,
  }) {
    return ProductItemDetailsModel(
      id: id ?? this.id,
      unitAmount: unitAmount ?? this.unitAmount,
      currency: currency ?? this.currency,
      period: period ?? this.period,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'unit_amount': unitAmount,
      'currency': currency.toString(),
      'period': period.toString(),
    };
  }

  @override
  Map<String, dynamic> toDebugMap() {
    return toMap();
  }

  factory ProductItemDetailsModel.fromMap(
    Map<String, dynamic> data, {
    String? id,
  }) {
    return ProductItemDetailsModel(
      id: id,
      unitAmount: data['unit_amount'],
      currency: parseCurrency(data['currency']),
      period: parsePeriod(data['period']),
    );
  }

  static SFCurrency parseCurrency(String value) {
    final String normalizedValue =
        value.contains('.') ? value.split('.').last : value;

    return SFCurrency.values.firstWhere(
      (e) => e.toString().split('.').last == normalizedValue,
      orElse: () => SFCurrency.eur,
    );
  }

  static SFPricePeriod parsePeriod(String value) {
    final String normalizedValue =
        value.contains('.') ? value.split('.').last : value;

    return SFPricePeriod.values.firstWhere(
      (e) => e.toString().split('.').last == normalizedValue,
      orElse: () => SFPricePeriod.month,
    );
  }
}''';

String generateProductItemDetailsModel(String projectName) {
  // Pas besoin de remplacer les imports car ce modèle n'utilise que des packages externes
  return productItemDetailsModelTemplate;
}
