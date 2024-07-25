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
  List<User> filteredUserList = [];
  int count = 0;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    updateListView();
    super.initState();
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<User>> userListFuture = databaseHelper.getUserList();
      userListFuture.then((userList) {
        setState(() {
          this.userList = userList;
          this.filteredUserList = userList;
          this.count = userList.length;
        });
      });
    });
  }

  void filterSearchResults(String query) {
    List<User> dummySearchList = [];
    dummySearchList.addAll(userList);
    if (query.isNotEmpty) {
      List<User> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.name!.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        // filteredUserList.clear();
        filteredUserList.addAll(dummyListData);
        count = filteredUserList.length;
      });
      return;
    } else {
      setState(() {
        filteredUserList.clear();
        filteredUserList.addAll(userList);
        count = filteredUserList.length;
      });
    }
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: filterSearchResults,
              decoration: InputDecoration(
                labelText: "Search",
                hintText: "Search by name",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
              ),
            ),
          ),
          Expanded(child: getUsersListView()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrangeAccent,
        onPressed: () {
          navigateToDetail(User('', '', " "as int, " "as int, ''), 'Add User');
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
              filteredUserList[position].name!,
              style: TextStyle(color: Colors.black),
            ),
            subtitle: Text(filteredUserList[position].description!),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.grey),
                  onPressed: () {
                    navigateToDetail(filteredUserList[position], 'Edit User');
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.grey),
                  onPressed: () {
                    _delete(context, filteredUserList[position]);
                  },
                ),
              ],
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => UserDetails(filteredUserList[position]),
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
