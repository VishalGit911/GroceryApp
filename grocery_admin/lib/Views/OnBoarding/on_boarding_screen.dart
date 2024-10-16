import 'package:flutter/material.dart';
import 'package:grocery_admin/Views/SignIn/signin_screen.dart';
import 'package:grocery_admin/Widget/common_notindicator.dart';


class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/onboarding.png"),
                    fit: BoxFit.fill)),
          ),
          Column(
            children: [
              Expanded(flex: 5, child: SizedBox()),
              Expanded(
                  flex: 5,
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Image(
                              image: AssetImage("assets/images/logo.png")),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15, bottom: 0),
                          child: Text(
                            "  Welcome\nto our store",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 45,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Text(
                          "Get your groceries in as fast as one hour",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: CommanButton(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignInScreen(),
                                  ),
                                      (route) => false,
                                );

                                // Navigator.pushAndRemoveUntil(
                                //     context,
                                //     MaterialPageRoute(
                                //       builder: (context) => HomeScreen(),
                                //     ),
                                //     (route) => false);
                              },
                              text: Text(
                                "Get Started",
                                style: TextStyle(fontSize: 18),
                              ),
                              backgroundColor: Colors.green.shade800,
                              foregroundColor: Colors.white),
                        )
                      ],
                    ),
                  ))
            ],
          )
        ],
      ),
    );
  }
}
