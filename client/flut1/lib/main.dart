import 'package:firebase_core/firebase_core.dart';
import 'package:flut1/core/theme/theme.dart';
import 'package:flut1/features/auth/view/pages/login_page.dart';
import 'package:flut1/features/auth/view/pages/signup_page.dart';
import 'package:flut1/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: MyApp()));
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
