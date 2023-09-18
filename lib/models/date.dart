class Date {
  Date({
      required this.seconds,
      required this.nanos,});

  Date.fromJson(dynamic json) {
    seconds = json['seconds'];
    nanos = json['nanos'];
  }
  late String seconds;
  late double nanos;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['seconds'] = seconds;
    map['nanos'] = nanos;
    return map;
  }

}