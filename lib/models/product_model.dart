// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class ProductModel {
  final String name;
  final String description;
  final double price;
  final int quantity;
  final String category;
  final List<dynamic> images;
  final String id;
  final String sellerId;
  final List<dynamic> rating;
  final DateTime createdAt;
  const ProductModel({
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.category,
    required this.images,
    required this.id,
    required this.sellerId,
    required this.rating,
    required this.createdAt,
  });

  ProductModel copyWith({
    String? name,
    String? description,
    double? price,
    int? quantity,
    String? category,
    List<dynamic>? images,
    String? id,
    String? sellerId,
    List<dynamic>? rating,
    DateTime? createdAt,
  }) {
    return ProductModel(
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
      images: images ?? this.images,
      id: id ?? this.id,
      sellerId: sellerId ?? this.sellerId,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      'category': category,
      'images': images,
      'id': id,
      'sellerId': sellerId,
      'rating': rating,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      name: (map["name"] ?? '') as String,
      description: (map["description"] ?? '') as String,
      price: (map["price"] ?? 0.0) as double,
      quantity: (map["quantity"] ?? 0) as int,
      category: (map["category"] ?? '') as String,
      images: List<dynamic>.from(((map['images'] ?? const <dynamic>[]) as List<dynamic>),),
      id: (map["id"] ?? '') as String,
      sellerId: (map["sellerId"] ?? '') as String,
      rating: List<dynamic>.from(((map['rating'] ?? const <dynamic>[]) as List<dynamic>),),
      createdAt: DateTime.fromMillisecondsSinceEpoch((map["createdAt"]??0) as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductModel(name: $name, description: $description, price: $price, quantity: $quantity, category: $category, images: $images, id: $id, sellerId: $sellerId, rating: $rating, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant ProductModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.description == description &&
      other.price == price &&
      other.quantity == quantity &&
      other.category == category &&
      listEquals(other.images, images) &&
      other.id == id &&
      other.sellerId == sellerId &&
      listEquals(other.rating, rating) &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      description.hashCode ^
      price.hashCode ^
      quantity.hashCode ^
      category.hashCode ^
      images.hashCode ^
      id.hashCode ^
      sellerId.hashCode ^
      rating.hashCode ^
      createdAt.hashCode;
  }
}
