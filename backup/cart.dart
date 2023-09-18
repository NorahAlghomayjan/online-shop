import 'package:online_shop_app/models/cart_item.dart';

class Cart {
  Cart({
      required this.id,
      required this.userId,
      required this.itemList,});

  Cart.fromJson(dynamic json) {
    id = json['id'];
    userId = json['userId'];
    if (json['itemList'] != null) {
      itemList = [];
      json['itemList'].forEach((v) {
        itemList.add(CartItem.fromJson(v));
      });
    }
  }
  late String id;
  late String userId;
  late List<dynamic> itemList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['userId'] = userId;
    if (itemList != null) {
      map['itemList'] = itemList.map((v) => v.toJson()).toList();
    }
    return map;
  }

}