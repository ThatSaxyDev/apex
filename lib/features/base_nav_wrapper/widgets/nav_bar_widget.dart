// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:apex/theme/palette.dart';
import 'package:apex/utils/string_extensions.dart';
import 'package:apex/utils/widget_extensions.dart';

class NavBarWidget extends ConsumerWidget {
  final IconData icon;
  final Color? color;
  final Color? iconColor;
  final String label;
  final FontWeight? fontWeight;
  final void Function()? onTap;
  const NavBarWidget({
    super.key,
    required this.icon,
    this.color,
    this.iconColor,
    required this.label,
    this.fontWeight,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: SizedBox(
        width: 100.w,
        child: Column(
          children: [
            //! ICON
            Icon(
              icon,
              size: 24.w,
              color: color ?? currentTheme.textTheme.bodyMedium!.color,
            ),

            //! SPACER
            5.sbH,

            //! LABEL
            Text(
              label,
              style: TextStyle(
                fontWeight: fontWeight ?? FontWeight.w500,
                fontSize: 13.sp,
                color: color ?? currentTheme.textTheme.bodyMedium!.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
