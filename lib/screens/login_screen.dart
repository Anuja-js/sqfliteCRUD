import 'package:crud_sqflite_app/screens/home_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();

  final formkey = GlobalKey<FormState>();
  bool obscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: const Text("Log In"),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 45),
        child: Form(
          key: formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                style: const TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Courier',
                ),
                controller: _nameController,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  labelText: 'Enter Your Name',
                  labelStyle: TextStyle(
                    color: Colors.deepOrangeAccent,
                  ),
                  fillColor: Colors.grey,
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2)),
                  errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please Enter Your Name";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                style: const TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Courier',
                ),
                controller: _passwordController,
                obscureText: obscure,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscure = !obscure;
                        });
                      },
                      icon: obscure
                          ?const Icon(Icons.visibility_outlined,
                              color: Colors.deepOrangeAccent)
                          :const Icon(
                              Icons.visibility_off_outlined,
                              color: Colors.deepOrangeAccent,
                            )),
                  labelText: "Enter Your Password",
                  labelStyle:const TextStyle(color: Colors.deepOrangeAccent),
                  border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2)),
                  errorBorder:const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 2),
                  ),
                  focusedBorder:const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please Enter Your Password";
                  } else {
                    return null;
                  }
                },
              ),
              const Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (formkey.currentState!.validate()) {
                      checkLogIn(context);
                    } else {
                       if (kDebugMode) {
                         print("Data Empty");
                       }
                    }
                    // checkLogIn(context);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.grey),
                    padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: MediaQuery.of(context).size.width / 2.7),
                    ),
                  ),
                  child: const Text("LogIn"),
                ),
              ),
              const SizedBox(height: 30,)
            ],
          ),
        ),
      )),
    );
  }

  void checkLogIn(BuildContext ctx) async {
    final username = _nameController.text;
    final password = _passwordController.text;
    if (username == "Anuja" && password == "anuja@gmail.com") {
//go to home
      if (kDebugMode) {
        print("User name and password correct");
      }
      final sharedprfs = await SharedPreferences.getInstance();
      await sharedprfs.setBool(save_Key, true);

      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx1) {
        return const HomePage();
      }));
    } else {
      if (kDebugMode) {
        print("User name and password doesn't match");
      }
      //snackBar
      const errorMessage = "User name or password is incorrect";

      ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
          margin: EdgeInsets.all(15.0),
          content: Text(errorMessage)
      )
      );
    }
  }
}
