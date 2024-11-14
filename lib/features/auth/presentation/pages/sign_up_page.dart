import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/pages/log_in_page.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_field.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  //uisng controller we can grab the values from the text fields..
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(3.0),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthFailure) {
                showSnackBar(context, state.msg);
              }
              if (state is AuthSuccess) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LogInPage()));
              }
            },
            builder: (context, state) {
              if (state is AuthLoading) {
                return const Loader();
              }
              return Form(
                //form will validate all the text filed desendent to it..
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Sign Up.",
                      style:
                          TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 30),
                    AuthField(
                      hintText: "Name",
                      controller: nameController,
                    ),
                    const SizedBox(height: 15),
                    AuthField(
                      hintText: "Email",
                      controller: emailController,
                    ),
                    const SizedBox(height: 15),
                    AuthField(
                      hintText: "Password",
                      controller: passwordController,
                      obscureText: true,
                    ),
                    const SizedBox(height: 15),
                    AuthGradientButton(
                      buttonText: "Sign Up",
                      onPressed: () {
                        //  print("----------------SIGN Up Pressed--------");
                        if (formKey.currentState!.validate()) {
                          // print("------- FORM IS VALID -------");
                          //print("email is ${emailController.text.toString()}");
                          //print(
                          // "email is ${passwordController.text.toString()}");
                          // print("email is ${nameController.text.toString()}");
                          context.read<AuthBloc>().add(
                                AuthSignUp(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                    name: nameController.text.trim()),
                              );
                        } else {
                          //print("------- FORM IS NOT VALID -------");
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LogInPage()));
                      },
                      child: RichText(
                          text: TextSpan(
                              text: 'Already have an account? ',
                              style: Theme.of(context).textTheme.titleMedium,
                              children: [
                            TextSpan(
                                text: 'Sign In',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                        color: AppPallete.gradient2,
                                        fontWeight: FontWeight.bold))
                          ])),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
