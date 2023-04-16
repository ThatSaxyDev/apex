import 'dart:developer';

import 'package:apex/features/auth/controller/auth_controller.dart';
import 'package:apex/features/seller/features/products/controllers/product_controller.dart';
import 'package:apex/features/seller/features/products/widgets/seller_product.dart';
import 'package:apex/theme/palette.dart';
import 'package:apex/utils/error_text.dart';
import 'package:apex/utils/loader.dart';
import 'package:apex/utils/string_extensions.dart';
import 'package:apex/utils/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:routemaster/routemaster.dart';

class ProductsView extends ConsumerWidget {
  const ProductsView({super.key});

  //! nav
  void navigateToAddProduct(BuildContext context) {
    Routemaster.of(context).push('/add-products');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final currentTheme = ref.watch(themeNotifierProvider);
    final productsStream = ref.watch(getSellerProductsProvider);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: currentTheme.textTheme.bodyMedium!.color,
        tooltip: 'Add a product',
        onPressed: () => navigateToAddProduct(context),
        child: const Icon(PhosphorIcons.plusBold),
      ),
      body: Column(
        children: [
          60.sbH,
          Padding(
            padding: 24.padH,
            child: RichText(
              text: TextSpan(
                text: 'Hello ',
                style: TextStyle(
                  fontSize: 20.sp,
                  color: currentTheme.textTheme.bodyMedium!.color,
                  fontWeight: FontWeight.w500,
                ),
                children: [
                  TextSpan(
                    text: user.name,
                    style: TextStyle(
                      fontSize: 23.sp,
                      color: Pallete.blueColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text: ', Your Products',
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: currentTheme.textTheme.bodyMedium!.color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          25.sbH,
          //! products
          productsStream.when(
            data: (products) {
              if (products.isEmpty) {
                return Expanded(
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

              return Expanded(
                child: GridView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, index) {
                    final productData = products[index];
                    return Column(
                      children: [
                        SellerProduct(
                          product: productData,
                          index: index,
                        ),
                      ],
                    );
                  },
                ),
              );
            },
            error: (error, stackTrace) {
              log(error.toString());
              return ErrorText(error: error.toString());
            },
            loading: () => const Loader(),
          ),
        ],
      ),
    );
  }
}
