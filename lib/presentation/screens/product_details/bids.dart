import 'dart:convert';
import 'package:bidmarket/presentation/screens/home/pdoudict_detiles/profiles.dart';

class Bids {
  String? id;
  String? productId;
  String? userId;
  num? bidAmount;
  String? createdAt;
  Profiles? profiles;

  Bids({
    this.id,
    this.productId,
    this.userId,
    this.bidAmount,
    this.createdAt,
    this.profiles,
  });

  factory Bids.fromRawJson(String str) => Bids.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Bids.fromJson(Map<String, dynamic> json) => Bids(
    id: json["id"],
    productId: json["product_id"],
    userId: json["user_id"],
    bidAmount: json["bid_amount"],
    createdAt: json["created_at"],
    profiles: json["profiles"] == null ? null : Profiles.fromJson(json["profiles"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_id": productId,
    "user_id": userId,
    "bid_amount": bidAmount,
    "created_at": createdAt,
    "profiles": profiles?.toJson(),
  };
}