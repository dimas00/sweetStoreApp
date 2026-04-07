import 'package:flutter/material.dart';

import '../common/constants/app_colors.dart';
import '../login.dart';


class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 3)).then((_) =>  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> Login())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(

        alignment: Alignment.center,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomLeft,
                colors: [AppColors.purpleone, AppColors.purpletwo])
        ),
        child:Container(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),

        ),
      ),


    );
  }
}
