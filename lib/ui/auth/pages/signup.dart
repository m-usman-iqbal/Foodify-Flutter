import 'package:burger/bloc/signup_bloc/signup_bloc.dart';
import 'package:burger/bloc/signup_bloc/signup_event.dart';
import 'package:burger/bloc/signup_bloc/signup_state.dart';
import 'package:burger/data/repositories/singup_repository.dart';
import 'package:burger/data/services/signup_services.dart';
import 'package:burger/ui/auth/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Signup extends StatelessWidget {
  Signup({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController imagePathController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final repository = SignupRepository(service: SignupService());

    return BlocProvider(
      create: (_) => SignupBloc(repository: repository),
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.fromLTRB(35, 55, 35, 42),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Image.asset('assets/Logo.png', fit: BoxFit.cover),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 84,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 32,
                        child: Text(
                          'Hello, Create an account',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        height: 48,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );
                          },
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.71,
                                color: Color(0xFF7A869A),
                              ),
                              children: [
                                TextSpan(text: 'Already have an account?'),
                                TextSpan(
                                  text: ' Sign in',
                                  style: TextStyle(
                                    color: Color(0xFFEF9F27),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                BlocConsumer<SignupBloc, SignupState>(
                  listener: (context, state) {
                    if (state is SignupSuccess) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          title: const Text(
                            "Registration Successful",
                            textAlign: TextAlign.center,
                          ),
                          content: const Text(
                            "Your account has been created successfully.\nYou can now log in to continue.",
                            textAlign: TextAlign.center,
                          ),
                          actions: [
                            Align(
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginScreen(),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: const Color(0xFFEF9F27),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Login',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (state is SignupFailure) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.message)));
                    }
                  },
                  builder: (context, state) {
                    return Container(
                      height: 400,
                      width: double.infinity,
                      child: Column(
                        children: [
                          Container(
                            height: 350,
                            width: double.infinity,
                            child: Column(
                              children: [
                                Container(
                                  height: 260,
                                  width: double.infinity,
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 44,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF4F5F7),
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                        child: TextField(
                                          controller: usernameController,
                                          decoration: const InputDecoration(
                                            hintText: 'Username',
                                            border: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 16,
                                                ),
                                          ),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF7A869A),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        height: 44,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF4F5F7),
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                        child: TextField(
                                          controller: emailController,
                                          decoration: const InputDecoration(
                                            hintText: 'Email',
                                            border: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 16,
                                                ),
                                          ),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF7A869A),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        height: 44,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF4F5F7),
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                        child: TextField(
                                          controller: passwordController,
                                          obscureText: true,
                                          decoration: const InputDecoration(
                                            hintText: 'Password',
                                            border: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 16,
                                                ),
                                          ),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF7A869A),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        height: 44,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF4F5F7),
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                        child: TextField(
                                          controller: addressController,
                                          decoration: const InputDecoration(
                                            hintText: 'Address',
                                            border: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 16,
                                                ),
                                          ),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF7A869A),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        height: 44,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF4F5F7),
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                        child: TextField(
                                          controller: imagePathController,
                                          decoration: const InputDecoration(
                                            hintText: 'Image Path',
                                            border: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 16,
                                                ),
                                          ),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF7A869A),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                GestureDetector(
                                  onTap: () {
                                    context.read<SignupBloc>().add(
                                      SignupButtonPressed(
                                        email: emailController.text.trim(),
                                        password: passwordController.text
                                            .trim(),
                                        username: usernameController.text
                                            .trim(),
                                        address: addressController.text.trim(),
                                        imagePath: imagePathController.text
                                            .trim(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 44,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEF9F27),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Center(
                                      child: state is SignupLoading
                                          ? const CircularProgressIndicator(
                                              color: Colors.white,
                                            )
                                          : const Text(
                                              'Register',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          const SizedBox(
                            height: 20,
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFFEF9F27),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
