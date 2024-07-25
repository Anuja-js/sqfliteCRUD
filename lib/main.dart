import 'package:crud_sqflite_app/screens/edit_user_details.dart';
import 'package:crud_sqflite_app/screens/splash_screen.dart';
import 'package:flutter/material.dart';
const save_Key = "userLoggedIn";
void main(){
  runApp( MyApp()
  );
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Users",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.deepPurple
      ),
      home: SplashScreen(),
    );
  }
}
