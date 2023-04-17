import 'dart:developer';

import 'package:apex/features/auth/controller/auth_controller.dart';
import 'package:apex/features/orders/controllers/orders_controller.dart';
import 'package:apex/features/seller/features/products/controllers/product_controller.dart';
import 'package:apex/theme/palette.dart';
import 'package:apex/utils/error_text.dart';
import 'package:apex/utils/loader.dart';
import 'package:apex/utils/string_extensions.dart';
import 'package:apex/utils/widget_extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:routemaster/routemaster.dart';

class OrdersView extends ConsumerStatefulWidget {
  const OrdersView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OrdersViewState();
}

class _OrdersViewState extends ConsumerState<OrdersView> {
  final ValueNotifier<bool> isOpenSelected = ValueNotifier(false);
  final PageController _controller = PageController();

  int getNumberOfOpenOrdersNumber(orders) {
    return orders.where((order) => order.status == 'pending').length;
  }

  int getNumberOfClosedOrdersNumber(orders) {
    int num;
    int del = orders.where((order) => order.status == 'delivered').length;
    int notdel = orders.where((order) => order.status == 'notdelivered').length;
    num = del + notdel;
    return num;
  }

  void navigateToOrderDetails(BuildContext context, String orderId) {
    Routemaster.of(context).push('/orders/$orderId');
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);
    final user = ref.watch(userProvider)!;
    final ordersStream = ref.watch(getAllOrdersProvider);
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
            'Orders',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: currentTheme.textTheme.bodyMedium!.color,
              // fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: ordersStream.when(
        data: (orders) {
          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 150.h,
                    child: Image.asset('empty'.png),
                  ),
                  15.sbH,
                  Text(
                    'You have no orders',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }

