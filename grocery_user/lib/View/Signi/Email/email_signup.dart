import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_user/Firebase/firebase_services.dart';
import 'package:grocery_user/View/Signi/Email/register.dart';
import 'package:grocery_user/View/Signi/Email/signin_email.dart';
import 'package:grocery_user/Widget/common_indicator.dart';

class EmailSignUp extends StatefulWidget {
  const EmailSignUp({super.key});

  @override
  State<EmailSignUp> createState() => _EmailSignUpState();
}

class _EmailSignUpState extends State<EmailSignUp> {
  final formkey = GlobalKey<FormState>();

  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController password2controller = TextEditingController();

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
                    } else {
                      return null;
                    }
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
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 20, bottom: 5),
                child: TextFormField(
                  obscureText: isvisibility,
                  validator: (value) {
                    if (value != passwordcontroller.text.toString()) {
                      return "Not Match password";
                    } else {
                      return null;
                    }
                  },
                  controller: password2controller,
                  decoration: InputDecoration(
                      hintText: "Confirm Password",
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
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Already have an account"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EmailSignin(),
                            ));
                      },
                      child: Text(
                        "Signin",
                        style: TextStyle(color: Colors.green.shade800),
                      ),
                    ),
                  )
                ],
              ),
              CommonIndicatorButton(
                  backgroundColor: Colors.green.shade800,
                  foregroundColor: Colors.white,
                  isloading: isloading,
                  onPressed: () {
                    emailLoginButton(
                        email: emailcontroller.text.toString(),
                        password: passwordcontroller.text.toString());
                    // signInButton(
                    //     email: emailcontroller.text.toString(),
                    //     password: passwordcontroller.text.toString());
                  },
                  text: "SignUp")
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  Future<void> emailLoginButton(
      {required String email, required String password}) async {
    if (formkey.currentState!.validate()) {
      setState(() {
        isloading = true;
      });

      User? user = await FirebaseServices()
          .registerEmail(email: email, password: password);

      if (user != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RegisterAccount(
                user: user,
              ),
            ));
      }
    }
  }
}
