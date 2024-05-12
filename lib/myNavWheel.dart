import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:a_crave/profileBusiness.dart';
import 'package:a_crave/reelsDetails.dart';

import 'camera_home.dart';
import 'camera_screen.dart';
import 'cravingsPage.dart';
import 'homepage.dart';
import 'notificationsPage.dart';
import 'profileUser.dart';

import 'chatPage.dart';
import 'reels.dart';

import 'showStories.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';

import 'package:sizer/sizer.dart';
import 'dart:math' as math;

import 'circle_wheel_scroll/circle_wheel_scroll_view.dart';
import 'stories_for_flutter/lib/stories_for_flutter.dart';
import 'package:circle_list/circle_list.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'constants.dart' as constant;

class MyNavWheel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:100),
      child:
      Transform.scale(
        scale:
        (MediaQuery.of(context).size.height / 600),
        child:CircleList(
          // showInitialAnimation: true,
          rotateMode:RotateMode.allRotate,
          innerCircleColor:Color(constant.Color.crave_blue),
          outerCircleColor:Color(constant.Color.crave_blue),
          origin: Offset(50.0.w, 0),
          children: [
            Container(),
            Container(),
            Container(),
            Container(),
            Container(),
            Container(),

            Image(image: AssetImage('images/menu_settings.png'),height:30),
            GestureDetector(
              onTap:(){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CameraScreen()));
              },
              child: Image(image: AssetImage('images/menu_camera.png'),height:30),
            ),

            GestureDetector(
              onTap:(){
                // Navigator.pushReplacement(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => Homepage()));
                // Navigator.of(context).pushNamed('/');
              },
              child: Image(image: AssetImage('images/menu_home.png'),height:35),
            ),
            GestureDetector(
              onTap:(){
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => CravingsPage()));
                Navigator.of(context).pushNamed('/cravingsPage');
              },
              child: Image(image: AssetImage('images/menu_cravings.png'),height:30),
            ),

            GestureDetector(
              onTap:(){
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => ReelsDetails()));
              },
              child:Image(image: AssetImage('images/menu_reels.png'),height:35),
            ),

            GestureDetector(
              onTap:(){
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => ProfileUser()));
              },
              child:Image(image: AssetImage('images/menu_me.png'),height:35),
            ),

            GestureDetector(
              onTap:(){
                // Navigator.pushReplacement(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => ChatPage()));
                Navigator.of(context).pushNamed('/chatPage');
              },
              child: Image(image: AssetImage('images/menu_chat.png'),height:30),
            ),

            GestureDetector(
              onTap:(){
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationsPage()));
              },
              child: Image(image: AssetImage('images/menu_bell.png'),height:40),
            ),

            Container(),
            Container(),
            Container(),
            Container(),

          ],
        ),
      ),
    );
  }
}
