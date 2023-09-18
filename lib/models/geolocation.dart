class Geolocation {
  Geolocation({
      required this.lat,
      required this.long,});

  Geolocation.fromJson(dynamic json) {
    lat = json['lat'];
    long = json['long'];
  }
  late double lat;
  late double long;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['lat'] = lat;
    map['long'] = long;
    return map;
  }

}