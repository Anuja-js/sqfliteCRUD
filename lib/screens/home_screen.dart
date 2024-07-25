import 'dart:io';

import 'package:crud_sqflite_app/screens/user_detail.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../utils/database_helper.dart';
import 'edit_user_details.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<User> userList = [];
  int count = 0;

  @override
  void initState() {
    updateListView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),
        backgroundColor: Colors.deepOrangeAccent,
        actions: [
          IconButton(
            onPressed: () {
              logout(context);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: getUsersListView(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrangeAccent,
        onPressed: () {
          navigateToDetail(User('', '', null,null, '', null), 'Add User');
        },
        tooltip: 'Add User',
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getUsersListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        print(userList[position].imagePath);
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.yellow,
              radius: 25,
              child: userList[position].imagePath != null
                  ? Container(width: 50,height: 50,

                child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image.file(File(userList[position].imagePath!,),fit: BoxFit.cover,)),
              )
                  : Container(child: Icon(Icons.person),
              ),

            ),
            title: Text(
              userList[position].name!,
              style: TextStyle(color: Colors.black),
            ),
            subtitle: Text(userList[position].description!),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.grey),
                  onPressed: () {
                    navigateToDetail(userList[position], 'Edit User');
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.grey),
                  onPressed: () {
                    _delete(context, userList[position]);
                  },
                ),
              ],
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => UserDetails(userList[position])
              ));
            },
          ),
        );
      },
    );
  }

  void navigateToDetail(User user, String title) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserDetailsEdit(user, title),
      ),
    );
    if (result) {
      updateListView();
    }
  }

  void _delete(BuildContext context, User user) async {
    int result = await databaseHelper.deleteUser(user.id!);
    if (result != 0) {
      showSnackbar(context, 'User Deleted Successfully');
      updateListView();
    }
  }

  void showSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void updateListView() async {
    var userListFuture = databaseHelper.getUserList();
    userListFuture.then((userList) {
      setState(() {
        this.userList = userList;
        count = userList.length;
      });
    });
  }

  void logout(BuildContext context) {
    // Implement your logout functionality here
  }
}
