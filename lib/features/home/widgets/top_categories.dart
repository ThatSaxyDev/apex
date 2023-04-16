// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:apex/theme/palette.dart';
import 'package:apex/utils/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class TopCategories extends ConsumerWidget {
  const TopCategories({Key? key}) : super(key: key);

  void navigateToCategoryPage(BuildContext context, String category) {
    // Navigator.pushNamed(context, CategoryDealsScreen.routeName,
    //     arguments: category);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);
    return SizedBox(
      height: 62.h,
      child: Padding(
        padding: 10.padH,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: categoryIcons
              .map((e) => InkWell(
                    onTap: () {},
                    child: SizedBox(
                      width: 70.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                currentTheme.textTheme.bodyMedium!.color,
                            radius: 20.w,
                            child: Icon(
                              e.icon,
                              color: currentTheme.backgroundColor,
                            ),
                          ),
                          Text(
                            e.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class CategoryIcon {
  final String title;
  final IconData icon;
  const CategoryIcon({
    required this.title,
    required this.icon,
  });
}

List<CategoryIcon> categoryIcons = [
  CategoryIcon(title: 'Mobiles', icon: PhosphorIcons.phoneBold),
  CategoryIcon(title: 'Essentials', icon: PhosphorIcons.cookingPotBold),
  CategoryIcon(title: 'Appliances', icon: PhosphorIcons.televisionBold),
  CategoryIcon(title: 'Books', icon: PhosphorIcons.booksBold),
  CategoryIcon(title: 'Fashion', icon: PhosphorIcons.tShirtBold),
];
