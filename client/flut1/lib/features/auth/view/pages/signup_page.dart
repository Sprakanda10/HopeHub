import 'package:flut1/core/common/sign_in_btn.dart';
import 'package:flut1/core/constants/constants.dart';
import 'package:flut1/core/theme/app_pallete.dart';

import 'package:flut1/features/auth/repositories/auth_remote_repository.dart';
import 'package:flut1/features/auth/view/pages/login_page.dart';
import 'package:flut1/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:flut1/features/auth/view/widgets/custom_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fpdart/fpdart.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
    formKey.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          Constants.logoPath,
          height: 80,
          alignment: Alignment.centerLeft,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Sign Up.',
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              CustomField(hintText: 'Name', controller: nameController),
              const SizedBox(height: 15),
              CustomField(hintText: 'Email', controller: emailController),
              const SizedBox(height: 15),
              CustomField(
                hintText: 'Password',
                controller: passwordController,
                isObscureText: true,
              ),
              const SizedBox(height: 20),
              AuthGradientButton(
                buttonText: 'Sign Up',
                onTap: () async {
                  final res = await AuthRemoteRepository().signup(
                    name: nameController.text,
                    email: emailController.text,
                    password: passwordController.text,
                  );
                  final val = switch (res) {
                    Left(value: final l) => l,
                    Right(value: final r) => r.toString(),
                  };
                  print(val);
                },
              ),
              const SizedBox(height: 30),

              SignInBtn(ref: ref),

              const SizedBox(height: 30),

              RichText(
                text: TextSpan(
                  text: 'By continuing you agree to our ',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  children: [
                    TextSpan(
                      text: 'Terms and Conditions ',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () {
                              showTCBottomSheet(context);
                            },
                    ),
                    // TextSpan(text: 'and '),
                    // TextSpan(
                    //   text: "Privacy and Policy",
                    //   style: TextStyle(color: Colors.blue),
                    //   recognizer: TapGestureRecognizer()..onTap = () {},
                    // ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  text: 'Already have an account? ',
                  style: Theme.of(context).textTheme.titleMedium,
                  children: [
                    TextSpan(
                      text: 'Sign In',
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                            },
                      style: const TextStyle(
                        color: Pallete.gradient2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showTCBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close),
              ),
            ),
            Text(
              'Terms and Conditions content goes here.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              'Helloooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo',
            ),
          ],
        ),
      );
    },
  );
}
