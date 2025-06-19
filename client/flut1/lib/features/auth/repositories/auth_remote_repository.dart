import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flut1/core/constants/constants.dart';
import 'package:flut1/core/constants/firebase_constants.dart';
import 'package:flut1/core/providers/firebase_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flut1/features/auth/model/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flut1/core/failure/failure.dart';

class AuthRemoteRepository {
  Future<Either<AppFailure, UserModel>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );
      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 201) {
        // Handl e error
        return Left(AppFailure(resBodyMap['detail']));
      }

      return Right(
        UserModel(
          email: email,
          name: name,
          uid: resBodyMap['uid'].toString(),
          profilePic: Constants.avatarDefault,
          banner: Constants.bannerDefault,
          isAuthenticated: true,
          hope: 0,
          awards: [],
        ),
      );
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        print('Google sign-in was cancelled by the user');
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        print('Google auth tokens are null');
        return;
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      if (userCredential.additionalUserInfo!.isNewUser) {
        // Save new user
        UserModel userModel = UserModel(
          email: userCredential.user?.email ?? '',
          name: userCredential.user?.displayName ?? '',
          uid: userCredential.user!.uid,
          profilePic: userCredential.user?.photoURL ?? Constants.avatarDefault,
          banner: Constants.bannerDefault,
          isAuthenticated: true,
          hope: 0,
          awards: [],
        );

        await _users.doc(userCredential.user!.uid).set(userModel.toMap());
        print('New user saved to Firestore');
      } else {
        // Existing user — load from Firestore!
        final userDoc = await _users.doc(userCredential.user!.uid).get();

        if (userDoc.exists) {
          final data = userDoc.data() as Map<String, dynamic>;
          UserModel userModel = UserModel.fromMap(data);
          print('Loaded user from Firestore: hope=${userModel.hope}');

          // Important: assign this userModel to app state / provider
          // Example:
          // ref.read(userProvider.notifier).state = userModel;
        } else {
          print('Existing user has no Firestore document!');
        }
      }
    } catch (e) {
      print('Google Sign-In failed: $e');
      rethrow;
    }
  }
}
