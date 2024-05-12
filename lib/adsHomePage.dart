// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:a_crave/chatDetailPage.dart';
import 'package:a_crave/createAdsPage.dart';
import 'package:a_crave/reels.dart';
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
import 'homepage.dart';
import 'manageAccessPage.dart';
import 'notificationsPage.dart';
import 'profileBusiness.dart';
import 'profileUser.dart';
import 'reelsDetails.dart';

import 'constants.dart' as constant;

class AdsHomePage extends StatefulWidget {
  const AdsHomePage({Key? key}) : super(key: key);

  @override
  AdsHomePageState createState() => AdsHomePageState();
}

class AdsHomePageState extends State<AdsHomePage> {

  final textController = TextEditingController();
  final textSearchUserController = TextEditingController();
  int currentTab = 0;

  @override
  void initState() {
    super.initState();
    //WidgetsBinding.instance!.addPostFrameCallback((_) => startLoad());
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
                              Column(
                                children: [
                                  Container(
                                      padding: const EdgeInsets.only(
                                          top: 50.0,bottom:10,left:20),
                                      width:MediaQuery.of(context).size.width,
                                      child:Text("Manage Ads",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black,
                                              fontSize: 16.0.sp))
                                  ),

                                  Container(
                                    //width:250,
                                    height:40,
                                    margin: const EdgeInsets.only(bottom: 15.0,top:15),
                                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
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
                                    padding: const EdgeInsets.only(left:5,right:5,bottom:5),
                                    child:Divider(
                                      color: Colors.grey,
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
                                          Container(
                                            //color:Colors.black,
                                            padding: const EdgeInsets.only(left:20,bottom:10,right:20),
                                            child:Column(
                                              children: [
                                                GestureDetector(
                                                  onTap:(){
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => CreateAdsPage()));
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                          margin:const EdgeInsets.only(right:5),
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.all(Radius.circular(10))
                                                          ),
                                                          width: 50.0,
                                                          child:DottedBorder(
                                                            borderType: BorderType.RRect,
                                                            dashPattern: [5],
                                                            radius: Radius.circular(10),
                                                            color: Colors.black,
                                                            strokeWidth: 0.5,
                                                            child: Center(
                                                              child:Icon(Icons.add,size: 40,),
                                                            ),
                                                          )
                                                      ),
                                                      Container(
                                                        width:50.0.w,
                                                        padding:EdgeInsets.only(left:10),
                                                        child:
                                                        Column(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text('Create Ad',
                                                                style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.w600,
                                                                    fontSize: 16.0.sp)),


                                                          ],
                                                        ),

                                                      ),

                                                    ],

                                                  ),
                                                ),


                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(left:5,right:5,top:0,bottom:5),
                                            child:Divider(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Container(
                                            //color:Colors.black,
                                            padding: const EdgeInsets.only(left:20,bottom:10,right:20),
                                            child:Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Image.asset(
                                                        'images/food1.png',
                                                        width:18.0.w
                                                    ),

                                                    Container(
                                                      width:71.0.w,
                                                      padding:EdgeInsets.only(left:10),
                                                      child:
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text('Sushi Set',
                                                                  style: TextStyle(
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.w700,
                                                                      fontSize: 12.0.sp)),
                                                              Container(
                                                                margin: EdgeInsets.only(left:5,top:5),
                                                                width: 8,
                                                                height: 8,
                                                                //child: Icon(CustomIcons.option, size: 20,),
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape.circle,
                                                                    color: Color(constant.Color.crave_orange)),
                                                              ),
                                                              Spacer(),
                                                              Text('EDIT',
                                                                  style: TextStyle(
                                                                      color:Color(constant.Color.crave_blue),
                                                                      fontWeight: FontWeight.w700,
                                                                      fontSize: 10.0.sp)),
                                                            ],
                                                          ),

