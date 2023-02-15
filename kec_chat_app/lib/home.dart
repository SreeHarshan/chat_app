import 'package:socket_io_client/socket_io_client.dart' as io;
import 'dart:convert' as convert;
import 'package:flutter/material.dart';

import 'global.dart';
import 'login.dart';
import 'chat.dart';

late io.Socket socket;

void connect(BuildContext context) {
  try {
    print("connecting to server");
    socket = io.io(server_address);

    socket.onConnect((_) => {socket.emit("join", "hello")});

    socket.on("message", (data) => {});
    socket.on("login", login_result);
  } on Exception catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('There was an issue connecting to server, please restart'),
      backgroundColor: Colors.red,
    ));
  }
}

void login_result(var data) {
  var jsonResponse = convert.jsonDecode(data) as Map<String, dynamic>;

  login = jsonResponse["value"];
}

void login_io(String uname, String pass) {
  var json = {"uname": "$uname", "pass": "$pass"};
  print("sending json value to socket");
  socket.emit("login", json);
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _homepage createState() => _homepage();
}

// ignore: camel_case_types
class _homepage extends State<HomePage> {
  // ignore: non_constant_identifier_names
  Widget floating_button(BuildContext context) {
    if (login) {
      return FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SearchMem(notifyParent: refresh)));
          },
          child: const Icon(Icons.add));
    }
    return const SizedBox();
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Kec Chat App"), actions: <Widget>[
          Center(
              child: Text(
            userid,
            style: const TextStyle(fontSize: 13),
          )),
          IconButton(
              onPressed: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Login(
                                  notifyParent: refresh,
                                )))
                  },
              icon: const Icon(Icons.assignment_ind))
        ]),
        body: Center(
            child: login
                ? ChatList()
                : const Center(
                    child: Text("Login to view messages first"),
                  )),
        floatingActionButton: floating_button(context));
  }
}
