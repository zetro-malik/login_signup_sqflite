import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login_signup_sqflite/database/local_Database.dart';
import 'package:login_signup_sqflite/model/person.dart';

import '../widgets/SignInButton.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  File? _image;

  Future getImage(bool FromCamera) async {
    final image = await ImagePicker().pickImage(
        source: FromCamera ? ImageSource.camera : ImageSource.gallery);
    if (image == null) {
      return;
    }
    final tempImg = File(image.path);
    setState(() {
      _image = tempImg;
    });
  }

  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController confirmpass = TextEditingController();

  final _formkey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(50.0),

          //for validation
          child: Form(
            key: _formkey,

            //to add scroling feature
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //for round profile photo
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30),
                        )),
                        builder: (context) => DraggableScrollableSheet(
                            initialChildSize: 0.4,
                            maxChildSize: 0.9,
                            minChildSize: 0.32,
                            expand: false,
                            builder: (context, scrollController) {
                              return SingleChildScrollView(
                                controller: scrollController,
                                child: widgetsInBottomSheet(),
                              );
                            }),
                      );
                    },
                    child: _image == null
                        ? CircleAvatar(
                            backgroundColor: Colors.blue.shade300,
                            radius: 100,
                          )
                        : CircleAvatar(
                            backgroundImage: FileImage(_image!),
                            radius: 100,
                          ),
                  ),

                  //text
                  SizedBox(height: 10),
                  Text(
                    "SignUp",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),

                  //USERNAME textfield
                  TextFormField(
                    controller: user,
                    decoration: new InputDecoration(
                      labelText: "Username",
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderSide: new BorderSide(),
                      ),
                      //fillColor: Colors.green
                    ),
                    validator: (val) {
                      if (val!.length == 0) {
                        return "username cannot be empty";
                      } else {
                        return null;
                      }
                    },
                    style: new TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                  SizedBox(height: 20),

                  //[password] textfield

                  TextFormField(
                    controller: pass,
                    decoration: new InputDecoration(
                      labelText: "password",
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderSide: new BorderSide(),
                      ),
                      //fillColor: Colors.green
                    ),
                    validator: (val) {
                      if (val!.length == 0) {
                        return "password cannot be empty";
                      } else if (val!.length < 8) {
                        return "length less than 8";
                      } else {
                        return null;
                      }
                    },
                    style: new TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                  SizedBox(height: 20),

                  //confirm password textfield

                  TextFormField(
                    controller: confirmpass,
                    decoration: new InputDecoration(
                      labelText: "confirm password",
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderSide: new BorderSide(),
                      ),
                      //fillColor: Colors.green
                    ),
                    validator: (val) {
                      print(val);
                      if (val!.length == 0) {
                        return " empty";
                      } else if (val! != pass.text) {
                        return "not matching";
                      } else {
                        return null;
                      }
                    },
                    style: new TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),

                  SizedBox(height: 20),

                  //ending of textfields

                  //buttons for the screens
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            onCreate(context);
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 2,
                            primary: Colors.blue.shade400,
                            shape: const StadiumBorder(),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Create Account",
                              style: TextStyle(fontSize: 24),
                            ),
                          )),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget widgetsInBottomSheet() {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      clipBehavior: Clip.none,
      children: [
        tipOnBottomSheet(),
        Column(children: [
          const SizedBox(
            height: 100,
          ),
          SignInButton(
            onTap: () {
              getImage(true);
              Navigator.pop(context);
            },
            iconPath: 'assets/logos/camera.png',
            textLabel: 'Take from camera',
            backgroundColor: Colors.grey.shade300,
            elevation: 0.0,
          ),
          const SizedBox(
            height: 40,
          ),
          SignInButton(
            onTap: () {
              getImage(false);
              Navigator.pop(context);
            },
            iconPath: 'assets/logos/gallery.png',
            textLabel: 'Take from gallery',
            backgroundColor: Colors.grey.shade300,
            elevation: 0.0,
          ),
        ])
      ],
    );
  }

  Widget tipOnBottomSheet() {
    return Positioned(
      top: -15,
      child: Container(
        width: 60,
        height: 7,
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
      ),
    );
  }

  void onCreate(BuildContext context) async {
    if (_formkey.currentState!.validate()) {
      Person obj = Person(username: user.text, password: pass.text);
      await DatabaseHelper.instance.insertUser(obj);

      showDialog(
        context: context,
        builder: (context) {
          return Container(
            child: AlertDialog(
              title: Text("Inserted..."),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("OK"))
              ],
            ),
          );
        },
      );
    }
  }
}
