import 'package:flutter/material.dart';

var login = false;
var userid = '';
var username = '';

var server_address="http://192.168.99.58:5000";

buildShowDialog(BuildContext context) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      });
}