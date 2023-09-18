import 'product.dart';

class CartItem {
  CartItem({
      required this.product,
      required this.quantity,});

  CartItem.fromJson(dynamic json) {
    product = (json['product'] != null ? Product.fromJson(json['product']) : null)!;
    quantity = json['quantity'];
  }
  late Product product;
  late String quantity;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (product != null) {
      map['product'] = product.toJson();
    }
    map['quantity'] = quantity;
    return map;
  }

}