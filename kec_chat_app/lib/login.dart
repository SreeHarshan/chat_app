import 'package:flutter/material.dart';
import 'package:http/http.dart' as HTTP;
import 'dart:convert' as convert;
import 'package:string_validator/string_validator.dart';

import 'global.dart';
import 'home.dart';
import 'signup.dart';
import 'home.dart';

class Login extends StatefulWidget {
  final Function() notifyParent;

  const Login({Key? key, required this.notifyParent}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _login(notifyParent);
}

class _login extends State<Login> {
  final Function() notifyParent;

  _login(this.notifyParent);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String uname = "",pass="";

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Save our form now.

    }

    // connect to normal flask server
    
    String api = '/login?uname=$uname&pass=$pass';
    var url = Uri.parse(server_address + api);
    buildShowDialog(context);
    print("connecting to server");
    try {
      var response = await HTTP.get(url).whenComplete(() {
        Navigator.pop(context);
        Navigator.pop(context);
        notifyParent();

      });
      print("Successfully connected");
      if (response.statusCode == 200) {
        var jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;
        if (jsonResponse["login"]) {
          login = true;
          username = uname;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Succcessfully login'),
        backgroundColor: Colors.green,
      ));
        }
        else{
          login = false;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Successfully login'),
          backgroundColor: Colors.green,
      ));
        }
      }
    } on Exception catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('There was an issue logging in'),
        backgroundColor: Colors.red,
      ));
    }
  }
  String? _validate_uname(String? value){
    if(value!.length>8 && value.isNotEmpty && isAlphanumeric(value) && isAlpha(value.substring(1))){
      return null;

    }
    return "The username must be at least 8 characters and must consist only of alphabets and numbers";
  }

  String? _validate_pass(String? value){
    if (value!.length < 8) {
      return 'The Password must be at least 8 characters.';
    }
    return null;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Kec Chat App"),
                    ),
        body: Center(
          child: !login
              ? Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      "User Login",
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'username',
                          labelText: 'Username'),
                          validator: _validate_uname,

                      onChanged: (value) {
                        uname = value;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'password',
                          labelText: 'Password'),
                          validator: _validate_pass,
                      onChanged: (value) {
                        pass = value;
                      },
                    ),
                    const SizedBox(height: 15.0),
                    GestureDetector(
                      child: Container(
                        width: 150.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: Theme.of(context).colorScheme.secondary),
                        child: const Center(
                          child: Text("Submit"),
                        ),
                      ),
                      onTap: () => _submit(),
                    ),
                    GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignupPage(
                                )));
                  },
                  child: Container(
                    height: 49.0,
                    width: 99.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: const Center(
                      child: Text(
                        'New User? Register here',
                        style: TextStyle(fontSize: 12,decoration: TextDecoration.underline),
                      ),
                    ),
                  )),

                  ],
                ),)
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Logged in as $username",
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 15.0),
                    GestureDetector(
                      child: Container(
                        width: 150.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: Theme.of(context).colorScheme.secondary),
                        child: const Center(
                          child: Text("Logout"),
                        ),
                      ),
                      onTap: () {
                        login = false;
                        userid = '';
                        username ='';
                        Navigator.pop(context);
                        notifyParent();
                      },
                    ),
                                      ],
                ),
        ));
  }
}