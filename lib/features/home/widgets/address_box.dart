import 'package:apex/features/auth/controller/auth_controller.dart';
import 'package:apex/theme/palette.dart';
import 'package:apex/utils/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AddressBox extends ConsumerWidget {
  const AddressBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final currentTheme = ref.watch(themeNotifierProvider);
    return Container(
      height: 40.h,
      decoration: const BoxDecoration(
        // gradient: LinearGradient(
        //   colors: [
        //     Color.fromARGB(255, 114, 226, 221),
        //     Color.fromARGB(255, 162, 236, 233),
        //   ],
        //   stops: [0.5, 1.0],
        // ),
        color: Colors.transparent,
      ),
      padding: EdgeInsets.only(left: 10.w),
      child: Row(
        children: [
          Icon(
            PhosphorIcons.mapPinBold,
            size: 20.sp,
            color: Pallete.blueColor,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 5.w),
              child: Text(
                user.address.isEmpty
                    ? 'Delivery to ${user.name} - Set your address'
                    : 'Delivery to ${user.name} - ${user.address}',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Padding(
            padding: 10.padH,
            child: Icon(
              Icons.arrow_drop_down_outlined,
              size: 24.w,
              color: currentTheme.textTheme.bodyMedium!.color,
            ),
          ),
        ],
      ),
    );
  }
}
