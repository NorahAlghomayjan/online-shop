import 'name.dart';
import 'address.dart';

class User {
  User({
      required this.id,
      required this.email,
      required this.username,
      required this.password,
      required this.name,
      required this.phone,
      required this.address,
      required this.v,});

  User.fromJson(dynamic json) {
    id = json['id'];
    email = json['email'];
    username = json['username'];
    password = json['password'];
    name = (json['name'] != null ? Name.fromJson(json['name']) : null)!;
    phone = json['phone'];
    address = (json['address'] != null ? Address.fromJson(json['address']) : null)!;
    v = json['__v'];
  }
  late String id;
  late String email;
  late String username;
  late String password;
  late Name name;
  late String phone;
  late Address address;
  late double v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['email'] = email;
    map['username'] = username;
    map['password'] = password;
    if (name != null) {
      map['name'] = name.toJson();
    }
    map['phone'] = phone;
    if (address != null) {
      map['address'] = address.toJson();
    }
    map['__v'] = v;
    return map;
  }

}