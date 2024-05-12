// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:a_crave/manageAccessPage.dart';
import 'package:a_crave/profileUser.dart';
import 'package:a_crave/reels.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';

import 'package:sizer/sizer.dart';
import 'dart:math' as math;
import 'package:circle_list/circle_list.dart';
import 'addMenuItem.dart';
import 'adsHomePage.dart';
import 'chatPage.dart';
import 'circle_wheel_scroll/circle_wheel_scroll_view.dart';
import 'cravingsPage.dart';
import 'followersPage.dart';
import 'followingPage.dart';
import 'homepage.dart';
import 'notificationsPage.dart';
import 'reelsDetails.dart';
import 'stories_for_flutter/lib/stories_for_flutter.dart';

import 'constants.dart' as constant;

class ProfileBusiness extends StatefulWidget {
  const ProfileBusiness({Key? key}) : super(key: key);

  @override
  ProfileBusinessState createState() => ProfileBusinessState();
}

class ProfileBusinessState extends State<ProfileBusiness> {
  final textController = TextEditingController();

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
                              Align(
                                alignment: Alignment.topCenter,
                                child:Container(
                                  height:200,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    // color:Colors.black,
                                    image: DecorationImage(
                                      image: AssetImage("images/business_bg.png"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  // decoration: BoxDecoration(
                                  //   color:Color(0xFF2CBFC6),
                                  //   borderRadius: BorderRadius.only(
                                  //     topLeft: Radius.circular(100),
                                  //     bottomLeft: Radius.circular(100),
                                  //   ),
                                  //
                                  // ),

                                ),

                              ),
                              Padding(
                                padding: EdgeInsets.only(top:190),
                                child: Card(
                                  margin:EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                                  ),
                                  child:Container(
                                    //color:Colors.black,
                                    padding: EdgeInsets.only(bottom:0,top:4.0.h),
                                    child:SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(top:10,bottom:10),
                                            child:Text('McDonalds',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 16.0.sp)),
                                          ),

                                          IntrinsicHeight(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                GestureDetector(
                                                  onTap:(){
                                                    // Navigator.push(
                                                    //     context,
                                                    //     MaterialPageRoute(
                                                    //         builder: (context) => FollowersPage()));
                                                  },
                                                  child: Column(
                                                    children: [
                                                      Text('1.2m',
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w700,
                                                              color:Color(constant.Color.crave_orange),
                                                              fontSize: 18.0.sp)),
                                                      Text('FOLLOWERS',
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 10.0.sp)),
                                                    ],
                                                  ),
                                                ),


                                                Container(
                                                  padding: EdgeInsets.only(left:5,right:5),
                                                  child:VerticalDivider(),
                                                ),
                                                GestureDetector(
                                                  onTap:(){
                                                    // Navigator.push(
                                                    //     context,
                                                    //     MaterialPageRoute(
                                                    //         builder: (context) => FollowingPage()));
                                                  },
                                                  child:Column(
                                                    children: [
                                                      Text('9.4m',
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w700,
                                                              color:Color(constant.Color.crave_orange),
                                                              fontSize: 18.0.sp)),
                                                      Text('CRAVES',
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 10.0.sp)),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(left:5,right:5),
                                                  child:VerticalDivider(),
                                                ),
                                                GestureDetector(
                                                  onTap:(){
                                                    // Navigator.push(
                                                    //     context,
                                                    //     MaterialPageRoute(
                                                    //         builder: (context) => FollowingPage()));
                                                  },
                                                  child:Column(
                                                    children: [
                                                      Text('30.1m',
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w700,
                                                              color:Color(constant.Color.crave_orange),
                                                              fontSize: 18.0.sp)),
                                                      Text('PAGE VIEWS',
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 10.0.sp)),
                                                    ],
                                                  ),
                                                ),


                                              ],
                                            ),
                                          ),

                                          Padding(
                                            padding: EdgeInsets.only(top:15,bottom:10),
                                            child:Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                    width:40.w,
                                                    height:5.h,
                                                    child: ElevatedButton(
                                                        child: Text(
                                                            "Run Ads".toUpperCase(),
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.w700,
                                                                fontSize: 12.0.sp)
                                                        ),
                                                        style: ButtonStyle(
                                                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                                            backgroundColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(255, 104, 57, 1.0)),
                                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(5.0),
                                                                    side: const BorderSide(color: Color.fromRGBO(255, 104, 57, 1.0))
                                                                )
                                                            )
                                                        ),
                                                        onPressed: () =>  Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => AdsHomePage())),
                                                    )
                                                ),
                                                SizedBox(width:5),
                                                SizedBox(
                                                    width:25.w,
                                                    height:5.h,
                                                    child: ElevatedButton(
                                                        child: Text(
                                                            "GET VERIFIED".toUpperCase(),
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.w700,
                                                                fontSize: 9.0.sp)
                                                        ),
                                                        style: ButtonStyle(
                                                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                                            backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(5.0),
                                                                    side: const BorderSide(color: Colors.black)
                                                                )
                                                            )
                                                        ),
                                                        onPressed: () => null
                                                    )
                                                ),
                                              ],
                                            ),
                                          ),

                                          Container(
                                            // color:Colors.black,
                                            padding: const EdgeInsets.only(left:15,right:15),
                                            margin:const EdgeInsets.only(bottom:20,top:20),
                                            height:20.0.h,
                                            child:
                                            ListView(
                                              // This next line does the trick.
                                              scrollDirection: Axis.horizontal,
                                              children: <Widget>[
                                                Container(
                                                    margin:const EdgeInsets.only(right:5),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.all(Radius.circular(10))
                                                    ),
                                                    width: 80.0,
                                                    child:DottedBorder(
                                                      borderType: BorderType.RRect,
                                                      dashPattern: [5],
                                                      radius: Radius.circular(10),
                                                      color: Colors.black,
                                                      strokeWidth: 1,
                                                      child: Center(
                                                        child:Icon(Icons.add,size: 40,),
                                                      ),
                                                    )
                                                ),

                                                Container(
                                                  margin:const EdgeInsets.only(right:5),
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(image: AssetImage("images/reels1.png"), fit: BoxFit.cover),
                                                      // color: Color(0xffF2F2F2),
                                                      // border: Border.all(
                                                      //   color: Color(0xff2CBFC6),
                                                      // ),
                                                      borderRadius: BorderRadius.all(Radius.circular(10))
                                                  ),
                                                  width: 80.0,
                                                ),
                                                Container(
                                                  margin:const EdgeInsets.only(right:5),
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(image: AssetImage("images/reels2.png"), fit: BoxFit.cover),
                                                      // color: Color(0xffF2F2F2),
                                                      // border: Border.all(
                                                      //   color: Color(0xff2CBFC6),
                                                      // ),
                                                      borderRadius: BorderRadius.all(Radius.circular(10))
                                                  ),
                                                  width: 80.0,
                                                ),
                                                Container(
                                                  margin:const EdgeInsets.only(right:5),
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(image: AssetImage("images/reels1.png"), fit: BoxFit.cover),
                                                      // color: Color(0xffF2F2F2),
                                                      // border: Border.all(
                                                      //   color: Color(0xff2CBFC6),
                                                      // ),
                                                      borderRadius: BorderRadius.all(Radius.circular(10))
                                                  ),
                                                  width: 80.0,
                                                ),
                                                Container(
                                                  margin:const EdgeInsets.only(right:5),
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(image: AssetImage("images/reels2.png"), fit: BoxFit.cover),
                                                      // color: Color(0xffF2F2F2),
                                                      // border: Border.all(
                                                      //   color: Color(0xff2CBFC6),
                                                      // ),
                                                      borderRadius: BorderRadius.all(Radius.circular(10))
                                                  ),
                                                  width: 80.0,
                                                ),



                                              ],
                                            ),
                                          ),

                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child:IntrinsicHeight(
                                              child:Row(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left:15,top:15),
                                                    child:Text('MENU',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: 14.0.sp)),
                                                  ),
                                                  Container(
                                                    width:80.0.w,
                                                    padding: const EdgeInsets.only(left:15,right:15),
                                                    child:Divider(
                                                      color:Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),



                                          ),

                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child:
                                            Padding(
                                              padding: const EdgeInsets.only(left:15,top:15,bottom:15),
                                              child:Text('Burgers',
                                                  style: TextStyle(
                                                      color:Color(constant.Color.crave_orange),
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 12.0.sp)),
                                            ),

                                          ),


                                          Container(
                                            padding: const EdgeInsets.only(left:15,right:15),
                                            margin:const EdgeInsets.only(bottom:15),
                                            height:70,
                                            child: ListView(
                                              // This next line does the trick.
                                              scrollDirection: Axis.horizontal,
                                              children: <Widget>[
                                                GestureDetector(
                                                  onTap:(){
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => AddMenuItem()));
                                                  },
                                                  child:Container(
                                                      margin:const EdgeInsets.only(right:5),
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.all(Radius.circular(10))
                                                      ),
                                                      width: 70.0,
                                                      child:DottedBorder(
                                                        borderType: BorderType.RRect,
                                                        dashPattern: [5],
                                                        radius: Radius.circular(10),
                                                        color: Colors.black,
                                                        strokeWidth: 1,
                                                        child: Center(
                                                          child:Icon(Icons.add,size: 40,),
                                                        ),
                                                      )
                                                  ),
                                                ),


                                                Stack(
                                                  children: [
                                                    Container(
                                                      margin:const EdgeInsets.only(right:5),
                                                      decoration: BoxDecoration(
                                                          image: DecorationImage(image: AssetImage("images/burger1.png"), fit: BoxFit.cover),
                                                          // color: Color(0xffF2F2F2),
                                                          // border: Border.all(
                                                          //   color: Color(0xff2CBFC6),
                                                          // ),
                                                          borderRadius: BorderRadius.all(Radius.circular(10))
                                                      ),
                                                      width: 80.0,
                                                    ),
                                                    Positioned.fill(
                                                      child:Align(
                                                        alignment: Alignment.topRight,
                                                        child: Image.asset(
                                                          'images/cancel_btn_icon.png',
                                                          height: 3.0.h,
                                                        ),
                                                      ),
                                                    ),

                                                  ],
                                                ),

                                                Stack(
                                                  children: [
                                                    Container(
                                                      margin:const EdgeInsets.only(right:5),
                                                      decoration: BoxDecoration(
                                                          image: DecorationImage(image: AssetImage("images/burger2.jpg"), fit: BoxFit.cover),
                                                          // color: Color(0xffF2F2F2),
                                                          // border: Border.all(
                                                          //   color: Color(0xff2CBFC6),
                                                          // ),
                                                          borderRadius: BorderRadius.all(Radius.circular(10))
                                                      ),
                                                      width: 80.0,
                                                    ),
                                                    Positioned.fill(
                                                      child:Align(
                                                        alignment: Alignment.topRight,
                                                        child: Image.asset(
                                                          'images/cancel_btn_icon.png',
                                                          height: 3.0.h,
                                                        ),
                                                      ),
                                                    ),

                                                  ],
                                                ),
                                                Stack(
                                                  children: [
                                                    Container(
                                                      margin:const EdgeInsets.only(right:5),
                                                      decoration: BoxDecoration(
                                                          image: DecorationImage(image: AssetImage("images/burger1.png"), fit: BoxFit.cover),
                                                          // color: Color(0xffF2F2F2),
                                                          // border: Border.all(
                                                          //   color: Color(0xff2CBFC6),
                                                          // ),
                                                          borderRadius: BorderRadius.all(Radius.circular(10))
                                                      ),
                                                      width: 80.0,
                                                    ),
                                                    Positioned.fill(
                                                      child:Align(
                                                        alignment: Alignment.topRight,
                                                        child: Image.asset(
                                                          'images/cancel_btn_icon.png',
                                                          height: 3.0.h,
                                                        ),
                                                      ),
                                                    ),

                                                  ],
                                                ),
                                                Stack(
                                                  children: [
                                                    Container(
                                                      margin:const EdgeInsets.only(right:5),
                                                      decoration: BoxDecoration(
                                                          image: DecorationImage(image: AssetImage("images/burger2.jpg"), fit: BoxFit.cover),
                                                          // color: Color(0xffF2F2F2),
                                                          // border: Border.all(
                                                          //   color: Color(0xff2CBFC6),
                                                          // ),
                                                          borderRadius: BorderRadius.all(Radius.circular(10))
                                                      ),
                                                      width: 80.0,
                                                    ),
                                                    Positioned.fill(
                                                      child:Align(
                                                        alignment: Alignment.topRight,
                                                        child: Image.asset(
                                                          'images/cancel_btn_icon.png',
                                                          height: 3.0.h,
                                                        ),
                                                      ),
                                                    ),

                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(left:15,right:15),
                                            child:Divider(
                                              color:Colors.grey,
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child:
                                            Padding(
                                              padding: const EdgeInsets.only(left:15,top:5,bottom:15),
                                              child:Text('Snacks',
                                                  style: TextStyle(
                                                      color:Color(constant.Color.crave_orange),
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 12.0.sp)),
                                            ),

                                          ),


                                          Container(
                                            padding: const EdgeInsets.only(left:15,right:15),
                                            margin:const EdgeInsets.only(bottom:15),
                                            height:70,
                                            child: ListView(
                                              // This next line does the trick.
                                              scrollDirection: Axis.horizontal,
                                              children: <Widget>[
                                                GestureDetector(
                                                  onTap:(){
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => AddMenuItem()));
                                                  },
                                                  child:Container(
                                                      margin:const EdgeInsets.only(right:5),
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.all(Radius.circular(10))
                                                      ),
                                                      width: 70.0,
                                                      child:DottedBorder(
                                                        borderType: BorderType.RRect,
                                                        dashPattern: [5],
                                                        radius: Radius.circular(10),
                                                        color: Colors.black,
                                                        strokeWidth: 1,
                                                        child: Center(
                                                          child:Icon(Icons.add,size: 40,),
                                                        ),
                                                      )
                                                  ),
                                                ),


                                                Stack(
                                                  children: [
                                                    Container(
                                                      margin:const EdgeInsets.only(right:5),
                                                      decoration: BoxDecoration(
                                                          image: DecorationImage(image: AssetImage("images/mcdfries.jpg"), fit: BoxFit.cover),
                                                          // color: Color(0xffF2F2F2),
                                                          // border: Border.all(
                                                          //   color: Color(0xff2CBFC6),
                                                          // ),
                                                          borderRadius: BorderRadius.all(Radius.circular(10))
                                                      ),
                                                      width: 80.0,
                                                    ),
                                                    Positioned.fill(
                                                      child:Align(
                                                        alignment: Alignment.topRight,
                                                        child: Image.asset(
                                                          'images/cancel_btn_icon.png',
                                                          height: 3.0.h,
                                                        ),
                                                      ),
                                                    ),

                                                  ],
                                                ),
                                                Stack(
                                                  children: [
                                                    Container(
                                                      margin:const EdgeInsets.only(right:5),
                                                      decoration: BoxDecoration(
                                                          image: DecorationImage(image: AssetImage("images/mcdicecream.jpg"), fit: BoxFit.cover),
                                                          // color: Color(0xffF2F2F2),
                                                          // border: Border.all(
                                                          //   color: Color(0xff2CBFC6),
                                                          // ),
                                                          borderRadius: BorderRadius.all(Radius.circular(10))
                                                      ),
                                                      width: 80.0,
                                                    ),
                                                    Positioned.fill(
                                                      child:Align(
                                                        alignment: Alignment.topRight,
                                                        child: Image.asset(
                                                          'images/cancel_btn_icon.png',
                                                          height: 3.0.h,
                                                        ),
                                                      ),
                                                    ),

                                                  ],
                                                ),

                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(bottom:5,left:15,right:15),
                                            child:Divider(
                                              color:Colors.grey,
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child:
                                            Padding(
                                              padding: const EdgeInsets.only(left:15,top:0,bottom:10),
                                              child:Text('Drinks',
                                                  style: TextStyle(
                                                      color:Color(constant.Color.crave_orange),
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 12.0.sp)),
                                            ),

                                          ),

                                          Container(
                                            padding: const EdgeInsets.only(left:15,right:15),
                                            margin:const EdgeInsets.only(bottom:30),
                                            height:70,
                                            child: ListView(
                                              // This next line does the trick.
                                              scrollDirection: Axis.horizontal,
                                              children: <Widget>[
                                                GestureDetector(
                                                  onTap:(){
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => AddMenuItem()));
                                                  },
                                                  child:Container(
                                                      margin:const EdgeInsets.only(right:5),
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.all(Radius.circular(10))
                                                      ),
                                                      width: 70.0,
                                                      child:DottedBorder(
                                                        borderType: BorderType.RRect,
                                                        dashPattern: [5],
                                                        radius: Radius.circular(10),
                                                        color: Colors.black,
                                                        strokeWidth: 1,
                                                        child: Center(
                                                          child:Icon(Icons.add,size: 40,),
                                                        ),
                                                      )
                                                  ),
                                                ),


                                                Stack(
                                                  children: [
                                                    Container(
                                                      margin:const EdgeInsets.only(right:5),
                                                      decoration: BoxDecoration(
                                                          image: DecorationImage(image: AssetImage("images/mcdcafe.jpg"), fit: BoxFit.cover),
                                                          // color: Color(0xffF2F2F2),
                                                          // border: Border.all(
                                                          //   color: Color(0xff2CBFC6),
                                                          // ),
                                                          borderRadius: BorderRadius.all(Radius.circular(10))
                                                      ),
                                                      width: 80.0,
                                                    ),
                                                    Positioned.fill(
                                                      child:Align(
                                                        alignment: Alignment.topRight,
                                                        child: Image.asset(
                                                          'images/cancel_btn_icon.png',
                                                          height: 3.0.h,
                                                        ),
                                                      ),
                                                    ),

                                                  ],
                                                ),
                                                Stack(
                                                  children: [
                                                    Container(
                                                      margin:const EdgeInsets.only(right:5),
                                                      decoration: BoxDecoration(
                                                          image: DecorationImage(image: AssetImage("images/mcdcafe.jpg"), fit: BoxFit.cover),
                                                          // color: Color(0xffF2F2F2),
                                                          // border: Border.all(
                                                          //   color: Color(0xff2CBFC6),
                                                          // ),
                                                          borderRadius: BorderRadius.all(Radius.circular(10))
                                                      ),
                                                      width: 80.0,
                                                    ),
                                                    Positioned.fill(
                                                      child:Align(
                                                        alignment: Alignment.topRight,
                                                        child: Image.asset(
                                                          'images/cancel_btn_icon.png',
                                                          height: 3.0.h,
                                                        ),
                                                      ),
                                                    ),

                                                  ],
                                                ),
                                                Stack(
                                                  children: [
                                                    Container(
                                                      margin:const EdgeInsets.only(right:5),
                                                      decoration: BoxDecoration(
                                                          image: DecorationImage(image: AssetImage("images/mcdcafe.jpg"), fit: BoxFit.cover),
                                                          // color: Color(0xffF2F2F2),
                                                          // border: Border.all(
                                                          //   color: Color(0xff2CBFC6),
                                                          // ),
                                                          borderRadius: BorderRadius.all(Radius.circular(10))
                                                      ),
                                                      width: 80.0,
                                                    ),
                                                    Positioned.fill(
                                                      child:Align(
                                                        alignment: Alignment.topRight,
                                                        child: Image.asset(
                                                          'images/cancel_btn_icon.png',
                                                          height: 3.0.h,
                                                        ),
                                                      ),
                                                    ),

                                                  ],
                                                ),
                                                Stack(
                                                  children: [
                                                    Container(
                                                      margin:const EdgeInsets.only(right:5),
                                                      decoration: BoxDecoration(
                                                          image: DecorationImage(image: AssetImage("images/mcdcafe.jpg"), fit: BoxFit.cover),
                                                          // color: Color(0xffF2F2F2),
                                                          // border: Border.all(
                                                          //   color: Color(0xff2CBFC6),
                                                          // ),
                                                          borderRadius: BorderRadius.all(Radius.circular(10))
                                                      ),
                                                      width: 80.0,
                                                    ),
                                                    Positioned.fill(
                                                      child:Align(
                                                        alignment: Alignment.topRight,
                                                        child: Image.asset(
                                                          'images/cancel_btn_icon.png',
                                                          height: 3.0.h,
                                                        ),
                                                      ),
                                                    ),

                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(bottom:5,left:20,right:20),
                                            child:Divider(
                                              color:Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                  ),
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.only(top:12.0.h),
                                child:Align(
                                  alignment: Alignment.topCenter,
                                  child:
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 65.0,
                                    child: CircleAvatar(
                                      backgroundImage: AssetImage('images/mcdlogo.jpg'),
                                      radius: 60.0,
                                    ),
                                  ),
                                  // Image.asset(
                                  //   'images/user1.png',
                                  //   height: 15.0.h,
                                  // ),
                                ),

                              ),

                              Builder(builder: (context) {
                                return  GestureDetector(
                                  onTap:(){
                                    Scaffold.of(context).openEndDrawer();
                                  },
                                  child:Padding(
                                    padding: const EdgeInsets.only(top:100),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child:Container(
                                        // height:MediaQuery.of(context).size.height ,
                                        width: 5.0.w,
                                        decoration: BoxDecoration(
                                          // color:Colors.black,
                                          image: DecorationImage(
                                            image: AssetImage("images/sidewheel.png"),
                                            //fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),

                          endDrawer:
                          Padding(
                            padding: const EdgeInsets.only(top:100),
                            child:
                            Transform.scale(
                              scale:
                              (MediaQuery.of(context).size.height / 550),
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
                                      // Navigator.pushReplacement(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) => Homepage()));
                                    },
                                    child: Image(image: AssetImage('images/menu_switch_account.png'),height:40),
                                  ),
                                  GestureDetector(
                                    onTap:(){
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => AdsHomePage()));
                                    },
                                    child: Image(image: AssetImage('images/menu_run_ads.png'),height:30),
                                  ),

                                  GestureDetector(
                                    onTap:(){
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ProfileBusiness()));
                                    },
                                    child:  Image(image: AssetImage('images/menu_manage_business.png'),height:40),
                                  ),


                                  Image(image: AssetImage('images/menu_manage_branches.png'),height:40),
                                  GestureDetector(
                                    onTap:(){
                                      // Navigator.pushReplacement(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) => ChatPage()));
                                    },
                                    child: Image(image: AssetImage('images/menu_chat.png'),height:30),
                                  ),

                                  GestureDetector(
                                    onTap:(){
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ManageAccessPage()));
                                    },
                                    child:  Image(image: AssetImage('images/menu_manage_access.png'),height:40),
                                  ),

                                  Container(),
                                  Container(),
                                  Container(),
                                  Container(),
                                  Container(),
                                ],
                              ),
                            ),


                            // Transform(
                            //   alignment: Alignment.center,
                            //   transform: Matrix4.rotationY(math.pi),
                            //   child:  GestureDetector(
                            //     onTap:goToReels,
                            //     child:CircleListScrollView(
                            //       // controller: _scrollController,
                            //       // controller: _controllerFixed,
                            //       physics: CircleFixedExtentScrollPhysics(),
                            //       axis: Axis.vertical,
                            //       itemExtent: 65,
                            //       // children: List.generate(20, _buildItem),
                            //       children: [
                            //         Transform(
                            //           alignment: Alignment.center,
                            //           transform: Matrix4.rotationY(math.pi),
                            //           child:  Center(
                            //             child: Container(
                            //                 padding: EdgeInsets.all(5),
                            //                 child: Image(image: AssetImage('images/menu_bell.png'),height:45)
                            //             ),
                            //           ),
                            //         ),
                            //         Transform(
                            //           alignment: Alignment.center,
                            //           transform: Matrix4.rotationY(math.pi),
                            //           child:  Center(
                            //             child: Container(
                            //                 padding: EdgeInsets.all(5),
                            //                 child: Image(image: AssetImage('images/menu_chat.png'),height:40)
                            //             ),
                            //           ),
                            //         ),
                            //         Transform(
                            //           alignment: Alignment.center,
                            //           transform: Matrix4.rotationY(math.pi),
                            //           child:  Center(
                            //             child: Container(
                            //                 padding: EdgeInsets.all(5),
                            //                 child: Image(image: AssetImage('images/menu_switch_account.png'),height:80)
                            //             ),
                            //           ),
                            //         ),
                            //         Transform(
                            //           alignment: Alignment.center,
                            //           transform: Matrix4.rotationY(math.pi),
                            //           child:  Center(
                            //             child: Container(
                            //                 padding: EdgeInsets.all(5),
                            //                 child: Image(image: AssetImage('images/menu_me.png'),height:50)
                            //             ),
                            //           ),
                            //         ),
                            //         Transform(
                            //           alignment: Alignment.center,
                            //           transform: Matrix4.rotationY(math.pi),
                            //           child:
                            //           Center(
                            //             child: Container(
                            //                 padding: EdgeInsets.all(5),
                            //                 child: Image(image: AssetImage('images/menu_reels.png'),height:50)
                            //             ),
                            //           ),
                            //
                            //         ),
                            //
                            //         Transform(
                            //           alignment: Alignment.center,
                            //           transform: Matrix4.rotationY(math.pi),
                            //           child:  Center(
                            //             child: Container(
                            //                 padding: EdgeInsets.all(5),
                            //                 child: Image(image: AssetImage('images/menu_cravings.png'),height:50)
                            //             ),
                            //           ),
                            //         ),
                            //         Transform(
                            //           alignment: Alignment.center,
                            //           transform: Matrix4.rotationY(math.pi),
                            //           child:  Center(
                            //             child: Container(
                            //                 padding: EdgeInsets.all(5),
                            //                 child: Image(image: AssetImage('images/menu_home.png'),height:50)
                            //             ),
                            //           ),
                            //         ),
                            //         Transform(
                            //           alignment: Alignment.center,
                            //           transform: Matrix4.rotationY(math.pi),
                            //           child:  Center(
                            //             child: Container(
                            //                 padding: EdgeInsets.all(5),
                            //                 child: Image(image: AssetImage('images/menu_camera.png'),height:40)
                            //             ),
                            //           ),
                            //         ),
                            //         Transform(
                            //           alignment: Alignment.center,
                            //           transform: Matrix4.rotationY(math.pi),
                            //           child:  Center(
                            //             child: Container(
                            //                 padding: EdgeInsets.all(5),
                            //                 child: Image(image: AssetImage('images/menu_run_ads.png'),height:40)
                            //             ),
                            //           ),
                            //         ),
                            //         Transform(
                            //           alignment: Alignment.center,
                            //           transform: Matrix4.rotationY(math.pi),
                            //           child:  Center(
                            //             child: Container(
                            //                 padding: EdgeInsets.all(5),
                            //                 child: Image(image: AssetImage('images/menu_settings.png'),height:50)
                            //             ),
                            //           ),
                            //         ),
                            //       ],
                            //       radius: MediaQuery.of(context).size.width * 0.6,
                            //       onSelectedItemChanged: (index){
                            //         onChangedMenu(index);
                            //         print('Current index: $index');
                            //       },
                            //
                            //     ),
                            //   ),
                            //
                            // ),
                          ),
                          drawerScrimColor: Colors.transparent,
                          drawerEdgeDragWidth: MediaQuery.of(context).size.width,
                        ),
                      );
                    });
              }
          );
        }
    );

  }
}


