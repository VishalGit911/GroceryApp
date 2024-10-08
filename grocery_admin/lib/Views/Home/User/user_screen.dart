import 'package:flutter/material.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)),
            borderSide: BorderSide.none),
        title: Text("User"),
        backgroundColor: Colors.deepPurple.shade200,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Text(
          "Not Found",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.normal),
        ),
      ),
    );
  }
}
