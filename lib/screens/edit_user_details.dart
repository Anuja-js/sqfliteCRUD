import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
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
  final ImagePicker _picker = ImagePicker();
  String appBarTitle;
  User user;

  TextEditingController nameController = TextEditingController();
  TextEditingController qualificationController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String? _imagePath;

  UserDetailsEditState(this.user, this.appBarTitle);
@override
  void initState() {
  nameController.text = user.name!;
  qualificationController.text = user.qualification!;
  ageController.text = user.age.toString();
  phoneController.text = user.phone.toString();
  descriptionController.text = user.description!;
  _imagePath = user.imagePath;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

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
        child: ListView(physics: ScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: <Widget>[
            InkWell(
              child: CircleAvatar(
                backgroundColor: Colors.yellow,
                radius: 50,
             child: _imagePath != null
                 ? Container(width: 100,height: 100,
                   child: ClipRRect(
               borderRadius: BorderRadius.circular(50),
                     clipBehavior: Clip.antiAliasWithSaveLayer,
                     child: Image.file(File(_imagePath!,),fit: BoxFit.cover,)),
                 )
                 : Container(child: Icon(Icons.camera_alt_outlined),
             ),

        ),


              onTap: ()async {
                final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  setState(() {
                    _imagePath = pickedFile.path;
                    print(_imagePath);
                  });
                }else{
                  print("error/////////////////////////////");
                }
              },
            ),
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
                child: Text(
                  appBarTitle == 'Save student' ? 'Update User' : 'Save student',
                  style: TextStyle(fontSize: 18.0),
                ),
                onPressed: () {
                  _save();
                },
              ),
            ),
          ],
        ),
      ),
    );
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
    user.phone = int.parse(phoneController.text);
  }

  void updateDescription() {
    user.description = descriptionController.text;
  }

  void _save() async {
    moveToLastScreen();
    user.imagePath = _imagePath;
    print(user.imagePath);
    if (appBarTitle == 'Save student') {
      await helper.insertUser(user);
    } else {
      await helper.updateUser(user);
    }
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}
