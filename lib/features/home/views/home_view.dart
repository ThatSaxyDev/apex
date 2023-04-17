import 'package:apex/features/auth/controller/auth_controller.dart';
import 'package:apex/features/home/widgets/address_box.dart';
import 'package:apex/features/home/widgets/carousel_image.dart';
import 'package:apex/features/home/widgets/deat_of_the_day.dart';
import 'package:apex/features/home/widgets/search_bar.dart';
import 'package:apex/features/home/widgets/top_categories.dart';
import 'package:apex/features/seller/features/products/controllers/product_controller.dart';
import 'package:apex/features/seller/features/products/widgets/customers_product.dart';
import 'package:apex/features/seller/features/products/widgets/seller_product.dart';
import 'package:apex/theme/palette.dart';
import 'package:apex/utils/error_text.dart';
import 'package:apex/utils/loader.dart';
import 'package:apex/utils/string_extensions.dart';
import 'package:apex/utils/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:routemaster/routemaster.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  void navigateToCart(BuildContext context) {
    Routemaster.of(context).push('/cart');
  }

  void navigateToUpdateAddress(BuildContext context) {
    Routemaster.of(context).push('/update-address');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);
    final productsStream = ref.watch(getAllProductsProvider);
    final user = ref.watch(userProvider)!;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: currentTheme.backgroundColor,
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
          ),
          title: const SearchBar(),
          actions: [
            10.sbW,
            SizedBox(
              height: 30.h,
              width: 40.w,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () => navigateToCart(context),
                      child: Icon(
                        PhosphorIcons.shoppingCartBold,
                        size: 26.sp,
                      ),
                    ),
                  ),
                  Builder(
                    builder: (context) {
                      Set uniqueElements = Set<String>.from(user.cart);

                      int count = uniqueElements.length;

                      if (user.cart.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      return Positioned(
                        right: 0,
                        top: 5.h,
                        child: CircleAvatar(
                          radius: 10.w,
                          backgroundColor:
                              currentTheme.textTheme.bodyMedium!.color,
                          child: CircleAvatar(
                            radius: 8.w,
                            backgroundColor: currentTheme.backgroundColor,
                            child: Text(
                              count.toString(),
                              style: TextStyle(
                                color: currentTheme.textTheme.bodyMedium!.color,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            10.sbW,
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        child: Column(
          children: [
            InkWell(
              onTap: () => navigateToUpdateAddress(context),
              child: const AddressBox(),
            ),
            10.sbH,
            const CarouselImage(),

            20.sbH,
            const TopCategories(),
            20.sbH,
            Padding(
              padding: 20.padH,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Deals',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            20.sbH,
            productsStream.when(
              data: (products) {
                if (products.isEmpty) {
                  return SizedBox(
                    height: 200.h,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 150.h,
                            child: Image.asset('empty'.png),
                          ),
                          15.sbH,
                          Text(
                            'You have no products for sale!',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, index) {
                    final productData = products[index];
                    return Column(
                      children: [
                        CustomersProduct(
                          product: productData,
                          index: index,
                        ),
                      ],
                    );
                  },
                );
              },
              error: (error, stactrace) => ErrorText(error: error.toString()),
              loading: () => const Loader(),
            ),

            // const DealOfTheDay(),

            15.sbH,
            // const KeepShopping(),
          ],
        ),
      ),
    );
  }
}
