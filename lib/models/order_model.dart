// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class OrderModel {
  final String orderId;
  final List<dynamic> cart;
  final List<dynamic> quantity;
  final String address;
  final String userId;
  final DateTime orderedAt;
  final DateTime deliveredAt;
  final String status;
  final int totalPrice;
  const OrderModel({
    required this.orderId,
    required this.cart,
    required this.quantity,
    required this.address,
    required this.userId,
    required this.orderedAt,
    required this.deliveredAt,
    required this.status,
    required this.totalPrice,
  });

  OrderModel copyWith({
    String? orderId,
    List<dynamic>? cart,
    List<dynamic>? quantity,
    String? address,
    String? userId,
    DateTime? orderedAt,
    DateTime? deliveredAt,
    String? status,
    int? totalPrice,
  }) {
    return OrderModel(
      orderId: orderId ?? this.orderId,
      cart: cart ?? this.cart,
      quantity: quantity ?? this.quantity,
      address: address ?? this.address,
      userId: userId ?? this.userId,
      orderedAt: orderedAt ?? this.orderedAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      status: status ?? this.status,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'orderId': orderId,
      'cart': cart,
      'quantity': quantity,
      'address': address,
      'userId': userId,
      'orderedAt': orderedAt.millisecondsSinceEpoch,
      'deliveredAt': deliveredAt.millisecondsSinceEpoch,
      'status': status,
      'totalPrice': totalPrice,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      orderId: (map["orderId"] ?? '') as String,
      cart: List<dynamic>.from(((map['cart'] ?? const <dynamic>[]) as List<dynamic>),),
      quantity: List<dynamic>.from(((map['quantity'] ?? const <dynamic>[]) as List<dynamic>),),
      address: (map["address"] ?? '') as String,
      userId: (map["userId"] ?? '') as String,
      orderedAt: DateTime.fromMillisecondsSinceEpoch((map["orderedAt"]??0) as int),
      deliveredAt: DateTime.fromMillisecondsSinceEpoch((map["deliveredAt"]??0) as int),
      status: (map["status"] ?? '') as String,
      totalPrice: (map["totalPrice"] ?? 0) as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OrderModel(orderId: $orderId, cart: $cart, quantity: $quantity, address: $address, userId: $userId, orderedAt: $orderedAt, deliveredAt: $deliveredAt, status: $status, totalPrice: $totalPrice)';
  }

  @override
  bool operator ==(covariant OrderModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.orderId == orderId &&
      listEquals(other.cart, cart) &&
      listEquals(other.quantity, quantity) &&
      other.address == address &&
      other.userId == userId &&
      other.orderedAt == orderedAt &&
      other.deliveredAt == deliveredAt &&
      other.status == status &&
      other.totalPrice == totalPrice;
  }

  @override
  int get hashCode {
    return orderId.hashCode ^
      cart.hashCode ^
      quantity.hashCode ^
      address.hashCode ^
      userId.hashCode ^
      orderedAt.hashCode ^
      deliveredAt.hashCode ^
      status.hashCode ^
      totalPrice.hashCode;
  }
}
