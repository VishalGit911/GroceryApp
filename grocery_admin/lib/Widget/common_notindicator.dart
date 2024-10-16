import 'package:flutter/material.dart';

Widget CommanButton({
  required void Function()? onPressed,
  required Widget text,
  required Color? backgroundColor,
  required Color? foregroundColor,
  // required double width,
  // required double height,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Center(
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              fixedSize: Size(350, 60),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              backgroundColor: backgroundColor,
              foregroundColor: foregroundColor),
          onPressed: onPressed,
          child: text),
    ),
  );
}
