import 'package:apex/core/utils.dart';
import 'package:apex/features/auth/controller/auth_controller.dart';
import 'package:apex/features/orders/repositories/orders_repository.dart';
import 'package:apex/models/order_model.dart';
import 'package:apex/utils/error_text.dart';
import 'package:apex/utils/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//! get all orders provider
final getAllOrdersProvider = StreamProvider((ref) {
  final orderController = ref.watch(orderControllerProvider.notifier);

  return orderController.getAllOrders();
});

//! get particular order details provider
final getOrderDetailsProvider = StreamProvider.family((ref, String orderId) {
  final orderController = ref.watch(orderControllerProvider.notifier);
  return orderController.getOrderDetails(orderId);
});

final orderControllerProvider =
    StateNotifierProvider<OrderController, bool>((ref) {
  final orderRepository = ref.watch(orderRepositoryProvider);
  return OrderController(
    orderRepository: orderRepository,
    ref: ref,
  );
});

class OrderController extends StateNotifier<bool> {
  final OrderRepository _orderRepository;
  final Ref _ref;
  OrderController({
    required OrderRepository orderRepository,
    required Ref ref,
  })  : _orderRepository = orderRepository,
        _ref = ref,
        super(false);

  //! update order delivered
  void updateOrderDelivered({
    required BuildContext context,
    required String orderId,
  }) async {
    late OrderModel order;
    state = true;
    final ress = _ref.read(getOrderDetailsProvider(orderId));

    ress.when(
      data: (data) {
        order = data;
      },
      error: (error, stactrace) => ErrorText(error: error.toString()),
      loading: () => const Loader(),
    );
    final res = await _orderRepository.updateOrderStatus(order.copyWith(
      status: 'delivered',
      deliveredAt: DateTime.now(),
    ));

    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => showSnackBar(context, 'Done!'),
    );
  }

  //! update order not delivered
  void updateOrderNotDelivered({
    required BuildContext context,
    required String orderId,
  }) async {
    late OrderModel order;
    state = true;
    final ress = _ref.read(getOrderDetailsProvider(orderId));

    ress.when(
      data: (data) {
        order = data;
      },
      error: (error, stactrace) => ErrorText(error: error.toString()),
      loading: () => const Loader(),
    );
    final res = await _orderRepository.updateOrderStatus(order.copyWith(
      status: 'notdelivered',
    ));

    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => showSnackBar(context, 'Done!'),
    );
  }

  //! update order not delivered
  void updateOrderPending({
    required BuildContext context,
    required String orderId,
  }) async {
    late OrderModel order;
    state = true;
    final ress = _ref.read(getOrderDetailsProvider(orderId));

    ress.when(
      data: (data) {
        order = data;
      },
      error: (error, stactrace) => ErrorText(error: error.toString()),
      loading: () => const Loader(),
    );
    final res = await _orderRepository.updateOrderStatus(order.copyWith(
      status: 'pending',
    ));

    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => showSnackBar(context, 'Done!'),
    );
  }

  //! get all orders for customer
  Stream<List<OrderModel>> getAllOrders() {
    final user = _ref.read(userProvider)!;
    return _orderRepository.getAllOrders(user.uid);
  }

  //! get order details
  Stream<OrderModel> getOrderDetails(String orderId) {
    return _orderRepository.getOrderDetail(orderId);
  }
}
