// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String profilePic;
  final String address;
  final String userType;
  final List<dynamic> cart;
  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.profilePic,
    required this.address,
    required this.userType,
    required this.cart,
  });

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? profilePic,
    String? address,
    String? userType,
    List<dynamic>? cart,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      profilePic: profilePic ?? this.profilePic,
      address: address ?? this.address,
      userType: userType ?? this.userType,
      cart: cart ?? this.cart,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      'profilePic': profilePic,
      'address': address,
      'userType': userType,
      'cart': cart,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: (map["uid"] ?? '') as String,
      name: (map["name"] ?? '') as String,
      email: (map["email"] ?? '') as String,
      profilePic: (map["profilePic"] ?? '') as String,
      address: (map["address"] ?? '') as String,
      userType: (map["userType"] ?? '') as String,
      cart: List<Map<String, dynamic>>.from(
        map['cart']?.map(
          (x) => Map<String, dynamic>.from(x),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, email: $email, profilePic: $profilePic, address: $address, userType: $userType, cart: $cart)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.name == name &&
        other.email == email &&
        other.profilePic == profilePic &&
        other.address == address &&
        other.userType == userType &&
        listEquals(other.cart, cart);
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        email.hashCode ^
        profilePic.hashCode ^
        address.hashCode ^
        userType.hashCode ^
        cart.hashCode;
  }
}
