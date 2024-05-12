// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:a_crave/chatDetailPage.dart';
import 'package:a_crave/profileUser.dart';
import 'package:a_crave/reels.dart';
import 'package:a_crave/reelsDetails.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';

import 'package:sizer/sizer.dart';
import 'constants.dart' as constant;
import 'dart:math' as math;
import 'package:circle_list/circle_list.dart';
import 'camera_screen.dart';
import 'circle_wheel_scroll/circle_wheel_scroll_view.dart';
import 'cravingsPage.dart';
import 'dataClass.dart';
import 'homeBase.dart';
import 'homepage.dart';
import 'myNavWheel.dart';
import 'notificationsPage.dart';
import 'profileBusiness.dart';

class ChatPage extends StatefulWidget {
  final PageController chatPageController;
  final List<Chatroom> chatroom;
  final List<Chatroom> dummychatroom;
  final String user_email;
  final Function(String) onDataChange;
  const ChatPage({Key? key, required this.chatPageController, required this.chatroom,required this.dummychatroom, required this.user_email, required this.onDataChange}) : super(key: key);

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {

  final textController = TextEditingController();
  List<Chatroom> currentChat = [];
  List<Chatroom> dummyChat = [];
  int currentTab = 0;


  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance!.addPostFrameCallback((_) => startLoad());
  }

  // void startLoad(){
  //   setState(() {
  //     print("sratload");
  //     currentChat = this.widget.chatroom;
  //     dummyChat = this.widget.chatroom;
  //
  //     print(currentChat.length);
  //   });
  // }

  void goToDetails(String chatroomId) {
    print("click here");
    this.widget.onDataChange(chatroomId);
    this.widget.chatPageController.nextPage(duration: Duration(milliseconds: 100), curve: Curves.easeIn);
    PageViewDemo.of(context)!.hideWheel();
  }

