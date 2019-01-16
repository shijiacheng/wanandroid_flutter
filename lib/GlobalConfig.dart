import 'package:flutter/material.dart';

class GlobalConfig {
  static bool dark = false;

  static getThemeData(bool dark){
    if(dark){
      return themeDataDark;
    }else{
      return themeDataLight;
    }
  }

  static ThemeData themeData = getThemeData(dark);

  static ThemeData themeDataLight = new ThemeData(
    primarySwatch: Colors.blue,
    primaryColor: Colors.grey[100],
    primaryColorBrightness: Brightness.light,
  );

  static ThemeData themeDataDark = new ThemeData.dark();
}