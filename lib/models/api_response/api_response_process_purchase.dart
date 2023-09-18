import 'package:online_shop_app/models/purchase_invoice.dart';

class ApiProcessPurchase {
  ApiProcessPurchase({
      required this.success,
      required this.errorMessage,
      required this.command,
      required this.data,});

  ApiProcessPurchase.fromJson(dynamic json) {
    success = json['success'];
    errorMessage = json['errorMessage'];
    command = json['command'];
    data = (json['data'] != null ? PurchaseInvoice.fromJson(json['data']) : null)!;
  }
  late bool success;
  late String errorMessage;
  late String command;
  late PurchaseInvoice data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['errorMessage'] = errorMessage;
    map['command'] = command;
    if (data != null) {
      map['data'] = data.toJson();
    }
    return map;
  }

}