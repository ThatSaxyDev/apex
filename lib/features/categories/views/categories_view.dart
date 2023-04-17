import 'package:apex/features/auth/controller/auth_controller.dart';
import 'package:apex/features/profile/widgets/profile_tile.dart';
import 'package:apex/theme/palette.dart';
import 'package:apex/utils/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:routemaster/routemaster.dart';

class CategoriesView extends ConsumerWidget {
  const CategoriesView({super.key});

  void navigateToCategory(BuildContext context, String categoryName) {
    Routemaster.of(context).push('/category/$categoryName');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);
    final user = ref.watch(userProvider)!;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          elevation: 0,
          backgroundColor: currentTheme.backgroundColor,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
          ),
          centerTitle: true,
          title: Text(
            'Categories',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: currentTheme.textTheme.bodyMedium!.color,
              // fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          24.sbH,
          Column(
            children: profileItems
                .map(
                  (e) => ProfileTile(
                    onTap: () {
                      navigateToCategory(context, e.title);
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
        ],
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
    icon: PhosphorIcons.phoneBold,
    title: 'Mobiles',
    isSwitch: false,
    isLogout: false,
    isReactive: false,
  ),
  ProfileItem(
    icon: PhosphorIcons.cookingPotBold,
    title: 'Essentials',
    isSwitch: false,
    isLogout: false,
    isReactive: false,
  ),
  ProfileItem(
    icon: PhosphorIcons.televisionBold,
    title: 'Appliances',
    isSwitch: false,
    isLogout: false,
    isReactive: false,
  ),
  ProfileItem(
    icon: PhosphorIcons.booksBold,
    title: 'Books',
    isSwitch: false,
    isLogout: false,
    isReactive: false,
  ),
  ProfileItem(
    icon: PhosphorIcons.tShirtBold,
    title: 'Fashion',
    isSwitch: false,
    isLogout: false,
    isReactive: false,
  ),
];
