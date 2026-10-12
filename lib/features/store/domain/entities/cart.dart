import 'package:equatable/equatable.dart';

class Cart extends Equatable {
  final List<CartItem> items;
  final CartAddress? deliveryAddress;
  final double subtotal;
  final double discount;
  final double deliveryCharge;
  final double couponDiscount;
  final double total;

  const Cart({
    this.items = const [],
    this.deliveryAddress,
    this.subtotal = 0,
    this.discount = 0,
    this.deliveryCharge = 0,
    this.couponDiscount = 0,
    this.total = 0,
  });
  Cart copyWith({
    List<CartItem>? items,
    CartAddress? deliveryAddress,
    double? subtotal,
    double? discount,
    double? deliveryCharge,
    double? couponDiscount,
    double? total,
  }) {
    return Cart(
      items: items ?? this.items,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      subtotal: subtotal ?? this.subtotal,
      discount: discount ?? this.discount,
      deliveryCharge: deliveryCharge ?? this.deliveryCharge,
      couponDiscount: couponDiscount ?? this.couponDiscount,
      total: total ?? this.total,
    );
  }
  @override
  List<Object?> get props => [
    items,
    deliveryAddress,
    subtotal,
    discount,
    deliveryCharge,
    couponDiscount,
    total,
  ];
}

class CartItem extends Equatable {
  final String id;
  final String productId;
  final String name;
  final String image;
  final double price;
  final double? originalPrice;
  final int quantity;

  const CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.image,
    required this.price,
    this.originalPrice,
    required this.quantity,
  });

  double get itemTotal => price * quantity;

  @override
  List<Object?> get props => [
    id,
    productId,
    name,
    image,
    price,
    originalPrice,
    quantity,
  ];
}

class CartAddress extends Equatable {
  final String id;
  final String name;
  final String phone;
  final String address;
  final String city;
  final String state;
  final String pincode;

  const CartAddress({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
  });

  @override
  List<Object?> get props => [id, name, phone, address, city, state, pincode];
}