          //! when "orders", give the pageView
          return ValueListenableBuilder(
            valueListenable: isOpenSelected,
            child: const SizedBox.shrink(),
            builder: (context, value, child) {
              return Column(
                children: [
                  10.sbH,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          isOpenSelected.value = false;
                          isOpenSelected.notifyListeners();
                          _controller.animateToPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                            0,
                          );
                        },
                        child: Text(
                          'Open',
                          style: TextStyle(
                            color: isOpenSelected.value == true
                                ? Pallete.greyColor
                                : currentTheme.textTheme.bodyMedium!.color,
                            fontSize:
                                isOpenSelected.value == true ? 20.sp : 27.sp,
                            fontWeight: isOpenSelected.value == true
                                ? FontWeight.w400
                                : FontWeight.w800,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          isOpenSelected.value = true;
                          isOpenSelected.notifyListeners();
                          _controller.animateToPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                            1,
                          );
                        },
                        child: Text(
                          'Closed',
                          style: TextStyle(
                            color: isOpenSelected.value == true
                                ? currentTheme.textTheme.bodyMedium!.color
                                : Pallete.greyColor,
                            fontSize:
                                isOpenSelected.value == true ? 27.sp : 20.sp,
                            fontWeight: isOpenSelected.value == true
                                ? FontWeight.w800
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  10.sbH,

                  //! orders
                  Expanded(
                    child: PageView(
                      onPageChanged: (value) {
                        if (value == 0) {
                          isOpenSelected.value = false;
                        } else {
                          isOpenSelected.value = true;
                        }
                      },
                      controller: _controller,
                      pageSnapping: true,
                      children: [
                        //! open orders
                        ordersStream.when(
                          data: (orderss) {
                            int pending = getNumberOfOpenOrdersNumber(orderss);

                            if (pending == 0) {
                              return Center(
                                child: Text(
                                  'Nothing here',
                                  style: TextStyle(
                                    color: Pallete.thickRed,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }

                            //! pending orders
                            return ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 22.w)
                                  .copyWith(top: 10.h),
                              itemCount: orderss.length,
                              itemBuilder: (context, index) {
                                final ord = orderss[index];
                                if (ord.status != 'pending') {
                                  return const SizedBox.shrink();
                                }
                                return InkWell(
                                  onTap: () => navigateToOrderDetails(
                                      context, ord.orderId),
                                  child: Container(
                                    height: 100.h,
                                    padding: EdgeInsets.all(15.h),
                                    margin: EdgeInsets.only(bottom: 15.h),
                                    decoration: BoxDecoration(
                                      color: currentTheme.backgroundColor,
                                      borderRadius: BorderRadius.circular(15.r),
                                      border: Border.all(width: 0.5.w),
                                    ),
                                    child: Row(
                                      children: [
                                        //! first image
                                        Consumer(
                                          builder: (context, ref, child) {
                                            return ref
                                                .watch(
                                                    getProductDetailsProvider(
                                                        ord.cart[0]))
                                                .when(
                                                  data: (product) => Container(
                                                    height: 60.h,
                                                    width: 60.w,
                                                    decoration: BoxDecoration(
                                                      color: currentTheme
                                                          .backgroundColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.r),
                                                      border: Border.all(
                                                          width: 0.5.w),
                                                    ),
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          product.images[0],
                                                      placeholder: (context,
                                                              url) =>
                                                          Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
                                                            colors: [
                                                              Colors.black12
                                                                  .withOpacity(
                                                                      0.1),
                                                              Colors.black12
                                                                  .withOpacity(
                                                                      0.1),
                                                              Colors.black26,
                                                              Colors.black26,
                                                            ],
                                                            begin: Alignment
                                                                .topLeft,
                                                            end: Alignment
                                                                .bottomRight,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.r),
                                                        ),
                                                      )
                                                              .animate(
                                                                  onPlay: (controller) =>
                                                                      controller
                                                                          .repeat())
                                                              .shimmer(
                                                                  duration:
                                                                      1200.ms),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(
                                                              Icons.error),
                                                    ),
                                                  ),
                                                  error: (error, stactrace) {
                                                    log(error.toString());
                                                    return ErrorText(
                                                        error:
                                                            error.toString());
                                                  },
                                                  loading: () => const Loader(),
                                                );
                                          },
                                        ),

                                        //!
                                        15.sbW,
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                ord.orderId.toCapitalized(),
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.w,
                                                    vertical: 5.h),
                                                decoration: BoxDecoration(
                                                  color: Colors.orange,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r),
                                                ),
                                                child: Text(
                                                  ord.status.toUpperCase(),
                                                  style: TextStyle(
                                                    color: Pallete.whiteColor,
                                                    fontSize: 10.sp,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                DateFormat.yMMMMEEEEd()
                                                    .format(ord.orderedAt),
                                                style: TextStyle(
                                                  fontSize: 11.sp,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          error: (error, stactrace) {
                            log(error.toString());
                            return ErrorText(error: error.toString());
                          },
                          loading: () => const Loader(),
                        ),

                        //! closed orders
                        ordersStream.when(
                          data: (orderss) {
                            int closed = getNumberOfClosedOrdersNumber(orderss);

                            if (closed == 0) {
                              return Center(
                                child: Text(
                                  'Nothing here',
                                  style: TextStyle(
                                    color: Pallete.thickRed,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }

                            //! closed orders
                            return ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 22.w)
                                  .copyWith(top: 10.h),
                              itemCount: orderss.length,
                              itemBuilder: (context, index) {
                                final ord = orderss[index];
                                if (ord.status == 'pending') {
                                  return const SizedBox.shrink();
                                }
                                return InkWell(
                                  onTap: () => navigateToOrderDetails(
                                      context, ord.orderId),
                                  child: Container(
                                    height: 100.h,
                                    padding: EdgeInsets.all(15.h),
                                    margin: EdgeInsets.only(bottom: 15.h),
                                    decoration: BoxDecoration(
                                      color: currentTheme.backgroundColor,
                                      borderRadius: BorderRadius.circular(15.r),
                                      border: Border.all(width: 0.5.w),
                                    ),
                                    child: Row(
                                      children: [
                                        //! first image
                                        Consumer(
                                          builder: (context, ref, child) {
                                            return ref
                                                .watch(
                                                    getProductDetailsProvider(
                                                        ord.cart[0]))
                                                .when(
                                                  data: (product) => Container(
                                                    height: 60.h,
                                                    width: 60.w,
                                                    decoration: BoxDecoration(
                                                      color: currentTheme
                                                          .backgroundColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.r),
                                                      border: Border.all(
                                                          width: 0.5.w),
                                                    ),
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          product.images[0],
                                                      placeholder: (context,
                                                              url) =>
                                                          Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
                                                            colors: [
                                                              Colors.black12
                                                                  .withOpacity(
                                                                      0.1),
                                                              Colors.black12
                                                                  .withOpacity(
                                                                      0.1),
                                                              Colors.black26,
                                                              Colors.black26,
                                                            ],
                                                            begin: Alignment
                                                                .topLeft,
                                                            end: Alignment
                                                                .bottomRight,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.r),
                                                        ),
                                                      )
                                                              .animate(
                                                                  onPlay: (controller) =>
                                                                      controller
                                                                          .repeat())
                                                              .shimmer(
                                                                  duration:
                                                                      1200.ms),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(
                                                              Icons.error),
                                                    ),
                                                  ),
                                                  error: (error, stactrace) {
                                                    log(error.toString());
                                                    return ErrorText(
                                                        error:
                                                            error.toString());
                                                  },
                                                  loading: () => const Loader(),
                                                );
                                          },
                                        ),

                                        //!
                                        15.sbW,
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                ord.orderId.toCapitalized(),
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.w,
                                                    vertical: 5.h),
                                                decoration: BoxDecoration(
                                                  color:
                                                      ord.status == 'delivered'
                                                          ? Colors.green
                                                          : Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r),
                                                ),
                                                child: Text(
                                                  ord.status.toUpperCase(),
                                                  style: TextStyle(
                                                    color: Pallete.whiteColor,
                                                    fontSize: 10.sp,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                DateFormat.yMMMMEEEEd()
                                                    .format(ord.orderedAt),
                                                style: TextStyle(
                                                  fontSize: 11.sp,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          error: (error, stactrace) {
                            log(error.toString());
                            return ErrorText(error: error.toString());
                          },
                          loading: () => const Loader(),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
        error: (error, stactrace) {
          log(error.toString());
          return ErrorText(error: error.toString());
        },
        loading: () => const Loader(),
      ),
    );
  }
}
