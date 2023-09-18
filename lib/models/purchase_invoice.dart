import 'package:online_shop_app/models/cart_item.dart';

import 'date.dart';

class PurchaseInvoice {
  PurchaseInvoice({
    required this.id,
    required this.userId,
    required this.cartItemList,
    required this.totalAmount,
    required this.date,});

  PurchaseInvoice.fromJson(dynamic json) {
    id = json['id'];
    userId = json['userId'];
    if (json['cartItemList'] != null) {
      cartItemList = [];
      json['cartItemList'].forEach((v) {
        cartItemList.add(CartItem.fromJson(v));
      });
    }
    totalAmount = json['totalAmount'];
    date = (json['date'] != null ? Date.fromJson(json['date']) : null)!;
  }
  late String id;
  late String userId;
  late List<CartItem> cartItemList;
  late double totalAmount;
  late Date date;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['userId'] = userId;
    if (cartItemList != null) {
      map['cartItemList'] = cartItemList.map((v) => v.toJson()).toList();
    }
    map['totalAmount'] = totalAmount;
    if (date != null) {
      map['date'] = date.toJson();
    }
    return map;
  }

}