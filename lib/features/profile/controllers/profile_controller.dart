import 'dart:io';

import 'package:apex/core/failure.dart';
import 'package:apex/core/providers/storage_repository_provider.dart';
import 'package:apex/core/utils.dart';
import 'package:apex/features/auth/controller/auth_controller.dart';
import 'package:apex/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/enums/enums.dart';
import '../repository/profile_repository.dart';

// final getVerificationsProvider = StreamProvider((ref) {
//   final communityController = ref.watch(userProfileControllerProvider.notifier);
//   return communityController.getVerification();
// });

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return UserProfileController(
    userProfileRepository: userProfileRepository,
    storageRepository: storageRepository,
    ref: ref,
  );
});

class UserProfileController extends StateNotifier<bool> {
  final UserProfileRepository _userProfileRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;
  UserProfileController({
    required UserProfileRepository userProfileRepository,
    required StorageRepository storageRepository,
    required Ref ref,
  })  : _userProfileRepository = userProfileRepository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);

  void setUserType({
    required BuildContext context,
    // required File? profileFile,
    // Uint8List? file,
    required String type,
  }) async {
    state = true;
    UserModel user = _ref.read(userProvider)!;
    // if (profileFile != null) {
    //   final res = await _storageRepository.storeFile(
    //     path: 'users/profile',
    //     id: user.uid,
    //     file: profileFile,
    //     webFile: file,
    //   );
    //   res.fold(
    //     (l) => showSnackBar(context, l.message),
    //     (r) => user = user.copyWith(profilePic: r),
    //   );
    // }
    UserModel userr = user.copyWith(userType: type);

    final res = await _userProfileRepository.editProfile(userr);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, 'Done!');
        _ref.read(userProvider.notifier).update((state) => userr);
        Routemaster.of(context).pop();
      },
    );
  }

  // update address
  void updateUserAddress({
    required BuildContext context,
    required String address,
  }) async {
    state = true;
    UserModel user = _ref.read(userProvider)!;
    UserModel userr = user.copyWith(address: address);

    final res = await _userProfileRepository.editProfile(userr);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, 'Done!');
        _ref.read(userProvider.notifier).update((state) => userr);
        Routemaster.of(context).pop();
      },
    );
  }
}
