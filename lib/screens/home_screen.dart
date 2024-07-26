import 'dart:io';

import 'package:crud_sqflite_app/screens/user_detail.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../utils/database_helper.dart';
import 'edit_user_details.dart';
import 'login_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<User> userList = [];
  int count = 0;
  bool isPress = true;
  @override
  void initState() {
    updateListView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Students"),
        backgroundColor: Colors.black,
        actions: [
          IconButton(onPressed: () {
            setState(() {
              isPress=!isPress;
            });
          }, icon: Icon(Icons.grid_4x4_outlined)),
          IconButton(
            onPressed: () {
              logout(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Image.asset(
                "assets/images/background.jpeg",
                fit: BoxFit.fill,
              )),
      isPress?    getUsersListView():getUserGridView()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          navigateToDetail(User('', '', null, null, '', null), 'Add Student');
        },
        tooltip: 'Add Student',
        child: const Icon(Icons.add),
      ),
    );
  }

  ListView getUsersListView() {
    return ListView.builder(
      physics: ScrollPhysics(),
      scrollDirection: Axis.vertical,

      
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.transparent,
          elevation: 2.0,
          child: ListTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            leading: CircleAvatar(
              backgroundColor: Colors.black,
              radius: 25,
              child: userList[position].imagePath != null
                  ? SizedBox(
                      width: 50,
                      height: 50,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Image.file(
                            File(
                              userList[position].imagePath!,
                            ),
                            fit: BoxFit.cover,
                          )),
                    )
                  : const Icon(Icons.person),
            ),
            title: Text(
              userList[position].name!,
              style: const TextStyle(color: Colors.black),
            ),
            subtitle: Text(userList[position].qualification!),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.grey),
                  onPressed: () {
                    navigateToDetail(userList[position], 'Edit User');
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.grey),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Logout?..."),
                            content: Text(
                                "Are you sure? ${userList[position].name} is deleted?"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Cancel")),
                              TextButton(
                                  onPressed: () {
                                    _delete(context, userList[position]);
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Delete")),
                            ],
                          );
                        });
                  },
                ),
              ],
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => UserDetails(userList[position])));
            },
          ),
        );
      },
    );
  }

  GridView getUserGridView() {
    return GridView.builder(padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        physics: ScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: count,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (BuildContext context, int position) {
          return InkWell(
            onTap:() {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => UserDetails(userList[position])));
          },
            child: Card(shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              color: Colors.transparent,
              elevation: 2.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 35,
                        child: userList[position].imagePath != null
                            ? SizedBox(
                          width: 80,
                          height: 80,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Image.file(
                                File(
                                  userList[position].imagePath!,
                                ),
                                fit: BoxFit.cover,
                              )),
                        )
                            : const Icon(Icons.person),
                      ),
                      SizedBox(height: 20,),
                      Text(
                        userList[position].name!,
                        style: const TextStyle(color: Colors.black,fontSize: 18),
                      ),
                      SizedBox(height: 20,),
                      Text(
                        userList[position].qualification!,
                        style: const TextStyle(color: Colors.black54,fontSize: 15),
                      ),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.grey),
                          onPressed: () {
                            navigateToDetail(userList[position], 'Edit User');
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.grey),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Logout?..."),
                                    content: Text(
                                        "Are you sure? ${userList[position].name} is deleted?"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("Cancel")),
                                      TextButton(
                                          onPressed: () {
                                            _delete(context, userList[position]);
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("Delete")),
                                    ],
                                  );
                                });
                          },
                        ),
                      ],)
                    ],
                  ),
                ),

              ),

          );
        });
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
      // ignore: use_build_context_synchronously
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

  logout(BuildContext ctx) async {
    final sharedprfs = await SharedPreferences.getInstance();
    // ignore: use_build_context_synchronously
    showDialog(
        context: ctx,
        builder: (ctx1) {
          return AlertDialog(
            title: const Text("Logout"),
            content: const Text("Do you want to logout......?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx1).pop();
                  },
                  child: const Text("Close")),
              TextButton(
                  onPressed: () async {
                    await sharedprfs.clear();
                    // ignore: use_build_context_synchronously
                    Navigator.of(ctx).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (ctx1) => const LoginScreen()),
                        (route) => false);
                  },
                  child: const Text("Logout")),
            ],
          );
        });
  }
}
