import 'package:apex/core/constants/firebase_constants.dart';
import 'package:apex/core/failure.dart';
import 'package:apex/core/providers/firebase_provider.dart';
import 'package:apex/core/type_defs.dart';

import 'package:apex/models/user_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final userProfileRepositoryProvider = Provider((ref) {
  return UserProfileRepository(firestore: ref.watch(firestoreProvider));
});

class UserProfileRepository {
  final FirebaseFirestore _firestore;
  UserProfileRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  FutureVoid editProfile(UserModel user) async {
    try {
      return right(_users.doc(user.uid).update(user.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // FutureVoid requestVerification(VerificationModel verification) async {
  //   try {
  //     _users.doc(verification.userId).update({'schoolName': 'pending'});
  //     return right(
  //         _verifications.doc(verification.userId).set(verification.toMap()));
  //   } on FirebaseException catch (e) {
  //     throw e.message!;
  //   } catch (e) {
  //     return left(Failure(e.toString()));
  //   }
  // }

  // Stream<List<VerificationModel>> getVerificationStatus(String uid) {
  //   return _verifications
  //       .where('userId', isEqualTo: uid)
  //       .snapshots()
  //       .map((event) {
  //     List<VerificationModel> verifications = [];
  //     for (var doc in event.docs) {
  //       verifications
  //           .add(VerificationModel.fromMap(doc.data() as Map<String, dynamic>));
  //     }
  //     return verifications;
  //   });
  // }

  // Stream<List<Post>> getUserPosts(String uid) {
  //   return _posts
  //       .where('uid', isEqualTo: uid)
  //       .orderBy('createdAt', descending: true)
  //       .snapshots()
  //       .map((event) => event.docs
  //           .map((e) => Post.fromMap(e.data() as Map<String, dynamic>))
  //           .toList());
  // }

  FutureVoid addToBookmarks(String uid, String postId) async {
    try {
      return right(_users.doc(uid).update({
        'bookmarks': postId,
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid followUserProfile(String userIdToFollow, String userId) async {
    try {
      return right(_users.doc(userIdToFollow).update(
        {
          'followers': FieldValue.arrayUnion([userId]),
        },
      ));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // FutureVoid followUserProfile(String userIdToFollow, String userId) async {
  //   try {
  //     final userDoc = _users.doc(userIdToFollow);
  //     final userDocSnapshot = await userDoc.get();
  //     final followers =
  //         List<String>.from(userDocSnapshot.get('followers') ?? []);
  //     final following =
  //         List<String>.from(userDocSnapshot.get('following') ?? []);

  //     if (followers.contains(userIdToFollow) && following.contains(userIdToFollow)) {
  //       await userDoc.update({
  //         'canInteract': FieldValue.arrayUnion([userIdToFollow]),
  //       });
  //     }
  //     return right(_users.doc(userIdToFollow).update(
  //       {
  //         'followers': FieldValue.arrayUnion([userId]),
  //       },
  //     ));
  //   } on FirebaseException catch (e) {
  //     throw e.message!;
  //   } catch (e) {
  //     return left(Failure(e.toString()));
  //   }
  // }

  FutureVoid unfollowUserProfile(String userIdToUnfollow, String userId) async {
    try {
      return right(_users.doc(userIdToUnfollow).update(
        {
          'followers': FieldValue.arrayRemove([userId]),
        },
      ));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid addToUserFollowing(String userIdFollowing, String userId) async {
    try {
      return right(_users.doc(userId).update(
        {
          'following': FieldValue.arrayUnion([userIdFollowing]),
        },
      ));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid removeFromUserFollowing(
      String userIdFollowing, String userId) async {
    try {
      return right(_users.doc(userId).update(
        {
          'following': FieldValue.arrayRemove([userIdFollowing]),
        },
      ));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  CollectionReference get _verifications =>
      _firestore.collection(FirebaseConstants.verificationCollection);
}
