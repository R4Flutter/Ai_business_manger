import 'package:flutter/material.dart';
import 'package:hack_this_fall_25/screens/Splash_screen.dart';
import 'package:hack_this_fall_25/screens/home_screen.dart';
import 'package:hack_this_fall_25/screens/recorder_screen.dart';
import 'package:hack_this_fall_25/screens/Confirm_Transciption_screen.dart';

class Routes {
   static const  splash = '/splash';
  static const home = '/home';
  static const recorder = '/recorder';
  static const confirm = '/confirm';

  static Map<String, WidgetBuilder> get all => {
        splash: (context) => const SplashScreen(),
        home: (context) => const HomeScreen(),
        recorder: (context) => const RecorderScreen(),
        confirm: (context) => const ConfirmTranscriptionScreen(),
      };
}
