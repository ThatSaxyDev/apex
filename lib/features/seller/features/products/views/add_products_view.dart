import 'dart:io';

import 'package:apex/core/utils.dart';
import 'package:apex/features/seller/features/products/controllers/product_controller.dart';
import 'package:apex/theme/palette.dart';
import 'package:apex/utils/app_texts.dart';
import 'package:apex/utils/button.dart';
import 'package:apex/utils/custom_textfield.dart';
import 'package:apex/utils/loader.dart';
import 'package:apex/utils/widget_extensions.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AddProductsView extends ConsumerStatefulWidget {
  const AddProductsView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddProductsViewState();
}

class _AddProductsViewState extends ConsumerState<AddProductsView> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final _addProductFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    productNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    quantityController.dispose();
  }

  String category = 'Mobiles';

  List<File> images = [];

  void selectImages() async {
    var res = await pickImages();
    setState(() {
      images = res;
    });
  }

  void sellProduct() {
    if (_addProductFormKey.currentState!.validate() && images.isNotEmpty) {
      ref.read(productControllerProvider.notifier).addProduct(
            context: context,
            name: productNameController.text,
            description: descriptionController.text,
            price: int.parse(priceController.text),
            quantity: int.parse(quantityController.text),
            category: category,
            images: images,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);
    final isLoading = ref.watch(productControllerProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Add Products',
          style: TextStyle(
            color: currentTheme.textTheme.bodyMedium!.color,
          ),
        ),
      ),
      body: isLoading
          ? const Loader()
          : SingleChildScrollView(
              child: Form(
                key: _addProductFormKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20.h,
                      ),
                      images.isNotEmpty
                          ? CarouselSlider(
                              items: images.map(
                                (i) {
                                  return Builder(
                                    builder: (BuildContext context) =>
                                        Image.file(
                                      i,
                                      fit: BoxFit.cover,
                                      height: 200.h,
                                    ),
                                  );
                                },
                              ).toList(),
                              options: CarouselOptions(
                                autoPlay: true,
                                aspectRatio: 2.0,
                                enlargeCenterPage: true,
                                viewportFraction: 1,
                                height: 200.h,
                              ),
                            )
                          : GestureDetector(
                              onTap: selectImages,
                              child: DottedBorder(
                                borderType: BorderType.RRect,
                                radius: Radius.circular(10.r),
                                dashPattern: const [10, 4],
                                color: Colors.grey,
                                child: Container(
                                  width: double.infinity,
                                  height: 150.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        PhosphorIcons.folder,
                                        size: 40.w,
                                      ),
                                      15.sbH,
                                      Text(
                                        'Select Product Images',
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                      30.sbH,
                      CustomTextField(
                        controller: productNameController,
                        hintText: 'Product Name',
                      ),
                      20.sbH,
                      CustomTextField(
                        controller: descriptionController,
                        hintText: 'Description',
                        maxLines: 7,
                      ),
                      20.sbH,
                      CustomTextField(
                        controller: priceController,
                        hintText: 'Price',
                        prefixText: '${AppTexts.naira} ',
                        keyboardType: const TextInputType.numberWithOptions(),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                      20.sbH,
                      CustomTextField(
                        controller: quantityController,
                        hintText: 'Quantity',
                        keyboardType: const TextInputType.numberWithOptions(),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                      20.sbH,
                      Row(
                        children: [
                          Text(
                            'Category: ',
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: currentTheme.textTheme.bodyMedium!.color,
                            ),
                          ),
                          SizedBox(
                            width: 200.w,
                            child: Center(
                              child: DropdownButton(
                                dropdownColor: currentTheme.backgroundColor,
                                onChanged: (String? newVal) {
                                  setState(() {
                                    category = newVal!;
                                  });
                                },
                                value: category,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: productCategories.map((String item) {
                                  return DropdownMenuItem(
                                    value: item,
                                    child: Text(item),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      20.sbH,
                      BButton(
                        text: 'Sell',
                        onTap: sellProduct,
                      ),
                      50.sbH,
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
