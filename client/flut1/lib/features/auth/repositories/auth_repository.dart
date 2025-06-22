import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flut1/core/constants/constants.dart';
import 'package:flut1/core/constants/firebase_constants.dart';
import 'package:flut1/core/providers/firebase_providers.dart';
import 'package:flut1/core/typedef.dart';
import 'package:flut1/core/failure/failure.dart';
import 'package:flut1/features/auth/model/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fpdart/fpdart.dart'; // no show, import all

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
  }) : _firestore = firestore,
       _auth = auth,
       _googleSignIn = googleSignIn;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  FutureEither<UserModel?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        print('Google sign-in was cancelled by the user');
        return Left(AppFailure('Google sign-in was cancelled by the user'));
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        print('Google auth tokens are null');
        return Left(AppFailure('Google auth tokens are null'));
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      final uid = userCredential.user!.uid;

      if (userCredential.additionalUserInfo!.isNewUser) {
        // Save new user
        UserModel userModel = UserModel(
          email: userCredential.user?.email ?? '',
          name: userCredential.user?.displayName ?? '',
          uid: uid,
          profilePic: userCredential.user?.photoURL ?? Constants.avatarDefault,
          banner: Constants.bannerDefault,
          isAuthenticated: true,
          hope: 0,
          awards: [],
        );

        await _users.doc(uid).set(userModel.toMap(), SetOptions(merge: true));
        print('New user saved to Firestore');
        return Right(userModel);
      } else {
        // Existing user — load from Firestore
        final userDoc = await _users.doc(uid).get();

        if (userDoc.exists) {
          final data = userDoc.data() as Map<String, dynamic>;
          UserModel userModel = UserModel.fromMap(data);
          print('Loaded user from Firestore: hope=${userModel.hope}');
          return Right(userModel);
        } else {
          print('Existing user has no Firestore document!');
          return Left(AppFailure('Existing user has no Firestore document!'));
        }
      }
    } catch (e) {
      print('Google Sign-In failed: $e');
      return Left(AppFailure('Google Sign-In failed: $e'));
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider),
    googleSignIn: ref.read(googleSignInProvider),
  );
});
