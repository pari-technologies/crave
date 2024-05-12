// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:a_crave/chatDetailPage.dart';
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
import 'homeBase.dart';
import 'homepage.dart';
import 'notificationsPage.dart';
import 'profileBusiness.dart';
import 'profileUser.dart';
import 'reelsDetails.dart';

import 'constants.dart' as constant;

class CravingsFollowing extends StatefulWidget {
  const CravingsFollowing({Key? key}) : super(key: key);

  @override
  CravingsFollowingState createState() => CravingsFollowingState();
}

class CravingsFollowingState extends State<CravingsFollowing> {

  final textController = TextEditingController();
  int currentTab = 0;

  @override
  void initState() {
    super.initState();
    //WidgetsBinding.instance!.addPostFrameCallback((_) => startLoad());
  }

  void goToCravingsPage(pageNo){
    if(pageNo == "1"){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CravingsPage()));
    }
    else if(pageNo == "2"){
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => CravingsPage()));
    }
    else if(pageNo == "3"){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CravingsFollowing()));
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
                                          top: 50.0,bottom:20,left:20),
                                      width:MediaQuery.of(context).size.width,
                                      child:Text("CRAVES",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black,
                                              fontSize: 16.0.sp))
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(left: 30.0, right: 30.0,bottom:15),
                                    child:IntrinsicHeight(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          GestureDetector(
                                            onTap:(){
                                              goToCravingsPage("1");
                                            },
                                            child:Text("TOP CRAVES",
                                                style: TextStyle(
                                                    color: Color(0xFFDEDDDD),
                                                    fontSize: 11.0.sp)),
                                          ),
                                          SizedBox(
                                            width:2.0.w,
                                          ),
                                          Container(
                                            //padding: const EdgeInsets.only(top:15,bottom:15),
                                            child:VerticalDivider(
                                                color:Colors.grey
                                            ),
                                          ),
                                          SizedBox(
                                            width:2.0.w,
                                          ),
                                          GestureDetector(
                                            onTap:(){
                                              goToCravingsPage("2");
                                            },
                                            child:Text("DISCOVER",
                                                style: TextStyle(
                                                    color: Color(0xFFDEDDDD),
                                                    fontSize: 11.0.sp)),
                                          ),
                                          SizedBox(
                                            width:2.0.w,
                                          ),
                                          Container(
                                            // padding: const EdgeInsets.only(top:15,bottom:15),
                                            child:VerticalDivider(
                                                color:Colors.grey
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap:(){
                                              goToCravingsPage("3");
                                            },
                                            child:Text("FOLLOWING",
                                                style: TextStyle(
                                                    color: currentTab==1?Colors.black:Color(0xFFDEDDDD),
                                                    fontSize: 11.0.sp)),
                                          ),
                                        ],
                                      ),
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
                                                Row(
                                                  children: [
                                                    Image.asset(
                                                      'images/user1.png',
                                                      height: 6.0.h,
                                                    ),

                                                    Container(
                                                      width:50.0.w,
                                                      padding:EdgeInsets.only(left:10),
                                                      child:
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text('Kar Heng',
                                                              style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontWeight: FontWeight.w700,
                                                                  fontSize: 12.0.sp)),
                                                          SizedBox(height:0.5.h),
                                                          Text('USERNAMEBLAH',
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontSize: 8.0.sp)),

                                                        ],
                                                      ),

                                                    ),
                                                    Spacer(),
                                                    Text('FOLLOWING',
                                                        style: TextStyle(
                                                            color:Color(constant.Color.crave_blue),
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: 10.0.sp)),
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
                                                      'images/user1.png',
                                                      height: 6.0.h,
                                                    ),

                                                    Container(
                                                      width:50.0.w,
                                                      padding:EdgeInsets.only(left:10),
                                                      child:
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text('Kar Heng',
                                                              style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontWeight: FontWeight.w700,
                                                                  fontSize: 12.0.sp)),
                                                          SizedBox(height:0.5.h),
                                                          Text('USERNAMEBLAH',
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontSize: 8.0.sp)),

                                                        ],
                                                      ),

                                                    ),
                                                    Spacer(),
                                                    Text('FOLLOWING',
                                                        style: TextStyle(
                                                            color:Color(constant.Color.crave_blue),
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: 10.0.sp)),
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
                                                      'images/user1.png',
                                                      height: 6.0.h,
                                                    ),

                                                    Container(
                                                      width:50.0.w,
                                                      padding:EdgeInsets.only(left:10),
                                                      child:
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text('Kar Heng',
                                                              style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontWeight: FontWeight.w700,
                                                                  fontSize: 12.0.sp)),
                                                          SizedBox(height:0.5.h),
                                                          Text('USERNAMEBLAH',
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontSize: 8.0.sp)),

                                                        ],
                                                      ),

                                                    ),
                                                    Spacer(),
                                                    Text('FOLLOWING',
                                                        style: TextStyle(
                                                            color:Color(constant.Color.crave_blue),
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: 10.0.sp)),
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
                                                      'images/user1.png',
                                                      height: 6.0.h,
                                                    ),

                                                    Container(
                                                      width:50.0.w,
                                                      padding:EdgeInsets.only(left:10),
                                                      child:
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text('Kar Heng',
                                                              style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontWeight: FontWeight.w700,
                                                                  fontSize: 12.0.sp)),
                                                          SizedBox(height:0.5.h),
                                                          Text('USERNAMEBLAH',
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontSize: 8.0.sp)),

                                                        ],
                                                      ),

                                                    ),
                                                    Spacer(),
                                                    Text('FOLLOWING',
                                                        style: TextStyle(
                                                            color:Color(constant.Color.crave_blue),
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: 10.0.sp)),
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


                              Builder(builder: (context) {
                                return  GestureDetector(
                                  onTap:(){
                                    // Scaffold.of(context).openEndDrawer();
                                    setState(() {
                                      PageViewDemo.of(context)!.showWheel();
                                    });
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

                          // endDrawer:
                          // Padding(
                          //   padding: const EdgeInsets.only(top:100),
                          //   child:
                          //   Transform.scale(
                          //     scale:
                          //     (MediaQuery.of(context).size.height / 600),
                          //     child:CircleList(
                          //
                          //       // showInitialAnimation: true,
                          //       rotateMode:RotateMode.allRotate,
                          //       innerCircleColor:Color(constant.Color.crave_blue),
                          //       outerCircleColor:Color(constant.Color.crave_blue),
                          //       origin: Offset(50.0.w, 0),
                          //       children: [
                          //         Container(),
                          //         Container(),
                          //         Container(),
                          //         Container(),
                          //         Container(),
                          //         Container(),
                          //
                          //         Image(image: AssetImage('images/menu_settings.png'),height:30),
                          //         GestureDetector(
                          //           onTap:(){
                          //             Navigator.push(
                          //                 context,
                          //                 MaterialPageRoute(
                          //                     builder: (context) => CameraScreen()));
                          //           },
                          //           child: Image(image: AssetImage('images/menu_camera.png'),height:30),
                          //         ),
                          //
                          //         GestureDetector(
                          //           onTap:(){
                          //             // Navigator.pushReplacement(
                          //             //     context,
                          //             //     MaterialPageRoute(
                          //             //         builder: (context) => Homepage()));
                          //           },
                          //           child: Image(image: AssetImage('images/menu_home.png'),height:35),
                          //         ),
                          //         GestureDetector(
                          //           onTap:(){
                          //             Navigator.push(
                          //                 context,
                          //                 MaterialPageRoute(
                          //                     builder: (context) => CravingsPage()));
                          //           },
                          //           child: Image(image: AssetImage('images/menu_cravings.png'),height:30),
                          //         ),
                          //
                          //         GestureDetector(
                          //           onTap:(){
                          //             // Navigator.push(
                          //             //     context,
                          //             //     MaterialPageRoute(
                          //             //         builder: (context) => ReelsDetails()));
                          //           },
                          //           child:Image(image: AssetImage('images/menu_reels.png'),height:35),
                          //         ),
                          //
                          //         GestureDetector(
                          //           onTap:(){
                          //             Navigator.push(
                          //                 context,
                          //                 MaterialPageRoute(
                          //                     builder: (context) => ProfileUser()));
                          //           },
                          //           child:Image(image: AssetImage('images/menu_me.png'),height:35),
                          //         ),
                          //
                          //         GestureDetector(
                          //           onTap:(){
                          //             // Navigator.pushReplacement(
                          //             //     context,
                          //             //     MaterialPageRoute(
                          //             //         builder: (context) => ChatPage()));
                          //           },
                          //           child: Image(image: AssetImage('images/menu_chat.png'),height:30),
                          //         ),
                          //
                          //         GestureDetector(
                          //           onTap:(){
                          //             Navigator.pushReplacement(
                          //                 context,
                          //                 MaterialPageRoute(
                          //                     builder: (context) => NotificationsPage()));
                          //           },
                          //           child: Image(image: AssetImage('images/menu_bell.png'),height:40),
                          //         ),
                          //
                          //         Container(),
                          //         Container(),
                          //         Container(),
                          //         Container(),
                          //
                          //       ],
                          //     ),
                          //   ),
                          //
                          //
                          //   // Transform(
                          //   //   alignment: Alignment.center,
                          //   //   transform: Matrix4.rotationY(math.pi),
                          //   //   child:  CircleListScrollView(
                          //   //     // controller: _scrollController,
                          //   //     // controller: _controllerFixed,
                          //   //     physics: CircleFixedExtentScrollPhysics(),
                          //   //     axis: Axis.vertical,
                          //   //     itemExtent: 65,
                          //   //     // children: List.generate(20, _buildItem),
                          //   //     children: [
                          //   //       Transform(
                          //   //         alignment: Alignment.center,
                          //   //         transform: Matrix4.rotationY(math.pi),
                          //   //         child:
                          //   //         TextButton(
                          //   //           onPressed: () {
                          //   //             Navigator.pushReplacement(
                          //   //                 context,
                          //   //                 MaterialPageRoute(
                          //   //                     builder: (context) => NotificationsPage()));
                          //   //           },
                          //   //
                          //   //           child: Text("TEXT BUTTON",style: TextStyle(
                          //   //               fontWeight: FontWeight.w700,
                          //   //               color: Colors.white,
                          //   //               fontSize: 10.0.sp)),
                          //   //         ),
                          //   //
                          //   //       ),
                          //   //
                          //   //       Transform(
                          //   //         alignment: Alignment.center,
                          //   //         transform: Matrix4.rotationY(math.pi),
                          //   //         child:
                          //   //         GestureDetector(
                          //   //           onTap:(){
                          //   //             Navigator.pushReplacement(
                          //   //                               context,
                          //   //                               MaterialPageRoute(
                          //   //                                   builder: (context) => NotificationsPage()));
                          //   //           },
                          //   //           child: Center(
                          //   //             child: Container(
                          //   //                 padding: EdgeInsets.all(5),
                          //   //                 child: Image(image: AssetImage('images/menu_chat.png'),height:40)
                          //   //             ),
                          //   //           ),
                          //   //         ),
                          //   //
                          //   //       ),
                          //   //       Transform(
                          //   //         alignment: Alignment.center,
                          //   //         transform: Matrix4.rotationY(math.pi),
                          //   //         child:  Center(
                          //   //           child: Container(
                          //   //               padding: EdgeInsets.all(5),
                          //   //               child: Image(image: AssetImage('images/menu_chat.png'),height:40)
                          //   //           ),
                          //   //         ),
                          //   //       ),
                          //   //       Transform(
                          //   //         alignment: Alignment.center,
                          //   //         transform: Matrix4.rotationY(math.pi),
                          //   //         child:  Center(
                          //   //           child: Container(
                          //   //               padding: EdgeInsets.all(5),
                          //   //               child: Image(image: AssetImage('images/menu_switch_account.png'),height:80)
                          //   //           ),
                          //   //         ),
                          //   //       ),
                          //   //       Transform(
                          //   //         alignment: Alignment.center,
                          //   //         transform: Matrix4.rotationY(math.pi),
                          //   //         child:  Center(
                          //   //           child: Container(
                          //   //               padding: EdgeInsets.all(5),
                          //   //               child: Image(image: AssetImage('images/menu_me.png'),height:50)
                          //   //           ),
                          //   //         ),
                          //   //       ),
                          //   //       Transform(
                          //   //         alignment: Alignment.center,
                          //   //         transform: Matrix4.rotationY(math.pi),
                          //   //         child:
                          //   //         Center(
                          //   //           child: Container(
                          //   //               padding: EdgeInsets.all(5),
                          //   //               child: Image(image: AssetImage('images/menu_reels.png'),height:50)
                          //   //           ),
                          //   //         ),
                          //   //
                          //   //       ),
                          //   //
                          //   //       Transform(
                          //   //         alignment: Alignment.center,
                          //   //         transform: Matrix4.rotationY(math.pi),
                          //   //         child:  Center(
                          //   //           child: Container(
                          //   //               padding: EdgeInsets.all(5),
                          //   //               child: Image(image: AssetImage('images/menu_cravings.png'),height:50)
                          //   //           ),
                          //   //         ),
                          //   //       ),
                          //   //       Transform(
                          //   //         alignment: Alignment.center,
                          //   //         transform: Matrix4.rotationY(math.pi),
                          //   //         child:  Center(
                          //   //           child: Container(
                          //   //               padding: EdgeInsets.all(5),
                          //   //               child: Image(image: AssetImage('images/menu_home.png'),height:50)
                          //   //           ),
                          //   //         ),
                          //   //       ),
                          //   //       Transform(
                          //   //         alignment: Alignment.center,
                          //   //         transform: Matrix4.rotationY(math.pi),
                          //   //         child:  Center(
                          //   //           child: Container(
                          //   //               padding: EdgeInsets.all(5),
                          //   //               child: Image(image: AssetImage('images/menu_camera.png'),height:40)
                          //   //           ),
                          //   //         ),
                          //   //       ),
                          //   //       Transform(
                          //   //         alignment: Alignment.center,
                          //   //         transform: Matrix4.rotationY(math.pi),
                          //   //         child:  Center(
                          //   //           child: Container(
                          //   //               padding: EdgeInsets.all(5),
                          //   //               child: Image(image: AssetImage('images/menu_run_ads.png'),height:40)
                          //   //           ),
                          //   //         ),
                          //   //       ),
                          //   //       Transform(
                          //   //         alignment: Alignment.center,
                          //   //         transform: Matrix4.rotationY(math.pi),
                          //   //         child:  Center(
                          //   //           child: Container(
                          //   //               padding: EdgeInsets.all(5),
                          //   //               child: Image(image: AssetImage('images/menu_settings.png'),height:50)
                          //   //           ),
                          //   //         ),
                          //   //       ),
                          //   //     ],
                          //   //     radius: MediaQuery.of(context).size.width * 0.6,
                          //   //     onSelectedItemChanged: (index){
                          //   //       onChangedMenu(index);
                          //   //       print('Current index: $index');
                          //   //     },
                          //   //
                          //   //   ),
                          //   //
                          //   // ),
                          // ),
                          // drawerScrimColor: Colors.transparent,
                          // drawerEdgeDragWidth: MediaQuery.of(context).size.width,
                        ),
                      );
                    });
              }
          );
        }
    );

  }
}