  void filterSearchChat(String query) {
    print(query);
    print(this.widget.dummychatroom.length);
    List<Chatroom> dummySearchList = [];
    dummySearchList.addAll(this.widget.dummychatroom);
    if(query.isNotEmpty) {
      List<Chatroom> dummyListData = [];
      dummySearchList.forEach((item) {
        if(item.p1_name.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        this.widget.chatroom.clear();
        this.widget.chatroom.addAll(dummyListData);
      });
      // return;
    } else {
      setState(() {
        this.widget.chatroom.clear();
        this.widget.chatroom.addAll(this.widget.dummychatroom);
        // loadMediaDiscoverSearch();
      });
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
                                    padding: const EdgeInsets.only(bottom:15),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(15),
                                        bottomLeft: Radius.circular(15),
                                      ),
                                      border: Border.all(
                                        width: 2,
                                        color: Color(constant.Color.crave_grey),
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    child:Column(
                                      children: [
                                        SafeArea(
                                          bottom:false,
                                          child: Container(
                                              padding: const EdgeInsets.only(
                                                  top: 40.0,bottom:10,left:30),
                                              width:MediaQuery.of(context).size.width,
                                              child:Text("CHAT",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                      color: Color(constant.Color.crave_brown),
                                                      fontSize: 16.0.sp))
                                          ),
                                        ),

                                        Container(
                                          //width:250,
                                          height:35,
                                          margin: const EdgeInsets.only(bottom: 20.0,top:10),
                                          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                          child:TextField(
                                            autofocus: false,
                                            controller: textController,
                                            cursorColor: Colors.black,
                                            keyboardType: TextInputType.text,
                                            textInputAction: TextInputAction.go,
                                            textCapitalization: TextCapitalization.sentences,
                                            onChanged: (value){
                                              filterSearchChat(value);
                                            },
                                            decoration: InputDecoration(
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
                                                    fontSize: 14,
                                                    color:Colors.grey[400]
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                                  borderSide: BorderSide(color:Color(0xFFF2F2F2) ),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                                  borderSide: BorderSide(color:Color(0xFFF2F2F2) ),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(10)),
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
                                        Padding(
                                          padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                                          child:IntrinsicHeight(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                GestureDetector(
                                                  onTap:(){
                                                    // onTabChange(0);
                                                  },
                                                  child:Text("USERS",
                                                      style: TextStyle(
                                                          color: currentTab==0?Colors.black:Color(0xFFDEDDDD),
                                                          fontSize: 8.0.sp)),
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
                                                    //onTabChange(1);
                                                  },
                                                  child:Text("BUSINESSES",
                                                      style: TextStyle(
                                                          color: currentTab==1?Colors.black:Color(0xFFDEDDDD),
                                                          fontSize: 8.0.sp)),
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

                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),


                                  Expanded(
                                    child:MediaQuery.removePadding(
                                      removeTop: true,
                                      context: context,
                                      child:
                                      ListView.builder(
                                        // the number of items in the list
                                          itemCount: this.widget.chatroom.length,
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          // display each item of the product list
                                          itemBuilder: (context, index) {
                                            return
                                              this.widget.chatroom[index].p1_email != this.widget.user_email?
                                              Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap:(){
                                                      goToDetails(this.widget.chatroom[index].chatroom_id);
                                                      // Navigator.push(
                                                      //     context,
                                                      //     MaterialPageRoute(
                                                      //         builder: (context) => ChatDetailPage()));
                                                    },
                                                    child:Container(
                                                      color:Colors.transparent,
                                                      padding: const EdgeInsets.only(left:20,bottom:10,right:20,top:10),
                                                      child:Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              CircleAvatar(
                                                                radius: 22.0,
                                                                backgroundImage:
                                                                NetworkImage(constant.Url.profile_url+this.widget.chatroom[index].p1_profile_img),
                                                                backgroundColor: Colors.transparent,
                                                              ),
                                                              // Image.asset(
                                                              //   'images/user1.png',
                                                              //   height: 6.0.h,
                                                              // ),

                                                              Container(
                                                                width:60.0.w,
                                                                padding:EdgeInsets.only(left:15),
                                                                child:
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(this.widget.chatroom[index].p1_name,
                                                                        style: TextStyle(
                                                                            color: Color(constant.Color.crave_brown),
                                                                            fontWeight: FontWeight.w700,
                                                                            fontSize: 14.0.sp)),
                                                                    SizedBox(height:1.0.h),
                                                                    Text(this.widget.chatroom[index].recent_chat,
                                                                        maxLines: 1,
                                                                        overflow: TextOverflow.ellipsis,
                                                                        style: TextStyle(
                                                                            color: Colors.black,
                                                                            fontSize: 8.0.sp)),

                                                                  ],
                                                                ),

                                                              ),
                                                              Spacer(),
                                                              Text('SEEN',
                                                                  style: TextStyle(
                                                                      color: Colors.grey,
                                                                      fontSize: 8.0.sp)),
                                                            ],

                                                          ),

                                                        ],
                                                      ),
                                                    ),
                                                  ),

                                                  Container(
                                                    padding: const EdgeInsets.only(left:5,right:5,top:0,bottom:5),
                                                    child:Divider(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ):
                                              Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap:(){
                                                      goToDetails(this.widget.chatroom[index].chatroom_id);
                                                      // Navigator.push(
                                                      //     context,
                                                      //     MaterialPageRoute(
                                                      //         builder: (context) => ChatDetailPage()));
                                                    },
                                                    child:Container(
                                                      color:Colors.transparent,
                                                      padding: const EdgeInsets.only(left:20,bottom:10,right:20,top:10),
                                                      child:Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              CircleAvatar(
                                                                radius: 22.0,
                                                                backgroundImage:
                                                                NetworkImage(constant.Url.profile_url+this.widget.chatroom[index].p2_profile_img),
                                                                backgroundColor: Colors.transparent,
                                                              ),
                                                              // Image.asset(
                                                              //   'images/user1.png',
                                                              //   height: 6.0.h,
                                                              // ),

                                                              Container(
                                                                width:60.0.w,
                                                                padding:EdgeInsets.only(left:15),
                                                                child:
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(this.widget.chatroom[index].p2_name,
                                                                        style: TextStyle(
                                                                            color: Color(constant.Color.crave_brown),
                                                                            fontWeight: FontWeight.w700,
                                                                            fontSize: 14.0.sp)),
                                                                    SizedBox(height:1.0.h),
                                                                    Text(this.widget.chatroom[index].recent_chat,
                                                                        maxLines: 1,
                                                                        overflow: TextOverflow.ellipsis,
                                                                        style: TextStyle(
                                                                            color: Colors.black,
                                                                            fontSize: 8.0.sp)),

                                                                  ],
                                                                ),

                                                              ),
                                                              Spacer(),
                                                              Text('SEEN',
                                                                  style: TextStyle(
                                                                      color: Colors.grey,
                                                                      fontSize: 8.0.sp)),
                                                            ],

                                                          ),

                                                        ],
                                                      ),
                                                    ),
                                                  ),

                                                  Container(
                                                    padding: const EdgeInsets.only(left:5,right:5,top:0,bottom:5),
                                                    child:Divider(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              );
                                          }),
                                      // ListView(
                                      //   shrinkWrap: true,
                                      //   //physics: NeverScrollableScrollPhysics(),
                                      //   // crossAxisCount: 2,
                                      //   // // mainAxisSpacing: 10.0,
                                      //   // crossAxisSpacing: 10.0,
                                      //   // childAspectRatio: aspectRatio,
                                      //   children: <Widget>[
                                      //
                                      //     GestureDetector(
                                      //       onTap:(){
                                      //         goToDetails();
                                      //         // Navigator.push(
                                      //         //     context,
                                      //         //     MaterialPageRoute(
                                      //         //         builder: (context) => ChatDetailPage()));
                                      //       },
                                      //       child:Container(
                                      //         //color:Colors.black,
                                      //         padding: const EdgeInsets.only(left:20,bottom:10,right:20,top:10),
                                      //         child:Column(
                                      //           children: [
                                      //             Row(
                                      //               children: [
                                      //                 Image.asset(
                                      //                   'images/user1.png',
                                      //                   height: 6.0.h,
                                      //                 ),
                                      //
                                      //                 Container(
                                      //                   width:60.0.w,
                                      //                   padding:EdgeInsets.only(left:15),
                                      //                   child:
                                      //                   Column(
                                      //                     mainAxisAlignment: MainAxisAlignment.start,
                                      //                     crossAxisAlignment: CrossAxisAlignment.start,
                                      //                     children: [
                                      //                       Text('Kar Heng',
                                      //                           style: TextStyle(
                                      //                               color: Color(constant.Color.crave_brown),
                                      //                               fontWeight: FontWeight.w700,
                                      //                               fontSize: 14.0.sp)),
                                      //                       SizedBox(height:1.0.h),
                                      //                       Text('Lorem ipsum dolor sit amet, consectetur adipiscing . . . ',
                                      //                           maxLines: 1,
                                      //                           overflow: TextOverflow.ellipsis,
                                      //                           style: TextStyle(
                                      //                               color: Colors.black,
                                      //                               fontSize: 8.0.sp)),
                                      //
                                      //                     ],
                                      //                   ),
                                      //
                                      //                 ),
                                      //                 Spacer(),
                                      //                 Text('SEEN',
                                      //                     style: TextStyle(
                                      //                         color: Colors.grey,
                                      //                         fontSize: 8.0.sp)),
                                      //               ],
                                      //
                                      //             ),
                                      //
                                      //           ],
                                      //         ),
                                      //       ),
                                      //     ),
                                      //
                                      //     Container(
                                      //       padding: const EdgeInsets.only(left:5,right:5,top:0,bottom:5),
                                      //       child:Divider(
                                      //         color: Colors.grey,
                                      //       ),
                                      //     ),
                                      //     Container(
                                      //       //color:Colors.black,
                                      //       padding: const EdgeInsets.only(left:20,bottom:10,right:20),
                                      //       child:Column(
                                      //         children: [
                                      //           Row(
                                      //             children: [
                                      //               Image.asset(
                                      //                 'images/user1.png',
                                      //                 height: 6.0.h,
                                      //               ),
                                      //
                                      //               Container(
                                      //                 width:60.0.w,
                                      //                 padding:EdgeInsets.only(left:15),
                                      //                 child:
                                      //                 Column(
                                      //                   mainAxisAlignment: MainAxisAlignment.start,
                                      //                   crossAxisAlignment: CrossAxisAlignment.start,
                                      //                   children: [
                                      //                     Text('Kar Heng',
                                      //                         style: TextStyle(
                                      //                             color: Color(constant.Color.crave_brown),
                                      //                             fontWeight: FontWeight.w700,
                                      //                             fontSize: 12.0.sp)),
                                      //                     SizedBox(height:1.0.h),
                                      //                     Text('Lorem ipsum dolor sit amet, consectetur adipiscing . . . ',
                                      //                         maxLines: 1,
                                      //                         overflow: TextOverflow.ellipsis,
                                      //                         style: TextStyle(
                                      //                             color: Colors.black,
                                      //                             fontSize: 8.0.sp)),
                                      //
                                      //                   ],
                                      //                 ),
                                      //
                                      //               ),
                                      //               Spacer(),
                                      //               Text('DELIVERED',
                                      //                   style: TextStyle(
                                      //                       color: Colors.grey,
                                      //                       fontSize: 8.0.sp)),
                                      //             ],
                                      //
                                      //           ),
                                      //
                                      //         ],
                                      //       ),
                                      //     ),
                                      //     Container(
                                      //       padding: const EdgeInsets.only(left:5,right:5,top:0,bottom:5),
                                      //       child:Divider(
                                      //         color: Colors.grey,
                                      //       ),
                                      //     ),
                                      //     Container(
                                      //       //color:Colors.black,
                                      //       padding: const EdgeInsets.only(left:20,bottom:10,right:20),
                                      //       child:Column(
                                      //         children: [
                                      //           Row(
                                      //             children: [
                                      //               Image.asset(
                                      //                 'images/user1.png',
                                      //                 height: 6.0.h,
                                      //               ),
                                      //
                                      //               Container(
                                      //                 width:60.0.w,
                                      //                 padding:EdgeInsets.only(left:15),
                                      //                 child:
                                      //                 Column(
                                      //                   mainAxisAlignment: MainAxisAlignment.start,
                                      //                   crossAxisAlignment: CrossAxisAlignment.start,
                                      //                   children: [
                                      //                     Text('Kar Heng',
                                      //                         style: TextStyle(
                                      //                             color: Color(constant.Color.crave_brown),
                                      //                             fontWeight: FontWeight.w700,
                                      //                             fontSize: 12.0.sp)),
                                      //                     SizedBox(height:1.0.h),
                                      //                     Text('Lorem ipsum dolor sit amet, consectetur adipiscing . . . ',
                                      //                         maxLines: 1,
                                      //                         overflow: TextOverflow.ellipsis,
                                      //                         style: TextStyle(
                                      //                             color: Colors.black,
                                      //                             fontSize: 8.0.sp)),
                                      //
                                      //                   ],
                                      //                 ),
                                      //
                                      //               ),
                                      //               Spacer(),
                                      //               Text('SEEN',
                                      //                   style: TextStyle(
                                      //                       color: Colors.grey,
                                      //                       fontSize: 8.0.sp)),
                                      //             ],
                                      //
                                      //           ),
                                      //
                                      //         ],
                                      //       ),
                                      //     ),
                                      //     Container(
                                      //       padding: const EdgeInsets.only(left:5,right:5,top:0,bottom:5),
                                      //       child:Divider(
                                      //         color: Colors.grey,
                                      //       ),
                                      //     ),
                                      //     Container(
                                      //       //color:Colors.black,
                                      //       padding: const EdgeInsets.only(left:20,bottom:10,right:20),
                                      //       child:Column(
                                      //         children: [
                                      //           Row(
                                      //             children: [
                                      //               Image.asset(
                                      //                 'images/user1.png',
                                      //                 height: 6.0.h,
                                      //               ),
                                      //
                                      //               Container(
                                      //                 width:60.0.w,
                                      //                 padding:EdgeInsets.only(left:15),
                                      //                 child:
                                      //                 Column(
                                      //                   mainAxisAlignment: MainAxisAlignment.start,
                                      //                   crossAxisAlignment: CrossAxisAlignment.start,
                                      //                   children: [
                                      //                     Text('Kar Heng',
                                      //                         style: TextStyle(
                                      //                             color: Color(constant.Color.crave_brown),
                                      //                             fontWeight: FontWeight.w700,
                                      //                             fontSize: 12.0.sp)),
                                      //                     SizedBox(height:1.0.h),
                                      //                     Text('Lorem ipsum dolor sit amet, consectetur adipiscing . . . ',
                                      //                         maxLines: 1,
                                      //                         overflow: TextOverflow.ellipsis,
                                      //                         style: TextStyle(
                                      //                             color: Colors.black,
                                      //                             fontSize: 8.0.sp)),
                                      //
                                      //                   ],
                                      //                 ),
                                      //
                                      //               ),
                                      //               Spacer(),
                                      //               Text('SEEN',
                                      //                   style: TextStyle(
                                      //                       color: Colors.grey,
                                      //                       fontSize: 8.0.sp)),
                                      //             ],
                                      //
                                      //           ),
                                      //
                                      //         ],
                                      //       ),
                                      //     ),
                                      //     Container(
                                      //       padding: const EdgeInsets.only(left:5,right:5,top:0,bottom:5),
                                      //       child:Divider(
                                      //         color: Colors.grey,
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ),
                                    ),
                                  )


                                ],
                              ),

                              // Builder(builder: (context) {
                              //   return  GestureDetector(
                              //     onTap:(){
                              //       // Scaffold.of(context).openEndDrawer();
                              //       setState(() {
                              //         PageViewDemo.of(context)!.showWheel();
                              //       });
                              //     },
                              //     child:Padding(
                              //       padding: const EdgeInsets.only(top:100),
                              //       child: Align(
                              //         alignment: Alignment.centerRight,
                              //         child:Container(
                              //           // height:MediaQuery.of(context).size.height ,
                              //           width: 5.0.w,
                              //           decoration: BoxDecoration(
                              //             // color:Colors.black,
                              //             image: DecorationImage(
                              //               image: AssetImage("images/sidewheel.png"),
                              //               //fit: BoxFit.cover,
                              //             ),
                              //           ),
                              //         ),
                              //       ),
                              //     ),
                              //   );
                              // }),
                            ],
                          ),

                          // endDrawer:
                          //     MyNavWheel(),
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
                          //       innerCircleColor:Color(0xFF2CBFC6),
                          //       outerCircleColor:Color(0xFF2CBFC6),
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
                          //             Navigator.pushReplacement(
                          //                 context,
                          //                 MaterialPageRoute(
                          //                     builder: (context) => Homepage()));
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
                          //             Navigator.push(
                          //                 context,
                          //                 MaterialPageRoute(
                          //                     builder: (context) => ReelsDetails()));
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
                          //             Navigator.pushReplacement(
                          //                 context,
                          //                 MaterialPageRoute(
                          //                     builder: (context) => ChatPage()));
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


