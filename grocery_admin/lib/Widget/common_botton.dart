import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget CommonIndicatorButton(
    {required isloading,
    required Color? foregroundColor,
    required Color? backgroundColor,
    required void Function()? onPressed,
    required text}) {
  return Padding(
    padding: const EdgeInsets.only(top: 50),
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                foregroundColor: foregroundColor,
                backgroundColor: backgroundColor,
                fixedSize: Size(400, 60)),
            onPressed: onPressed,
            child: isloading
                ? CircularProgressIndicator(
                    color: Colors.white,
                  )
                : Text(
                    text,
                    style: TextStyle(fontSize: 20),
                  )),
      ),
    ),
  );
}
