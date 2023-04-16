// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:apex/features/seller/features/products/controllers/product_controller.dart';
import 'package:apex/models/product_model.dart';
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

import 'package:apex/theme/palette.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:routemaster/routemaster.dart';

class SellerProductDetails extends ConsumerWidget {
  final String productId;
  const SellerProductDetails({
    super.key,
    required this.productId,
  });

  void addToProductQuantitySeller(
    ProductModel product,
    WidgetRef ref,
    BuildContext context,
  ) {
    ref
        .read(productControllerProvider.notifier)
        .addToProductQuantitySeller(product);
  }

  void reduceFromProductQuantitySeller(
    ProductModel product,
    WidgetRef ref,
    BuildContext context,
  ) {
    ref
        .read(productControllerProvider.notifier)
        .reduceFromProductQuantitySeller(product);
  }

  void deleteProduct(
      WidgetRef ref, BuildContext context, ProductModel product) {
    ref
        .read(productControllerProvider.notifier)
        .deleteProduct(context: context, product: product);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);
    final productDetailStream = ref.watch(getProductDetailsProvider(productId));
    return productDetailStream.when(
      data: (product) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Details',
              style: TextStyle(
                color: currentTheme.textTheme.bodyMedium!.color,
              ),
            ),
          ),
          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                10.sbH,
                Padding(
                  padding: 15.padH,
                  child: Wrap(
                    children: [
                      Text(
                        product.id,
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ],
                  ),
                ),
                10.sbH,
                Padding(
                  padding: 15.padH,
                  child: const Stars(rating: 3),
                ),
                10.sbH,
                Padding(
                  padding: EdgeInsets.only(
                    left: 15.w,
                  ),
                  child: Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                10.sbH,
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
                        // color: Colors.black,
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
                10.sbH,
                Divider(
                  thickness: 3,
                  color: Pallete.blueColor.withOpacity(0.5),
                ),
                10.sbH,
                Padding(
                  padding: 15.padH,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Quantity: ',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            // color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: product.quantity.toString(),
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                                color: Pallete.blueColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          //! add
                          BButton(
                            onTap: () => addToProductQuantitySeller(
                                product, ref, context),
                            width: 40.w,
                            isText: false,
                            item: const Icon(PhosphorIcons.plusBold),
                          ),
                          15.sbW,
                          //! remove
                          BButton(
                            onTap: () => reduceFromProductQuantitySeller(
                                product, ref, context),
                            width: 40.w,
                            isText: false,
                            item: const Icon(PhosphorIcons.minusBold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                50.sbH,
                Align(
                  alignment: Alignment.center,
                  child: BButton(
                    onTap: () {
                      Routemaster.of(context).pop();
                      deleteProduct(ref, context, product);
                    },
                    color: Pallete.thickRed,
                    width: 200.w,
                    isText: false,
                    item: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          PhosphorIcons.trashBold,
                          color: Pallete.whiteColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      error: (error, stactrace) => ErrorText(error: error.toString()),
      loading: () => const Loader(),
    );
  }
}
