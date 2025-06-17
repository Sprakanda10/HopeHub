import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flut1/core/constants/constants.dart';
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
        UserModel(email: email, name: name, id: resBodyMap['id'].toString()),
      );
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      print(response.statusCode);
      print(response.body);
    } catch (e) {
      print(e);
    }
  }
}

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider),
    googleSignIn: ref.read(googleSignInProvider),
  ),
);

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
       _googleSignIn = GoogleSignIn(
         clientId:
             '129962059793-jjgs1a2ig1lgnkke8cpud2o654i16p5j.apps.googleusercontent.com',
       );
  CollectionReference get _users =>
      _firestore.collection('firebaseconstants.usersCollection');

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // If user cancels the sign-in popup
      if (googleUser == null) {
        print('Google sign-in was cancelled by the user');
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      //  Ensure both tokens are non-null
      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        print('Google auth tokens are null');
        return;
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
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
    } catch (e) {
      print('Google Sign-In failed: $e');
      rethrow;
    }
  }
}
