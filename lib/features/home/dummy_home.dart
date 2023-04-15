import 'package:apex/features/auth/controller/auth_controller.dart';
import 'package:apex/features/profile/controllers/profile_controller.dart';
import 'package:apex/theme/palette.dart';
import 'package:apex/utils/button.dart';
import 'package:apex/utils/loader.dart';
import 'package:apex/utils/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DummyHome extends ConsumerWidget {
  const DummyHome({super.key});

  void updateProfile(BuildContext context, WidgetRef ref, String type) {
    ref
        .read(userProfileControllerProvider.notifier)
        .setUserType(context: context, type: type);
  }

  void logOut(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logOut();
  }

  void toggleTheme(WidgetRef ref) {
    ref.read(themeNotifierProvider.notifier).toggleTheme();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isLoading = ref.watch(userProfileControllerProvider);
    // return Scaffold(
    //   body: user.userType.isEmpty
    //       ? isLoading
    //           ? const Loader()
    //           : SizedBox(
    //               height: height(context),
    //               width: width(context),
    //               child: Center(
    //                 child: Column(
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: [
    //                     Text(
    //                       'Are you a',
    //                       textAlign: TextAlign.center,
    //                       style: TextStyle(
    //                         fontWeight: FontWeight.w800,
    //                         fontSize: 30.sp,
    //                       ),
    //                     ),
    //                     20.sbH,
    //                     //! buyer
    //                     BButton(
    //                       onTap: () => updateProfile(context, ref, 'buyer'),
    //                       width: 300.w,
    //                       text: 'Buyer',
    //                     ),
    //                     10.sbH,
    //                     Text(
    //                       'or',
    //                       textAlign: TextAlign.center,
    //                       style: TextStyle(
    //                         fontWeight: FontWeight.w800,
    //                         fontSize: 20.sp,
    //                       ),
    //                     ),
    //                     10.sbH,
    //                     BButton(
    //                       onTap: () => updateProfile(context, ref, 'seller'),
    //                       width: 300.w,
    //                       text: 'Seller',
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             )
    //       : Center(
    //           child: Text(
    //             user.name,
    //           ),
    //         ),
    // );
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BButton(
              onTap: () => logOut(ref),
              text: 'Log out',
            ),
            Switch.adaptive(
              value: ref.watch(themeNotifierProvider.notifier).mode ==
                  ThemeMode.dark,
              onChanged: (val) => toggleTheme(ref),
            )
          ],
        ),
      ),
    );
  }
}
