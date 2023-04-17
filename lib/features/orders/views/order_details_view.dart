// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:apex/features/orders/controllers/orders_controller.dart';
import 'package:apex/utils/error_text.dart';
import 'package:apex/utils/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:apex/features/auth/controller/auth_controller.dart';
import 'package:apex/theme/palette.dart';

class OrderDetailsView extends ConsumerWidget {
  final String orderId;
  const OrderDetailsView({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);
    final user = ref.watch(userProvider)!;
    final orderDetailsStream = ref.watch(getOrderDetailsProvider(orderId));
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          elevation: 0,
          backgroundColor: currentTheme.backgroundColor,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
          ),
          centerTitle: true,
          title: Text(
            'Order Details',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: currentTheme.textTheme.bodyMedium!.color,
              // fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: orderDetailsStream.when(
        data: (order) {
          return const SizedBox.shrink();
        },
        error: (error, stactrace) => ErrorText(error: error.toString()),
        loading: () => const Loader(),
      ),
    );
  }
}
