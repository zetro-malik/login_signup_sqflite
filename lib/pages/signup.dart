import 'package:flutter/material.dart';
import 'package:login_signup_sqflite/database/local_Database.dart';
import 'package:login_signup_sqflite/model/person.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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
                  CircleAvatar(
                    backgroundImage: AssetImage(
                      'assets/profile.png',
                    ),
                    radius: 100,
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
