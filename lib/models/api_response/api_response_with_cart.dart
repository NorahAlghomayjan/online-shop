
import '../cart.dart';

class ApiResponseWithCart {
  ApiResponseWithCart({
      required this.success,
      required this.errorMessage,
      required this.command,
      required this.data,});

  ApiResponseWithCart.fromJson(dynamic json) {
    success = json['success'];
    errorMessage = json['errorMessage'];
    command = json['command'];
    data = (json['data'] != null ? Cart.fromJson(json['data']) : null)!;
  }
  late bool success;
  late String errorMessage;
  late String command;
  late Cart data;

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