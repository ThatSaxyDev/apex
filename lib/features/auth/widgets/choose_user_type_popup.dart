import 'package:apex/features/auth/controller/auth_controller.dart';
import 'package:apex/theme/palette.dart';
import 'package:apex/utils/button.dart';
import 'package:apex/utils/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ChooseUserTypePopUp extends ConsumerWidget {
  final Animation<double> a1;
  final Animation<double> a2;
  const ChooseUserTypePopUp({
    super.key,
    required this.a1,
    required this.a2,
  });

  void signInWithGoogle(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider.notifier).signInWithGoogle(context);
  }

  void signInWithGoogleSeller(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider.notifier).signInWithGoogleSeller(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final currentTheme = ref.watch(themeNotifierProvider);
    return Dialog(
      elevation: 65.0.h,
      backgroundColor: Colors.transparent,
      child: Container(
        //! USE ANIMATION DOUBLE VALUES TO ANIMATE DIALOGUE
        height: 240.h * a1.value,
        width: 280.w * a2.value,
        padding: EdgeInsets.all(25.w),
        decoration: BoxDecoration(
          color: currentTheme.backgroundColor,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(PhosphorIcons.xBold),
                  ),
                ),
                12.sbH,
                Text(
                  'You can join communites here, or by searching, or applying to create one',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
                25.sbH,
                BButton(
                  onTap: () {
                    // Navigator.of(context).pop();
                  },
                  width: 150.h,
                  text: 'Join',
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Apply',
                    style: TextStyle(
                      color: currentTheme.textTheme.bodyMedium!.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
