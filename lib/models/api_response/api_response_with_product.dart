import '../product.dart';

class ApiResponseWithProduct {
  ApiResponseWithProduct({
      required this.success,
    required this.errorMessage,
    required this.command,
    required this.data,});

  ApiResponseWithProduct.fromJson(dynamic json) {
    success = json['success'];
    errorMessage = json['errorMessage'];
    command = json['command'];
    data = (json['data'] != null ? Product.fromJson(json['data']) : null)!;
  }
  late bool success;
  late String errorMessage;
  late String command;
  late Product data;

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