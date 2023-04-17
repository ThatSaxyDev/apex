import 'dart:developer';

import 'package:apex/features/auth/controller/auth_controller.dart';
import 'package:apex/features/cart/controllers/cart_controller.dart';
import 'package:apex/features/seller/features/products/controllers/product_controller.dart';
import 'package:apex/models/product_model.dart';
import 'package:apex/theme/palette.dart';
import 'package:apex/utils/button.dart';
import 'package:apex/utils/error_text.dart';
import 'package:apex/utils/loader.dart';
import 'package:apex/utils/string_extensions.dart';
import 'package:apex/utils/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:routemaster/routemaster.dart';

import '../../../utils/app_texts.dart';

class CartView extends ConsumerWidget {
  const CartView({super.key});

  void addToCart(
      BuildContext context, String userId, WidgetRef ref, String productId) {
    ref
        .read(cartControllerProvider.notifier)
        .addToCart(context: context, productId: productId, userId: userId);
  }

  void removeFromCart(
      BuildContext context, String userId, WidgetRef ref, String productId) {
    ref
        .read(cartControllerProvider.notifier)
        .removeFromCart(context: context, productId: productId, userId: userId);
  }

  void navigateToUpdateAddress(BuildContext context) {
    Routemaster.of(context).push('/update-address');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);
    final user = ref.watch(userProvider)!;
    final productsInCartStream = ref.watch(getAllProductsInCartProvider);
    ValueNotifier<int> totalPrice = ValueNotifier(0);

    //! cart
    Set uniqueElements = Set<String>.from(user.cart);

