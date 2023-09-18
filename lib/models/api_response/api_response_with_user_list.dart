import '../user.dart';

class ApiResponseWithUserList{
  ApiResponseWithUserList({
    required this.success,
    required this.errorMsg,
    required this.command,
    required this.data,
});
  ApiResponseWithUserList.fromJson(dynamic json){
    success = json['success'];
    errorMsg = json['errorMessage'];
    command = json['command'];
    if(json['data'] is String && json['data'].toString().isEmpty){
      data = [];
    } else if(json['data']!=null){
      data = [];
      json['data'].forEach((v){
        data.add(User.fromJson(v));
      });
    }
  }

  late bool success;
  late String errorMsg;
  late String command;
  late List<User> data;

  Map<String,dynamic> toJson(){
    final map = <String, dynamic>{};
    map['success'] = success;
    map['errorMessage'] = errorMsg;
    map['command'] = command;
    if (data != null) {
      map['data'] = data.map((v) => v.toJson()).toList();
    }
    return map;
  }
}