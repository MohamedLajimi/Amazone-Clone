import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/auth/services/auth_service.dart';
import 'package:amazon_clone/widgets/custom_button.dart';
import 'package:amazon_clone/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

enum Auth { signin, signup }

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth-screen';
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthService authService = AuthService();
  Auth _auth = Auth.signup;
  final _signUpFormKey = GlobalKey<FormState>();
  final _signInFormKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: GlobalVariables.greyBackgroundCOlor,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
            child: Column(
              children: [
                const Text(
                  'Welcome',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                  tileColor:
                      _auth == Auth.signup ? Colors.white : Colors.transparent,
                  leading: Radio(
                    activeColor: GlobalVariables.secondaryColor,
                    value: Auth.signup,
                    groupValue: _auth,
                    onChanged: (value) {
                      setState(() {
                        _auth = value!;
                      });
                    },
                  ),
                  title: const Text(
                    'Create Account',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                if (_auth == Auth.signup)
                  Container(
                    color: GlobalVariables.backgroundColor,
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                        key: _signUpFormKey,
                        child: Column(
                          children: [
                            CustomTextField(
                                controller: _nameController, hintText: 'Name'),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomTextField(
                                controller: _emailController,
                                hintText: 'Email'),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomTextField(
                                controller: _passwordController,
                                hintText: 'Password'),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomButton(
                                text: 'Sign Up',
                                onPressed: () {
                                  if (_signUpFormKey.currentState!.validate()) {
                                    authService.signUpUser(
                                        context: context,
                                        name: _nameController.text,
                                        email: _emailController.text,
                                        password: _passwordController.text);
                                  }
                                })
                          ],
                        )),
                  ),
                ListTile(
                  tileColor:
                      _auth == Auth.signin ? Colors.white : Colors.transparent,
                  leading: Radio(
                    activeColor: GlobalVariables.secondaryColor,
                    value: Auth.signin,
                    groupValue: _auth,
                    onChanged: (value) {
                      setState(() {
                        _auth = value!;
                      });
                    },
                  ),
                  title: const Text(
                    'Sign In',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                if (_auth == Auth.signin)
                  Container(
                    color: GlobalVariables.backgroundColor,
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                        key: _signInFormKey,
                        child: Column(
                          children: [
                            CustomTextField(
                                controller: _emailController,
                                hintText: 'Email'),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomTextField(
                                controller: _passwordController,
                                hintText: 'Password'),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomButton(
                                text: 'Sign In',
                                onPressed: () {
                                  if (_signInFormKey.currentState!.validate()) {
                                    authService.signInUser(
                                        context: context,
                                        email: _emailController.text,
                                        password: _passwordController.text);
                                  }
                                })
                          ],
                        )),
                  ),
              ],
            ),
          )),
    );
  }
}
