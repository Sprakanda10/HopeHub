import 'package:flut1/core/theme/theme.dart';
import 'package:flut1/features/auth/view/pages/login_page.dart';
import 'package:flut1/features/auth/view/pages/signup_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.darkThemeMode,
      home: const SignupPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
