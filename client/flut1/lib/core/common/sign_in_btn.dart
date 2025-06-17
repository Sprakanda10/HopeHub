import 'package:flut1/core/constants/constants.dart';
import 'package:flut1/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignInBtn extends StatelessWidget {
  final WidgetRef ref;
  const SignInBtn({super.key, required this.ref});

  void signInWithGoogle(BuildContext context) {
    print('Sign in button clicked');
    ref.read(authControllerProvider).signInWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => signInWithGoogle(context),
      icon: Image.asset(Constants.googlePath, width: 24, height: 24),
      label: const Text(
        'Sign in with Google',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
