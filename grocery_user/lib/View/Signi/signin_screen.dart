import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_user/Widget/common_indicator.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final globalkey = GlobalKey<FormState>();
  final numbercontroller = TextEditingController();
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: globalkey,
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
                padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
                child: Text("Enter mobile number"),
              ),
              Padding(
                  padding: const EdgeInsets.only(
                    top: 5,
                    left: 25,
                    right: 25,
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter Mobile Number";
                      } else if (value.length != 10) {
                        return "Please nter valid number";
                      } else {
                        return null;
                      }
                    },
                    controller: numbercontroller,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10)),
                        prefix: Text("91+ "),
                        hintStyle: TextStyle(fontSize: 20)),
                  )),
              Center(
                child: CommonIndicatorButton(
                    isloading: isloading,
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green.shade800,
                    onPressed: () async {
                      if (globalkey.currentState!.validate()) {
                        setState(() {
                          isloading = true;
                        });

                        try {
                          final finalmobilenumber =
                              "+91${numbercontroller.text.toString().trim()}";
                          await FirebaseAuth.instance.verifyPhoneNumber(
                            phoneNumber: finalmobilenumber,
                            verificationCompleted: (phoneAuthCredential) async {
                              await FirebaseAuth.instance
                                  .signInWithCredential(phoneAuthCredential);
                              print("Verification completed");
                            },
                            verificationFailed: (error) {
                              final snackbar = SnackBar(
                                  content: Text("Failed : ${error.message}"));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackbar);

                              print("Verification failed: ${error.message}");
                              setState(() {
                                isloading = false;
                              });
                            },
                            codeSent: (verificationId, forceResendingToken) {
                              print("OTP sent");
                              setState(() {
                                isloading = false;
                              });
                            },
                            codeAutoRetrievalTimeout: (verificationId) {},
                          );
                        } catch (e) {}
                      }
                    },
                    text: "Continue"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
