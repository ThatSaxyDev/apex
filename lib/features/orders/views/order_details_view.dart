// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:apex/features/orders/controllers/orders_controller.dart';
import 'package:apex/features/seller/features/products/controllers/product_controller.dart';
import 'package:apex/models/product_model.dart';
import 'package:apex/utils/app_texts.dart';
import 'package:apex/utils/button.dart';
import 'package:apex/utils/error_text.dart';
import 'package:apex/utils/loader.dart';
import 'package:apex/utils/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:apex/features/auth/controller/auth_controller.dart';
import 'package:apex/theme/palette.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class OrderDetailsView extends ConsumerWidget {
  final String orderId;
  const OrderDetailsView({
    super.key,
    required this.orderId,
  });

  void markDelivered(WidgetRef ref, BuildContext context) {
    ref
        .read(orderControllerProvider.notifier)
        .updateOrderDelivered(context: context, orderId: orderId);
  }

  void markNOTDelivered(WidgetRef ref, BuildContext context) {
    ref
        .read(orderControllerProvider.notifier)
        .updateOrderNotDelivered(context: context, orderId: orderId);
  }

  void markPending(WidgetRef ref, BuildContext context) {
    ref
        .read(orderControllerProvider.notifier)
        .updateOrderPending(context: context, orderId: orderId);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);
    // final user = ref.watch(userProvider)!;
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
          Set uniqueElements = Set<String>.from(order.cart);

          int cartCount = uniqueElements.length;

          return SingleChildScrollView(
            child: Column(
              children: [
                15.sbH,
                Padding(
                  padding: 20.padH,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                        text: 'Ordered: ',
                        style: TextStyle(
                          fontSize: 12.sp,
                          // fontWeight: FontWeight.bold,
                          color: currentTheme.textTheme.bodyMedium!.color,
                        ),
                        children: [
                          TextSpan(
                            text:
                                '${DateFormat.yMMMMEEEEd().format(order.orderedAt)} ${DateFormat.jm().format(order.orderedAt)}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w800,
                              color: currentTheme.textTheme.bodyMedium!.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                10.sbH,
                if (order.status == 'delivered')
                  Padding(
                    padding: 20.padH,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                          text: 'Delivered: ',
                          style: TextStyle(
                            fontSize: 12.sp,
                            // fontWeight: FontWeight.bold,
                            color: currentTheme.textTheme.bodyMedium!.color,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  '${DateFormat.yMMMMEEEEd().format(order.deliveredAt)} ${DateFormat.jm().format(order.deliveredAt)}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w800,
                                color: currentTheme.textTheme.bodyMedium!.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                10.sbH,

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
                        Text(
                          '${AppTexts.naira} ${order.totalPrice}',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.cyan,
                          ),
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
                      'Items ($cartCount)',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                15.sbH,
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: order.status == 'pending'
                        ? Colors.orange
                        : order.status == 'delivered'
                            ? Colors.green
                            : Colors.red,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    order.status.toUpperCase(),
                    style: TextStyle(
                      color: Pallete.whiteColor,
                      fontSize: 10.sp,
                    ), 
                  ),
                ),
                50.sbH,

                BButton(
                  onTap: () => markDelivered(ref, context),
                  width: 200.w,
                  color: Colors.green,
                  text: 'Delivered?',
                ),
                20.sbH,
                BButton(
                  onTap: () => markNOTDelivered(ref, context),
                  width: 200.w,
                  color: Colors.red,
                  text: 'notDelivered?',
                ),
                20.sbH,
                BButton(
                  onTap: () => markPending(ref, context),
                  width: 200.w,
                  color: Colors.orange,
                  text: 'pending?',
                ),

                // SizedBox(
                //   height: 200,
                //   child: ListView.builder(
                //     padding: 20.padH,
                //     physics: const NeverScrollableScrollPhysics(),
                //     itemBuilder: (context, index) {
                //       return const SizedBox.shrink();
                //     },
                //   ),
                // )

                // productsInCartStream.when(
                //   data: (products) {
                //     return ListView.builder(
                //       padding: EdgeInsets.symmetric(horizontal: 15.w)
                //           .copyWith(bottom: 25.h),
                //       physics: const NeverScrollableScrollPhysics(),
                //       shrinkWrap: true,
                //       itemCount: products.length,
                //       itemBuilder: (context, index) {
                //         final product = products[index];

                //         return ref
                //             .watch(getProductDetailsProvider(product.id))
                //             .when(
                //               data: (productItself) {
                //                 return Container(
                //                   height: 170.h,
                //                   padding: EdgeInsets.all(15.w),
                //                   width: double.infinity,
                //                   decoration: BoxDecoration(
                //                     borderRadius: product == products.last
                //                         ? BorderRadius.only(
                //                             bottomLeft: Radius.circular(10.r),
                //                             bottomRight: Radius.circular(10.r),
                //                           )
                //                         : BorderRadius.only(
                //                             topLeft: Radius.circular(10.r),
                //                             topRight: Radius.circular(10.r),
                //                           ),
                //                     border: Border.all(
                //                       color: Colors.grey,
                //                       width: 0.8,
                //                     ),
                //                   ),
                //                   child: Center(
                //                     child: Row(
                //                       children: [
                //                         CircleAvatar(
                //                           radius: 55.h,
                //                           backgroundImage: NetworkImage(
                //                             productItself.images[0],
                //                           ),
                //                         ),
                //                         15.sbW,
                //                         Expanded(
                //                           child: Column(
                //                             // mainAxisAlignment:
                //                             //     MainAxisAlignment.spaceEvenly,
                //                             crossAxisAlignment:
                //                                 CrossAxisAlignment.start,
                //                             children: [
                //                               5.sbH,
                //                               Text(
                //                                 productItself.name,
                //                                 style: TextStyle(
                //                                   fontSize: 16.sp,
                //                                   fontWeight: FontWeight.w400,
                //                                 ),
                //                               ),
                //                               10.sbH,
                //                               Text(
                //                                 '${AppTexts.naira} ${productItself.price}',
                //                                 style: TextStyle(
                //                                   fontSize: 20.sp,
                //                                   fontWeight: FontWeight.w800,
                //                                 ),
                //                               ),
                //                               const Spacer(),
                //                             ],
                //                           ),
                //                         ),
                //                       ],
                //                     ),
                //                   ),
                //                 );
                //               },
                //               error: (error, stactrace) =>
                //                   ErrorText(error: error.toString()),
                //               loading: () => const Loader(),
                //             );
                //       },
                //     );
                //   },
                //   error: (error, stactrace) =>
                //       ErrorText(error: error.toString()),
                //   loading: () => const Loader(),
                // ),
              ],
            ),
          );
        },
        error: (error, stactrace) => ErrorText(error: error.toString()),
        loading: () => const Loader(),
      ),
    );
  }
}
