import 'package:apex/core/constants/firebase_constants.dart';
import 'package:apex/core/failure.dart';
import 'package:apex/core/providers/firebase_provider.dart';
import 'package:apex/core/type_defs.dart';
import 'package:apex/models/order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final orderRepositoryProvider = Provider((ref) {
  return OrderRepository(firestore: ref.watch(firestoreProvider));
});

class OrderRepository {
  final FirebaseFirestore _firestore;
  OrderRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  //! get orders for customer
  Stream<List<OrderModel>> getAllOrders(String uid) {
    return _orders
        .where('userId', isEqualTo: uid)
        .orderBy('orderedAt', descending: true)
        .snapshots()
        .map((event) => event.docs
            .map(
              (e) => OrderModel.fromMap(e.data() as Map<String, dynamic>),
            )
            .toList());
  }

  //! get order details
  Stream<OrderModel> getOrderDetail(String orderId) {
    return _orders.doc(orderId).snapshots().map(
        (event) => OrderModel.fromMap(event.data() as Map<String, dynamic>));
  }

  //! update order status
  FutureVoid updateOrderStatus(OrderModel order) async {
    try {
      return right(_orders.doc(order.orderId).update(order.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  CollectionReference get _orders =>
      _firestore.collection(FirebaseConstants.ordersCollection);

  CollectionReference get _products =>
      _firestore.collection(FirebaseConstants.productsCollection);
}
