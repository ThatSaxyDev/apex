import 'dart:developer';
import 'dart:io';

import 'package:apex/core/providers/storage_repository_provider.dart';
import 'package:apex/core/utils.dart';
import 'package:apex/features/auth/controller/auth_controller.dart';
import 'package:apex/features/seller/features/products/repositories/product_repository.dart';
import 'package:apex/models/product_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

//! get particular product details provider
final getProductDetailsProvider =
    StreamProvider.family((ref, String productId) {
  final productController = ref.watch(productControllerProvider.notifier);
  return productController.getProductDetail(productId);
});

//! get sellers products providers
final getSellerProductsProvider = StreamProvider((ref) {
  final productController = ref.watch(productControllerProvider.notifier);

  return productController.getAllProducts();
});

//! get all products providers
final getAllProductsProvider = StreamProvider((ref) {
  final productController = ref.watch(productControllerProvider.notifier);

  return productController.getAllProducts();
});

final productControllerProvider =
    StateNotifierProvider<ProductController, bool>((ref) {
  final productRepository = ref.watch(productRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return ProductController(
    productRepository: productRepository,
    storageRepository: storageRepository,
    ref: ref,
  );
});

class ProductController extends StateNotifier<bool> {
  final ProductRepository _productRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;
  ProductController({
    required ProductRepository productRepository,
    required StorageRepository storageRepository,
    required Ref ref,
  })  : _productRepository = productRepository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);

  //! add products
  void addProduct({
    required BuildContext context,
    required String name,
    required String description,
    required int price,
    required int quantity,
    required String category,
    required List<File>? images,
  }) async {
    state = true;
    String randomId = const Uuid().v1();
    String productId = '$name-$randomId';
    final user = _ref.read(userProvider)!;
    List<String> photoUrls = [];

    // log(images!.length.toString());

    if (images != null) {
      for (File image in images) {
        final res = await _storageRepository.storeFile(
          path:
              'products/${user.uid}/${DateTime.now().millisecondsSinceEpoch.toString()}',
          id: user.uid,
          file: image,
        );

        res.fold(
          (l) => showSnackBar(context, l.message),
          (r) => photoUrls.add(r),
        );
      }
    }

    final ProductModel product = ProductModel(
      name: name,
      description: description,
      price: price,
      quantity: quantity,
      category: category,
      images: photoUrls,
      sellerId: user.uid,
      id: productId,
      createdAt: DateTime.now(),
      rating: [],
      addedToCart: [],
    );

    final res = await _productRepository.addProducts(product);

    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, 'Product Added!');
        Routemaster.of(context).pop();
      },
    );
  }

  void deleteProduct({
    required BuildContext context,
    required ProductModel product,
  }) async {
    final res = await _productRepository.deleteProduct(product);

    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, 'Product Deleted!');
        // Routemaster.of(context).pop();
      },
    );
  }

  void addToProductQuantitySeller(ProductModel product) async {
    return _productRepository.addToProductQuantitySeller(product);
  }

  void reduceFromProductQuantitySeller(ProductModel product) async {
    return _productRepository.reduceFromProductQuantitySeller(product);
  }

  //! get particualar product details
  Stream<ProductModel> getProductDetail(String productId) {
    return _productRepository.getProductDetail(productId);
  }

  //! get sellers products
  Stream<List<ProductModel>> getSellerProducts() {
    final user = _ref.read(userProvider)!;
    return _productRepository.getSellerProducts(user.uid);
  }

  //! get all products
  Stream<List<ProductModel>> getAllProducts() {
    return _productRepository.getAllProducts();
  }
}
