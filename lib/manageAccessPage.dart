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
import 'adsHomePage.dart';
import 'chatPage.dart';
import 'circle_wheel_scroll/circle_wheel_scroll_view.dart';
import 'cravingsPage.dart';
import 'homepage.dart';
import 'notificationsPage.dart';
import 'profileBusiness.dart';
import 'profileUser.dart';
import 'reelsDetails.dart';

import 'constants.dart' as constant;

class ManageAccessPage extends StatefulWidget {
  const ManageAccessPage({Key? key}) : super(key: key);

  @override
  ManageAccessPageState createState() => ManageAccessPageState();
}

class ManageAccessPageState extends State<ManageAccessPage> {

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
                                      child:Text("Manage Team",
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
                                                                  fontWeight: FontWeight.w600,
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
                                                    Text('REMOVE',
                                                        style: TextStyle(
                                                            color:Color(constant.Color.crave_orange),
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
                                                    Text('REMOVE',
                                                        style: TextStyle(
                                                            color:Color(constant.Color.crave_orange),
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
                                                    Text('REMOVE',
                                                        style: TextStyle(
                                                            color:Color(constant.Color.crave_orange),
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
                                                    Text('REMOVE',
                                                        style: TextStyle(
                                                            color:Color(constant.Color.crave_orange),
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
                                                      'images/profile_img.png',
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
                                                          Text('Thanos',
                                                              style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontWeight: FontWeight.w700,
                                                                  fontSize: 12.0.sp)),
                                                          SizedBox(height:0.5.h),
                                                          Text('madtitan',
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontSize: 8.0.sp)),

                                                        ],
                                                      ),

                                                    ),
                                                    Spacer(),
                                                    Text('PENDING',
                                                        style: TextStyle(
                                                            color:Colors.grey,
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
                                                      'images/add_team_member_icon.png',
                                                      height: 6.0.h,
                                                    ),

                                                    Container(
                                                      width:75.0.w,
                                                      padding:EdgeInsets.only(left:0),
                                                      child:
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                          Container(
                                                            //width:250,
                                                            height:30,
                                                            margin: const EdgeInsets.only(bottom: 15.0,top:5),
                                                            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                                            child:TextField(
                                                              autofocus: false,
                                                              controller: textSearchUserController,
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
                                                                      fontSize: 12,
                                                                      color:Colors.black
                                                                  ),
                                                                  hintStyle: TextStyle(
                                                                      fontSize: 12,
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
                                                                  hintText: "Username or Email"),
                                                            ),
                                                          ),
                                                          // SizedBox(height:0.5.h),
                                                          Text('SEND REQUEST',
                                                              style: TextStyle(
                                                                  color:Color(constant.Color.crave_blue),
                                                                  fontWeight: FontWeight.w700,
                                                                  fontSize: 10.0.sp)),

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
                                      Navigator.pushReplacement(
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


