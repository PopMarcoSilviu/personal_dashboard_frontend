import 'package:flutter/material.dart';


class CustomTheme {
  static ThemeData get lightTheme { //1
    return ThemeData( //2
        primaryColor: Colors.purple,
        scaffoldBackgroundColor: Colors.grey[300],
        fontFamily: 'Montserrat', //3
        buttonTheme: ButtonThemeData( // 4
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          buttonColor: Colors.purpleAccent,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: Colors.purple,
        ),
    ),
      focusColor: Colors.purple,
      textSelectionTheme: TextSelectionThemeData(selectionHandleColor: Colors.purple),
      hoverColor: Colors.purple[900]

    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
        primaryColor: Colors.grey[700],
        scaffoldBackgroundColor: Colors.black,
        fontFamily: 'Montserrat',
        textTheme: ThemeData.dark().textTheme,
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          buttonColor: Colors.purple[300],

        )
    );
  }

}