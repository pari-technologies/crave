// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';

import 'package:sizer/sizer.dart';
import 'dart:math' as math;
import 'package:circle_list/circle_list.dart';
import 'camera_screen.dart';
import 'chatPage.dart';
import 'circle_wheel_scroll/circle_wheel_scroll_view.dart';
import 'cravingsPage.dart';
import 'homeBase.dart';
import 'homepage.dart';
import 'notificationsPage.dart';
import 'profileBusiness.dart';
import 'profileUser.dart';
import 'reelsDetails.dart';

class Reels extends StatefulWidget {
  final PageController reelsPageController;
  const Reels({Key? key, required this.reelsPageController}) : super(key: key);

  @override
  ReelsState createState() => ReelsState();
}

class ReelsState extends State<Reels> {

  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => startLoad());
  }

  onChangeTab(int nowTab){
    setState(() {
      // currentTab = nowTab;
    });
  }

  void goToReelsDetails() {
    setState(() {
      Navigator.of(context).pushNamed("/reelsDetails");
    });
  }

  void startLoad() async{
    print(MediaQuery.of(context).size.width);
    precacheImage(new AssetImage('images/menu_bell.png'),context);
    precacheImage(new AssetImage('images/menu_chat.png'),context);
    precacheImage(new AssetImage('images/menu_camera.png'),context);
    precacheImage(new AssetImage('images/menu_cravings.png'),context);
    precacheImage(new AssetImage('images/menu_home.png'),context);
    precacheImage(new AssetImage('images/menu_me.png'),context);
    precacheImage(new AssetImage('images/menu_reels.png'),context);
    precacheImage(new AssetImage('images/menu_run_ads.png'),context);
    precacheImage(new AssetImage('images/menu_settings.png'),context);
    precacheImage(new AssetImage('images/menu_switch_account.png'),context);

  }


  @override
  Widget build(BuildContext context) {

    var maxWidth = 500.0;
    var width = MediaQuery.of(context).size.width;
    var columns = (width ~/ maxWidth) + 1;
    var columnWidth = width / columns;
    var aspectRatio = columnWidth / 450;

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
                        home: Scaffold(
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
                              Column(
                                children: [
                                  Container(
                                      padding: const EdgeInsets.only(
                                          top: 50.0,bottom:0),
                                      width:MediaQuery.of(context).size.width,
                                      child:Image.asset(
                                        'images/crave_logo_word.png',
                                        height: 40,
                                      )
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(left:5,right:5,top:5,bottom:2),
                                    child:Divider(
                                      color: Colors.grey,
                                    ),
                                  ),

                                  Container(
                                    //width:250,
                                    height:40,
                                    margin: const EdgeInsets.only(bottom: 10.0,top:10),
                                    padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                                    child:TextField(
                                      autofocus: false,
                                      controller: textController,
                                      cursorColor: Colors.black,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.go,
                                      textCapitalization: TextCapitalization.sentences,
                                      decoration: const InputDecoration(
                                          counterText: '',
                                          filled: true,
                                          // Color(0xFFD6D6D6)
                                          fillColor: Color(0xFFF2F2F2),
                                          contentPadding:EdgeInsets.symmetric(horizontal: 15,vertical:10),
                                          labelStyle: TextStyle(
                                              fontSize: 14,
                                              color:Colors.black
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color:Color(0xFFF2F2F2) ),
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(color:Color(0xFFF2F2F2) ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color:Color(0xFFF2F2F2), ),
                                          ),
                                          suffixIcon: Icon(
                                            Icons.search,
                                            color: Colors.grey,
                                            size: 20.0,
                                          ),
                                          hintText: "Search"),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(left:5,right:5,top:2,bottom:5),
                                    child:Divider(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Expanded(
                                    child:MediaQuery.removePadding(
                                      removeTop: true,
                                      context: context,
                                      child:GridView.count(
                                        //physics: NeverScrollableScrollPhysics(),
                                        crossAxisCount: 3,
                                        mainAxisSpacing: 10.0,
                                        // crossAxisSpacing: 10.0,
                                        childAspectRatio: aspectRatio,
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap:goToReelsDetails,
                                            child:Container(
                                              //color:Colors.black,
                                              padding: const EdgeInsets.only(left:20),
                                              child:Stack(
                                                children: [
                                                  Container(
                                                    height:150,
                                                    width:30.0.w,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(image: AssetImage("images/reelsList1.png"), fit: BoxFit.cover),

                                                    ),
                                                  ),
                                                  Container(
                                                    height:150,
                                                    width:30.0.w,
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [Colors.black, Colors.transparent, Colors.transparent, Colors.black],
                                                        begin: Alignment.topCenter,
                                                        end: Alignment.bottomCenter,
                                                        stops: [0, 0.0, 0.7, 1],
                                                      ),
                                                    ),

                                                    child:Align(
                                                      alignment: Alignment.bottomCenter,
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(bottom:5),
                                                        child:Row(
                                                          children: [
                                                            Icon(
                                                              Icons.play_arrow_outlined,
                                                              color: Colors.grey,
                                                              size: 20.0,
                                                            ),
                                                            Text("65K",
                                                                textAlign: TextAlign.end,
                                                                style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 12.0.sp))
                                                          ],
                                                        ),
                                                      ),

                                                    ),

                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),

                                          GestureDetector(
                                            onTap:goToReelsDetails,
                                            child:Container(
                                              //color:Colors.black,
                                              padding: const EdgeInsets.only(left:10,right:10),
                                              child:Stack(
                                                children: [
                                                  Container(
                                                    height:150,
                                                    width:30.0.w,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(image: AssetImage("images/reelsList2.png"), fit: BoxFit.cover),

                                                    ),
                                                  ),
                                                  Container(
                                                    height:150,
                                                    width:30.0.w,
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [Colors.black, Colors.transparent, Colors.transparent, Colors.black],
                                                        begin: Alignment.topCenter,
                                                        end: Alignment.bottomCenter,
                                                        stops: [0, 0.0, 0.7, 1],
                                                      ),
                                                    ),

                                                    child:Align(
                                                      alignment: Alignment.bottomCenter,
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(bottom:5),
                                                        child:Row(
                                                          children: [
                                                            Icon(
                                                              Icons.play_arrow_outlined,
                                                              color: Colors.grey,
                                                              size: 20.0,
                                                            ),
                                                            Text("65K",
                                                                textAlign: TextAlign.end,
                                                                style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 12.0.sp))
                                                          ],
                                                        ),
                                                      ),

                                                    ),

                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),

                                          GestureDetector(
                                            onTap:goToReelsDetails,
                                            child:Container(
                                              //color:Colors.black,
                                              padding: const EdgeInsets.only(right:20),
                                              child:Stack(
                                                children: [
                                                  Container(
                                                    height:150,
                                                    width:30.0.w,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(image: AssetImage("images/reelsList3.png"), fit: BoxFit.cover),

                                                    ),
                                                  ),
                                                  Container(
                                                    height:150,
                                                    width:30.0.w,
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [Colors.black, Colors.transparent, Colors.transparent, Colors.black],
                                                        begin: Alignment.topCenter,
                                                        end: Alignment.bottomCenter,
                                                        stops: [0, 0.0, 0.7, 1],
                                                      ),
                                                    ),

                                                    child:Align(
                                                      alignment: Alignment.bottomCenter,
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(bottom:5),
                                                        child:Row(
                                                          children: [
                                                            Icon(
                                                              Icons.play_arrow_outlined,
                                                              color: Colors.grey,
                                                              size: 20.0,
                                                            ),
                                                            Text("65K",
                                                                textAlign: TextAlign.end,
                                                                style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 12.0.sp))
                                                          ],
                                                        ),
                                                      ),

                                                    ),

                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),

                                          GestureDetector(
                                            onTap:goToReelsDetails,
                                            child: Container(
                                              //color:Colors.black,
                                              padding: const EdgeInsets.only(left:20),
                                              child:Stack(
                                                children: [
                                                  Container(
                                                    height:150,
                                                    width:30.0.w,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(image: AssetImage("images/reelsList4.png"), fit: BoxFit.cover),

                                                    ),
                                                  ),
                                                  Container(
                                                    height:150,
                                                    width:30.0.w,
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [Colors.black, Colors.transparent, Colors.transparent, Colors.black],
                                                        begin: Alignment.topCenter,
                                                        end: Alignment.bottomCenter,
                                                        stops: [0, 0.0, 0.7, 1],
                                                      ),
                                                    ),

                                                    child:Align(
                                                      alignment: Alignment.bottomCenter,
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(bottom:5),
                                                        child:Row(
                                                          children: [
                                                            Icon(
                                                              Icons.play_arrow_outlined,
                                                              color: Colors.grey,
                                                              size: 20.0,
                                                            ),
                                                            Text("65K",
                                                                textAlign: TextAlign.end,
                                                                style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 12.0.sp))
                                                          ],
                                                        ),
                                                      ),

                                                    ),

                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),

                                          GestureDetector(
                                            onTap:goToReelsDetails,
                                            child: Container(
                                              //color:Colors.black,
                                              padding: const EdgeInsets.only(left:10,right:10),
                                              child:Stack(
                                                children: [
                                                  Container(
                                                    height:150,
                                                    width:30.0.w,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(image: AssetImage("images/reelsList5.png"), fit: BoxFit.cover),

                                                    ),
                                                  ),
                                                  Container(
                                                    height:150,
                                                    width:30.0.w,
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [Colors.black, Colors.transparent, Colors.transparent, Colors.black],
                                                        begin: Alignment.topCenter,
                                                        end: Alignment.bottomCenter,
                                                        stops: [0, 0.0, 0.7, 1],
                                                      ),
                                                    ),

                                                    child:Align(
                                                      alignment: Alignment.bottomCenter,
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(bottom:5),
                                                        child:Row(
                                                          children: [
                                                            Icon(
                                                              Icons.play_arrow_outlined,
                                                              color: Colors.grey,
                                                              size: 20.0,
                                                            ),
                                                            Text("65K",
                                                                textAlign: TextAlign.end,
                                                                style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 12.0.sp))
                                                          ],
                                                        ),
                                                      ),

                                                    ),

                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),

                                          GestureDetector(
                                            onTap:goToReelsDetails,
                                            child: Container(
                                              //color:Colors.black,
                                              padding: const EdgeInsets.only(right:20),
                                              child:Stack(
                                                children: [
                                                  Container(
                                                    height:150,
                                                    width:30.0.w,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(image: AssetImage("images/reelsList6.png"), fit: BoxFit.cover),

                                                    ),
                                                  ),
                                                  Container(
                                                    height:150,
                                                    width:30.0.w,
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [Colors.black, Colors.transparent, Colors.transparent, Colors.black],
                                                        begin: Alignment.topCenter,
                                                        end: Alignment.bottomCenter,
                                                        stops: [0, 0.0, 0.7, 1],
                                                      ),
                                                    ),

                                                    child:Align(
                                                      alignment: Alignment.bottomCenter,
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(bottom:5),
                                                        child:Row(
                                                          children: [
                                                            Icon(
                                                              Icons.play_arrow_outlined,
                                                              color: Colors.grey,
                                                              size: 20.0,
                                                            ),
                                                            Text("65K",
                                                                textAlign: TextAlign.end,
                                                                style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 12.0.sp))
                                                          ],
                                                        ),
                                                      ),

                                                    ),

                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),

                                          GestureDetector(
                                            onTap:goToReelsDetails,
                                            child: Container(
                                              //color:Colors.black,
                                              padding: const EdgeInsets.only(left:20),
                                              child:Stack(
                                                children: [
                                                  Container(
                                                    height:150,
                                                    width:30.0.w,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(image: AssetImage("images/reelsList1.png"), fit: BoxFit.cover),

                                                    ),
                                                  ),
                                                  Container(
                                                    height:150,
                                                    width:30.0.w,
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [Colors.black, Colors.transparent, Colors.transparent, Colors.black],
                                                        begin: Alignment.topCenter,
                                                        end: Alignment.bottomCenter,
                                                        stops: [0, 0.0, 0.7, 1],
                                                      ),
                                                    ),

                                                    child:Align(
                                                      alignment: Alignment.bottomCenter,
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(bottom:5),
                                                        child:Row(
                                                          children: [
                                                            Icon(
                                                              Icons.play_arrow_outlined,
                                                              color: Colors.grey,
                                                              size: 20.0,
                                                            ),
                                                            Text("65K",
                                                                textAlign: TextAlign.end,
                                                                style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 12.0.sp))
                                                          ],
                                                        ),
                                                      ),

                                                    ),

                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),

                                          GestureDetector(
                                            onTap:goToReelsDetails,
                                            child: Container(
                                              //color:Colors.black,
                                              padding: const EdgeInsets.only(left:10,right:10),
                                              child:Stack(
                                                children: [
                                                  Container(
                                                    height:150,
                                                    width:30.0.w,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(image: AssetImage("images/reelsList2.png"), fit: BoxFit.cover),

                                                    ),
                                                  ),
                                                  Container(
                                                    height:150,
                                                    width:30.0.w,
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [Colors.black, Colors.transparent, Colors.transparent, Colors.black],
                                                        begin: Alignment.topCenter,
                                                        end: Alignment.bottomCenter,
                                                        stops: [0, 0.0, 0.7, 1],
                                                      ),
                                                    ),

                                                    child:Align(
                                                      alignment: Alignment.bottomCenter,
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(bottom:5),
                                                        child:Row(
                                                          children: [
                                                            Icon(
                                                              Icons.play_arrow_outlined,
                                                              color: Colors.grey,
                                                              size: 20.0,
                                                            ),
                                                            Text("65K",
                                                                textAlign: TextAlign.end,
                                                                style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 12.0.sp))
                                                          ],
                                                        ),
                                                      ),

                                                    ),

                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),

                                          GestureDetector(
                                            onTap:goToReelsDetails,
                                            child:  Container(
                                              //color:Colors.black,
                                              padding: const EdgeInsets.only(right:20),
                                              child:Stack(
                                                children: [
                                                  Container(
                                                    height:150,
                                                    width:30.0.w,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(image: AssetImage("images/reelsList3.png"), fit: BoxFit.cover),

                                                    ),
                                                  ),
                                                  Container(
                                                    height:150,
                                                    width:30.0.w,
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [Colors.black, Colors.transparent, Colors.transparent, Colors.black],
                                                        begin: Alignment.topCenter,
                                                        end: Alignment.bottomCenter,
                                                        stops: [0, 0.0, 0.7, 1],
                                                      ),
                                                    ),

                                                    child:Align(
                                                      alignment: Alignment.bottomCenter,
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(bottom:5),
                                                        child:Row(
                                                          children: [
                                                            Icon(
                                                              Icons.play_arrow_outlined,
                                                              color: Colors.grey,
                                                              size: 20.0,
                                                            ),
                                                            Text("65K",
                                                                textAlign: TextAlign.end,
                                                                style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 12.0.sp))
                                                          ],
                                                        ),
                                                      ),

                                                    ),

                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),

                                          GestureDetector(
                                            onTap:goToReelsDetails,
                                            child: Container(
                                              //color:Colors.black,
                                              padding: const EdgeInsets.only(left:20),
                                              child:Stack(
                                                children: [
                                                  Container(
                                                    height:150,
                                                    width:30.0.w,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(image: AssetImage("images/reelsList4.png"), fit: BoxFit.cover),

                                                    ),
                                                  ),
                                                  Container(
                                                    height:150,
                                                    width:30.0.w,
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [Colors.black, Colors.transparent, Colors.transparent, Colors.black],
                                                        begin: Alignment.topCenter,
                                                        end: Alignment.bottomCenter,
                                                        stops: [0, 0.0, 0.7, 1],
                                                      ),
                                                    ),

                                                    child:Align(
                                                      alignment: Alignment.bottomCenter,
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(bottom:5),
                                                        child:Row(
                                                          children: [
                                                            Icon(
                                                              Icons.play_arrow_outlined,
                                                              color: Colors.grey,
                                                              size: 20.0,
                                                            ),
                                                            Text("65K",
                                                                textAlign: TextAlign.end,
                                                                style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 12.0.sp))
                                                          ],
                                                        ),
                                                      ),

                                                    ),

                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),

                                          GestureDetector(
                                            onTap:goToReelsDetails,
                                            child:Container(
                                              //color:Colors.black,
                                              padding: const EdgeInsets.only(left:10,right:10),
                                              child:Stack(
                                                children: [
                                                  Container(
                                                    height:150,
                                                    width:30.0.w,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(image: AssetImage("images/reelsList5.png"), fit: BoxFit.cover),

                                                    ),
                                                  ),
                                                  Container(
                                                    height:150,
                                                    width:30.0.w,
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [Colors.black, Colors.transparent, Colors.transparent, Colors.black],
                                                        begin: Alignment.topCenter,
                                                        end: Alignment.bottomCenter,
                                                        stops: [0, 0.0, 0.7, 1],
                                                      ),
                                                    ),

                                                    child:Align(
                                                      alignment: Alignment.bottomCenter,
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(bottom:5),
                                                        child:Row(
                                                          children: [
                                                            Icon(
                                                              Icons.play_arrow_outlined,
                                                              color: Colors.grey,
                                                              size: 20.0,
                                                            ),
                                                            Text("65K",
                                                                textAlign: TextAlign.end,
                                                                style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 12.0.sp))
                                                          ],
                                                        ),
                                                      ),

                                                    ),

                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),

                                          GestureDetector(
                                            onTap:goToReelsDetails,
                                            child:Container(
                                              //color:Colors.black,
                                              padding: const EdgeInsets.only(right:20),
                                              child:Stack(
                                                children: [
                                                  Container(
                                                    height:150,
                                                    width:30.0.w,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(image: AssetImage("images/reelsList6.png"), fit: BoxFit.cover),

                                                    ),
                                                  ),
                                                  Container(
                                                    height:150,
                                                    width:30.0.w,
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [Colors.black, Colors.transparent, Colors.transparent, Colors.black],
                                                        begin: Alignment.topCenter,
                                                        end: Alignment.bottomCenter,
                                                        stops: [0, 0.0, 0.7, 1],
                                                      ),
                                                    ),

                                                    child:Align(
                                                      alignment: Alignment.bottomCenter,
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(bottom:5),
                                                        child:Row(
                                                          children: [
                                                            Icon(
                                                              Icons.play_arrow_outlined,
                                                              color: Colors.grey,
                                                              size: 20.0,
                                                            ),
                                                            Text("65K",
                                                                textAlign: TextAlign.end,
                                                                style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 12.0.sp))
                                                          ],
                                                        ),
                                                      ),

                                                    ),

                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),

                                  )

                                ],
                              ),


                            ],
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


