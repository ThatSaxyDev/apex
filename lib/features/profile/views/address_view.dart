import 'package:apex/features/auth/controller/auth_controller.dart';
import 'package:apex/features/profile/controllers/profile_controller.dart';
import 'package:apex/theme/palette.dart';
import 'package:apex/utils/button.dart';
import 'package:apex/utils/custom_textfield.dart';
import 'package:apex/utils/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddressView extends ConsumerStatefulWidget {
  const AddressView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddressViewState();
}

class _AddressViewState extends ConsumerState<AddressView> {
  final TextEditingController flatController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final _addressFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    flatController.dispose();
    streetController.dispose();
    pincodeController.dispose();
    cityController.dispose();
  }

  void updateAddress() {
    if (_addressFormKey.currentState!.validate()) {
      ref.read(userProfileControllerProvider.notifier).updateUserAddress(
          context: context,
          address:
              '${flatController.text}, ${streetController.text}, ${pincodeController.text}, ${cityController.text}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);
    final user = ref.watch(userProvider)!;
    // final isLoading = ref.watch(userProfileControllerProvider);
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
            'Address',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: currentTheme.textTheme.bodyMedium!.color,
              // fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: 18.padH,
          child: Form(
            key: _addressFormKey,
            child: Column(
              children: [
                7.sbH,
                RichText(
                  text: TextSpan(
                    text: 'Currrent Address: ',
                    style: TextStyle(
                      fontSize: 16.sp,
                      // fontWeight: FontWeight.bold,
                      color: currentTheme.textTheme.bodyMedium!.color,
                    ),
                    children: [
                      TextSpan(
                        text: user.address.isEmpty
                            ? 'You have not set your address'
                            : user.address,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: Pallete.blueColor,
                        ),
                      ),
                    ],
                  ),
                ),
                20.sbH,
                CustomTextField(
                  controller: flatController,
                  hintText: 'Flat/House No/Building',
                ),
                20.sbH,
                CustomTextField(
                  controller: streetController,
                  hintText: 'Area/Street',
                ),
                20.sbH,
                CustomTextField(
                  controller: pincodeController,
                  hintText: 'ZipCode',
                ),
                20.sbH,
                CustomTextField(
                  controller: cityController,
                  hintText: 'Town/City',
                ),
                30.sbH,
          
                //! set address button
          
                BButton(
                  height: 55.h,
                  width: 200.w,
                  onTap: () {
                    updateAddress();
                    flatController.clear();
                    streetController.clear();
                    pincodeController.clear();
                    cityController.clear();
                  },
                  text: 'Done',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
