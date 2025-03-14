import 'package:flutter/material.dart';

class MySplashScreen extends StatefulWidget {
  final String itemSplash;

  const MySplashScreen({Key? key, required this.itemSplash}) : super(key: key);

  @override
  MySplashScreenState createState() => MySplashScreenState();
}

class MySplashScreenState extends State<MySplashScreen> {
  bool alreadySaved = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Container(
        color: Colors.white,
        child: Image.asset(
          widget.itemSplash,
          fit: BoxFit.fill,
        ),
      );
}
