import 'package:online_shop_app/models/cart_item.dart';

class Cart {
  Cart({
      required this.id,
      required this.userId,
      required this.cartItemList,});

  Cart.fromJson(dynamic json) {
    id = json['id'];
    userId = json['userId'];
    if (json['itemList'] != null) {
      cartItemList = [];
      json['itemList'].forEach((v) {
        cartItemList.add(CartItem.fromJson(v));
      });
    }
  }
  late String id;
  late String userId;
  late List<CartItem> cartItemList;

  get total {
    double value = 0;
    for (var item in cartItemList) {
      value += double.parse(item.quantity) * item.product.price;
    }
    return value;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['userId'] = userId;
    if (cartItemList != null) {
      map['itemList'] = cartItemList.map((v) => v.toJson()).toList();
    }
    return map;
  }

}