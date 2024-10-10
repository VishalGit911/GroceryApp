import 'package:flutter/material.dart';
import 'package:grocery_user/View/Signi/Email/email_signup.dart';
import 'package:grocery_user/Widget/common_indicator.dart';

import '../../../Firebase/firebase_services.dart';
import '../../Home/home_screen.dart';

class EmailSignin extends StatefulWidget {
  const EmailSignin({super.key});

  @override
  State<EmailSignin> createState() => _EmailSigninState();
}

class _EmailSigninState extends State<EmailSignin> {
  final formkey = GlobalKey<FormState>();

  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  void togglechange() {
    setState(() {
      isvisibility = !isvisibility;
    });
  }

  bool isvisibility = false;
  bool isloading = false;
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
                      return "Enter valid email";
                    } else {
                      return null;
                    }
                  },
                  controller: emailcontroller,
                  decoration: InputDecoration(
                      hintText: "Email",
                      suffixIcon: Icon(Icons.mail_outline),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 20, bottom: 5),
                child: TextFormField(
                  obscureText: isvisibility,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Entere valid password";
                    } else {}
                  },
                  controller: passwordcontroller,
                  decoration: InputDecoration(
                      hintText: "Password",
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("don't have an account ?"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EmailSignUp(),
                            ));
                      },
                      child: Text(
                        "SignUp",
                        style: TextStyle(color: Colors.green.shade800),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: CommonIndicatorButton(
                    backgroundColor: Colors.green.shade800,
                    foregroundColor: Colors.white,
                    isloading: isloading,
                    onPressed: () {
                      signInButton(
                          email: emailcontroller.text.toString(),
                          password: passwordcontroller.text.toString());
                    },
                    text: "SignIn"),
              )
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  signInButton({required String email, required String password}) async {
    if (formkey.currentState!.validate()) {
      setState(() {
        isloading = true;
      });
      try {
        final user = await FirebaseServices()
            .signInWithEmailPassword(email: email, password: password);
        if (user != null) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
            (route) => false,
          );
          final snackBar = SnackBar(
              backgroundColor: Colors.black,
              margin: EdgeInsets.all(15),
              behavior: SnackBarBehavior.floating,
              duration: Duration(milliseconds: 3000),
              shape:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              content: Text(
                "SignIn SuccessFull",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.white),
              ));

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } catch (e) {
        final snackBar = SnackBar(
            backgroundColor: Colors.black,
            margin: EdgeInsets.all(15),
            behavior: SnackBarBehavior.floating,
            duration: Duration(milliseconds: 3000),
            shape: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            content: Text(
              "Not User Found",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.white),
            ));

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } finally {
        setState(() {
          isloading = false;
        });
      }
    }
  }
}
