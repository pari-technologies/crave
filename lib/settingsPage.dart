// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:a_crave/login.dart';
import 'package:a_crave/reels.dart';
import 'package:a_crave/reelsDetails.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';

import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homeBase.dart';
import 'homepage.dart';
import 'profileBusiness.dart';
import 'profileUser.dart';

import 'constants.dart' as constant;

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {

  bool isCrave = false;
  bool isLikes = false;
  bool isComment = false;
  bool isWheel = false;
  bool isDrag = false;
  bool isWheelSound = false;
  @override
  void initState() {
    super.initState();
    //WidgetsBinding.instance!.addPostFrameCallback((_) => startLoad());
  }

  void goToComments() {
    setState(() {
      Navigator.of(context).pushNamed("/feedDetails");
    });
  }

  void logout() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user_email", "");

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Login()));

    // Navigator.of(context).pushReplacementNamed("/login");

  }

  void toggleCrave(bool value) {

    if(isCrave == false)
    {
      setState(() {
        isCrave = true;
        // textValue = 'Switch Button is ON';
      });
      print('Switch Button is ON');
    }
    else
    {
      setState(() {
        isCrave = false;
        // textValue = 'Switch Button is OFF';
      });
      print('Switch Button is OFF');
    }
  }

  void toggleLikes(bool value) {

    if(isLikes == false)
    {
      setState(() {
        isLikes = true;
        // textValue = 'Switch Button is ON';
      });
      print('Switch Button is ON');
    }
    else
    {
      setState(() {
        isLikes = false;
        // textValue = 'Switch Button is OFF';
      });
      print('Switch Button is OFF');
    }
  }

  void toggleComment(bool value) {

    if(isComment == false)
    {
      setState(() {
        isComment = true;
        // textValue = 'Switch Button is ON';
      });
      print('Switch Button is ON');
    }
    else
    {
      setState(() {
        isComment = false;
        // textValue = 'Switch Button is OFF';
      });
      print('Switch Button is OFF');
    }
  }

  void toggleWheel(bool value) {

    if(isWheel == false)
    {
      setState(() {
        isWheel = true;
        // textValue = 'Switch Button is ON';
      });
      print('Switch Button is ON');
    }
    else
    {
      setState(() {
        isWheel = false;
        // textValue = 'Switch Button is OFF';
      });
      print('Switch Button is OFF');
    }
  }

  void toggleDrag(bool value) {

    if(isDrag == false)
    {
      setState(() {
        isDrag = true;
        // textValue = 'Switch Button is ON';
      });
      print('Switch Button is ON');
    }
    else
    {
      setState(() {
        isDrag = false;
        // textValue = 'Switch Button is OFF';
      });
      print('Switch Button is OFF');
    }
  }

  void toggleWheelSound(bool value) {

    if(isWheelSound == false)
    {
      setState(() {
        isWheelSound = true;
        // textValue = 'Switch Button is ON';
      });
      print('Switch Button is ON');
    }
    else
    {
      setState(() {
        isWheelSound = false;
        // textValue = 'Switch Button is OFF';
      });
      print('Switch Button is OFF');
    }
  }




  @override
  Widget build(BuildContext context) {

    var maxWidth = 500.0;
    var width = MediaQuery.of(context).size.width;
    var columns = (width ~/ maxWidth) + 1;
    var columnWidth = width / columns;
    var aspectRatio = columnWidth / 390;

    final screenSize = MediaQuery.of(context).size;

    return LayoutBuilder(
        builder:(context, constraints){
          return OrientationBuilder(
              builder:(context, orientation){
                //initialize SizerUtil()
                return Sizer(
                    builder: (context, orientation, screenType) {
                      return MaterialApp(
                        theme: ThemeData(
                          // Define the default font family.
                          fontFamily: 'Montserrat',
                          // Define the default TextTheme. Use this to specify the default
                          // text styling for headlines, titles, bodies of text, and more.

                        ),
                        home:
                        GestureDetector(
                          onHorizontalDragUpdate: (details) {
                            // Note: Sensitivity is integer used when you don't want to mess up vertical drag
                            int sensitivity = 10;
                            if (details.delta.dx > sensitivity) {
                              // Right Swipe
                              print("is wheel shown");
                              print(details.delta.dx);
                              if(PageViewDemo.of(context)!.isShowWheel){
                                PageViewDemo.of(context)!.hideWheel();
                              }
                              print("swipe right");
                            } else if(details.delta.dx < -sensitivity){
                              //Left Swipe
                              if(!PageViewDemo.of(context)!.isShowWheel){
                                PageViewDemo.of(context)!.showWheel();
                              }
                              print("swipe left");
                            }
                          },
                          child: Scaffold(
                            // appBar: AppBar(
                            //   backgroundColor: Colors.white,
                            //   automaticallyImplyLeading: false,
                            //   actions: <Widget>[Container()],
                            //   title: Image.asset('images/crave_logo_word.png',height: 40,),
                            //   centerTitle: true,
                            // ),
                            resizeToAvoidBottomInset: false,
                            backgroundColor: Colors.white,
                            body:
                            Stack(
                              children: <Widget>[
                                SafeArea(
                                  child:Column(
                                    children: [
                                      Card(
                                        margin:EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                        ),
                                        child:Container(
                                            padding: const EdgeInsets.only(
                                                top: 40.0,bottom:15,left:20),
                                            width:MediaQuery.of(context).size.width,
                                            child:Text("SETTINGS",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    color: Color(constant.Color.crave_brown),
                                                    fontSize: 18.0.sp))
                                        ),
                                      ),


                                      Expanded(
                                        child:MediaQuery.removePadding(
                                          removeTop: true,
                                          context: context,
                                          child:ListView(
                                            shrinkWrap: true,
                                            //physics: NeverScrollableScrollPhysics(),
                                            // crossAxisCount: 2,
                                            // // mainAxisSpacing: 10.0,
                                            // crossAxisSpacing: 10.0,
                                            // childAspectRatio: aspectRatio,
                                            children: <Widget>[
                                              //comment for a while to do later

                                              Container(
                                                padding:EdgeInsets.only(left:20,bottom:10,top:15),
                                                child:Text("Notifications",
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w700,
                                                        color: Color(constant.Color.crave_brown),
                                                        fontSize: 14.0.sp))
                                              ),

                                              Padding(
                                               padding:EdgeInsets.only(left:20,right:20),
                                               child: Row(
                                                 children: [
                                                   Column(
                                                     crossAxisAlignment: CrossAxisAlignment.start,
                                                     mainAxisAlignment: MainAxisAlignment.start,
                                                     children: [
                                                       Text("Craves",
                                                           textAlign: TextAlign.start,
                                                           style: TextStyle(
                                                               fontWeight: FontWeight.w500,
                                                               color: Color(constant.Color.crave_brown),
                                                               fontSize: 14.0.sp)),
                                                       Text("On",
                                                           textAlign: TextAlign.start,
                                                           style: TextStyle(
                                                               fontWeight: FontWeight.w600,
                                                               color: Color(constant.Color.crave_orange),
                                                               fontSize: 14.0.sp))
                                                     ],
                                                   ),
                                                   Spacer(),
                                                   Switch(
                                                     onChanged: toggleCrave,
                                                     value: isCrave,
                                                     activeColor: Colors.white,
                                                     activeTrackColor: Colors.grey[300],
                                                     inactiveThumbColor: Colors.white,
                                                     inactiveTrackColor: Color(constant.Color.crave_orange)
                                                   ),
                                                 ],
                                               ),
                                             ),
                                              Container(
                                                padding: const EdgeInsets.only(left:20,right:20),
                                                child:Divider(
                                                  color:Colors.grey[400],
                                                ),
                                              ),
                                              Padding(
                                                padding:EdgeInsets.only(left:20,right:20),
                                                child: Row(
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Text("Likes",
                                                            textAlign: TextAlign.start,
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.w500,
                                                                color: Color(constant.Color.crave_brown),
                                                                fontSize: 14.0.sp)),
                                                        Text("On",
                                                            textAlign: TextAlign.start,
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.w600,
                                                                color: Color(constant.Color.crave_orange),
                                                                fontSize: 14.0.sp))
                                                      ],
                                                    ),
                                                    Spacer(),
                                                    Switch(
                                                        onChanged: toggleLikes,
                                                        value: isLikes,
                                                        activeColor: Colors.white,
                                                        activeTrackColor: Colors.grey[300],
                                                        inactiveThumbColor: Colors.white,
                                                        inactiveTrackColor: Color(constant.Color.crave_orange)
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(left:20,right:20),
                                                child:Divider(
                                                  color:Colors.grey[400],
                                                ),
                                              ),
                                              Padding(
                                                padding:EdgeInsets.only(left:20,right:20),
                                                child: Row(
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Text("Comments",
                                                            textAlign: TextAlign.start,
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.w500,
                                                                color: Color(constant.Color.crave_brown),
                                                                fontSize: 14.0.sp)),
                                                        Text("On",
                                                            textAlign: TextAlign.start,
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.w600,
                                                                color: Color(constant.Color.crave_orange),
                                                                fontSize: 14.0.sp))
                                                      ],
                                                    ),
                                                    Spacer(),
                                                    Switch(
                                                        onChanged: toggleComment,
                                                        value: isComment,
                                                        activeColor: Colors.white,
                                                        activeTrackColor: Colors.grey[300],
                                                        inactiveThumbColor: Colors.white,
                                                        inactiveTrackColor: Color(constant.Color.crave_orange)
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              Container(
                                                color:Color(constant.Color.crave_grey),
                                                child:Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                        padding:EdgeInsets.only(left:20,bottom:10,top:15),
                                                        child:Text("Navigation Wheel",
                                                            textAlign: TextAlign.start,
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.w700,
                                                                color: Color(constant.Color.crave_brown),
                                                                fontSize: 14.0.sp))
                                                    ),
                                                    Padding(
                                                      padding:EdgeInsets.only(left:20,right:20),
                                                      child: Row(
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              Text("Hide Wheel",
                                                                  textAlign: TextAlign.start,
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.w500,
                                                                      color: Color(constant.Color.crave_brown),
                                                                      fontSize: 14.0.sp)),
                                                              Text("On",
                                                                  textAlign: TextAlign.start,
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.w600,
                                                                      color: Color(constant.Color.crave_orange),
                                                                      fontSize: 14.0.sp))
                                                            ],
                                                          ),
                                                          Spacer(),
                                                          Switch(
                                                              onChanged: toggleWheel,
                                                              value: isWheel,
                                                              activeColor: Colors.white,
                                                              activeTrackColor: Colors.grey[300],
                                                              inactiveThumbColor: Colors.white,
                                                              inactiveTrackColor: Color(constant.Color.crave_orange)
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: const EdgeInsets.only(left:20,right:20),
                                                      child:Divider(
                                                        color:Colors.grey[400],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:EdgeInsets.only(left:20,right:20),
                                                      child: Row(
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              Text("Dragging Animation",
                                                                  textAlign: TextAlign.start,
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.w500,
                                                                      color: Color(constant.Color.crave_brown),
                                                                      fontSize: 14.0.sp)),
                                                              Text("On",
                                                                  textAlign: TextAlign.start,
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.w600,
                                                                      color: Color(constant.Color.crave_orange),
                                                                      fontSize: 14.0.sp))
                                                            ],
                                                          ),
                                                          Spacer(),
                                                          Switch(
                                                              onChanged: toggleDrag,
                                                              value: isDrag,
                                                              activeColor: Colors.white,
                                                              activeTrackColor: Colors.grey[300],
                                                              inactiveThumbColor: Colors.white,
                                                              inactiveTrackColor: Color(constant.Color.crave_orange)
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: const EdgeInsets.only(left:20,right:20),
                                                      child:Divider(
                                                        color:Colors.grey[400],
                                                      ),
                                                    ),
                                                    Container(
                                                      height:40,
                                                      padding:EdgeInsets.only(left:20,right:20),
                                                      child: Row(
                                                        children: [
                                                          Text("Position",
                                                              textAlign: TextAlign.start,
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight.w500,
                                                                  color: Color(constant.Color.crave_brown),
                                                                  fontSize: 14.0.sp)),
                                                          Spacer(),
                                                          Text("Bottom",
                                                              textAlign: TextAlign.start,
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight.w700,
                                                                  color: Colors.grey,
                                                                  fontSize: 12.0.sp)),
                                                          Icon(Icons.arrow_forward_ios,size: 15,color:Colors.grey)
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: const EdgeInsets.only(left:20,right:20),
                                                      child:Divider(
                                                        color:Colors.grey[400],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:EdgeInsets.only(left:20,right:20,bottom:10),
                                                      child: Row(
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              Text("Wheel Sound",
                                                                  textAlign: TextAlign.start,
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.w500,
                                                                      color: Color(constant.Color.crave_brown),
                                                                      fontSize: 14.0.sp)),
                                                              Text("On",
                                                                  textAlign: TextAlign.start,
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.w600,
                                                                      color: Color(constant.Color.crave_orange),
                                                                      fontSize: 14.0.sp))
                                                            ],
                                                          ),
                                                          Spacer(),
                                                          Switch(
                                                              onChanged: toggleWheelSound,
                                                              value: isWheelSound,
                                                              activeColor: Colors.white,
                                                              activeTrackColor: Colors.grey[300],
                                                              inactiveThumbColor: Colors.white,
                                                              inactiveTrackColor: Color(constant.Color.crave_orange)
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ),

                                              Container(
                                                  padding:EdgeInsets.only(left:20,bottom:10,top:15),
                                                  child:Text("Security",
                                                      textAlign: TextAlign.start,
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.w700,
                                                          color: Color(constant.Color.crave_brown),
                                                          fontSize: 14.0.sp))
                                              ),
                                              Container(
                                                height:40,
                                                padding:EdgeInsets.only(left:20,right:20),
                                                child: Row(
                                                  children: [
                                                    Text("Password",
                                                        textAlign: TextAlign.start,
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                            color: Color(constant.Color.crave_brown),
                                                            fontSize: 14.0.sp)),
                                                    Spacer(),
                                                    Text("Change",
                                                        textAlign: TextAlign.start,
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w700,
                                                            color: Color(constant.Color.crave_orange),
                                                            fontSize: 12.0.sp)),

                                                  ],
                                                ),
                                              ),

                                              Container(
                                                  color:Color(constant.Color.crave_grey),
                                                  child:Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                          padding:EdgeInsets.only(left:20,bottom:10,top:15),
                                                          child:Text("Payment",
                                                              textAlign: TextAlign.start,
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight.w700,
                                                                  color: Color(constant.Color.crave_brown),
                                                                  fontSize: 14.0.sp))
                                                      ),
                                                      Container(
                                                        height:40,
                                                        padding:EdgeInsets.only(left:20,right:20),
                                                        child: Row(
                                                          children: [
                                                            Text("Payment Method",
                                                                textAlign: TextAlign.start,
                                                                style: TextStyle(
                                                                    fontWeight: FontWeight.w500,
                                                                    color: Color(constant.Color.crave_brown),
                                                                    fontSize: 14.0.sp)),
                                                            Spacer(),

                                                            Icon(Icons.arrow_forward_ios,size: 15,color:Colors.grey)
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: const EdgeInsets.only(left:20,right:20),
                                                        child:Divider(
                                                          color:Colors.grey[400],
                                                        ),
                                                      ),
                                                      Container(
                                                        height:40,
                                                        padding:EdgeInsets.only(left:20,right:20),
                                                        child: Row(
                                                          children: [
                                                            Text("Security",
                                                                textAlign: TextAlign.start,
                                                                style: TextStyle(
                                                                    fontWeight: FontWeight.w500,
                                                                    color: Color(constant.Color.crave_brown),
                                                                    fontSize: 14.0.sp)),
                                                            Spacer(),

                                                            Icon(Icons.arrow_forward_ios,size: 15,color:Colors.grey)
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                              ),

                                              Container(
                                                  child:Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                          padding:EdgeInsets.only(left:20,bottom:10,top:15),
                                                          child:Text("Help",
                                                              textAlign: TextAlign.start,
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight.w700,
                                                                  color: Color(constant.Color.crave_brown),
                                                                  fontSize: 14.0.sp))
                                                      ),
                                                      Container(
                                                        height:40,
                                                        padding:EdgeInsets.only(left:20,right:20),
                                                        child: Row(
                                                          children: [
                                                            Text("Make a Report",
                                                                textAlign: TextAlign.start,
                                                                style: TextStyle(
                                                                    fontWeight: FontWeight.w500,
                                                                    color: Color(constant.Color.crave_brown),
                                                                    fontSize: 14.0.sp)),
                                                            Spacer(),

                                                            Icon(Icons.arrow_forward_ios,size: 15,color:Colors.grey)
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: const EdgeInsets.only(left:20,right:20),
                                                        child:Divider(
                                                          color:Colors.grey[400],
                                                        ),
                                                      ),
                                                      Container(
                                                        height:40,
                                                        padding:EdgeInsets.only(left:20,right:20),
                                                        child: Row(
                                                          children: [
                                                            Text("Help Center/FAQs",
                                                                textAlign: TextAlign.start,
                                                                style: TextStyle(
                                                                    fontWeight: FontWeight.w500,
                                                                    color: Color(constant.Color.crave_brown),
                                                                    fontSize: 14.0.sp)),
                                                            Spacer(),

                                                            Icon(Icons.arrow_forward_ios,size: 15,color:Colors.grey)
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                              ),

                                              Container(
                                                  color:Color(constant.Color.crave_grey),
                                                  child:Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                          padding:EdgeInsets.only(left:20,bottom:10,top:15),
                                                          child:Text("About",
                                                              textAlign: TextAlign.start,
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight.w700,
                                                                  color: Color(constant.Color.crave_brown),
                                                                  fontSize: 14.0.sp))
                                                      ),
                                                      Container(
                                                        height:40,
                                                        padding:EdgeInsets.only(left:20,right:20),
                                                        child: Row(
                                                          children: [
                                                            Text("Data Policy",
                                                                textAlign: TextAlign.start,
                                                                style: TextStyle(
                                                                    fontWeight: FontWeight.w500,
                                                                    color: Color(constant.Color.crave_brown),
                                                                    fontSize: 14.0.sp)),
                                                            Spacer(),

                                                            Icon(Icons.arrow_forward_ios,size: 15,color:Colors.grey)
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: const EdgeInsets.only(left:20,right:20),
                                                        child:Divider(
                                                          color:Colors.grey[400],
                                                        ),
                                                      ),
                                                      Container(
                                                        height:40,
                                                        padding:EdgeInsets.only(left:20,right:20),
                                                        child: Row(
                                                          children: [
                                                            Text("Terms of Use",
                                                                textAlign: TextAlign.start,
                                                                style: TextStyle(
                                                                    fontWeight: FontWeight.w500,
                                                                    color: Color(constant.Color.crave_brown),
                                                                    fontSize: 14.0.sp)),
                                                            Spacer(),

                                                            Icon(Icons.arrow_forward_ios,size: 15,color:Colors.grey)
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                              ),

                                              Container(
                                                  child:Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                          padding:EdgeInsets.only(left:20,bottom:10,top:15),
                                                          child:Text("Account",
                                                              textAlign: TextAlign.start,
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight.w700,
                                                                  color: Color(constant.Color.crave_brown),
                                                                  fontSize: 14.0.sp))
                                                      ),
                                                      GestureDetector(
                                                        onTap:logout,
                                                        child: Container(
                                                          height:40,
                                                          width:100.0.w,
                                                          color:Colors.transparent,
                                                          padding:EdgeInsets.only(left:20,right:20),
                                                          child: Row(
                                                            children: [
                                                              Text("Logout",
                                                                  textAlign: TextAlign.start,
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.w500,
                                                                      color: Color(constant.Color.crave_brown),
                                                                      fontSize: 14.0.sp)),
                                                              Spacer(),

                                                              Icon(Icons.arrow_forward_ios,size: 15,color:Colors.grey)
                                                            ],
                                                          ),
                                                        ),
                                                      ),

                                                      Container(
                                                        height:50,
                                                      ),

                                                    ],
                                                  )
                                              ),

                                            ],
                                          ),
                                        ),
                                      )


                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      );
                    });
              }
          );
        }
    );

  }
}


