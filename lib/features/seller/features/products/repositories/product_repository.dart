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

  CollectionReference get _products =>
      _firestore.collection(FirebaseConstants.productsCollection);
}
