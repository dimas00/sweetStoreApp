import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sweet_store/App_widget.dart';
import 'package:sweet_store/screens/android/home.dart';
import 'package:sweet_store/screens/android/login.dart';


void main() {


  if(Platform.isAndroid){
    debugPrint('app no android');
    runApp(AppWidget());
    WidgetsFlutterBinding.ensureInitialized();
  }

  if(Platform.isIOS){
    debugPrint('app no ios');
  }



}
