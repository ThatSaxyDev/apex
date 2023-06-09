// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:apex/features/seller/features/products/controllers/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:apex/models/product_model.dart';
import 'package:apex/utils/widget_extensions.dart';
import 'package:routemaster/routemaster.dart';

class SellerProduct extends ConsumerWidget {
  final ProductModel product;
  final int index;
  const SellerProduct({
    super.key,
    required this.product,
    required this.index,
  });

  void deleteProduct(WidgetRef ref, BuildContext context) {
    ref.read(productControllerProvider.notifier).deleteProduct(context: context, product: product);
  }

  void navigateToProductDetails(BuildContext context) {
    Routemaster.of(context).push('/product-details/${product.id}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              child: Padding(
                padding: index % 2 == 0
                    ? EdgeInsets.only(left: 24.w, right: 12.w)
                    : EdgeInsets.only(right: 24.w, left: 12.w),
                child: PhysicalModel(
                  color: Colors.white,
                  elevation: 15,
                  borderRadius: BorderRadius.circular(15.r),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.r),
                    child: Image.network(
                      product.images[0],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            10.sbH,
            Padding(
              padding: index % 2 == 0
                  ? EdgeInsets.only(left: 24.w, right: 12.w)
                  : EdgeInsets.only(right: 24.w, left: 12.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  17.sbW,
                  InkWell(
                    onTap: () => deleteProduct(ref, context),
                    child: const Icon(
                      PhosphorIcons.trashBold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
