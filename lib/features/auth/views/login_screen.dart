import 'package:apex/features/auth/controller/auth_controller.dart';
import 'package:apex/theme/palette.dart';
import 'package:apex/utils/button.dart';
import 'package:apex/utils/loader.dart';
import 'package:apex/utils/string_extensions.dart';
import 'package:apex/utils/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:routemaster/routemaster.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

   void signInWithGoogleSeller(BuildContext context, WidgetRef ref) {
    Routemaster.of(context).pop();
    ref.read(authControllerProvider.notifier).signInWithGoogleSeller(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: isLoading
            ? const Loader()
            : Column(
                children: [
                  200.sbH,
                  Text(
                    'Apex',
                    style: TextStyle(fontSize: 30.sp),
                  ),
                  170.sbH,
                  GButton(
                    padding: 10.h,
                    item: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 30.w,
                          child: Image.asset('google'.png),
                        ),
                        15.sbW,
                        Text(
                          'Continue With Google',
                          style: TextStyle(
                              fontSize: 14.sp,
                              color: currentTheme.textTheme.bodyMedium!.color,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  150.sbH,
                  Text(
                    'Are you selling?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 20.sp,
                    ),
                  ),
                  10.sbH,
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) => Wrap(
                          children: [
                            Container(
                              height: 220.h,
                              padding: EdgeInsets.only(
                                  top: 15.h, right: 24.w, left: 24.w),
                              decoration: BoxDecoration(
                                color: currentTheme.backgroundColor,
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(30.r),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                // mainAxisAlignment:
                                //     MainAxisAlignment.spaceBetween,
                                children: [
                                  //! bar
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      height: 3.h,
                                      width: 72.w,
                                      decoration: BoxDecoration(
                                        color: currentTheme
                                            .textTheme.bodyMedium!.color,
                                        borderRadius:
                                            BorderRadius.circular(30.r),
                                      ),
                                    ),
                                  ),
                                  20.sbH,
                                  Text(
                                    'By clicking "Continue", you agree to sign up/in as a seller with your google account',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: currentTheme
                                          .textTheme.bodyMedium!.color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  40.sbH,

                                  TransparentButton(
                                    onTap: () => signInWithGoogleSeller(context, ref),
                                    color: Pallete.greey,
                                    isText: false,
                                    item: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 30.w,
                                          child: Image.asset('google'.png),
                                        ),
                                        15.sbW,
                                        Text(
                                          'Continue',
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              color: currentTheme
                                                  .textTheme.bodyMedium!.color,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Text(
                      'Tap here',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w800,
                        fontSize: 15.sp,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
