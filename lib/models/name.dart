class Name {
  Name({
      required this.firstname,
      required this.lastname,});

  Name.fromJson(dynamic json) {
    firstname = json['firstname'];
    lastname = json['lastname'];
  }
  late String firstname;
  late String lastname;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['firstname'] = firstname;
    map['lastname'] = lastname;
    return map;
  }

}