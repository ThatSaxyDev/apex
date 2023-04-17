import 'package:apex/core/constants/firebase_constants.dart';
import 'package:apex/core/failure.dart';
import 'package:apex/core/providers/firebase_provider.dart';
import 'package:apex/core/type_defs.dart';
import 'package:apex/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final productRepositoryProvider = Provider((ref) {
  return ProductRepository(firestore: ref.watch(firestoreProvider));
});

class ProductRepository {
  final FirebaseFirestore _firestore;
  ProductRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  //! add products for sale
  FutureVoid addProducts(ProductModel product) async {
    try {
      return right(_products.doc(product.id).set(product.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //! delete product
  FutureVoid deleteProduct(ProductModel product) async {
    try {
      return right(_products.doc(product.id).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //! get particular product details
  Stream<ProductModel> getProductDetail(String productId) {
    return _products.doc(productId).snapshots().map(
        (event) => ProductModel.fromMap(event.data() as Map<String, dynamic>));
  }

  //! get products
  Stream<List<ProductModel>> getSellerProducts(String userId) {
    return _products
        .where('sellerId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((event) => event.docs
            .map(
              (e) => ProductModel.fromMap(e.data() as Map<String, dynamic>),
            )
            .toList());
  }

  //! update product quantity
  //! add
  void addToProductQuantitySeller(ProductModel product) async {
    _products.doc(product.id).update({
      'quantity': product.quantity + 1,
    });
  }

  //! reduce/remove
  void reduceFromProductQuantitySeller(ProductModel product) async {
    if (product.quantity == 1) {
    } else {
      _products.doc(product.id).update({
        'quantity': product.quantity - 1,
      });
    }
  }

  //! get all products for customers
  Stream<List<ProductModel>> getAllProducts() {
    return _products
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((event) => event.docs
            .map(
              (e) => ProductModel.fromMap(e.data() as Map<String, dynamic>),
            )
            .toList());
  }

  //! get all products by categories for customers
  Stream<List<ProductModel>> getAllProductsByCategories(String category) {
    return _products
        .where('category', isEqualTo: category)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((event) => event.docs
            .map(
              (e) => ProductModel.fromMap(e.data() as Map<String, dynamic>),
            )
            .toList());
  }

  CollectionReference get _products =>
      _firestore.collection(FirebaseConstants.productsCollection);
}
