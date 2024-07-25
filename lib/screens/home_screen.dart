import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import '../models/user.dart';
import '../utils/database_helper.dart';
import 'edit_user_details.dart';
import 'login_screen.dart';
import 'user_detail.dart';

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
          navigateToDetail(User('', '', 0, 0, ''), 'Add User');
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
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.yellow,
              child: Icon(Icons.person),
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
                builder: (context) => UserDetails(userList[position]),
              ));
            },
          ),
        );
      },
    );
  }

  void _delete(BuildContext context, User user) async {
    if (user.id != null) {
      int result = await databaseHelper.deleteUser(user.id!);
      if (result != 0) {
        _showSnackBar(context, 'User Deleted Successfully');
        updateListView();
      } else {
        _showSnackBar(context, 'Error Deleting User');
      }
    } else {
      _showSnackBar(context, 'Error: User ID is null');
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<User>> userListFuture = databaseHelper.getUserList();
      userListFuture.then((userList) {
        setState(() {
          this.userList = userList;
          this.count = userList.length;
        });
      });
    });
  }

  void navigateToDetail(User user, String name) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return UserDetailsEdit(user, name);
      }),
    );

    if (result) {
      updateListView();
    }
  }

  void logout(BuildContext context) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    showDialog(
      context: context,
      builder: (context1) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Do you want to logout?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context1).pop();
              },
              child: const Text(
                "Close",
                style: TextStyle(color: Colors.deepOrangeAccent),
              ),
            ),
            TextButton(
              onPressed: () async {
                await sharedPrefs.clear();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context1) => const LoginScreen()),
                      (route) => false,
                );
              },
              child: const Text(
                "Logout",
                style: TextStyle(color: Colors.deepOrangeAccent),
              ),
            ),
          ],
        );
      },
    );
  }
}
