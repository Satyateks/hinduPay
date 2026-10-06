import 'package:equatable/equatable.dart';

class HomeData extends Equatable {
  final List<dynamic> banners;
  final List<dynamic> poojas;
  final List<dynamic> temples;
  final List<dynamic> products;
  final List<dynamic> services;

  const HomeData({
    this.banners = const [],
    this.poojas = const [],
    this.temples = const [],
    this.products = const [],
    this.services = const [],
  });

  @override
  List<Object?> get props => [banners, poojas, temples, products, services];
}
