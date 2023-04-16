import 'dart:developer';

import 'package:apex/core/utils.dart';
import 'package:apex/features/auth/controller/auth_controller.dart';
import 'package:apex/models/product_model.dart';
import 'package:apex/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  //! get all products in cart
  Stream<List<ProductModel>> getAllProductsInCart() {
    final user = _ref.read(userProvider)!;
    return _cartRepository.getAllProductsInCart(user.uid);
  }
}