    int cartCount = uniqueElements.length;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Cart',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: currentTheme.textTheme.bodyMedium!.color,
            // fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: user.cart.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Your cart is empty!',
                    style: TextStyle(
                      color: currentTheme.textTheme.bodyMedium!.color,
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  60.sbH,
                  SizedBox(
                    width: 200.w,
                    child: Image.asset(
                      'cart-empty'.png,
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  15.sbH,
                  Padding(
                    padding: 20.padH,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Cart Summary',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  20.sbH,

                  //! cart subtotal
                  Container(
                    height: 70.h,
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: currentTheme.backgroundColor,
                      // borderRadius: BorderRadius.circular(15.r),
                      border: Border.all(width: 0.5.w),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Subtotal',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          user.cart.isEmpty
                              ? const SizedBox.shrink()
                              : Consumer(
                                  builder: (context, ref, child) {
                                    final productsInCartStream =
                                        ref.watch(getAllProductsInCartProvider);

                                    return productsInCartStream.when(
                                      data: (products) {
                                        // log(products.toString());
                                        // Create a Map with the count of each productId in the productIds list
                                        List<int> prices = products
                                            .map((product) => product.price)
                                            .toList();

                                        Map<String, int> productCount = {};
                                        List<int> counts = [];
                                        for (String productId in user.cart) {
                                          productCount[productId] =
                                              (productCount[productId] ?? 0) +
                                                  1;
                                        }

                                        for (ProductModel product in products) {
                                          int count =
                                              productCount[product.id] ?? 0;

                                          counts.add(count);
                                        }

                                        // log(counts.toString());

                                        int result = prices
                                            .asMap()
                                            .map((index, value) => MapEntry(
                                                index, value * counts[index]))
                                            .values
                                            .reduce(
                                                (sum, value) => sum + value);

                                        // log(result.toString());
                                        totalPrice.value = result;
                                        totalPrice.notifyListeners();
                                        // log(totalPrice.value.toString());

                                        return Text(
                                          '${AppTexts.naira} $result',
                                          style: TextStyle(
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.cyan,
                                          ),
                                        );
                                      },
                                      error: (error, stactrace) =>
                                          ErrorText(error: error.toString()),
                                      loading: () => const Loader(),
                                    );
                                  },
                                ),
                        ],
                      ),
                    ),
                  ),

                  15.sbH,
                  Padding(
                    padding: 20.padH,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'CART ($cartCount)',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  20.sbH,

                  productsInCartStream.when(
                    data: (products) {
                      return ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 15.w)
                            .copyWith(bottom: 25.h),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];

                          return ref
                              .watch(getProductDetailsProvider(product.id))
                              .when(
                                data: (productItself) {
                                  return Container(
                                    height: 170.h,
                                    padding: EdgeInsets.all(15.w),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: product == products.last
                                          ? BorderRadius.only(
                                              bottomLeft: Radius.circular(10.r),
                                              bottomRight:
                                                  Radius.circular(10.r),
                                            )
                                          : BorderRadius.only(
                                              topLeft: Radius.circular(10.r),
                                              topRight: Radius.circular(10.r),
                                            ),
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 0.8,
                                      ),
                                    ),
                                    child: Center(
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 55.h,
                                            backgroundImage: NetworkImage(
                                              productItself.images[0],
                                            ),
                                          ),
                                          15.sbW,
                                          Expanded(
                                            child: Column(
                                              // mainAxisAlignment:
                                              //     MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                5.sbH,
                                                Text(
                                                  productItself.name,
                                                  style: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                10.sbH,
                                                Text(
                                                  '${AppTexts.naira} ${productItself.price}',
                                                  style: TextStyle(
                                                    fontSize: 20.sp,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                                const Spacer(),

                                                //! add remove
                                                Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Container(
                                                    height: 50.h,
                                                    width: 150.w,
                                                    padding:
                                                        EdgeInsets.all(7.w),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.r),
                                                      border: Border.all(
                                                        color: currentTheme
                                                            .textTheme
                                                            .bodyMedium!
                                                            .color!,
                                                        width: 2,
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        // remove
                                                        BButton(
                                                          onTap: () =>
                                                              removeFromCart(
                                                                  context,
                                                                  user.uid,
                                                                  ref,
                                                                  productItself
                                                                      .id),
                                                          height: 30.h,
                                                          width: 30.h,
                                                          color: currentTheme
                                                              .backgroundColor,
                                                          isText: false,
                                                          item: Icon(
                                                            PhosphorIcons
                                                                .minusBold,
                                                            color: currentTheme
                                                                .textTheme
                                                                .bodyMedium!
                                                                .color,
                                                          ),
                                                        ),

                                                        Builder(
                                                          builder: (context) {
                                                            int count = user
                                                                .cart
                                                                .where((item) =>
                                                                    item ==
                                                                    productItself
                                                                        .id)
                                                                .length;
                                                            return Text(
                                                              count.toString(),
                                                              style: TextStyle(
                                                                fontSize: 20.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: currentTheme
                                                                    .textTheme
                                                                    .bodyMedium!
                                                                    .color,
                                                              ),
                                                            );
                                                          },
                                                        ),

                                                        //! add
                                                        BButton(
                                                          onTap: () =>
                                                              addToCart(
                                                                  context,
                                                                  user.uid,
                                                                  ref,
                                                                  productItself
                                                                      .id),
                                                          height: 30.h,
                                                          width: 30.h,
                                                          color: currentTheme
                                                              .backgroundColor,
                                                          isText: false,
                                                          item: Icon(
                                                            PhosphorIcons
                                                                .plusBold,
                                                            color: currentTheme
                                                                .textTheme
                                                                .bodyMedium!
                                                                .color,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                error: (error, stactrace) =>
                                    ErrorText(error: error.toString()),
                                loading: () => const Loader(),
                              );
                        },
                      );
                    },
                    error: (error, stactrace) =>
                        ErrorText(error: error.toString()),
                    loading: () => const Loader(),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: user.cart.isEmpty
          ? null
          : Container(
              height: 110.h,
              decoration: BoxDecoration(
                color: currentTheme.textTheme.bodyMedium!.color,
                // borderRadius: BorderRadius.circular(30.r),
              ),
              child: Center(
                child: BButton(
                  height: 55.h,
                  width: 200.w,
                  color: currentTheme.backgroundColor,
                  onTap: () {
                    if (user.address.isEmpty) {
                      navigateToUpdateAddress(context);
                    } else {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor:
                            currentTheme.textTheme.bodyMedium!.color,
                        context: context,
                        builder: (context) => Wrap(
                          children: [
                            Container(
                              height: 240.h,
                              width: double.infinity,
                              padding: EdgeInsets.only(
                                  top: 15.h, right: 24.w, left: 24.w),
                              decoration: BoxDecoration(
                                color: currentTheme.textTheme.bodyMedium!.color,
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(30.r),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Pay:',
                                    style: TextStyle(
                                        fontSize: 25.sp,
                                        color: currentTheme.backgroundColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  15.sbH,
                                  Text(
                                    '${AppTexts.naira} ${totalPrice.value}',
                                    style: TextStyle(
                                      fontSize: 25.sp,
                                      fontWeight: FontWeight.w900,
                                      color: currentTheme.backgroundColor,
                                    ),
                                  ),
                                  20.sbH,
                                  BButton(
                                    onTap: () {
                                      ref
                                          .read(cartControllerProvider.notifier)
                                          .createCheckoutOrder(
                                            cart: user.cart,
                                            context: context,
                                            totalPrice: totalPrice.value,
                                          );
                                      Routemaster.of(context).pop();
                                    },
                                    height: 55.h,
                                    width: 200.w,
                                    color: currentTheme.backgroundColor,
                                    text: 'Place Order',
                                    textColor: currentTheme
                                        .textTheme.bodyMedium!.color,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  text: 'Checkout',
                  textColor: currentTheme.textTheme.bodyMedium!.color,
                ),
              ),
            ),
    );
  }
}
