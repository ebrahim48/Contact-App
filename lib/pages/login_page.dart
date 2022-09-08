import 'package:contact_app/auth_prefs.dart';
import 'package:contact_app/pages/contact_list_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class LoginPage extends StatefulWidget {
  static const String routeName ="/login";
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
 bool isObscure = true;
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: const Icon(Icons.email),
                ),
              ),
              SizedBox(height: 10,),
              TextField(
                controller: passwordController,
                obscureText: isObscure,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(isObscure ? Icons.visibility_off: Icons.visibility),
                  onPressed: () {
                      setState(() {
                        isObscure = !isObscure;
                      });
                  },
                  )
                ),
              ),
             const SizedBox(height: 20,),
              TextButton(
                onPressed: () {
                  setLoginStatus(true).then((value) => Navigator.pushReplacementNamed(context, ContactListPage.routeName));
                },
                child: const Text('LOGIN'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
