// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:crud_sqflite_app/screens/home_screen.dart';
import 'package:crud_sqflite_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:crud_sqflite_app/models/user.dart';
import 'package:crud_sqflite_app/screens/edit_user_details.dart';
import 'package:crud_sqflite_app/utils/database_helper.dart';

class UserDetails extends StatelessWidget {
  final User user;

  const UserDetails(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name!),
        backgroundColor: Colors.black,
      ),
      body: Stack(

        children: [
          Positioned(
              top: 0,
              left:0,
              right: 0,
              bottom: 0,
              child: Image.asset("assets/images/background.jpeg",fit: BoxFit.fill,)),
          Positioned(
            left:  MediaQuery.of(context).size.width/2.55, top: 20,

            child:   CircleAvatar(
              backgroundColor: Colors.black,
              radius: 50,
              child: user.imagePath != null
                  ? SizedBox(width:100,height: 100,

                child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image.file(File(user.imagePath!,),fit: BoxFit.cover,)),
              )
                  : const Icon(Icons.person),

            ),),
          Positioned(
            top: MediaQuery.of(context).size.height/7.5,
            left: 20,
            right: 20,
            bottom: 20,
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Name:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  user.name.toString(),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Qualification:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  user.qualification.toString(),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Age:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  user.age.toString(),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Phone:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  user.phone.toString(),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Description:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  user.description.toString(),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height/4.5,
            left: 25,
            right: 25,
            child:
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(

                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(

                    builder: (context) => UserDetailsEdit(user, "Edit User"),
                  ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                  child: Text('Edit'),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _deleteUser(context, user);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                  child: Text('Delete'),
                ),
              ),
            ],
          ),)
        ],

      ),
    );
  }

  void _deleteUser(BuildContext context, User user) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    int result = await databaseHelper.deleteUser(user.id!);
    if (result != 0) {
      _showSnackBar(context, 'User Deleted Successfully');

   Navigator.of(context).push(MaterialPageRoute(builder:  (context) => HomePage())
   );
    } else {
      _showSnackBar(context, 'Error Deleting User');
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
