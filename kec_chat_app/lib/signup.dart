import 'package:flutter/material.dart';
import 'global.dart';
import 'package:http/http.dart' as HTTP;
import 'dart:convert' as convert;
import 'package:string_validator/string_validator.dart';

class SignupPage extends StatefulWidget{
  const SignupPage({super.key});

  @override
  _signuppage createState() => _signuppage();
}

// ignore: camel_case_types
class _signuppage extends State<SignupPage>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String uname="",pass="",name="",pass2="";

  bool _done = true;

Future<void> _submit() async {
    if (_formKey.currentState!.validate() && _done) {
      _formKey.currentState!.save(); // Save our form now.
    }

    // Check if username is used in db

    String api = '/check?uname=$uname';
    var url = Uri.parse(server_address + api);
    buildShowDialog(context);

    try {
      var response = await HTTP.get(url).whenComplete(() {
        Navigator.pop(context);
      });
      if (response.statusCode == 200) {
        var jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;

        if (jsonResponse["Value"]) {
          //user is present in db
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Username already present'),
        backgroundColor: Colors.red,
      ));
        } else {
          // username is not present in db, so add new user
          api = "/adduser?uname=$uname&pass=$pass&name=$name";
          var url = Uri.parse(server_address + api);
          // ignore: use_build_context_synchronously
          buildShowDialog(context);
          var response = await HTTP.get(url).whenComplete(() => {Navigator.pop(context)});
          if(response.statusCode==200){
            var jsonResponse = convert.jsonDecode(response.body) as Map<String,dynamic>;

            if(jsonResponse["Value"]){
              //Successfully added the user
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Successfully registered'),
        backgroundColor: Colors.green,
      ));     

            }
            else{
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('There was an issue in the server'),
        backgroundColor: Colors.red,
      ));

            }
          }
          else{
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('There was an issue in the server'),
        backgroundColor: Colors.red,
      ));
          }
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
        }
      } else {
        print("bad response");
      }
    }
    // ignore: empty_catches
    on Exception catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('There was an issue submitting'),
        backgroundColor: Colors.red,
      ));
    }
  }

  String? _validate_uname(String? value){
    if(value!.length>8 && value.isNotEmpty && isAlphanumeric(value) && isAlpha(value.substring(1))){
      return null;

    }
    _done = false;
    return "The username must be at least 8 characters and must consist only of alphabets and numbers";
  }

  String? _validate_pass(String? value){
    if (value!.length < 8) {
      _done = false;
      return 'The Password must be at least 8 characters.';
    }

    pass = value;
    return null;

  }

   String? _validate_pass2(String? value){
    if(value==pass) {
      return null;
    }
    _done = false;
    return "Entered passwords must match";

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Kec Chat App"),
                    ),
        body: Center(
          child: 
               Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      "Register",
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
                    const SizedBox(height:20.0),
                    TextFormField(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'name',
                          labelText: 'Name'),

                      onChanged: (value) {
                        name = value;
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
                    const SizedBox(height: 20.0),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'password',
                          labelText: 'Repeat Password'),
                          validator: _validate_pass2,
                      onChanged: (value) {
                        pass2 = value;
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
                    )
                  ],
                ),)
                      ));
  }

}