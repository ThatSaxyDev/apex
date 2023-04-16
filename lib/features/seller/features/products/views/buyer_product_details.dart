import 'package:apex/features/auth/controller/auth_controller.dart';
import 'package:apex/features/cart/controllers/cart_controller.dart';
import 'package:apex/features/home/widgets/search_bar.dart';
import 'package:apex/features/seller/features/products/controllers/product_controller.dart';
import 'package:apex/theme/palette.dart';
import 'package:apex/utils/app_texts.dart';
import 'package:apex/utils/button.dart';
import 'package:apex/utils/error_text.dart';
import 'package:apex/utils/loader.dart';
import 'package:apex/utils/stars.dart';
import 'package:apex/utils/widget_extensions.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:badges/badges.dart' as badges;
import 'package:routemaster/routemaster.dart';

class BuyerProductDetailsView extends ConsumerStatefulWidget {
  final String productId;
  const BuyerProductDetailsView({
    super.key,
    required this.productId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BuyerProductDetailsViewState();
}

class _BuyerProductDetailsViewState
    extends ConsumerState<BuyerProductDetailsView> {
  void navigateToCart(BuildContext context) {
    Routemaster.of(context).push('/cart');
  }

  void addToCart(BuildContext context, String userId) {
    ref.read(cartControllerProvider.notifier).addToCart(
        context: context, productId: widget.productId, userId: userId);
  }

  void removeFromCart(BuildContext context, String userId) {
    ref.read(cartControllerProvider.notifier).removeFromCart(
        context: context, productId: widget.productId, userId: userId);
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);
    final user = ref.watch(userProvider)!;
    final productDetailStream =
        ref.watch(getProductDetailsProvider(widget.productId));
    final isLoading = ref.read(cartControllerProvider);
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
            'Details',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: currentTheme.textTheme.bodyMedium!.color,
              // fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            InkWell(
              onTap: () {},
              child: Icon(
                PhosphorIcons.magnifyingGlassBold,
                size: 26.sp,
              ),
            ),
            13.sbW,
            SizedBox(
              height: 30.h,
              width: 40.w,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () => navigateToCart(context),
                      child: Icon(
                        PhosphorIcons.shoppingCartBold,
                        size: 26.sp,
                      ),
                    ),
                  ),
                  Builder(
                    builder: (context) {
                      Set uniqueElements = Set<String>.from(user.cart);

                      int count = uniqueElements.length;

                      if (user.cart.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      return Positioned(
                        right: 0,
                        top: 5.h,
                        child: CircleAvatar(
                          radius: 10.w,
                          backgroundColor:
                              currentTheme.textTheme.bodyMedium!.color,
                          child: CircleAvatar(
                            radius: 8.w,
                            backgroundColor: currentTheme.backgroundColor,
                            child: Text(
                              count.toString(),
                              style: TextStyle(
                                color: currentTheme.textTheme.bodyMedium!.color,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            15.sbW,
          ],
        ),
      ),
      body: productDetailStream.when(
        data: (product) {
          return SingleChildScrollView(
            // physics: const AlwaysScrollableScrollPhysics(
            //   parent: BouncingScrollPhysics(),
            // ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                10.sbH,
                Padding(
                  padding: 15.padH,
                  child: Row(
                    children: [
                      Text(
                        'Product ID: ',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 250.w,
                        child: Text(
                          product.id,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                10.sbH,
                Padding(
                  padding: 15.padH,
                  child: Row(
                    children: [
                      Text(
                        'Vendor: ',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.bold),
                      ),
                      Consumer(
                        builder: (context, ref, child) {
                          return ref
                              .read(getUserProvider(product.sellerId))
                              .when(
                                data: (seller) => SizedBox(
                                  width: 250.w,
                                  child: Text(
                                    seller.name,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                                error: (error, stactrace) =>
                                    ErrorText(error: error.toString()),
                                loading: () => const Loader(),
                              );
                        },
                      ),
                    ],
                  ),
                ),
                10.sbH,
                Padding(
                  padding: 15.padH,
                  child: Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                CarouselSlider(
                  items: product.images.map(
                    (i) {
                      return Builder(
                        builder: (BuildContext context) => Image.network(
                          i,
                          fit: BoxFit.contain,
                          height: 200.h,
                        ),
                      );
                    },
                  ).toList(),
                  options: CarouselOptions(
                    aspectRatio: 2.0,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    viewportFraction: 1,
                    height: 300.h,
                  ),
                ),
                10.sbH,

                Padding(
                  padding: 15.padH,
                  child: RichText(
                    text: TextSpan(
                      text: 'Price: ',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: currentTheme.textTheme.bodyMedium!.color,
                      ),
                      children: [
                        TextSpan(
                          text: '${AppTexts.naira}${product.price}',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                            color: Pallete.blueColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                10.sbH,
                Padding(
                  padding: 15.padH,
                  child: Text(product.description),
                ),
                20.sbH,
                //! free shipping
                Padding(
                  padding: 15.padH,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Pallete.blueColor,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      'Free shipping*',
                      style: TextStyle(
                          color: Pallete.whiteColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                30.sbH,

                // Padding(
                //   padding: EdgeInsets.symmetric(
                //     horizontal: 8.w,
                //     vertical: 8.h,
                //   ),
                //   child: Text(
                //     'Rate The Product',
                //     style: TextStyle(
                //       fontSize: 22.sp,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
                // RatingBar.builder(
                //   initialRating: 3,
                //   itemCount: 5,
                //   minRating: 1,
                //   direction: Axis.horizontal,
                //   allowHalfRating: true,
                //   itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                //   itemBuilder: (context, _) => const Icon(
                //     Icons.star,
                //     color: Pallete.brownColor,
                //   ),
                //   onRatingUpdate: (rating) {
                //     // productDetailsServices.rateProduct(
                //     //   context: context,
                //     //   product: widget.product,
                //     //   rating: rating,
                //     // );
                //   },
                // )
              ],
            ),
          );
        },
        error: (error, stactrace) => ErrorText(error: error.toString()),
        loading: () => const Loader(),
      ),
      bottomNavigationBar: Container(
        height: 120.h,
        decoration: BoxDecoration(
          color: currentTheme.textTheme.bodyMedium!.color,
          // borderRadius: BorderRadius.circular(30.r),
        ),
        child: Center(
          child: user.cart.contains(widget.productId)
              ? Container(
                  height: 55.h,
                  width: 200.w,
                  padding: EdgeInsets.all(7.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: currentTheme.backgroundColor,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // remove
                      BButton(
                        onTap: () => removeFromCart(context, user.uid),
                        height: 30.h,
                        width: 30.h,
                        color: currentTheme.backgroundColor,
                        isText: false,
                        item: Icon(
                          PhosphorIcons.minusBold,
                          color: currentTheme.textTheme.bodyMedium!.color,
                        ),
                      ),

                      Builder(
                        builder: (context) {
                          int count = user.cart
                              .where((item) => item == widget.productId)
                              .length;
                          return Text(
                            count.toString(),
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                              color: currentTheme.backgroundColor,
                            ),
                          );
                        },
                      ),

                      //! add
                      BButton(
                        onTap: () => addToCart(context, user.uid),
                        height: 30.h,
                        width: 30.h,
                        color: currentTheme.backgroundColor,
                        isText: false,
                        item: Icon(
                          PhosphorIcons.plusBold,
                          color: currentTheme.textTheme.bodyMedium!.color,
                        ),
                      ),
                    ],
                  ),
                )
              : isLoading
                  ? const Loader()
                  : BButton(
                      onTap: () => addToCart(context, user.uid),
                      width: 200.w,
                      height: 55.h,
                      color: currentTheme.backgroundColor,
                      text: 'Add to cart',
                      textColor: currentTheme.textTheme.bodyMedium!.color,
                    ),
        ),
      ),
    );
  }
}

// class BuyerProductDetailsView extends ConsumerWidget {
//   final String productId;
//   const BuyerProductDetailsView({
//     super.key,
//     required this.productId,
//   });

//   void addToCart(WidgetRef ref, BuildContext context) {
//     ref
//         .read(cartControllerProvider.notifier)
//         .addToCart(context: context, productId: productId);
//   }

//   void removeFromCart(WidgetRef ref, BuildContext context) {
//     ref
//         .read(cartControllerProvider.notifier)
//         .removeFromCart(context: context, productId: productId);
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final currentTheme = ref.watch(themeNotifierProvider);
//     final user = ref.watch(userProvider)!;
//     final productDetailStream = ref.watch(getProductDetailsProvider(productId));
//     final isLoading = ref.read(cartControllerProvider);
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(60),
//         child: AppBar(
//           elevation: 0,
//           backgroundColor: currentTheme.backgroundColor,
//           flexibleSpace: Container(
//             decoration: const BoxDecoration(
//               color: Colors.transparent,
//             ),
//           ),
//           centerTitle: true,
//           title: Text(
//             'Details',
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(
//               color: currentTheme.textTheme.bodyMedium!.color,
//               // fontSize: 14.sp,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           actions: [
//             InkWell(
//               onTap: () {},
//               child: Icon(
//                 PhosphorIcons.magnifyingGlassBold,
//                 size: 26.sp,
//               ),
//             ),
//             10.sbW,
//             InkWell(
//               onTap: () {},
//               child: Icon(
//                 PhosphorIcons.shoppingCartBold,
//                 size: 26.sp,
//               ),
//             ),
//             10.sbW,
//           ],
//         ),
//       ),
//       body: productDetailStream.when(
//         data: (product) {
//           return SingleChildScrollView(
//             // physics: const AlwaysScrollableScrollPhysics(
//             //   parent: BouncingScrollPhysics(),
//             // ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 10.sbH,
//                 Padding(
//                   padding: 15.padH,
//                   child: Row(
//                     children: [
//                       Text(
//                         'Product ID: ',
//                         overflow: TextOverflow.ellipsis,
//                         style: TextStyle(
//                             fontSize: 14.sp, fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(
//                         width: 250.w,
//                         child: Text(
//                           product.id,
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyle(
//                             fontSize: 14.sp,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 10.sbH,
//                 Padding(
//                   padding: 15.padH,
//                   child: Row(
//                     children: [
//                       Text(
//                         'Vendor: ',
//                         overflow: TextOverflow.ellipsis,
//                         style: TextStyle(
//                             fontSize: 14.sp, fontWeight: FontWeight.bold),
//                       ),
//                       Consumer(
//                         builder: (context, ref, child) {
//                           return ref
//                               .read(getUserProvider(product.sellerId))
//                               .when(
//                                 data: (seller) => SizedBox(
//                                   width: 250.w,
//                                   child: Text(
//                                     seller.name,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: TextStyle(
//                                       fontSize: 14.sp,
//                                     ),
//                                   ),
//                                 ),
//                                 error: (error, stactrace) =>
//                                     ErrorText(error: error.toString()),
//                                 loading: () => const Loader(),
//                               );
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//                 10.sbH,
//                 Padding(
//                   padding: 15.padH,
//                   child: Text(
//                     product.name,
//                     style: TextStyle(
//                       fontSize: 19.sp,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 CarouselSlider(
//                   items: product.images.map(
//                     (i) {
//                       return Builder(
//                         builder: (BuildContext context) => Image.network(
//                           i,
//                           fit: BoxFit.contain,
//                           height: 200.h,
//                         ),
//                       );
//                     },
//                   ).toList(),
//                   options: CarouselOptions(
//                     aspectRatio: 2.0,
//                     enlargeCenterPage: true,
//                     autoPlay: true,
//                     viewportFraction: 1,
//                     height: 300.h,
//                   ),
//                 ),
//                 10.sbH,

//                 Padding(
//                   padding: 15.padH,
//                   child: RichText(
//                     text: TextSpan(
//                       text: 'Price: ',
//                       style: TextStyle(
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.bold,
//                         color: currentTheme.textTheme.bodyMedium!.color,
//                       ),
//                       children: [
//                         TextSpan(
//                           text: '${AppTexts.naira}${product.price}',
//                           style: TextStyle(
//                             fontSize: 18.sp,
//                             fontWeight: FontWeight.w500,
//                             color: Pallete.blueColor,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 10.sbH,
//                 Padding(
//                   padding: 15.padH,
//                   child: Text(product.description),
//                 ),
//                 20.sbH,
//                 //! free shipping
//                 Padding(
//                   padding: 15.padH,
//                   child: Container(
//                     padding: EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: Pallete.blueColor,
//                       borderRadius: BorderRadius.circular(10.r),
//                     ),
//                     child: Text(
//                       'Free shipping*',
//                       style: TextStyle(
//                           color: Pallete.whiteColor,
//                           fontWeight: FontWeight.w600),
//                     ),
//                   ),
//                 ),
//                 30.sbH,

//                 // Padding(
//                 //   padding: EdgeInsets.symmetric(
//                 //     horizontal: 8.w,
//                 //     vertical: 8.h,
//                 //   ),
//                 //   child: Text(
//                 //     'Rate The Product',
//                 //     style: TextStyle(
//                 //       fontSize: 22.sp,
//                 //       fontWeight: FontWeight.bold,
//                 //     ),
//                 //   ),
//                 // ),
//                 // RatingBar.builder(
//                 //   initialRating: 3,
//                 //   itemCount: 5,
//                 //   minRating: 1,
//                 //   direction: Axis.horizontal,
//                 //   allowHalfRating: true,
//                 //   itemPadding: const EdgeInsets.symmetric(horizontal: 4),
//                 //   itemBuilder: (context, _) => const Icon(
//                 //     Icons.star,
//                 //     color: Pallete.brownColor,
//                 //   ),
//                 //   onRatingUpdate: (rating) {
//                 //     // productDetailsServices.rateProduct(
//                 //     //   context: context,
//                 //     //   product: widget.product,
//                 //     //   rating: rating,
//                 //     // );
//                 //   },
//                 // )
//               ],
//             ),
//           );
//         },
//         error: (error, stactrace) => ErrorText(error: error.toString()),
//         loading: () => const Loader(),
//       ),
//       bottomNavigationBar: Container(
//         height: 120.h,
//         decoration: BoxDecoration(
//             color: currentTheme.textTheme.bodyMedium!.color,
//             borderRadius: BorderRadius.circular(30.r)),
//         child: Center(
//           child: user.cart.contains(productId)
//               ? InkWell(
//                   onTap: () => removeFromCart(ref, context),
//                   child: Container(
//                     height: 40,
//                     width: 40,
//                     color: Colors.red,
//                   ),
//                 )
//               : isLoading
//                   ? const Loader()
//                   : BButton(
//                       onTap: () => addToCart(ref, context),
//                       width: 200.w,
//                       height: 55.h,
//                       color: currentTheme.backgroundColor,
//                       text: 'Add to cart',
//                     ),
//         ),
//       ),
//     );
//   }
// }
