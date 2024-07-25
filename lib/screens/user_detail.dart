import 'package:flutter/material.dart';
import 'package:crud_sqflite_app/models/user.dart';
import 'package:crud_sqflite_app/screens/edit_user_details.dart';
import 'package:crud_sqflite_app/utils/database_helper.dart';

class UserDetails extends StatelessWidget {
  final User user;

  UserDetails(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              user.name.toString(),
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Qualification:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              user.qualification.toString(),
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Age:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              user.age.toString(),
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Phone:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              user.phone.toString(),
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Description:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              user.description.toString(),
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => UserDetailsEdit(user, "Edit User"),
                      ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                      child: Text('Edit'),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrangeAccent,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _deleteUser(context, user);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                      child: Text('Delete'),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrangeAccent,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteUser(BuildContext context, User user) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    int result = await databaseHelper.deleteUser(user.id!);
    if (result != 0) {
      _showSnackBar(context, 'User Deleted Successfully');
      Navigator.pop(context, true);
    } else {
      _showSnackBar(context, 'Error Deleting User');
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
