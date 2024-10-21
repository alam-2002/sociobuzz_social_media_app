import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sociobuzz_social_media_app/components/custom_button.dart';
import 'package:sociobuzz_social_media_app/components/custom_text_field.dart';
import 'package:sociobuzz_social_media_app/components/text_widget.dart';
import 'package:sociobuzz_social_media_app/features/authentication/presentation/cubits/auth_cubit.dart';
import 'package:sociobuzz_social_media_app/responsive/constrained_scaffold.dart';

class RegisterPage extends StatefulWidget {
  final Function() togglePage;
  const RegisterPage({super.key, required this.togglePage});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void register() {
    final String name = nameController.text;
    final String email = emailController.text;
    final String password = passwordController.text;
    final String confirmPW = confirmPasswordController.text;

    final authCubit = context.read<AuthCubit>();

    if (name.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        confirmPW.isNotEmpty) {
      if (password == confirmPW) {
        authCubit.register(name: name, email: email, password: password);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Label(
              label: 'Registration Successful',
              color: Colors.white,
            ),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Label(
              label: 'Password doesn\'t match!',
              color: Colors.white,
            ),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Label(
            label: 'Please complete all fields',
            color: Colors.white,
          ),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final inversePrimary = Theme.of(context).colorScheme.inversePrimary;
    return ConstrainedScaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock_open_rounded,
                    size: 80,
                    color: primary,
                  ),
                  SizedBox(height: 50),
                  Label(
                    label: 'Let\'s create an account first!',
                    color: primary,
                    fontSize: 16,
                    letterSpacing: 2,
                  ),
                  SizedBox(height: 25),
                  // name text field
                  CustomTextField(
                    controller: nameController,
                    hintText: 'Name',
                    obscureText: false,
                  ),
                  SizedBox(height: 15),
                  // email text field
                  CustomTextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    hintText: 'Email',
                    obscureText: false,
                  ),
                  SizedBox(height: 15),
                  // password text field
                  CustomTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),
                  SizedBox(height: 15),
                  // confirm password text field
                  CustomTextField(
                    controller: confirmPasswordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),
                  SizedBox(height: 25),
                  CustomButton(
                    onTap: register,
                    text: 'Register',
                  ),
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Label(
                        label: 'Already member?',
                        color: primary,
                      ),
                      GestureDetector(
                        onTap: widget.togglePage,
                        child: Label(
                          label: '  Go to Login',
                          color: inversePrimary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
