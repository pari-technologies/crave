import 'dart:async';
import 'package:a_crave/splashscreen2.dart';
import 'package:flutter/material.dart';
import 'package:splash_screen_view/SplashScreenView.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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
    // Navigator.of(context).pushReplacementNamed("/splash2");
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => SplashScreenTwo(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedOpacity(
          opacity: _visible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 2000),
        child:Container(
          color: Colors.white,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage("images/splashscreen.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ), /* add child content here */
        )
      ),



      // Container(
      //   height: double.infinity,
      //   width: double.infinity,
      //   color: Colors.white,
      //   child: SplashScreenView(
      //     navigateRoute: SplashScreenTwo(),
      //     duration: 3000,
      //     imageSize: 700,
      //     imageSrc: 'images/splashscreen.jpg',
      //     backgroundColor: Colors.white,
      //   ), /* add child content here */
      // ),
    );

  }
}