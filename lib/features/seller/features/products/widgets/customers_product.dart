// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:apex/features/seller/features/products/controllers/product_controller.dart';
import 'package:apex/theme/palette.dart';
import 'package:apex/utils/app_texts.dart';
import 'package:apex/utils/string_extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:apex/models/product_model.dart';
import 'package:apex/utils/widget_extensions.dart';
import 'package:routemaster/routemaster.dart';

class CustomersProduct extends ConsumerWidget {
  final ProductModel product;
  final int index;
  const CustomersProduct({
    super.key,
    required this.product,
    required this.index,
  });

  void navigateToProductDetails(BuildContext context) {
    Routemaster.of(context).push('/product-details/${product.id}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);
    return InkWell(
      onTap: () => navigateToProductDetails(context),
      child: SizedBox(
        height: 200.h,
        width: 200.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              // height: 140.h,
              // width: 140.w,
              child: Container(
                height: double.infinity,
                width: double.infinity,
                margin: index % 2 == 0
                    ? EdgeInsets.only(left: 24.w, right: 12.w)
                    : EdgeInsets.only(right: 24.w, left: 12.w),
                decoration: BoxDecoration(
                  color: currentTheme.backgroundColor,
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(width: 0.5.w),
                ),
                child: CachedNetworkImage(
                  imageUrl: product.images[0],
                  placeholder: (context, url) => Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black12.withOpacity(0.1),
                          Colors.black12.withOpacity(0.1),
                          Colors.black26,
                          Colors.black26,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                  )
                      .animate(onPlay: (controller) => controller.repeat())
                      .shimmer(duration: 1200.ms),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error),
                ),
              ),
            ),
            15.sbH,
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: index % 2 == 0
                    ? EdgeInsets.only(left: 24.w, right: 12.w)
                    : EdgeInsets.only(right: 24.w, left: 12.w),
                child: Text(
                  product.name,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            7.sbH,
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: index % 2 == 0
                    ? EdgeInsets.only(left: 24.w, right: 12.w)
                    : EdgeInsets.only(right: 24.w, left: 12.w),
                child: Text(
                  '${AppTexts.naira} ${product.price}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
