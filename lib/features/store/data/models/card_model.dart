import '../../domain/entities/cart.dart';

class CartModel extends Cart {
  const CartModel({
    required super.items,
    super.deliveryAddress,
    required super.subtotal,
    required super.discount,
    required super.deliveryCharge,
    required super.couponDiscount,
    required super.total,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      items: (json['items'] as List<dynamic>? ?? [])
          .map((item) => CartItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      deliveryAddress: json['delivery_address'] != null
          ? CartAddressModel.fromJson(
              json['delivery_address'] as Map<String, dynamic>,
            )
          : null,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0,
      deliveryCharge: (json['delivery_charge'] as num?)?.toDouble() ?? 0,
      couponDiscount: (json['coupon_discount'] as num?)?.toDouble() ?? 0,
      total: (json['total'] as num?)?.toDouble() ?? 0,
    );
  }
}

class CartItemModel extends CartItem {
  const CartItemModel({
    required super.id,
    required super.productId,
    required super.name,
    required super.image,
    required super.price,
    super.originalPrice,
    required super.quantity,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id']?.toString() ?? '',
      productId: json['product_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      originalPrice: (json['original_price'] as num?)?.toDouble(),
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
    );
  }
}

class CartAddressModel extends CartAddress {
  const CartAddressModel({
    required super.id,
    required super.name,
    required super.phone,
    required super.address,
    required super.city,
    required super.state,
    required super.pincode,
  });

  factory CartAddressModel.fromJson(Map<String, dynamic> json) {
    return CartAddressModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      pincode: json['pincode']?.toString() ?? '',
    );
  }
}
