import 'dart:convert';

class Profiles {
  String? id;
  String? fullName;

  Profiles({
    this.id,
    this.fullName,
  });

  factory Profiles.fromRawJson(String str) => Profiles.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Profiles.fromJson(Map<String, dynamic> json) => Profiles(
    id: json["id"],
    fullName: json["full_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "full_name": fullName,
  };
}
