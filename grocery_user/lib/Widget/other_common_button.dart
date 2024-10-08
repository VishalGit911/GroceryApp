
import 'package:flutter/material.dart';

Widget CommonOtherLogin(
    {required void Function()? onPressed,
      required Widget label,
      required Widget icon,
      required Color backgroundColor,
      required Color foregroundColor,
      required double width,
      required double height}) {
  return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          fixedSize: Size(width, height),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor),
      onPressed: onPressed,
      label: label,

      icon: icon);
}
