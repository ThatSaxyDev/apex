// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class OrderModel {
  final String orderId;
  final List<dynamic> products;
  final List<dynamic> quantity;
  final String address;
  final String userId;
  final int orderedAt;
  final int status;
  final double totalPrice;
  const OrderModel({
    required this.orderId,
    required this.products,
    required this.quantity,
    required this.address,
    required this.userId,
    required this.orderedAt,
    required this.status,
    required this.totalPrice,
  });

  OrderModel copyWith({
    String? orderId,
    List<dynamic>? products,
    List<dynamic>? quantity,
    String? address,
    String? userId,
    int? orderedAt,
    int? status,
    double? totalPrice,
  }) {
    return OrderModel(
      orderId: orderId ?? this.orderId,
      products: products ?? this.products,
      quantity: quantity ?? this.quantity,
      address: address ?? this.address,
      userId: userId ?? this.userId,
      orderedAt: orderedAt ?? this.orderedAt,
      status: status ?? this.status,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'orderId': orderId,
      'products': products,
      'quantity': quantity,
      'address': address,
      'userId': userId,
      'orderedAt': orderedAt,
      'status': status,
      'totalPrice': totalPrice,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      orderId: (map["orderId"] ?? '') as String,
      products: List<dynamic>.from(
        ((map['products'] ?? const <dynamic>[]) as List<dynamic>),
      ),
      quantity: List<dynamic>.from(
        ((map['quantity'] ?? const <dynamic>[]) as List<dynamic>),
      ),
      address: (map["address"] ?? '') as String,
      userId: (map["userId"] ?? '') as String,
      orderedAt: (map["orderedAt"] ?? 0) as int,
      status: (map["status"] ?? 0) as int,
      totalPrice: (map["totalPrice"] ?? 0.0) as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OrderModel(orderId: $orderId, products: $products, quantity: $quantity, address: $address, userId: $userId, orderedAt: $orderedAt, status: $status, totalPrice: $totalPrice)';
  }

  @override
  bool operator ==(covariant OrderModel other) {
    if (identical(this, other)) return true;

    return other.orderId == orderId &&
        listEquals(other.products, products) &&
        listEquals(other.quantity, quantity) &&
        other.address == address &&
        other.userId == userId &&
        other.orderedAt == orderedAt &&
        other.status == status &&
        other.totalPrice == totalPrice;
  }

  @override
  int get hashCode {
    return orderId.hashCode ^
        products.hashCode ^
        quantity.hashCode ^
        address.hashCode ^
        userId.hashCode ^
        orderedAt.hashCode ^
        status.hashCode ^
        totalPrice.hashCode;
  }
}
