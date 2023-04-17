import 'package:apex/core/constants/firebase_constants.dart';
import 'package:apex/core/failure.dart';
import 'package:apex/core/providers/firebase_provider.dart';
import 'package:apex/core/type_defs.dart';
import 'package:apex/models/order_model.dart';
import 'package:apex/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final cartRepositoryProvider = Provider((ref) {
  return CartRepository(firestore: ref.watch(firestoreProvider));
});

class CartRepository {
  final FirebaseFirestore _firestore;
  CartRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  //! add item to cart
  FutureVoid addToCart(String productId, String uid) async {
    try {
      DocumentSnapshot userDoc = await _users.doc(uid).get();
      Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
      List<dynamic> cart = data?['cart'] ?? [];
      cart.add(productId);

      //! update add to cart field in products
      _products.doc(productId).update({
        'addedToCart': FieldValue.arrayUnion([uid])
      });

      return right(_users.doc(uid).update({
        'cart': cart,
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //! remove item from cart
  FutureVoid removeFromCart(String productId, String uid) async {
    try {
      DocumentSnapshot userDoc = await _users.doc(uid).get();
      Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
      List<dynamic> cart = data?['cart'] ?? [];

      // Filter out all occurrences of the productId
      List<dynamic> filteredCart =
          cart.where((item) => item == productId).toList();

// Remove user from the added to cart list
      if (filteredCart.length == 1) {
        _products.doc(productId).update({
          'addedToCart': FieldValue.arrayRemove([uid])
        });
      }

      if (cart.contains(productId)) {
        cart.remove(productId);
      } else {}
      return right(_users.doc(uid).update({
        'cart': cart,
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //! get all products in cart
  Stream<List<ProductModel>> getAllProductsInCart(String userId) {
    return _products
        .where('addedToCart', arrayContains: userId)
        .snapshots()
        .map((event) => event.docs
            .map(
              (e) => ProductModel.fromMap(e.data() as Map<String, dynamic>),
            )
            .toList());
  }

  //! create check out order
  FutureVoid createCheckoutOrder(OrderModel order) async {
    try {
      return right(_orders.doc(order.orderId).set(order.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //! clear cart
  FutureVoid clearCart(String productId, String uid) async {
    try {
      _products.doc(productId).update({
        'addedToCart': FieldValue.arrayRemove([uid])
      });

      return right(_users.doc(uid).update({
        'cart': [],
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  CollectionReference get _products =>
      _firestore.collection(FirebaseConstants.productsCollection);

  CollectionReference get _orders =>
      _firestore.collection(FirebaseConstants.ordersCollection);
}
