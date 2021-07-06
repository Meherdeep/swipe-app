import 'dart:ui';

import 'package:flutter/material.dart';

//Colors

///primary dark blue for the app
Color primaryColor = Color(0xFFFD297B);

///primary light blue for the app
Color accentColor = Color(0xFFFF5864);

///very light bluish-white
Color secondaryColor = Color(0xFFFF655B);

///color for showing errors, such as in snackbar
Color errorColor = Color(0xFFfa5a5a);

///color for small headings
Color headingColor = Color(0xFF8C8C8C);

Color secondaryButtonColor = Color(0xFF333431);

///[canvasColorDown] to be used when the gradient is darker at the top and
///lighter at the bottom
final canvasColorDown = Colors.white;

///[canvasColorUp] to be used when the gradient is lighter at the top and
///darker at the bottom
final canvasColorUp = Colors.white;

final bgColor = Color(0xFFF9F9F9);

//text

final defaultButtonTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 18,
);

final buttonTextStyle = TextStyle(
  color: Color(0xFF8B97AD),
  fontSize: 18,
);

///default text style with a [white] color and [18] font size
final defaultTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 16,
);

///style for places where text is big and bold
final bigBoldTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 40,
  fontWeight: FontWeight.bold,
  letterSpacing: 1.3,
);

final bigHeadingStyle = TextStyle(
  color: Colors.black,
  fontSize: 35,
  fontWeight: FontWeight.bold,
  letterSpacing: 1.5,
);

final smallHeadingStyle = TextStyle(
  color: headingColor,
  fontSize: 16,
);

///small subtitle text style
final smallTextStyle = TextStyle(
  fontSize: 14,
  color: Color(0xFF6F6D81),
);

final smallMutedTextStyle = defaultTextStyle.copyWith(
  color: headingColor,
  fontSize: 13,
);

//misc

///sets a very large value for borderradius for circular buttons
final borderRadiusButton = BorderRadius.circular(50);

///default border radius to be used accross app, value = 10
final borderRadiusDefault = BorderRadius.circular(10);
