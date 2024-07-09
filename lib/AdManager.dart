import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:naat_app/apiConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class AdManager {

static int _colorIndex = 0;

static getAppBarColor(){
 return Color(0xFF122931);
}
static getRandomColor(){
  // get colors from list
  List<Color> colors = [
    Color(0xFF1C75D4),
    Color(0xFF328033),
    Color(0xFFD77209),
   // Color(0xFF590101),
  ];

  Color color = colors[_colorIndex];
  _colorIndex = (_colorIndex + 1) % colors.length;
  return color;
}
  static getNeumorphicBoxShadowColorLight(){
    return Color(0xFF1C3C47);
  }
  static getNeumorphicBoxShadowColorDark(){
    return Color(0xFF1C3C47);
  }
  static getNeumorphicBackgroundColor(){
    return Color(0xFF1C3C47);
  }
  static   getTextColor(){
    return Colors.white;
  }

  static String get baseURL {
    if (Platform.isAndroid) {
      return APP_BASE_URL;
    } else if (Platform.isIOS) {
      return APP_BASE_URL;
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
  static String get API_KEY {
    if (Platform.isAndroid) {
      return "goog_VSIiBRdoHzMNUiAgJgbUbpyHUlK";
    } else if (Platform.isIOS) {
      return "appl_bawYAQkuWOOYwVDRxyfPQzAcmvA";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
  static String get shareUrl {
    if (Platform.isAndroid) {
      return "https://play.google.com/store/apps/details?id="+packageName;
    } else if (Platform.isIOS) {
      return "https://apps.apple.com/us/app/%D8%A7%D9%84%D9%85%D8%B9%D9%84%D9%85-%D8%A7%D9%84%D8%A7%D9%84%D9%83%D8%AA%D8%B1%D9%88%D9%86%D9%8A/id"+packageName;
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
  static String get appName {
    if (Platform.isAndroid) {
      return "شروحات وحلول وامتحانات منهاج عُمان";
    } else if (Platform.isIOS) {
      return "شروحات وحلول وامتحانات منهاج عُمان";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
  static String get packageName {
    if (Platform.isAndroid) {
      return "com.shuruhat";
    } else if (Platform.isIOS) {
      return "1593733275";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
  static String get moreBooksApiUrl {
    if (Platform.isAndroid) {
      return "https://example.com/apps/api/bilali/more_books_api.json";
    } else if (Platform.isIOS) {
      return "https://example.com/apps/api/bilali/more_books_api.json";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get emailId {
    if (Platform.isAndroid) {
      return "mohmdahmad1968@gmail.com";
    } else if (Platform.isIOS) {
      return "mohmdahmad1968@icloud.com";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get appOpenId {
  return "";
     return "ca-app-pub-3940256099942544/9257395921";
    if (Platform.isAndroid) {
      return "ca-app-pub-8177765238464378/6180678589";
    } else if (Platform.isIOS) {
      return "ca-app-pub-8177765238464378/2743162302";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
  static String get bannerAdUnitId {
    return "ca-app-pub-8177765238464378/2290295726";

    if (Platform.isAndroid) {
      return "ca-app-pub-8177765238464378/7645142419";
    } else if (Platform.isIOS) {
      return "ca-app-pub-8177765238464378/4632568900";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {

    return "ca-app-pub-8177765238464378/9594070677";

    if (Platform.isAndroid) {
       return "ca-app-pub-8177765238464378/8630921029";
    } else if (Platform.isIOS) {
      return "ca-app-pub-8177765238464378/2006405564";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
  static String get appId {
  //  return "ca-app-pub-3940256099942544/9257395921";

    if (Platform.isAndroid) {
      return "ca-app-pub-8177765238464378~6415574698";
    } else if (Platform.isIOS) {
      return "ca-app-pub-8177765238464378~6415574698";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

}