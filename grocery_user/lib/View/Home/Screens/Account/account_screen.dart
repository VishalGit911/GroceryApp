import 'package:flutter/material.dart';
import 'package:grocery_user/Firebase/firebase_services.dart';
import 'package:grocery_user/Model/user.dart';
import 'package:grocery_user/View/Signi/Email/email_signup.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      getUserData();
    });
    super.initState();
  }

  UserData? userData;
  String name = "";
  String contact = "";
  String email = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                  flex: 2,
                  child: Container(
                    child: Card(
                      color: Colors.deepPurple.shade200,
                      shadowColor: Colors.black,
                      elevation: 10,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                radius: 50,
                                child: Center(
                                  child: Icon(
                                    Icons.person,
                                    size: 50,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 6,
                              child: Container(
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${name}",
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "${contact}",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        "${email}",
                                        style: TextStyle(fontSize: 16),
                                      )
                                    ],
                                  ),
                                ),
                              ))
                        ],
                      ),
                    ),
                  )),
              Expanded(
                  flex: 8,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ListTile(
                        title: Text("LogOut"),
                        trailing: IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Are you sore LogOut"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("Cencel")),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EmailSignUp(),
                                                ),
                                                (route) => false);
                                          },
                                          child: Text("Ok"))
                                    ],
                                  );
                                },
                              );
                            },
                            icon: Icon(Icons.logout))),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getUserData() async {
    userData = await FirebaseServices().getUserData();

    setState(() {
      name = userData!.name;
      contact = userData!.contact;
      email = userData!.email;
    });
  }
}