                                                          SizedBox(height:0.5.h),
                                                          Row(
                                                            // mainAxisAlignment: MainAxisAlignment.end,
                                                            crossAxisAlignment: CrossAxisAlignment.end,
                                                            children: [
                                                              Text('20 DEC - 31 DEC',
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.w700,
                                                                      color: Colors.black,
                                                                      fontSize: 8.0.sp)),
                                                              Text(' | ',
                                                                  style: TextStyle(
                                                                      color: Colors.grey,
                                                                      fontSize: 10.0.sp)),
                                                              Text('0 / 50,000',
                                                                  style: TextStyle(
                                                                      color: Colors.black,
                                                                      fontSize: 8.0.sp)),
                                                              Text(' MYR',
                                                                  style: TextStyle(
                                                                      color: Colors.black,
                                                                      fontSize: 6.0.sp)),
                                                            ],
                                                          ),

                                                          SizedBox(height:0.5.h),
                                                          Container(
                                                            margin: EdgeInsets.symmetric(vertical: 5),
                                                            height:5,
                                                            decoration: BoxDecoration(
                                                              border: Border.all(color: Colors.grey),
                                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                                            ),
                                                            // width: 300,
                                                            child: ClipRRect(
                                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                                              child: LinearProgressIndicator(
                                                                value: 1,
                                                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                                backgroundColor: Colors.white,

                                                              ),
                                                            ),
                                                          )

                                                        ],
                                                      ),

                                                    ),

                                                  ],

                                                ),

                                              ],
                                            ),
                                          ),

                                          Container(
                                            padding: const EdgeInsets.only(left:5,right:5,top:0,bottom:5),
                                            child:Divider(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Container(
                                            //color:Colors.black,
                                            padding: const EdgeInsets.only(left:20,bottom:10,right:20),
                                            child:Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Image.asset(
                                                        'images/food2.png',
                                                        width:18.0.w
                                                    ),

                                                    Container(
                                                      width:71.0.w,
                                                      padding:EdgeInsets.only(left:10),
                                                      child:
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text('Nasi Lemak Set',
                                                                  style: TextStyle(
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.w700,
                                                                      fontSize: 12.0.sp)),
                                                              Container(
                                                                margin: EdgeInsets.only(left:5,top:5),
                                                                width: 8,
                                                                height: 8,
                                                                //child: Icon(CustomIcons.option, size: 20,),
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape.circle,
                                                                    color: Colors.green),
                                                              ),
                                                              Spacer(),
                                                              Text('EDIT',
                                                                  style: TextStyle(
                                                                      color:Color(constant.Color.crave_blue),
                                                                      fontWeight: FontWeight.w700,
                                                                      fontSize: 10.0.sp)),
                                                            ],
                                                          ),

                                                          SizedBox(height:0.5.h),
                                                          Row(
                                                            // mainAxisAlignment: MainAxisAlignment.end,
                                                            crossAxisAlignment: CrossAxisAlignment.end,
                                                            children: [
                                                              Text('20 DEC - 31 DEC',
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.w700,
                                                                      color: Colors.black,
                                                                      fontSize: 8.0.sp)),
                                                              Text(' | ',
                                                                  style: TextStyle(
                                                                      color: Colors.grey,
                                                                      fontSize: 10.0.sp)),
                                                              Text('234,567 / 300,000',
                                                                  style: TextStyle(
                                                                      color: Colors.black,
                                                                      fontSize: 8.0.sp)),
                                                              Text(' MYR',
                                                                  style: TextStyle(
                                                                      color: Colors.black,
                                                                      fontSize: 6.0.sp)),
                                                            ],
                                                          ),

                                                          SizedBox(height:0.5.h),
                                                          Container(
                                                            margin: EdgeInsets.symmetric(vertical: 5),
                                                            height:5,
                                                            decoration: BoxDecoration(
                                                              border: Border.all(color: Colors.grey),
                                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                                            ),
                                                            // width: 300,
                                                            child: ClipRRect(
                                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                                              child: LinearProgressIndicator(
                                                                value: 0.7,
                                                                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                                                                backgroundColor: Colors.white,

                                                              ),
                                                            ),
                                                          )

                                                        ],
                                                      ),

                                                    ),

                                                  ],

                                                ),

                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(left:5,right:5,top:0,bottom:5),
                                            child:Divider(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Container(
                                            //color:Colors.black,
                                            padding: const EdgeInsets.only(left:20,bottom:10,right:20),
                                            child:Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Image.asset(
                                                      'images/food2.png',
                                                        width:18.0.w
                                                    ),

                                                    Container(
                                                      width:71.0.w,
                                                      padding:EdgeInsets.only(left:10),
                                                      child:
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text('X-mas Set',
                                                                  style: TextStyle(
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.w700,
                                                                      fontSize: 12.0.sp)),
                                                              Container(
                                                                margin: EdgeInsets.only(left:5,top:5),
                                                                width: 8,
                                                                height: 8,
                                                                //child: Icon(CustomIcons.option, size: 20,),
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape.circle,
                                                                    color: Colors.grey),
                                                              ),
                                                              Spacer(),
                                                              Text('EDIT',
                                                                  style: TextStyle(
                                                                      color:Color(constant.Color.crave_blue),
                                                                      fontWeight: FontWeight.w700,
                                                                      fontSize: 10.0.sp)),
                                                            ],
                                                          ),

                                                          SizedBox(height:0.5.h),
                                                          Row(
                                                            // mainAxisAlignment: MainAxisAlignment.end,
                                                            crossAxisAlignment: CrossAxisAlignment.end,
                                                            children: [
                                                              Text('20 DEC - 31 DEC',
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.w700,
                                                                      color: Colors.black,
                                                                      fontSize: 8.0.sp)),
                                                              Text(' | ',
                                                                  style: TextStyle(
                                                                      color: Colors.grey,
                                                                      fontSize: 10.0.sp)),
                                                              Text('20,000 / 20,000',
                                                                  style: TextStyle(
                                                                      color: Colors.black,
                                                                      fontSize: 8.0.sp)),
                                                              Text(' MYR',
                                                                  style: TextStyle(
                                                                      color: Colors.black,
                                                                      fontSize: 6.0.sp)),
                                                            ],
                                                          ),

                                                          SizedBox(height:0.5.h),
                                                          Container(
                                                            margin: EdgeInsets.symmetric(vertical: 5),
                                                            height:5,
                                                            decoration: BoxDecoration(
                                                                border: Border.all(color: Colors.grey),
                                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                                            ),
                                                            // width: 300,
                                                            child: ClipRRect(
                                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                                              child: LinearProgressIndicator(
                                                                value: 1,
                                                                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                                                                backgroundColor: Colors.white,

                                                              ),
                                                            ),
                                                          )

                                                        ],
                                                      ),

                                                    ),

                                                  ],

                                                ),

                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(left:5,right:5,top:0,bottom:5),
                                            child:Divider(
                                              color: Colors.grey,
                                            ),
                                          ),


                                        ],
                                      ),
                                    ),
                                  )


                                ],
                              ),

                              Align(
                                alignment: Alignment.bottomCenter,
                                child:Container(
                                    margin: EdgeInsets.only(bottom:10.0.h),
                                    padding : EdgeInsets.only(left:0),
                                    height:100,
                                    width:75.0.w,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    elevation: 5,
                                    child:
                                    Container(
                                      child: Row(
                                        children: [
                                          Column(
                                            children: [
                                              Container(
                                                height:50,
                                                margin: EdgeInsets.only(bottom:10,top:10,left:20),
                                                child:Image.asset(
                                                  'images/crave_credit_icon.png',
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(left:20),
                                                child: Text("CRAVE CREDIT",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.grey,
                                                        fontSize: 9.0.sp)),
                                              ),

                                            ],
                                          ),

                                          Container(
                                            padding: const EdgeInsets.only(left:5,right:5),
                                            margin : EdgeInsets.only(bottom:15,top:15),
                                            child:VerticalDivider(
                                              color: Colors.grey,
                                            ),
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.only(right:5,top:10),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text("255,280",
                                                        textAlign: TextAlign.left,
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: 18.0.sp)),
                                                    Text(" MYR",
                                                        textAlign: TextAlign.end,
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 9.0.sp)),
                                                  ],
                                                ),

                                                Padding(
                                                  padding: EdgeInsets.only(top:10),
                                                  child:SizedBox(
                                                      width:30.w,
                                                      height:4.h,
                                                      child: ElevatedButton(
                                                          child: Text(
                                                              "TOP UP".toUpperCase(),
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight.w700,
                                                                  fontSize: 14.0.sp)
                                                          ),
                                                          style: ButtonStyle(
                                                              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                                              backgroundColor: MaterialStateProperty.all<Color>(const Color(constant.Color.crave_orange)),
                                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                  RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(20.0),
                                                                      side: const BorderSide(color: Color(constant.Color.crave_orange))
                                                                  )
                                                              )
                                                          ),
                                                          onPressed: () => null
                                                      )
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),

                                  )
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
                                    },
                                    child: Image(image: AssetImage('images/menu_home.png'),height:35),
                                  ),
                                  GestureDetector(
                                    onTap:(){
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => CravingsPage()));
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


                            // Transform(
                            //   alignment: Alignment.center,
                            //   transform: Matrix4.rotationY(math.pi),
                            //   child:  CircleListScrollView(
                            //     // controller: _scrollController,
                            //     // controller: _controllerFixed,
                            //     physics: CircleFixedExtentScrollPhysics(),
                            //     axis: Axis.vertical,
                            //     itemExtent: 65,
                            //     // children: List.generate(20, _buildItem),
                            //     children: [
                            //       Transform(
                            //         alignment: Alignment.center,
                            //         transform: Matrix4.rotationY(math.pi),
                            //         child:
                            //         TextButton(
                            //           onPressed: () {
                            //             Navigator.pushReplacement(
                            //                 context,
                            //                 MaterialPageRoute(
                            //                     builder: (context) => NotificationsPage()));
                            //           },
                            //
                            //           child: Text("TEXT BUTTON",style: TextStyle(
                            //               fontWeight: FontWeight.w700,
                            //               color: Colors.white,
                            //               fontSize: 10.0.sp)),
                            //         ),
                            //
                            //       ),
                            //
                            //       Transform(
                            //         alignment: Alignment.center,
                            //         transform: Matrix4.rotationY(math.pi),
                            //         child:
                            //         GestureDetector(
                            //           onTap:(){
                            //             Navigator.pushReplacement(
                            //                               context,
                            //                               MaterialPageRoute(
                            //                                   builder: (context) => NotificationsPage()));
                            //           },
                            //           child: Center(
                            //             child: Container(
                            //                 padding: EdgeInsets.all(5),
                            //                 child: Image(image: AssetImage('images/menu_chat.png'),height:40)
                            //             ),
                            //           ),
                            //         ),
                            //
                            //       ),
                            //       Transform(
                            //         alignment: Alignment.center,
                            //         transform: Matrix4.rotationY(math.pi),
                            //         child:  Center(
                            //           child: Container(
                            //               padding: EdgeInsets.all(5),
                            //               child: Image(image: AssetImage('images/menu_chat.png'),height:40)
                            //           ),
                            //         ),
                            //       ),
                            //       Transform(
                            //         alignment: Alignment.center,
                            //         transform: Matrix4.rotationY(math.pi),
                            //         child:  Center(
                            //           child: Container(
                            //               padding: EdgeInsets.all(5),
                            //               child: Image(image: AssetImage('images/menu_switch_account.png'),height:80)
                            //           ),
                            //         ),
                            //       ),
                            //       Transform(
                            //         alignment: Alignment.center,
                            //         transform: Matrix4.rotationY(math.pi),
                            //         child:  Center(
                            //           child: Container(
                            //               padding: EdgeInsets.all(5),
                            //               child: Image(image: AssetImage('images/menu_me.png'),height:50)
                            //           ),
                            //         ),
                            //       ),
                            //       Transform(
                            //         alignment: Alignment.center,
                            //         transform: Matrix4.rotationY(math.pi),
                            //         child:
                            //         Center(
                            //           child: Container(
                            //               padding: EdgeInsets.all(5),
                            //               child: Image(image: AssetImage('images/menu_reels.png'),height:50)
                            //           ),
                            //         ),
                            //
                            //       ),
                            //
                            //       Transform(
                            //         alignment: Alignment.center,
                            //         transform: Matrix4.rotationY(math.pi),
                            //         child:  Center(
                            //           child: Container(
                            //               padding: EdgeInsets.all(5),
                            //               child: Image(image: AssetImage('images/menu_cravings.png'),height:50)
                            //           ),
                            //         ),
                            //       ),
                            //       Transform(
                            //         alignment: Alignment.center,
                            //         transform: Matrix4.rotationY(math.pi),
                            //         child:  Center(
                            //           child: Container(
                            //               padding: EdgeInsets.all(5),
                            //               child: Image(image: AssetImage('images/menu_home.png'),height:50)
                            //           ),
                            //         ),
                            //       ),
                            //       Transform(
                            //         alignment: Alignment.center,
                            //         transform: Matrix4.rotationY(math.pi),
                            //         child:  Center(
                            //           child: Container(
                            //               padding: EdgeInsets.all(5),
                            //               child: Image(image: AssetImage('images/menu_camera.png'),height:40)
                            //           ),
                            //         ),
                            //       ),
                            //       Transform(
                            //         alignment: Alignment.center,
                            //         transform: Matrix4.rotationY(math.pi),
                            //         child:  Center(
                            //           child: Container(
                            //               padding: EdgeInsets.all(5),
                            //               child: Image(image: AssetImage('images/menu_run_ads.png'),height:40)
                            //           ),
                            //         ),
                            //       ),
                            //       Transform(
                            //         alignment: Alignment.center,
                            //         transform: Matrix4.rotationY(math.pi),
                            //         child:  Center(
                            //           child: Container(
                            //               padding: EdgeInsets.all(5),
                            //               child: Image(image: AssetImage('images/menu_settings.png'),height:50)
                            //           ),
                            //         ),
                            //       ),
                            //     ],
                            //     radius: MediaQuery.of(context).size.width * 0.6,
                            //     onSelectedItemChanged: (index){
                            //       onChangedMenu(index);
                            //       print('Current index: $index');
                            //     },
                            //
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


