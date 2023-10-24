import 'dart:math';

import 'package:chess_bot/MainGameModel/PlayWithFriend/button_page.dart';
import 'package:chess_bot/generated/i18n.dart';
import 'package:chess_bot/test.dart';

import 'package:chess_bot/wholeproject/splash.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import 'MainGameModel/FreePlay/util/utils.dart';



// S strings;
// ChessController _chessController;
// OnlineGameController _onlineGameController;
// SharedPreferences prefs;
// String uuid;

// SharedPreferences prefs;

void main() async {
  //ensure binding to native code
  WidgetsFlutterBinding.ensureInitialized();
  //run the app
  runApp(MaterialApp(home:Splash(),
  debugShowCheckedModeBanner: false,));
  //init firebase app
  Firebase.initializeApp();
  //add all licenses
  // addLicenses();

}

