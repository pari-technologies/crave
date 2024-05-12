// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:a_crave/chatDetailPage.dart';
import 'package:a_crave/reels.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';

import 'package:sizer/sizer.dart';
import 'dart:math' as math;
import 'package:circle_list/circle_list.dart';
import 'camera_screen.dart';
import 'chatPage.dart';
import 'circle_wheel_scroll/circle_wheel_scroll_view.dart';
import 'cravingsPage.dart';
import 'dataClass.dart';
import 'homepage.dart';
import 'notificationsPage.dart';
import 'profileBusiness.dart';
import 'profileUser.dart';
import 'reelsDetails.dart';

import 'constants.dart' as constant;

class FollowersPage extends StatefulWidget {
  const FollowersPage({Key? key}) : super(key: key);

  @override
  FollowersPageState createState() => FollowersPageState();
}

class FollowersPageState extends State<FollowersPage> {

  final textController = TextEditingController();
  int currentTab = 0;

  List<Followers> currentFollowers = [];
  List<Followers> dummyFollowers = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => startLoad());
  }


  void startLoad(){
    loadFollowers();
  }


  Future<http.Response> followUser(String user_following) async {
    var url = Uri.parse(constant.Url.crave_url+'send_follower_user.php');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        "email":prefs.getString('user_email'),
        "follow_email":user_following,
      },
    );

    log(response.body);
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      //return Album.fromJson(json.decode(response.body));
      Map<String, dynamic> user = jsonDecode(response.body);
      log(response.body);
      log(user['result'].toString());
      if(user['result'].toString() == "0"){
      }
      else{
        loadFollowers();
      }

    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      print(response.body);
      print(response.statusCode);
      Navigator.of(context, rootNavigator: true).pop('dialog');
//        List<String> return_res = new List<String>.from(user['response']);
//        log(return_res[0]);
      throw Exception('Failed to send data');
    }
    return response;
  }

  Future<http.Response> loadFollowers() async {
    currentFollowers.clear();
    dummyFollowers.clear();
    var url = Uri.parse(constant.Url.crave_url+'get_followers.php');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        "email":prefs.getString('user_email'),
      },
    );

    log(response.body);
    if (response.statusCode == 200) {
      // print("get response body carlist");
      print(response.body);

      Map<String, dynamic> user = jsonDecode(response.body);

      if(user['followers'] != null){

        List<dynamic> body = user['followers'];

        List<Followers> followers = body
            .map(
              (dynamic item) => Followers.fromJson(item),
        ).toList();

        List<Followers> dummyfollowers = body
            .map(
              (dynamic item) => Followers.fromJson(item),
        ).toList();

        setState(() {
          //isCarAvailable = true;
          // selectedMedia = media[0];
          currentFollowers = followers;
          dummyFollowers = dummyfollowers;

        });

        print(currentFollowers);
      }
      else{
        setState(() {
          // isCarAvailable = false;
          //carList.;
        });

      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
    return response;
  }

  void filterSearchFollowers(String query) {
    print(query);
    print(dummyFollowers.length);
    List<Followers> dummySearchList = [];
    dummySearchList.addAll(dummyFollowers);
    if(query.isNotEmpty) {
      List<Followers> dummyListData = [];
      dummySearchList.forEach((item) {
        if(item.f_display_name.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        currentFollowers.clear();
        currentFollowers.addAll(dummyListData);
      });
      // return;
    } else {
      setState(() {
        currentFollowers.clear();
        currentFollowers.addAll(dummyFollowers);
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
                                      padding: const EdgeInsets.only(
                                          top: 50.0,bottom:10,left:20),
                                      width:MediaQuery.of(context).size.width,
                                      child:Text("FOLLOWERS",
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
                                      onChanged:(value){
                                        filterSearchFollowers(value);
                                      },
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
                                      child:
                                      ListView.builder(
                                        // the number of items in the list
                                          itemCount: currentFollowers.length,
                                          shrinkWrap: true,
                                          // display each item of the product list
                                          itemBuilder: (context, index) {
                                            return
                                              Column(
                                                children: [
                                                  Container(
                                                    //color:Colors.black,
                                                    padding: const EdgeInsets.only(left:20,bottom:10,right:20),
                                                    child:Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            CircleAvatar(
                                                              radius: 28.0,
                                                              backgroundImage:
                                                              NetworkImage(constant.Url.profile_url+currentFollowers[index].f_profile_img),
                                                              backgroundColor: Colors.transparent,
                                                            ),

                                                            Container(
                                                              width:50.0.w,
                                                              padding:EdgeInsets.only(left:10),
                                                              child:
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(currentFollowers[index].f_display_name,
                                                                      style: TextStyle(
                                                                          color: Colors.black,
                                                                          fontWeight: FontWeight.w600,
                                                                          fontSize: 12.0.sp)),
                                                                  SizedBox(height:0.5.h),
                                                                  Text(currentFollowers[index].f_username,
                                                                      maxLines: 1,
                                                                      overflow: TextOverflow.ellipsis,
                                                                      style: TextStyle(
                                                                          color: Colors.black,
                                                                          fontSize: 8.0.sp)),

                                                                ],
                                                              ),

                                                            ),
                                                            Spacer(),

                                                            GestureDetector(
                                                              onTap:(){
                                                                followUser(currentFollowers[index].f_email);
                                                              },
                                                              child: currentFollowers[index].f_is_follow=="0"?
                                                              Text('+ FOLLOW',
                                                                  style: TextStyle(
                                                                      color:Color(constant.Color.crave_orange),
                                                                      fontWeight: FontWeight.w700,
                                                                      fontSize: 10.0.sp)):
                                                              Text('FOLLOWING',
                                                                  style: TextStyle(
                                                                      color:Color(constant.Color.crave_blue),
                                                                      fontWeight: FontWeight.w700,
                                                                      fontSize: 10.0.sp)),
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
                                              );

                                          }),

                                    ),
                                  ),

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


