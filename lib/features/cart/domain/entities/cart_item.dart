class CartItem {
  final String productKey;
  final String name;
  final String imageUrl;
  final String size;
  final String price;
  final int quantity;

  CartItem({
    required this.productKey,
    required this.name,
    required this.imageUrl,
    required this.size,
    required this.price,
    required this.quantity,
  });

  String get cleanProductKey {
    final idx = productKey.indexOf('_');
    return idx != -1 ? productKey.substring(0, idx) : productKey;
  }
}