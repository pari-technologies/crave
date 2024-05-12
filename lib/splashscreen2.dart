import 'dart:async';
import 'welcome.dart';
import 'package:flutter/material.dart';
import 'package:splash_screen_view/SplashScreenView.dart';


class SplashScreenTwo extends StatefulWidget {
  const SplashScreenTwo({Key? key}) : super(key: key);

  @override
  _SplashScreenTwoState createState() => _SplashScreenTwoState();
}

class _SplashScreenTwoState extends State<SplashScreenTwo> {

  bool _visible = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => loadData());

  }

  Future<Timer> loadData() async {
    setState(() {
      _visible = !_visible;
    });
    return Timer(const Duration(seconds: 2), onDoneLoading);
  }

  onDoneLoading() async {
    Navigator.of(context).pushReplacementNamed("/welcome");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("images/splashscreen.jpg"), fit: BoxFit.cover),
        ),
        child: Center(child:
          AnimatedOpacity(
            duration: const Duration(milliseconds: 2000),
            opacity: _visible ? 1.0 : 0.0,
            child: Container(
                padding: const EdgeInsets.only(top:150),
                child:Image.asset(
                  'images/crave_word.jpg',
                  height: 50,
                )
            ),
          )
            ),
      )
    );

  }
}