import 'package:flutter/material.dart';
import 'package:sociobuzz_social_media_app/features/authentication/presentation/pages/login_page.dart';
import 'package:sociobuzz_social_media_app/features/authentication/presentation/pages/register_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  bool showLoginPage = true;

  void togglePages(){
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showLoginPage){
      return LoginPage(
        togglePage: togglePages,
      );
    } else {
      return RegisterPage(
        togglePage: togglePages,
      );
    }
  }
}