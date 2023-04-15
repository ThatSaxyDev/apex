import 'package:apex/features/auth/views/login_screen.dart';
import 'package:apex/features/base_nav_wrapper/views/base_nav_wrapper.dart';
import 'package:apex/features/base_nav_wrapper/views/seller_base_nav_wrapper.dart';
import 'package:apex/features/home/dummy_home.dart';
import 'package:apex/features/seller/features/products/views/add_products_view.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

//! these routes would be desplayed when the user is logged out
final loggedOutRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(
          child: LoginScreen(),
        ),
  },
);

//! these routes would be displayed when the user is logged in as a seller
final sellerLoggedInRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(
          child: SellerBaseNavWrapper(),
        ),
    '/add-products': (_) => const MaterialPage(
          child: AddProductsView(),
        ),
    // '/mark-attendance': (_) => const MaterialPage(
    //       child: MarkAttendanceView(),
    //     ),
    // '/project/:name': (routeData) => MaterialPage(
    //       child: ProjectView(
    //         name: routeData.pathParameters['name']!,
    //       ),
    //     ),
    // '/create-project': (_) => const MaterialPage(
    //       child: CreateProjectView(),
    //     ),
    // '/edit-profile': (_) => const MaterialPage(
    //       child: EditProfileView(),
    //     ),
  },
  onUnknownRoute: (path) => const MaterialPage(
    child: DummyHome(),
  ),
);

//! these routes would be displayed when the user is logged in as an employee
final buyerLoggedInRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(
          child: BaseNavWrapper(),
        ),
    // '/edit-profile': (_) => const MaterialPage(
    //       child: EditProfileView(),
    //     ),
    // '/project/:name': (routeData) => MaterialPage(
    //       child: ProjectView(
    //         name: routeData.pathParameters['name']!,
    //       ),
    //     ),
  },
  onUnknownRoute: (path) => const MaterialPage(
    child: DummyHome(),
  ),
);
