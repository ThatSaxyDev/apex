import 'package:apex/features/auth/controller/auth_controller.dart';
import 'package:apex/features/base_nav_wrapper/widgets/nav_bar_widget.dart';
import 'package:apex/features/home/dummy_home.dart';
import 'package:apex/features/seller/features/products/views/products_view.dart';
import 'package:apex/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SellerBaseNavWrapper extends ConsumerStatefulWidget {
  const SellerBaseNavWrapper({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SellerBaseNavWrapperState();
}

class _SellerBaseNavWrapperState extends ConsumerState<SellerBaseNavWrapper> {
  List<Widget> pages = [
   ProductsView(),
    Center(
      child: Text('Analytics'),
    ),
    DummyHome(),
  ];

  final ValueNotifier<int> _page = ValueNotifier(0);

  void logOut(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logOut();
  }

  @override
  void initState() {
    super.initState();
    _page.value = 0;
  }

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);
    return Scaffold(
      // pages
      body: ValueListenableBuilder(
        valueListenable: _page,
        builder: (context, value, child) => pages[_page.value],
      ),

      // nav bar
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: _page,
        builder: (context, value, child) => Material(
          elevation: 5,
          // nav bar content
          child: Container(
            color: currentTheme.backgroundColor,
            padding: EdgeInsets.only(top: 17.h, left: 7.w, right: 7.w),
            height: 80.h,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //! Notes
                NavBarWidget(
                  onTap: () => _page.value = 0,
                  icon: PhosphorIcons.houseBold,
                  label: 'Products',
                  color: _page.value == 0 ? Pallete.blueColor : null,
                  fontWeight: _page.value == 0 ? FontWeight.w600 : null,
                ),

                //! Insights
                NavBarWidget(
                  onTap: () => _page.value = 1,
                  icon: PhosphorIcons.graphBold,
                  label: 'Analytics',
                  iconColor: _page.value == 1 ? Pallete.blueColor : null,
                  color: _page.value == 1 ? Pallete.blueColor : null,
                  fontWeight: _page.value == 1 ? FontWeight.w600 : null,
                ),

                //! Home
                NavBarWidget(
                  onTap: () => _page.value = 2,
                  icon: PhosphorIcons.gearBold,
                  label: 'Settings',
                  color: _page.value == 2 ? Pallete.blueColor : null,
                  fontWeight: _page.value == 2 ? FontWeight.w600 : null,
                ),

                // //! Help
                // NavBarWidget(
                //   onTap: () => _page.value = 3,
                //   icon: _page.value == 3 ? 'help-filled' : 'help',
                //   label: 'Help',
                //   color: _page.value == 3 ? Pallete.blueColor : null,
                //   fontWeight: _page.value == 3 ? FontWeight.w600 : null,
                // ),

                // //! Profile
                // NavBarWidget(
                //   onTap: () => _page.value = 4,
                //   icon: _page.value == 4 ? 'profile-selected' : 'profile',
                //   label: 'Profile',
                //   color: _page.value == 4 ? Pallete.blueColor : null,
                //   fontWeight: _page.value == 4 ? FontWeight.w600 : null,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
