// import 'package:burger/bloc/login_bloc/login_bloc.dart';
// import 'package:burger/bloc/login_bloc/login_event.dart';
// import 'package:burger/bloc/login_bloc/login_state.dart';
// import 'package:burger/data/repositories/login_repository.dart';
// import 'package:burger/data/services/login_servies.dart';
// import 'package:burger/ui/auth/pages/signup.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../bottomTab/bottom.dart';

// class LoginScreen extends StatelessWidget {
//   LoginScreen({super.key});

//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final repository = LoginRepositoryImpl(LoginService());

//     return BlocProvider(
//       create: (_) => LoginBloc(repository: repository),
//       child: Scaffold(
//         body: Container(
//           margin: const EdgeInsets.fromLTRB(35, 70, 35, 42),
//           child: Column(
//             children: [
//               Center(child: Image.asset('assets/Logo.png', fit: BoxFit.cover)),
//               const SizedBox(height: 30),
//               SizedBox(
//                 height: 84,
//                 child: Column(
//                   children: [
//                     const SizedBox(
//                       height: 32,
//                       child: Text(
//                         'Welcome Back',
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     SizedBox(
//                       height: 48,
//                       child: GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (_) => Signup()),
//                           );
//                         },
//                         child: RichText(
//                           textAlign: TextAlign.center,
//                           text: TextSpan(
//                             style: TextStyle(
//                               fontSize: 14,
//                               height: 1.71,
//                               color: Color(0xFF7A869A),
//                             ),
//                             children: [
//                               TextSpan(
//                                 text: 'Hello Jos, sign in to continue!\n Or ',
//                               ),
//                               TextSpan(
//                                 text: 'Create new account',
//                                 style: TextStyle(
//                                   color: Color(0xFFEF9F27),
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 24),
//               BlocConsumer<LoginBloc, LoginState>(
//                 listener: (context, state) {
//                   if (state is LoginSuccess) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text("✅ Login Successful!"),
//                         backgroundColor: Colors.green,
//                         duration: Duration(seconds: 2),
//                       ),
//                     );
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(builder: (_) => const BottomTabs()),
//                     );
//                   }
//                   if (state is LoginFailure) {
//                     ScaffoldMessenger.of(
//                       context,
//                     ).showSnackBar(SnackBar(content: Text(state.message)));
//                   }
//                 },
//                 builder: (context, state) {
//                   return Container(
//                     height: 352,
//                     width: double.infinity,
//                     child: Column(
//                       children: [
//                         Container(
//                           height: 156,
//                           width: double.infinity,
//                           child: Column(
//                             children: [
//                               Container(
//                                 height: 96,
//                                 width: double.infinity,
//                                 child: Column(
//                                   children: [
//                                     Container(
//                                       height: 44,
//                                       width: double.infinity,
//                                       decoration: BoxDecoration(
//                                         color: const Color(0xFFF4F5F7),
//                                         borderRadius: BorderRadius.circular(15),
//                                       ),
//                                       child: TextField(
//                                         controller: _emailController,
//                                         decoration: const InputDecoration(
//                                           hintText: 'Email',
//                                           border: InputBorder.none,
//                                           contentPadding: EdgeInsets.symmetric(
//                                             horizontal: 12,
//                                             vertical: 16,
//                                           ),
//                                         ),
//                                         style: const TextStyle(
//                                           fontSize: 14,
//                                           color: Color(0xFF7A869A),
//                                         ),
//                                       ),
//                                     ),
//                                     const SizedBox(height: 8),
//                                     Container(
//                                       height: 44,
//                                       width: double.infinity,
//                                       decoration: BoxDecoration(
//                                         color: const Color(0xFFF4F5F7),
//                                         borderRadius: BorderRadius.circular(15),
//                                       ),
//                                       child: TextField(
//                                         controller: _passwordController,
//                                         decoration: const InputDecoration(
//                                           hintText: 'Password',
//                                           border: InputBorder.none,
//                                           contentPadding: EdgeInsets.symmetric(
//                                             horizontal: 12,
//                                             vertical: 16,
//                                           ),
//                                         ),
//                                         style: const TextStyle(
//                                           fontSize: 14,
//                                           color: Color(0xFF7A869A),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               const SizedBox(height: 16),
//                               GestureDetector(
//                                 onTap: () {
//                                   context.read<LoginBloc>().add(
//                                     LoginButtonPressed(
//                                       email: _emailController.text.trim(),
//                                       password: _passwordController.text.trim(),
//                                     ),
//                                   );
//                                 },
//                                 child: Container(
//                                   height: 44,
//                                   width: double.infinity,
//                                   decoration: BoxDecoration(
//                                     color: const Color(0xFFEF9F27),
//                                     borderRadius: BorderRadius.circular(15),
//                                   ),
//                                   child: Center(
//                                     child: state is LoginLoading
//                                         ? const CircularProgressIndicator(
//                                             color: Colors.white,
//                                           )
//                                         : const Text(
//                                             'Sign in',
//                                             style: TextStyle(
//                                               fontSize: 14,
//                                               fontWeight: FontWeight.bold,
//                                               color: Colors.white,
//                                             ),
//                                           ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         const SizedBox(
//                           height: 20,
//                           child: Text(
//                             'Forgot Password?',
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Color(0xFFEF9F27),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         SizedBox(
//                           height: 24,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Container(
//                                 width: 125,
//                                 height: 2,
//                                 color: Color(0xFFF4F5F7),
//                               ),
//                               const Text(
//                                 'OR',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: Color(0xFF7A869A),
//                                 ),
//                               ),
//                               Container(
//                                 width: 125,
//                                 height: 2,
//                                 color: Color(0xFFF4F5F7),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         SizedBox(
//                           height: 104,
//                           child: Column(
//                             children: [
//                               Container(
//                                 height: 48,
//                                 width: double.infinity,
//                                 decoration: BoxDecoration(
//                                   color: const Color(0xFFF4F5F7),
//                                   borderRadius: BorderRadius.circular(15),
//                                 ),
//                                 child: Center(
//                                   child: Row(
//                                     children: [
//                                       Image.asset(
//                                         'assets/Facebook.png',
//                                         height: 24,
//                                         width: 24,
//                                       ),
//                                       const Spacer(),
//                                       const Text(
//                                         'Continue with Facebook',
//                                         style: TextStyle(
//                                           fontSize: 14,
//                                           color: Colors.black,
//                                         ),
//                                       ),
//                                       const Spacer(),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               Container(
//                                 height: 48,
//                                 width: double.infinity,
//                                 decoration: BoxDecoration(
//                                   color: const Color(0xFFF4F5F7),
//                                   borderRadius: BorderRadius.circular(15),
//                                 ),
//                                 child: Center(
//                                   child: Row(
//                                     children: [
//                                       Image.asset(
//                                         'assets/Google.png',
//                                         height: 24,
//                                         width: 24,
//                                       ),
//                                       const Spacer(),
//                                       const Text(
//                                         'Continue with Google',
//                                         style: TextStyle(
//                                           fontSize: 14,
//                                           color: Colors.black,
//                                         ),
//                                       ),
//                                       const Spacer(),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:burger/bloc/login_bloc/login_bloc.dart';
import 'package:burger/bloc/login_bloc/login_event.dart';
import 'package:burger/bloc/login_bloc/login_state.dart';
import 'package:burger/data/repositories/login_repository.dart';
import 'package:burger/data/services/login_servies.dart';
import 'package:burger/ui/auth/pages/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bottomTab/bottom.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final repository = LoginRepositoryImpl(LoginService());

    return BlocProvider(
      create: (_) => LoginBloc(repository: repository),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.fromLTRB(35, 40, 35, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo
                  Center(
                    child: Image.asset(
                      'assets/Logo.png',
                      fit: BoxFit.cover,
                      height: 120,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Welcome Text
                  Column(
                    children: [
                      const Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => Signup()),
                          );
                        },
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.71,
                              color: Color(0xFF7A869A),
                            ),
                            children: [
                              TextSpan(
                                text: 'Hello Jos, sign in to continue!\n Or ',
                              ),
                              TextSpan(
                                text: 'Create new account',
                                style: TextStyle(
                                  color: Color(0xFFEF9F27),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Bloc Consumer
                  BlocConsumer<LoginBloc, LoginState>(
                    listener: (context, state) {
                      if (state is LoginSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("✅ Login Successful!"),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 2),
                          ),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const BottomTabs()),
                        );
                      }
                      if (state is LoginFailure) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(state.message)));
                      }
                    },
                    builder: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // TextFields
                          Container(
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF4F5F7),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: TextField(
                                    controller: _emailController,
                                    decoration: const InputDecoration(
                                      hintText: 'Email',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
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
                                const SizedBox(height: 12),
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF4F5F7),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: TextField(
                                    controller: _passwordController,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      hintText: 'Password',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
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

                          const SizedBox(height: 20),

                          // Login Button
                          GestureDetector(
                            onTap: () {
                              context.read<LoginBloc>().add(
                                LoginButtonPressed(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim(),
                                ),
                              );
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEF9F27),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: state is LoginLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : const Text(
                                        'Sign in',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          const Center(
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFFEF9F27),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Divider Row
                          Row(
                            children: const [
                              Expanded(
                                child: Divider(
                                  color: Color(0xFFF4F5F7),
                                  thickness: 2,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  'OR',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF7A869A),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Color(0xFFF4F5F7),
                                  thickness: 2,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Social Buttons
                          Column(
                            children: [
                              Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF4F5F7),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/Facebook.png',
                                      height: 24,
                                      width: 24,
                                    ),
                                    const SizedBox(width: 12),
                                    const Text(
                                      'Continue with Facebook',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF4F5F7),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/Google.png',
                                      height: 24,
                                      width: 24,
                                    ),
                                    const SizedBox(width: 12),
                                    const Text(
                                      'Continue with Google',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
