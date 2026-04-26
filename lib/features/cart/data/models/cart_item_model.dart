import '../../domain/entities/cart_item.dart';

class CartItemModel extends CartItem {
  CartItemModel({
    required super.productKey,
    required super.name,
    required super.imageUrl,
    required super.size,
    required super.price,
    required super.quantity,
  });

  factory CartItemModel.fromMap(String key, Map<String, dynamic> map) {
    return CartItemModel(
      productKey: key,
      name: map['name'] ?? '',
      imageUrl: map['mainImageUrl'] ?? '',
      size: map['size'] ?? '',
      price: map['price'] ?? '',
      quantity: map['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'mainImageUrl': imageUrl,
      'size': size,
      'price': price,
      'quantity': quantity,
    };
  }
}