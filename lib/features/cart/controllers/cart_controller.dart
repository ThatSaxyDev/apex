import 'dart:developer';

import 'package:apex/core/utils.dart';
import 'package:apex/features/auth/controller/auth_controller.dart';
import 'package:apex/models/order_model.dart';
import 'package:apex/models/product_model.dart';
import 'package:apex/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../repositories/cart_repository.dart';

//! get all products in cart provider
final getAllProductsInCartProvider = StreamProvider((ref) {
  final cartController = ref.watch(cartControllerProvider.notifier);
  return cartController.getAllProductsInCart();
});

final cartControllerProvider =
    StateNotifierProvider<CartController, bool>((ref) {
  final cartRepository = ref.watch(cartRepositoryProvider);
  return CartController(
    cartRepository: cartRepository,
    ref: ref,
  );
});

class CartController extends StateNotifier<bool> {
  final CartRepository _cartRepository;
  final Ref _ref;
  CartController({
    required CartRepository cartRepository,
    required Ref ref,
  })  : _cartRepository = cartRepository,
        _ref = ref,
        super(false);

  void addToCart(
      {required BuildContext context,
      required String productId,
      required String userId}) async {
    state = true;
    final res = await _cartRepository.addToCart(productId, userId);

    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        // showSnackBar(context, 'Cart updated!');
      },
    );
  }

  void removeFromCart(
      {required BuildContext context,
      required String productId,
      required String userId}) async {
    state = true;
    final res = await _cartRepository.removeFromCart(productId, userId);

    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        // showSnackBar(context, 'Cart updated!');
      },
    );
  }

  void createCheckoutOrder({
    required BuildContext context,
    required int totalPrice,
    required List<dynamic> cart,
  }) async {
    state = true;
    final user = _ref.read(userProvider)!;
    String randomId = const Uuid().v1();
    String orderId = 'order-$randomId';
    OrderModel order = OrderModel(
      orderId: orderId,
      cart: cart,
      quantity: [],
      address: user.address,
      userId: user.uid,
      orderedAt: DateTime.now(),
      deliveredAt: DateTime.now(),
      status: 'pending',
      totalPrice: totalPrice,
    );
    final res = await _cartRepository.createCheckoutOrder(order);

    for (String productId in cart) {
      await _cartRepository.clearCart(productId, user.uid);
    }
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => showSnackBar(context, 'Done'),
    );
  }

  //! get all products in cart
  Stream<List<ProductModel>> getAllProductsInCart() {
    final user = _ref.read(userProvider)!;
    return _cartRepository.getAllProductsInCart(user.uid);
  }
}
