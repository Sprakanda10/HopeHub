import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:flut1/core/constants/constants.dart';
import 'package:flut1/core/failure/failure.dart';
import 'package:flut1/features/auth/model/user_model.dart';
import 'package:http/http.dart' as http;

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
