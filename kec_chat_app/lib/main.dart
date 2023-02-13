import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';

/*
void main(){
  runApp(const MyApp());
}
*/
void main() {
  runApp(DevicePreview(builder: (context) => const MyApp()));

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kec Chat App',
      theme: ThemeData(
                primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Kec Chat App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       title: Text(widget.title),
      ),
      body: const Center(
             ),
         );
  }
}
