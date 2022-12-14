import 'package:flutter/material.dart';
import 'package:login_and_signup_with_sqflite/app/presenter/ui/login/login_page..dart';
import 'package:toast/toast.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login e Signup com SQFLite',
      home: LoginPage(),
    );
  }
}
