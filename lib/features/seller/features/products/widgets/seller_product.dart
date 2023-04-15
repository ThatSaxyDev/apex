// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:apex/utils/widget_extensions.dart';

class SellerProduct extends StatefulWidget {
  final VoidCallback onTap;
  final String productImage;
  final String productName;
  final VoidCallback onDelete;
  final int index;
  const SellerProduct({
    Key? key,
    required this.onTap,
    required this.productImage,
    required this.productName,
    required this.onDelete,
    required this.index,
  }) : super(key: key);

  @override
  State<SellerProduct> createState() => _SellerProductState();
}

class _SellerProductState extends State<SellerProduct> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
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
                padding: widget.index % 2 == 0
                    ? EdgeInsets.only(left: 24.w, right: 12.w)
                    : EdgeInsets.only(right: 24.w, left: 12.w),
                child: PhysicalModel(
                  color: Colors.white,
                  elevation: 15,
                  borderRadius: BorderRadius.circular(15.r),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.r),
                    child: Image.network(
                      widget.productImage,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            10.sbH,
            Padding(
              padding: widget.index % 2 == 0
                  ? EdgeInsets.only(left: 24.w, right: 12.w)
                  : EdgeInsets.only(right: 24.w, left: 12.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.productName,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  17.sbW,
                  InkWell(
                    onTap: widget.onDelete,
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
