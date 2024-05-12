import 'dart:async';
import 'package:a_crave/splashscreen2.dart';
import 'package:flutter/material.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:video_player/video_player.dart';
import 'constants.dart' as constant;
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'homeBase.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _visible = false;
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  late VideoPlayerController controller = VideoPlayerController.asset('video/splashvideo.mp4');
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => loadVideoPlayer());

  }

  // onDoneLoading() async {
  //   _firebaseMessaging.getToken().then((String? token) {
  //     assert(token != null);
  //     setState(() {
  //       // _homeScreenText = "Push Messaging token: $token";
  //     });
  //     setFCMToken(token);
  //     print("Push Messaging token: $token");
  //
  //   });
  //
  // }
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      // Fluttertoast.showToast(
      //     msg: "Location services are disabled.",
      //     toastLength: Toast.LENGTH_LONG,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.black,
      //     textColor: Colors.white,
      //     fontSize: 16.0
      // );
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        // Fluttertoast.showToast(
        //     msg: "Location permissions are denied",
        //     toastLength: Toast.LENGTH_LONG,
        //     gravity: ToastGravity.BOTTOM,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.black,
        //     textColor: Colors.white,
        //     fontSize: 16.0
        // );
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      // Fluttertoast.showToast(
      //     msg: "Location permissions are permanently denied, we cannot request permissions.",
      //     toastLength: Toast.LENGTH_LONG,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.black,
      //     textColor: Colors.white,
      //     fontSize: 16.0
      // );
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    // Fluttertoast.showToast(
    //     msg: "Got your location!",
    //     toastLength: Toast.LENGTH_LONG,
    //     gravity: ToastGravity.BOTTOM,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: Colors.black,
    //     textColor: Colors.white,
    //     fontSize: 16.0
    // );
    return await Geolocator.getCurrentPosition();
  }

  void getLocation() async{
    Position position = await _determinePosition();
    setState(() {
      setLatlng(position.latitude,position.longitude);
      print("curentl attaa");
      print(position.latitude);
      print(position.longitude);
    });
  }

  loadVideoPlayer(){
    getLocation();
    controller.addListener(() {
      setState(() {});
    });
    controller.initialize().then((value){
      setState(() {});
    });
    controller.play();
    return Timer(const Duration(seconds: 3), onDoneLoading);
  }

  setFCMToken(token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('fcm_token', token);
  }

  setLatlng(lat,lng) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('lat', lat);
    prefs.setDouble('lng', lng);
  }

  onDoneLoading() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey('user_email')){
       if(prefs.getString('user_email')== ""){
         print("user email empty");
         Navigator.of(context).pushReplacementNamed("/welcome");
       }
       else{
         Navigator.pushReplacement(
             context,
             MaterialPageRoute(
                 builder: (context) => PageViewDemo()));
       }

    }
    else{
      print("user email not exist");
      Navigator.of(context).pushReplacementNamed("/welcome");
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(constant.Color.crave_grey),
        child: Center(
          child:AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: VideoPlayer(controller),
          ),
        ),

      )




    );

  }
}