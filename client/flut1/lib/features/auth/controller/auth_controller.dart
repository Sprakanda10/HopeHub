import 'package:flut1/features/auth/repositories/auth_remote_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authControllerProvider = Provider(
  (ref) => AuthController(authRepository: ref.read(authRepositoryProvider)),
);

class AuthController {
  final AuthRepository _authRepository;
  AuthController({required AuthRepository authRepository})
    : _authRepository = authRepository;

  Future<void> signInWithGoogle() async {
    print('signInWithGoogle called in controller');
    try {
      await _authRepository.signInWithGoogle();
      print('Google sign-in successful');
    } catch (e) {
      print('Error during Google sign-in: $e');
    }
  }
}
