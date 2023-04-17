import 'package:apex/features/auth/controller/auth_controller.dart';
import 'package:apex/features/profile/widgets/profile_tile.dart';
import 'package:apex/theme/palette.dart';
import 'package:apex/utils/app_fade_animation.dart';
import 'package:apex/utils/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:routemaster/routemaster.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  void logOut(WidgetRef ref) async {
    ref.read(authControllerProvider.notifier).logOut();
  }

  void navigateToUpdateAddress(BuildContext context) {
    Routemaster.of(context).push('/update-address');
  }

  void navigateToCart(BuildContext context) {
    Routemaster.of(context).push('/cart');
  }

  void navigateToOrders(BuildContext context) {
    Routemaster.of(context).push('/orders');
  }

  void showlogOutDialog(WidgetRef ref, BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Please Confirm'),
            content: const Text('Are you sure you want to log out'),
            actions: [
              TextButton(
                onPressed: () {
                  Routemaster.of(context).pop();
                  logOut(ref);
                },
                child: const Text(
                  'Yes',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Routemaster.of(context).pop();
                },
                child: const Text(
                  'No',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final currentTheme = ref.watch(themeNotifierProvider);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            71.sbH,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 20.sbH,
                      //! header
                      Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      8.sbH,
                      Text(
                        '',
                        style: TextStyle(
                          color: Pallete.blackColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  40.sbW,
                ],
              ),
            ),

            // ! profile photo and name
            Row(
              children: [
                24.sbW,
                CircleAvatar(
                  radius: 25.w,
                  backgroundColor: Pallete.greyColor,
                  backgroundImage: NetworkImage(user.profilePic),
                ),
                15.sbW,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    7.sbH,
                    Text(
                      user.email,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            24.sbH,

            Column(
              children: profileItems
                  .map(
                    (e) => ProfileTile(
                      onTap: () {
                        switch (e.title) {
                          case 'Address':
                            navigateToUpdateAddress(context);
                            break;

                          case 'Cart':
                            navigateToCart(context);
                            break;

                          case 'Orders':
                            navigateToOrders(context);
                            break;
                        }
                      },
                      icon: e.icon,
                      title: e.title,
                      isSwitch: e.isSwitch,
                      isLogout: e.isLogout,
                      isReactive: e.isReactive,
                    ),
                  )
                  .toList(),
            ),
            60.sbH,

            ProfileTile(
              onTap: () => showlogOutDialog(ref, context),
              icon: PhosphorIcons.signOutBold,
              title: 'Log out',
              isLogout: true,
              isSwitch: false,
            ),
            30.sbH,
          ],
        ),
      ),
    );
  }
}

class ProfileItem {
  final IconData icon;
  final String title;
  final bool isSwitch;
  final bool isLogout;
  final bool isReactive;
  const ProfileItem({
    required this.icon,
    required this.title,
    required this.isSwitch,
    required this.isLogout,
    required this.isReactive,
  });
}

const profileItems = [
  ProfileItem(
    icon: PhosphorIcons.addressBook,
    title: 'Address',
    isSwitch: false,
    isLogout: false,
    isReactive: false,
  ),
  ProfileItem(
    icon: PhosphorIcons.shoppingCart,
    title: 'Cart',
    isSwitch: false,
    isLogout: false,
    isReactive: true,
  ),
  ProfileItem(
    icon: PhosphorIcons.shoppingBag,
    title: 'Orders',
    isSwitch: false,
    isLogout: false,
    isReactive: true,
  ),
  ProfileItem(
    icon: PhosphorIcons.moonStars,
    title: 'Dark Theme',
    isSwitch: true,
    isLogout: false,
    isReactive: false,
  ),
  // ProfileItem(
  //   icon: PhosphorIcons.appWindow,
  //   title: 'Community Creation Approval',
  //   isSwitch: false,
  //   isLogout: false,
  //   isReactive: false,
  // ),
];
