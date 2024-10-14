import 'package:flutter/material.dart';
import 'package:grocery_user/Firebase/firebase_services.dart';

import 'package:grocery_user/Widget/common_indicator.dart';

class AdressManageScreen extends StatefulWidget {
  const AdressManageScreen({super.key});

  @override
  State<AdressManageScreen> createState() => _AdressManageScreenState();
}

class _AdressManageScreenState extends State<AdressManageScreen> {
  final buildingnocontroller = TextEditingController();
  final areacontroller = TextEditingController();
  final citycontroller = TextEditingController();
  final pincodecontroller = TextEditingController();
  final statecontroller = TextEditingController();
  final formkey = GlobalKey<FormState>();
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
            key: formkey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter building no / house no";
                      } else {
                        return null;
                      }
                    },
                    controller: buildingnocontroller,
                    decoration: InputDecoration(
                        hintText: "Building no / House no",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter area ";
                      } else {
                        return null;
                      }
                    },
                    controller: areacontroller,
                    decoration: InputDecoration(
                        hintText: "Area / Near location",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter city";
                      } else {
                        return null;
                      }
                    },
                    controller: citycontroller,
                    decoration: InputDecoration(
                        hintText: "City",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter pincode";
                      } else if (value.length != 6) {
                        return "Enter valid pincode";
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.number,
                    controller: pincodecontroller,
                    decoration: InputDecoration(
                        hintText: "Pincode",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter state";
                      } else {
                        return null;
                      }
                    },
                    controller: statecontroller,
                    decoration: InputDecoration(
                        hintText: "State",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: CommonIndicatorButton(
                      isloading: isloading,
                      onPressed: () {
                        if (formkey.currentState!.validate()) {
                          setState(() {
                            isloading = true;
                          });
                          try {
                            FirebaseServices().addAdressFirebase(
                                context: context,
                                buildingno:
                                    buildingnocontroller.text.toString(),
                                neararea: areacontroller.text.toString(),
                                city: citycontroller.text.toString(),
                                pincode: pincodecontroller.text.toString(),
                                state: statecontroller.text.toString());
                          } catch (e) {
                            setState(() {
                              isloading = false;
                            });
                          }
                        }
                      },
                      text: "Save Adress",
                      backgroundColor: Colors.orange.shade300,
                      foregroundColor: Colors.white),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
