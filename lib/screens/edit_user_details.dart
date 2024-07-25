import 'package:flutter/material.dart';
import '../models/user.dart';
import '../utils/database_helper.dart';

class UserDetailsEdit extends StatefulWidget {
  final User user;
  final String appBarTitle;

  UserDetailsEdit(this.user, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return UserDetailsEditState(this.user, this.appBarTitle);
  }
}

class UserDetailsEditState extends State<UserDetailsEdit> {
  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  User user;

  TextEditingController nameController = TextEditingController();
  TextEditingController qualificationController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  UserDetailsEditState(this.user, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    nameController.text = user.name.toString();
    qualificationController.text = user.qualification.toString();
    ageController.text = user.age.toString();
    phoneController.text = user.phoneNumber.toString();
    descriptionController.text = user.description.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        backgroundColor: Colors.deepOrangeAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            moveToLastScreen();
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: nameController,
                style: TextStyle(fontSize: 18.0),
                onChanged: (value) {
                  updateName();
                },
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(fontSize: 18.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: qualificationController,
                style: TextStyle(fontSize: 18.0),
                onChanged: (value) {
                  updateQualification();
                },
                decoration: InputDecoration(
                  labelText: 'Qualification',
                  labelStyle: TextStyle(fontSize: 18.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: ageController,
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 18.0),
                onChanged: (value) {
                  updateAge();
                },
                decoration: InputDecoration(
                  labelText: 'Age',
                  labelStyle: TextStyle(fontSize: 18.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: phoneController,
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 18.0),
                onChanged: (value) {
                  updatePhone();
                },
                decoration: InputDecoration(
                  labelText: 'Phone',
                  labelStyle: TextStyle(fontSize: 18.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: descriptionController,
                style: TextStyle(fontSize: 18.0),
                onChanged: (value) {
                  updateDescription();
                },
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(fontSize: 18.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrangeAccent,
                  textStyle: TextStyle(fontSize: 18.0),
                ),
                onPressed: () {
                  setState(() {
                    _save();
                  });
                },
                child: Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void updateName() {
    user.name = nameController.text;
  }

  void updateQualification() {
    user.qualification = qualificationController.text;
  }

  void updateAge() {
    user.age = int.parse(ageController.text);
  }

  void updatePhone() {
    user.phoneNumber = int.parse(phoneController.text);
  }

  void updateDescription() {
    user.description = descriptionController.text;
  }

  void _save() async {
    moveToLastScreen();

    int result;
    if (user.id != null) {
      result = await helper.updateUser(user);
    } else {
      result = await helper.insertUser(user);
    }

    if (result != 0) {
      _showAlertDialog('Status', 'User Saved Successfully');
    } else {
      _showAlertDialog('Status', 'Problem Saving User');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
      context: context,
      builder: (_) => alertDialog,
    );
  }
}
