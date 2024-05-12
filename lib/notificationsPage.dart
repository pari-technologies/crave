// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:a_crave/reels.dart';
import 'package:a_crave/reelsDetails.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';

import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;
import 'package:circle_list/circle_list.dart';
import 'camera_screen.dart';
import 'chatPage.dart';
import 'circle_wheel_scroll/circle_wheel_scroll_view.dart';
import 'cravingsPage.dart';
import 'dataClass.dart';
import 'homeBase.dart';
import 'homepage.dart';
import 'profileBusiness.dart';
import 'profileUser.dart';

import 'constants.dart' as constant;

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  NotificationsPageState createState() => NotificationsPageState();
}

class NotificationsPageState extends State<NotificationsPage> {

  List<Notifications> returnedNoti = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => loadNotification());
  }

  Future<void> loadNotification() async {
    print("load storiess");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var url = Uri.parse(constant.Url.crave_url+'get_notification.php');
    returnedNoti.clear();
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        "email":prefs.getString('user_email'),
      },
    );

    if (response.statusCode == 200) {
      // print("get response body carlist");
      print(response.body);

      Map<String, dynamic> user = jsonDecode(response.body);
      if(user['notification'] != null){

        List<dynamic> body = user['notification'];

        List<Notifications> notis = body
            .map(
              (dynamic item) => Notifications.fromJson(item),
        ).toList();

        setState(() {
          returnedNoti = notis;
        });
      }



      // }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }

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
                                            child:Text("NOTIFICATIONS",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    color: Color(constant.Color.crave_brown),
                                                    fontSize: 14.0.sp))
                                        ),
                                      ),
                                      Container(
                                        child:MediaQuery.removePadding(
                                          removeTop: true,
                                          context: context,
                                          child:
                                          ListView.builder(
                                            // the number of items in the list
                                              itemCount: returnedNoti.length,
                                              shrinkWrap: true,
                                              physics: NeverScrollableScrollPhysics(),
                                              // display each item of the product list
                                              itemBuilder: (context, index) {
                                                return
                                                  Column(
                                                    children: [
                                                      Container(
                                                        //color:Colors.black,
                                                        padding: const EdgeInsets.only(left:20,bottom:20,right:15),
                                                        child:Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Image.network(
                                                                  constant.Url.profile_url+returnedNoti[index].n_profile_img,
                                                                  height: 4.0.h,
                                                                  width:6.0.w,
                                                                  fit: BoxFit.fitWidth,
                                                                ),
                                                                Container(
                                                                  width:60.0.w,
                                                                  padding:EdgeInsets.only(left:10),
                                                                  child:RichText(
                                                                    text: TextSpan(
                                                                      // Note: Styles for TextSpans must be explicitly defined.
                                                                      // Child text spans will inherit styles from parent
                                                                      style: TextStyle(
                                                                        fontSize: 10.0.sp,
                                                                        color: Colors.black,
                                                                        fontFamily: 'Montserrat',
                                                                      ),
                                                                      children: <TextSpan>[
                                                                        TextSpan(text: returnedNoti[index].n_display_name,style: const TextStyle(fontWeight: FontWeight.bold)),
                                                                        TextSpan(text: ' commented on your post. ', ),
                                                                        // TextSpan(text: ' 3w', style:const TextStyle(color: Colors.grey)),
                                                                      ],
                                                                    ),
                                                                  ),

                                                                  // Text('Lorem ipsum dolor sit amet, consectetur adipiscing . . . ',
                                                                  //     style: TextStyle(
                                                                  //         color: Colors.black,
                                                                  //         fontSize: 10.0.sp)),
                                                                ),
                                                                Spacer(),
                                                                Container(
                                                                  height:5.0.h,
                                                                  width:13.0.w,
                                                                  margin: const EdgeInsets.only(bottom:0,top:0,right:5),
                                                                  decoration: BoxDecoration(
                                                                      image: DecorationImage(image: AssetImage("images/food2.png"), fit: BoxFit.cover),
                                                                      borderRadius: BorderRadius.all(Radius.circular(10))
                                                                  ),
                                                                ),


                                                              ],

                                                            ),

                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                              }),

                                        ),
                                      ),

                                      // Expanded(
                                      //   child:MediaQuery.removePadding(
                                      //     removeTop: true,
                                      //     context: context,
                                      //     child:ListView(
                                      //       shrinkWrap: true,
                                      //       //physics: NeverScrollableScrollPhysics(),
                                      //       // crossAxisCount: 2,
                                      //       // // mainAxisSpacing: 10.0,
                                      //       // crossAxisSpacing: 10.0,
                                      //       // childAspectRatio: aspectRatio,
                                      //       children: <Widget>[
                                      //         //comment for a while to do later
                                      //
                                      //         Container(
                                      //           padding:EdgeInsets.only(left:20,bottom:10,top:15),
                                      //           child:Text('This Week',
                                      //               style: TextStyle(
                                      //                   fontWeight: FontWeight.w700,
                                      //                   color: Colors.grey,
                                      //                   fontSize: 11.0.sp)),
                                      //         ),
                                      //         Card(
                                      //           margin:EdgeInsets.zero,
                                      //           shape: RoundedRectangleBorder(
                                      //             borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                      //           ),
                                      //           child: Container(
                                      //             //color:Colors.black,
                                      //             margin: const EdgeInsets.only(left:20,bottom:10,right:15),
                                      //             child:Column(
                                      //               children: [
                                      //                 Row(
                                      //                   mainAxisAlignment: MainAxisAlignment.center,
                                      //                   children: [
                                      //                     Image.asset(
                                      //                       'images/user1.png',
                                      //                       height: 6.0.h,
                                      //                     ),
                                      //                     Container(
                                      //                       width:50.0.w,
                                      //                       padding:EdgeInsets.only(left:10),
                                      //                       child:RichText(
                                      //                         text: TextSpan(
                                      //                           // Note: Styles for TextSpans must be explicitly defined.
                                      //                           // Child text spans will inherit styles from parent
                                      //                           style: TextStyle(
                                      //                             fontSize: 10.0.sp,
                                      //                             color: Colors.black,
                                      //                             fontFamily: 'Montserrat',
                                      //                           ),
                                      //                           children: <TextSpan>[
                                      //                             TextSpan(text: 'KARHENGDESU',style: const TextStyle(fontWeight: FontWeight.bold)),
                                      //                             TextSpan(text: ' started following you. ', ),
                                      //                             TextSpan(text: ' 3d', style:const TextStyle(color: Colors.grey)),
                                      //                           ],
                                      //                         ),
                                      //                       ),
                                      //
                                      //                       // Text('Lorem ipsum dolor sit amet, consectetur adipiscing . . . ',
                                      //                       //     style: TextStyle(
                                      //                       //         color: Colors.black,
                                      //                       //         fontSize: 10.0.sp)),
                                      //                     ),
                                      //                     Spacer(),
                                      //                     Container(
                                      //                       //height:5.0.h,
                                      //                       //width:10.0.w,
                                      //                       margin: const EdgeInsets.only(bottom:0,top:0,right:5),
                                      //                       child:Text('FOLLOWING',
                                      //                           style: TextStyle(
                                      //                               fontWeight: FontWeight.w700,
                                      //                               color:Color(constant.Color.crave_blue),
                                      //                               fontSize: 10.0.sp)),
                                      //                     ),
                                      //
                                      //
                                      //                   ],
                                      //
                                      //                 ),
                                      //               ],
                                      //             ),
                                      //
                                      //           ),
                                      //         ),
                                      //
                                      //
                                      //         Container(
                                      //           padding:EdgeInsets.only(left:20,bottom:10,top:15),
                                      //           child:Text('This Month',
                                      //               style: TextStyle(
                                      //                   fontWeight: FontWeight.w700,
                                      //                   color: Colors.grey,
                                      //                   fontSize: 11.0.sp)),
                                      //         ),
                                      //         Container(
                                      //           //color:Colors.black,
                                      //           padding: const EdgeInsets.only(left:20,bottom:20,right:15),
                                      //           child:Column(
                                      //             children: [
                                      //               Row(
                                      //                 mainAxisAlignment: MainAxisAlignment.center,
                                      //                 children: [
                                      //                   Image.asset(
                                      //                     'images/user1.png',
                                      //                     height: 6.0.h,
                                      //                   ),
                                      //                   Container(
                                      //                     width:55.0.w,
                                      //                     padding:EdgeInsets.only(left:10),
                                      //                     child:RichText(
                                      //                       text: TextSpan(
                                      //                         // Note: Styles for TextSpans must be explicitly defined.
                                      //                         // Child text spans will inherit styles from parent
                                      //                         style: TextStyle(
                                      //                           fontSize: 10.0.sp,
                                      //                           color: Colors.black,
                                      //                           fontFamily: 'Montserrat',
                                      //                         ),
                                      //                         children: <TextSpan>[
                                      //                           TextSpan(text: 'trixieematel',style: const TextStyle(fontWeight: FontWeight.bold)),
                                      //                           TextSpan(text: ' started following you. ', ),
                                      //                           TextSpan(text: ' 1w', style:const TextStyle(color: Colors.grey)),
                                      //                         ],
                                      //                       ),
                                      //                     ),
                                      //
                                      //                     // Text('Lorem ipsum dolor sit amet, consectetur adipiscing . . . ',
                                      //                     //     style: TextStyle(
                                      //                     //         color: Colors.black,
                                      //                     //         fontSize: 10.0.sp)),
                                      //                   ),
                                      //                   Spacer(),
                                      //                   Container(
                                      //                     //height:5.0.h,
                                      //                     //width:10.0.w,
                                      //                     margin: const EdgeInsets.only(bottom:0,top:0,right:5),
                                      //                     child:Text('+ FOLLOW',
                                      //                         style: TextStyle(
                                      //                             color:Color(constant.Color.crave_orange),
                                      //                             fontWeight: FontWeight.w700,
                                      //                             fontSize: 10.0.sp)),
                                      //                   ),
                                      //                 ],
                                      //               ),
                                      //             ],
                                      //           ),
                                      //         ),
                                      //
                                      //         Container(
                                      //           //color:Colors.black,
                                      //           padding: const EdgeInsets.only(left:20,bottom:20,right:15),
                                      //           child:Column(
                                      //             children: [
                                      //               Row(
                                      //                 children: [
                                      //                   Container(
                                      //                     height:50,
                                      //                     width:13.0.w,
                                      //                     child: Stack(
                                      //                       children: [
                                      //                         Positioned(
                                      //                           child:Image.asset(
                                      //                             'images/user1.png',
                                      //                             height: 4.0.h,
                                      //                           ),
                                      //                         ),
                                      //                         Positioned(
                                      //                           right: 1.0,
                                      //                           top:15.0,
                                      //                           child:Image.asset(
                                      //                             'images/user1.png',
                                      //                             height: 4.0.h,
                                      //                           ),
                                      //                         ),
                                      //                       ],
                                      //                     ),
                                      //                   ),
                                      //
                                      //                   // Image.asset(
                                      //                   //   'images/user1.png',
                                      //                   //   height: 6.0.h,
                                      //                   // ),
                                      //                   Container(
                                      //                     width:55.0.w,
                                      //                     padding:EdgeInsets.only(left:10),
                                      //                     child:RichText(
                                      //                       text: TextSpan(
                                      //                         // Note: Styles for TextSpans must be explicitly defined.
                                      //                         // Child text spans will inherit styles from parent
                                      //                         style: TextStyle(
                                      //                           fontSize: 10.0.sp,
                                      //                           color: Colors.black,
                                      //                           fontFamily: 'Montserrat',
                                      //                         ),
                                      //                         children: <TextSpan>[
                                      //                           TextSpan(text: 'bobreuse, georgetteui ',style: const TextStyle(fontWeight: FontWeight.bold)),
                                      //                           TextSpan(text: ' and ',),
                                      //                           TextSpan(text: '32 others',style: const TextStyle(fontWeight: FontWeight.bold)),
                                      //                           TextSpan(text: ' liked your post. ', ),
                                      //                           TextSpan(text: ' 2w', style:const TextStyle(color: Colors.grey)),
                                      //                         ],
                                      //                       ),
                                      //                     ),
                                      //
                                      //                     // Text('Lorem ipsum dolor sit amet, consectetur adipiscing . . . ',
                                      //                     //     style: TextStyle(
                                      //                     //         color: Colors.black,
                                      //                     //         fontSize: 10.0.sp)),
                                      //                   ),
                                      //                   Spacer(),
                                      //                   Container(
                                      //                     height:5.0.h,
                                      //                     width:13.0.w,
                                      //                     margin: const EdgeInsets.only(bottom:0,top:0,right:5),
                                      //                     decoration: BoxDecoration(
                                      //                         image: DecorationImage(image: AssetImage("images/food1.png"), fit: BoxFit.cover),
                                      //                         borderRadius: BorderRadius.all(Radius.circular(10))
                                      //                     ),
                                      //                   ),
                                      //
                                      //
                                      //                 ],
                                      //
                                      //               ),
                                      //
                                      //             ],
                                      //           ),
                                      //         ),
                                      //
                                      //         Container(
                                      //           //color:Colors.black,
                                      //           padding: const EdgeInsets.only(left:20,bottom:20,right:15),
                                      //           child:Column(
                                      //             children: [
                                      //               Row(
                                      //                 mainAxisAlignment: MainAxisAlignment.center,
                                      //                 children: [
                                      //                   Image.asset(
                                      //                     'images/user1.png',
                                      //                     height: 6.0.h,
                                      //                   ),
                                      //                   Container(
                                      //                     width:60.0.w,
                                      //                     padding:EdgeInsets.only(left:10),
                                      //                     child:RichText(
                                      //                       text: TextSpan(
                                      //                         // Note: Styles for TextSpans must be explicitly defined.
                                      //                         // Child text spans will inherit styles from parent
                                      //                         style: TextStyle(
                                      //                           fontSize: 10.0.sp,
                                      //                           color: Colors.black,
                                      //                           fontFamily: 'Montserrat',
                                      //                         ),
                                      //                         children: <TextSpan>[
                                      //                           TextSpan(text: 'KARHENGDESU',style: const TextStyle(fontWeight: FontWeight.bold)),
                                      //                           TextSpan(text: ' tagged you in a post. ', ),
                                      //                           TextSpan(text: ' 3w', style:const TextStyle(color: Colors.grey)),
                                      //                         ],
                                      //                       ),
                                      //                     ),
                                      //
                                      //                     // Text('Lorem ipsum dolor sit amet, consectetur adipiscing . . . ',
                                      //                     //     style: TextStyle(
                                      //                     //         color: Colors.black,
                                      //                     //         fontSize: 10.0.sp)),
                                      //                   ),
                                      //                   Spacer(),
                                      //                   Container(
                                      //                     height:5.0.h,
                                      //                     width:13.0.w,
                                      //                     margin: const EdgeInsets.only(bottom:0,top:0,right:5),
                                      //                     decoration: BoxDecoration(
                                      //                         image: DecorationImage(image: AssetImage("images/food2.png"), fit: BoxFit.cover),
                                      //                         borderRadius: BorderRadius.all(Radius.circular(10))
                                      //                     ),
                                      //                   ),
                                      //
                                      //
                                      //                 ],
                                      //
                                      //               ),
                                      //
                                      //             ],
                                      //           ),
                                      //         ),
                                      //
                                      //         Container(
                                      //           //color:Colors.black,
                                      //           padding: const EdgeInsets.only(left:20,bottom:10,right:15),
                                      //           child:Column(
                                      //             children: [
                                      //               Row(
                                      //                 mainAxisAlignment: MainAxisAlignment.center,
                                      //                 children: [
                                      //                   Image.asset(
                                      //                     'images/user1.png',
                                      //                     height: 6.0.h,
                                      //                   ),
                                      //                   Container(
                                      //                     width:60.0.w,
                                      //                     padding:EdgeInsets.only(left:10),
                                      //                     child:RichText(
                                      //                       text: TextSpan(
                                      //                         // Note: Styles for TextSpans must be explicitly defined.
                                      //                         // Child text spans will inherit styles from parent
                                      //                         style: TextStyle(
                                      //                           fontSize: 10.0.sp,
                                      //                           color: Colors.black,
                                      //                           fontFamily: 'Montserrat',
                                      //                         ),
                                      //                         children: <TextSpan>[
                                      //                           TextSpan(text: 'violetchachkiie',style: const TextStyle(fontWeight: FontWeight.bold)),
                                      //                           TextSpan(text: ' mentioned you in a comment: ', ),
                                      //                           TextSpan(text: ' @itsmedesu ',style:const TextStyle(color:Color(constant.Color.crave_blue))),
                                      //                           TextSpan(text: ' okayyy cause really they do... ', ),
                                      //                           TextSpan(text: ' 3w', style:const TextStyle(color: Colors.grey)),
                                      //                         ],
                                      //                       ),
                                      //                     ),
                                      //
                                      //                     // Text('Lorem ipsum dolor sit amet, consectetur adipiscing . . . ',
                                      //                     //     style: TextStyle(
                                      //                     //         color: Colors.black,
                                      //                     //         fontSize: 10.0.sp)),
                                      //                   ),
                                      //                   Spacer(),
                                      //                   Container(
                                      //                     height:5.0.h,
                                      //                     width:13.0.w,
                                      //                     margin: const EdgeInsets.only(bottom:0,top:0,right:5),
                                      //                     decoration: BoxDecoration(
                                      //                         image: DecorationImage(image: AssetImage("images/food3.png"), fit: BoxFit.cover),
                                      //                         borderRadius: BorderRadius.all(Radius.circular(10))
                                      //                     ),
                                      //                   ),
                                      //
                                      //
                                      //                 ],
                                      //
                                      //               ),
                                      //
                                      //             ],
                                      //           ),
                                      //         ),
                                      //       ],
                                      //     ),
                                      //   ),
                                      // )


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


