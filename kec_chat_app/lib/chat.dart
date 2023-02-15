import 'package:flutter/material.dart';
import 'global.dart';
import 'package:http/http.dart' as HTTP;
import 'dart:convert' as convert;

// Global variable
List<Chat> chats = [Chat("dummy", true), Chat("dummy 2", false)];

class ChatWidget extends StatefulWidget {
  final String name;
  final bool online;

  const ChatWidget({super.key, required this.name, required this.online});

  @override
  Chat createState() => Chat(name, online);
}

class Chat extends State<ChatWidget> {
  late String name;
  late bool online;
  final _controller = TextEditingController();
  List<ChatBubble> convos = [
    const ChatBubble(text: "hi", isCurrentUser: false)
  ];

  Chat(this.name, this.online);

  void _addtext() {
    ChatBubble newchat = ChatBubble(text: _controller.text, isCurrentUser: true);
    setState(() {
      convos.add(newchat);
      _controller.text = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.greenAccent,
              child: Text(name[0]),
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              children: <Widget>[
                Text(name),
                online
                    ? const Text(
                        "online",
                        style: TextStyle(fontSize: 8),
                      )
                    : const Text("offline", style: TextStyle(fontSize: 8))
              ],
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      // Individual chat
      body: Stack(
        children: <Widget>[
          ListView(children: convos),
          /*ListView.builder(
            itemBuilder: (context, index) {
              return chats[index].build(context);
            },
          ),*/
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: _addtext,
                    backgroundColor: Colors.blue,
                    elevation: 0,
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ListItem extends StatefulWidget {
  const ListItem({super.key, required this.chat});

  final Chat chat;

  @override
  // ignore: library_private_types_in_public_api
  _listitem createState() => _listitem(chat: chat);
}

// ignore: camel_case_types
class _listitem extends State<ListItem> {
  Chat chat;
  _listitem({required this.chat});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => chat.build(context)));
      },
      leading: CircleAvatar(
        backgroundColor: Colors.blueAccent,
        child: Text(chat.name[0]),
      ),
      title: Text(chat.name),
    );
  }
}

class ChatList extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _chatlist createState() => _chatlist();
}

// ignore: camel_case_types
class _chatlist extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    if (chats.isEmpty) {
      return const Center(
        child: Text("Empty chats"),
      );
    }
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      children: chats.map((Chat chat) {
        return ListItem(chat: chat);
      }).toList(),
    );
  }
}

class SearchMem extends StatefulWidget {
  final Function() notifyParent;
  const SearchMem({super.key, required this.notifyParent});

  @override
  // ignore: library_private_types_in_public_api
  _searchmem createState() => _searchmem(notifyParent);
}

class _searchmem extends State<SearchMem> {
  final Function() notifyParent;

  _searchmem(this.notifyParent);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String uname = '';

  Future<void> _search() async {
    // connect to normal flask server
    String api = '/check?uname=$uname';
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
        if (jsonResponse["Value"]) {
          chats.add(Chat(uname, false));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('User not found'),
            backgroundColor: Colors.red,
          ));
        }
      }
    } on Exception catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('There was an error in server'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kec Chat app"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              "New Chat",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20.0),
            TextField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'username',
                  labelText: 'Username'),
              onChanged: (value) {
                uname = value;
              },
            ),
            const SizedBox(height: 20.0),
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
              onTap: () => _search(),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    Key? key,
    required this.text,
    required this.isCurrentUser,
  }) : super(key: key);
  final String text;
  final bool isCurrentUser;
  @override
  Widget build(BuildContext context) {
    return Padding(
      // asymmetric padding
      padding: EdgeInsets.fromLTRB(
        isCurrentUser ? 64.0 : 16.0,
        4,
        isCurrentUser ? 16.0 : 64.0,
        4,
      ),
      child: Align(
        // align the child within the container
        alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
        child: DecoratedBox(
          // chat bubble decoration
          decoration: BoxDecoration(
            color: isCurrentUser ? Colors.blue : Colors.grey[300],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: isCurrentUser ? Colors.white : Colors.black87),
            ),
          ),
        ),
      ),
    );
  }
}
