import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_user/Firebase/firebase_services.dart';
import 'package:grocery_user/Model/user.dart';
import 'package:grocery_user/View/Home/home_screen.dart';

import '../../../Widget/common_indicator.dart';

class RegisterAccount extends StatefulWidget {
  User user;

  RegisterAccount({super.key, required this.user});

  @override
  State<RegisterAccount> createState() => _RegisterAccountState();
}

class _RegisterAccountState extends State<RegisterAccount> {
  final formkey = GlobalKey<FormState>();
  final namecontroller = TextEditingController();
  final numberController = TextEditingController();
  bool isvisibility = false;
  bool isloading = false;
  void togglechange() {
    setState(() {
      isvisibility = !isvisibility;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image(image: AssetImage("assets/images/signin.png")),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "Get your grocereis\nwith nectar",
                  style: TextStyle(fontSize: 33, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 20, bottom: 5),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter name";
                    } else {
                      return null;
                    }
                  },
                  controller: namecontroller,
                  decoration: InputDecoration(
                      hintText: "Name",
                      suffixIcon: Icon(Icons.mail_outline),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 20, bottom: 5),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  obscureText: isvisibility,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Entere valid Number";
                    } else {
                      return null;
                    }
                  },
                  controller: numberController,
                  decoration: InputDecoration(
                      hintText: "Number",
                      suffixIcon: isvisibility
                          ? IconButton(
                              onPressed: togglechange,
                              icon: Icon(Icons.visibility),
                            )
                          : IconButton(
                              onPressed: togglechange,
                              icon: Icon(Icons.visibility_off)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15))),
                ),
              ),
              CommonIndicatorButton(
                  backgroundColor: Colors.green.shade800,
                  foregroundColor: Colors.white,
                  isloading: isloading,
                  onPressed: () {
                    register();
                  },
                  text: "Continue")
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  void register() async {
    if (formkey.currentState!.validate()) {
      setState(() {
        isloading = true;
      });
      try {
        bool value = await FirebaseServices().createUserAndStoreInDatabase(
            UserData(
                id: widget.user.uid,
                contact: numberController.text.toString(),
                name: namecontroller.text.toString(),
                email: widget.user.email!,
                createdAt: DateTime.now().millisecondsSinceEpoch));
        if (value) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
              (route) => false);

          final snackBar = SnackBar(
              backgroundColor: Colors.black,
              margin: EdgeInsets.all(15),
              behavior: SnackBarBehavior.floating,
              duration: Duration(milliseconds: 3000),
              shape:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              content: Text(
                "SignUp SuccessFull",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.white),
              ));

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } catch (E) {}
    }
  }
}
