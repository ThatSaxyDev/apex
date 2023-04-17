// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:apex/features/auth/controller/auth_controller.dart';
import 'package:apex/utils/error_text.dart';
import 'package:apex/utils/loader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:routemaster/routemaster.dart';

import 'package:apex/theme/palette.dart';
import 'package:apex/utils/string_extensions.dart';
import 'package:apex/utils/widget_extensions.dart';

class ProfileTile extends ConsumerWidget {
  final IconData icon;
  final String title;
  final bool? isSwitch;
  final bool? isLogout;
  final Color? iconColor;
  final void Function()? onTap;
  final void Function(bool)? onHover;
  final bool? isReactive;
  const ProfileTile({
    super.key,
    required this.icon,
    required this.title,
    this.isSwitch = true,
    this.isLogout = true,
    this.onTap,
    this.iconColor,
    this.onHover,
    this.isReactive,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);
    final user = ref.watch(userProvider)!;

    void toggleTheme(WidgetRef ref) {
      ref.read(themeNotifierProvider.notifier).toggleTheme();
    }

    return InkWell(
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      onHover: onHover,
      child: Container(
        height: 60.h,
        padding: EdgeInsets.only(left: 11.w, right: 19.43.h),
        margin: EdgeInsets.only(bottom: 16.h, left: 24.w, right: 24.w),
        decoration: BoxDecoration(
            color: currentTheme.backgroundColor,
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(width: 0.5.w)),
        child: Row(
          children: [
            Icon(
              icon,
              size: 25.w,
              color: isLogout == true
                  ? Pallete.thickRed
                  : isLogout == false
                      ? iconColor
                      : currentTheme.textTheme.bodyMedium!.color,
            ),
            13.5.sbW,
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Spacer(),
            isSwitch == true
                ? Switch.adaptive(
                    value: ref.watch(themeNotifierProvider.notifier).mode ==
                        ThemeMode.dark,
                    onChanged: (val) => toggleTheme(ref),
                  )
                : title == 'Cart'
                    ? Builder(
                        builder: (context) {
                          Set uniqueElements = Set<String>.from(user.cart);

                          int count = uniqueElements.length;

                          if (user.cart.isEmpty) {
                            return Icon(Icons.arrow_forward_ios_rounded,
                                size: 17.h);
                          }

                          return CircleAvatar(
                            radius: 15.w,
                            backgroundColor:
                                currentTheme.textTheme.bodyMedium!.color,
                            child: CircleAvatar(
                              radius: 13.w,
                              backgroundColor: currentTheme.backgroundColor,
                              child: Text(
                                count.toString(),
                                style: TextStyle(
                                  color:
                                      currentTheme.textTheme.bodyMedium!.color,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    // : title == 'Community Creation Approval'
                    //     ? ref.watch(getPending).when(
                    //           data: (data) {
                    //             int number = data.length;
                    //             if (data.isEmpty) {
                    //               return Icon(Icons.arrow_forward_ios_rounded,
                    //                   size: 17.h);
                    //             }
                    //             return CircleAvatar(
                    //               backgroundColor: Pallete.blueColor,
                    //               radius: 14.h,
                    //               child: Text(
                    //                 '$number',
                    //                 style: TextStyle(
                    //                   color: Pallete.whiteColor,
                    //                   fontWeight: FontWeight.w600,
                    //                   fontSize: 17.sp,
                    //                 ),
                    //               ),
                    //             );
                    //           },
                    //           error: (error, stackTrace) {
                    //             if (kDebugMode) print(error);
                    //             return ErrorText(error: error.toString());
                    //           },
                    //           loading: () => const Loader(),
                    //         )
                    : Icon(Icons.arrow_forward_ios_rounded, size: 17.h),
          ],
        ),
      ),
    );
  }
}
