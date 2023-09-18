import 'package:online_shop_app/models/cart_item.dart';

import '../purchase_invoice.dart';

class ApiResponseGetPurchases {
  ApiResponseGetPurchases({
      required this.success,
      required this.errorMessage,
      required this.command,
      required this.data,});

  ApiResponseGetPurchases.fromJson(dynamic json) {
    success = json['success'];
    errorMessage = json['errorMessage'];
    command = json['command'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(PurchaseInvoice.fromJson(v));
      });
    }
  }
  late bool success;
  late String errorMessage;
  late String command;
  late List<PurchaseInvoice> data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['errorMessage'] = errorMessage;
    map['command'] = command;
    if (data != null) {
      map['data'] = data.map((v) => v.toJson()).toList();
    }
    return map;
  }

}