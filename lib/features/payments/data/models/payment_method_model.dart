import '../../domain/entities/payment_method.dart';

class PaymentMethodModel {
  final PaymentMethod method;
  final String title;
  final String subtitle;
  final String icon;

  const PaymentMethodModel({
    required this.method,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}
