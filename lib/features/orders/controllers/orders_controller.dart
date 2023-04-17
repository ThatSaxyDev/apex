import 'package:apex/features/auth/controller/auth_controller.dart';
import 'package:apex/features/orders/repositories/orders_repository.dart';
import 'package:apex/models/order_model.dart';
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
