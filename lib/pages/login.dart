import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:login_signup_sqflite/database/local_Database.dart';
import 'package:login_signup_sqflite/pages/signup.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();
  final _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(
                    'assets/profile.png',
                  ),
                  radius: 100,
                ),
                SizedBox(height: 10),
                Text(
                  "Login",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
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
                    if (val?.length == 0) {
                      return "username cannot be empty";
                    } else {
                      return null;
                    }
                  },
                  style: new TextStyle(
                    fontFamily: "Poppins",
                  ),
                ),
                SizedBox(height: 10),
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
                      return "password length should be greater than 8";
                    } else {
                      return null;
                    }
                  },
                  style: new TextStyle(
                    fontFamily: "Poppins",
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        onPressed: login,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Login",
                            style: TextStyle(fontSize: 24),
                          ),
                        )),
                    SizedBox(height: 20),
                    ElevatedButton(
                        onPressed: () {
                          _navigateToNextScreen(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("SignUp", style: TextStyle(fontSize: 24)),
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void login() async {
    String user_exits = "not found";
    if (await DatabaseHelper.instance.checkUser(user.text, pass.text)) {
      user_exits = "User exits";
    }
    if (_formKey.currentState!.validate()) {
      showDialog(
          context: context,
          builder: ((context) {
            return Container(
              child: AlertDialog(
                title: Text(user_exits),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("OK"))
                ],
              ),
            );
          }));
    }
  }

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SignUp()));
  }
}
