import 'package:apex/features/seller/features/products/controllers/product_controller.dart';
import 'package:apex/utils/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DealOfTheDay extends ConsumerWidget {
  const DealOfTheDay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsStream =
        ref.watch(productControllerProvider.notifier).getAllProducts();
    return Column(
      children: [
        Padding(
          padding: 20.padH,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Deals',
              style: TextStyle(
                fontSize: 20.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
