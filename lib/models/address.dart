import 'geolocation.dart';

class Address {
  Address({
      required this.city,
      required this.street,
      required this.zipcode,
      required this.number,
      required this.geolocation,});

  Address.fromJson(dynamic json) {
    city = json['city'];
    street = json['street'];
    zipcode = json['zipcode'];
    number = json['number'];
    geolocation = (json['geolocation'] != null ? Geolocation.fromJson(json['geolocation']) : null)!;
  }
  late String city;
  late String street;
  late String zipcode;
  late String number;
  late Geolocation geolocation;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['city'] = city;
    map['street'] = street;
    map['zipcode'] = zipcode;
    map['number'] = number;
    if (geolocation != null) {
      map['geolocation'] = geolocation.toJson();
    }
    return map;
  }

}