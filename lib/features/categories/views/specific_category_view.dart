// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:apex/features/seller/features/products/controllers/product_controller.dart';
import 'package:apex/features/seller/features/products/widgets/customers_product.dart';
import 'package:apex/theme/palette.dart';
import 'package:apex/utils/error_text.dart';
import 'package:apex/utils/loader.dart';
import 'package:apex/utils/string_extensions.dart';
import 'package:apex/utils/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SpecificCategoryView extends ConsumerWidget {
  final String categoryName;
  const SpecificCategoryView({
    super.key,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);
    final productsStream =
        ref.watch(getAllProductsByCategoryProvider(categoryName));
    // final user = ref.watch(userProvider)!;
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
            categoryName,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: currentTheme.textTheme.bodyMedium!.color,
              // fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: productsStream.when(
        data: (products) {
          if (products.isEmpty) {
            return SizedBox(
              height: 200.h,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 150.h,
                      child: Image.asset('empty'.png),
                    ),
                    15.sbH,
                    Text(
                      'You have no products for sale!',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (context, index) {
              final productData = products[index];
              return Column(
                children: [
                  CustomersProduct(
                    product: productData,
                    index: index,
                  ),
                ],
              );
            },
          );
        },
        error: (error, stactrace) {
          log(error.toString());
          return ErrorText(error: error.toString());
        },
        loading: () => const Loader(),
      ),
    );
  }
}
