// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:a_crave/reels.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';

import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;
import 'package:circle_list/circle_list.dart';
import 'camera_screen.dart';
import 'chatPage.dart';
import 'circle_wheel_scroll/circle_wheel_scroll_view.dart';
import 'cravingsPage.dart';
import 'dataClass.dart';
import 'followersPage.dart';
import 'followingPage.dart';
import 'homeBase.dart';
import 'homepage.dart';
import 'notificationsPage.dart';
import 'profileBusiness.dart';
import 'reelsDetails.dart';
import 'stories_for_flutter/lib/stories_for_flutter.dart';
import 'constants.dart' as constant;

class ProfileUser extends StatefulWidget {
  final PageController profilePageController;
  final List<Media> medias;
  final List<UserProfile> user_profile;
  final List<CraveList> crave_list;
  final Function() loadCraveList;
  final String currentUser;
  const ProfileUser({Key? key,required this.profilePageController, required this.medias, required this.user_profile, required this.loadCraveList, required this.crave_list, required this.currentUser}) : super(key: key);

  @override
  ProfileUserState createState() => ProfileUserState();
}

class ProfileUserState extends State<ProfileUser> {
  final textController = TextEditingController();
  bool isMenuOpen = false;
  List<CraveContent> content1 = [];
  List<CraveContent> content2 = [];
  List<UserProfile> returnedProfile = [];
  // List<CraveList> crave_list = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => startLoad());
  }

  Future<void> loadUserProfile() async {

    var url = Uri.parse(constant.Url.crave_url+'get_user_profile.php');
    // returnedEvent.clear();
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        "email":this.widget.currentUser,
      },
    );

    if (response.statusCode == 200) {
      // print("get response body carlist");
      print(response.body);

      Map<String, dynamic> user = jsonDecode(response.body);

      if(user['user_profile'] != null){

        List<dynamic> body = user['user_profile'];

        List<UserProfile> user_profile = body
            .map(
              (dynamic item) => UserProfile.fromJson(item),
        ).toList();

        setState(() {
          //isCarAvailable = true;
          returnedProfile = user_profile;
        });


        //suggestions = location;
        // print("--avaialbel carr---");
        //print(returnedProfile);
        //return returnedProfile;
      }
      else{
        setState(() {
          // isCarAvailable = false;
          //carList.;
        });

        //return [];
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }

  }

  void startLoad(){
    Future.delayed(const Duration(milliseconds: 500), () {

      print("conte--- 1");
      this.widget.loadCraveList();
      print("conte--- 2");
      print(this.widget.crave_list);
      returnedProfile = this.widget.user_profile;

    });

    // print(this.widget.crave_list[0]);
    // Map<String, dynamic> crave_list = jsonDecode(this.widget.crave_list[0].toString());
    //
    // print("conte--- 3");
    // print(crave_list);
    // List<dynamic> body = crave_list['content'];
    // print("conte---");
    // print(body);
    // List<CraveContent> c_content = body
    //     .map(
    //       (dynamic item) => CraveContent.fromJson(item),
    // ).toList();
    //
    // setState(() {
    //   //isCarAvailable = true;
    //   content1 = c_content;
    //   print("conte--- content1");
    //   print(content1);
    // });
  }

  void goToPosts() {
    this.widget.profilePageController.jumpToPage(1);
  }

  void goToCraveLists() {
    this.widget.profilePageController.jumpToPage(2);
  }

  void openMenuOthers(){
    setState(() {
      isMenuOpen = !isMenuOpen;
    });
  }



  @override
  Widget build(BuildContext context) {

    var maxWidth = 500.0;
    var width = MediaQuery.of(context).size.width;
    var columns = (width ~/ maxWidth) + 1;
    var columnWidth = width / columns;
    var aspectRatio = columnWidth / 400;

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
                        home: GestureDetector(
                          onTap:(){
                            if(isMenuOpen){
                              openMenuOthers();
                            }

                          },
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
                                Align(
                                  alignment: Alignment.topCenter,
                                  child:Container(
                                    height:180,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      // color:Colors.black,
                                      image: DecorationImage(
                                        image: AssetImage("images/profile_bg.png"),
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
                                  padding: EdgeInsets.only(top:160),
                                  child: Card(
                                    margin:EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                                    ),
                                    child:Container(
                                      //color:Colors.black,
                                      padding: EdgeInsets.only(bottom:0,top:14.0),
                                      child:
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(width:15),
                                              Text('FOLLOWING',
                                                  style: TextStyle(
                                                      color: Color(constant.Color.crave_blue),
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 10.0.sp)),
                                              Spacer(),
                                              GestureDetector(
                                                onTap:openMenuOthers,
                                                child:Image.asset(
                                                    'images/others_icon.png',
                                                    height: 1.0.h,
                                                    width:5.0.w
                                                ),
                                              ),

                                              SizedBox(width:15),
                                            ],
                                          ),
                                          SizedBox(height:10),
                                          Text(returnedProfile[0].display_name,
                                              style: TextStyle(
                                                  color: Color(constant.Color.crave_brown),
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15.0.sp)),
                                          Padding(
                                            padding: EdgeInsets.only(top:3,bottom:10),
                                            child: Text(returnedProfile[0].username,
                                                style: TextStyle(
                                                    color: Color(constant.Color.crave_brown),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 8.0.sp)),
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

                                                    Navigator.of(context)
                                                        .push(
                                                        MaterialPageRoute(builder: (BuildContext context) => FollowersPage()))
                                                        .whenComplete(() => {loadUserProfile()});
                                                  },
                                                  child: Column(
                                                    children: [
                                                      Text(returnedProfile[0].user_followers,
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w600,
                                                              color:Color(constant.Color.crave_orange),
                                                              fontSize: 16.0.sp)),
                                                      Text('FOLLOWERS',
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 8.0.sp)),
                                                    ],
                                                  ),
                                                ),


                                                Container(
                                                  padding: EdgeInsets.only(left:5,right:5,top:5),
                                                  child:VerticalDivider(color:Colors.grey[500],thickness:1),
                                                ),
                                                GestureDetector(
                                                  onTap:(){
                                                    // Navigator.push(
                                                    //     context,
                                                    //     MaterialPageRoute(
                                                    //         builder: (context) => FollowingPage()));

                                                    Navigator.of(context)
                                                        .push(
                                                        MaterialPageRoute(builder: (BuildContext context) => FollowingPage()))
                                                        .whenComplete(() => {loadUserProfile()});
                                                  },
                                                  child:Column(
                                                    children: [
                                                      Text(returnedProfile[0].user_following,
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w600,
                                                              color:Color(constant.Color.crave_orange),
                                                              fontSize: 16.0.sp)),
                                                      Text('FOLLOWING',
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 8.0.sp)),
                                                    ],
                                                  ),
                                                ),


                                              ],
                                            ),
                                          ),

                                          Stack(
                                            children: [
                                              //Posts
                                              Container(
                                                padding: const EdgeInsets.only(left:15,right:20),
                                                margin:EdgeInsets.only(top:30,right:5),
                                                height:30.0.h,
                                                decoration: BoxDecoration(
                                                  // color:Colors.green,
                                                  image: DecorationImage(
                                                    image: AssetImage("images/own_profile_bg.png"),
                                                    fit: BoxFit.fill,
                                                    // colorFilter:ColorFilter.mode(
                                                    //         Colors.green,
                                                    //         BlendMode.multiply,
                                                    // ),
                                                  ),
                                                ),
                                                child:
                                                Column(
                                                  children: [
                                                    GestureDetector(
                                                      onTap:goToPosts,
                                                      child:Align(
                                                        alignment: Alignment.centerLeft,
                                                        child:
                                                        Padding(
                                                          padding: const EdgeInsets.only(top:15,bottom:15),
                                                          child:Text('Posts',
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight.w600,
                                                                  color: Color(constant.Color.crave_brown),
                                                                  fontSize: 14.0.sp)),
                                                        ),

                                                      ),
                                                    ),

                                                    GestureDetector(
                                                        onTap:goToPosts,
                                                      child:Container(
                                                        height:20.0.h,
                                                        child:
                                                        GridView.builder(
                                                            padding: EdgeInsets.zero,
                                                            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                                              maxCrossAxisExtent: 150,
                                                              childAspectRatio: aspectRatio,
                                                              mainAxisSpacing: 10,
                                                              crossAxisSpacing: 3,),
                                                            itemCount: this.widget.medias.length,
                                                            itemBuilder: (BuildContext ctx, index) {
                                                              return Container(
                                                                margin:const EdgeInsets.only(right:5),
                                                                decoration: BoxDecoration(
                                                                    image: DecorationImage(image: NetworkImage(constant.Url.media_url+this.widget.medias[index].media_name), fit: BoxFit.cover),
                                                                    // color: Color(0xffF2F2F2),
                                                                    // border: Border.all(
                                                                    //   color: Color(0xff2CBFC6),
                                                                    // ),
                                                                    borderRadius: BorderRadius.all(Radius.circular(5))
                                                                ),
                                                                // width: 80.0,
                                                              );
                                                            }),
                                                        // GridView.count(
                                                        //   childAspectRatio: aspectRatio,
                                                        //   padding: EdgeInsets.zero,
                                                        //   crossAxisCount: 3,
                                                        //   mainAxisSpacing: 10,
                                                        //   crossAxisSpacing: 3,
                                                        //   children: <Widget>[
                                                        //     Container(
                                                        //       margin:const EdgeInsets.only(right:5),
                                                        //       decoration: BoxDecoration(
                                                        //           image: DecorationImage(image: AssetImage("images/reelsList1.png"), fit: BoxFit.cover),
                                                        //           // color: Color(0xffF2F2F2),
                                                        //           // border: Border.all(
                                                        //           //   color: Color(0xff2CBFC6),
                                                        //           // ),
                                                        //           borderRadius: BorderRadius.all(Radius.circular(5))
                                                        //       ),
                                                        //       width: 80.0,
                                                        //     ),
                                                        //     Container(
                                                        //       margin:const EdgeInsets.only(right:5),
                                                        //       decoration: BoxDecoration(
                                                        //           image: DecorationImage(image: AssetImage("images/reelsList2.png"), fit: BoxFit.cover),
                                                        //           // color: Color(0xffF2F2F2),
                                                        //           // border: Border.all(
                                                        //           //   color: Color(0xff2CBFC6),
                                                        //           // ),
                                                        //           borderRadius: BorderRadius.all(Radius.circular(5))
                                                        //       ),
                                                        //       width: 80.0,
                                                        //     ),
                                                        //     Container(
                                                        //       margin:const EdgeInsets.only(right:5),
                                                        //       decoration: BoxDecoration(
                                                        //           image: DecorationImage(image: AssetImage("images/reelsList3.png"), fit: BoxFit.cover),
                                                        //           // color: Color(0xffF2F2F2),
                                                        //           // border: Border.all(
                                                        //           //   color: Color(0xff2CBFC6),
                                                        //           // ),
                                                        //           borderRadius: BorderRadius.all(Radius.circular(5))
                                                        //       ),
                                                        //       width: 80.0,
                                                        //     ),
                                                        //     Container(
                                                        //       margin:const EdgeInsets.only(right:5),
                                                        //       decoration: BoxDecoration(
                                                        //           image: DecorationImage(image: AssetImage("images/reelsList4.png"), fit: BoxFit.cover),
                                                        //           // color: Color(0xffF2F2F2),
                                                        //           // border: Border.all(
                                                        //           //   color: Color(0xff2CBFC6),
                                                        //           // ),
                                                        //           borderRadius: BorderRadius.all(Radius.circular(5))
                                                        //       ),
                                                        //       width: 80.0,
                                                        //     ),
                                                        //     Container(
                                                        //       margin:const EdgeInsets.only(right:5),
                                                        //       decoration: BoxDecoration(
                                                        //           image: DecorationImage(image: AssetImage("images/reelsList3.png"), fit: BoxFit.cover),
                                                        //           // color: Color(0xffF2F2F2),
                                                        //           // border: Border.all(
                                                        //           //   color: Color(0xff2CBFC6),
                                                        //           // ),
                                                        //           borderRadius: BorderRadius.all(Radius.circular(5))
                                                        //       ),
                                                        //       width: 80.0,
                                                        //     ),
                                                        //     Container(
                                                        //       margin:const EdgeInsets.only(right:5),
                                                        //       decoration: BoxDecoration(
                                                        //           image: DecorationImage(image: AssetImage("images/reelsList4.png"), fit: BoxFit.cover),
                                                        //           // color: Color(0xffF2F2F2),
                                                        //           // border: Border.all(
                                                        //           //   color: Color(0xff2CBFC6),
                                                        //           // ),
                                                        //           borderRadius: BorderRadius.all(Radius.circular(5))
                                                        //       ),
                                                        //       width: 80.0,
                                                        //     ),
                                                        //   ],
                                                        // ),
                                                      )
                                                    ),


                                                  ],
                                                ),


                                              ),
                                              //crave list
                                              Container(
                                                padding: const EdgeInsets.only(left:15,right:15),
                                                margin:EdgeInsets.only(top:31.0.h,left:10),
                                                height:30.0.h,
                                                decoration: BoxDecoration(
                                                  // color:Colors.yellow,
                                                  image: DecorationImage(
                                                    image: AssetImage("images/own_profile_bg2.png"),
                                                    fit: BoxFit.fill,
                                                    // colorFilter:ColorFilter.mode(
                                                    //         Colors.green,
                                                    //         BlendMode.multiply,
                                                    // ),
                                                  ),
                                                ),
                                                child:
                                                Column(
                                                  children: [
                                                    Align(
                                                      alignment: Alignment.centerLeft,
                                                      child:
                                                      GestureDetector(
                                                        onTap:goToCraveLists,
                                                        child:Padding(
                                                          padding: EdgeInsets.only(top:4.0.h,bottom:15),
                                                          child:Text('Craves Lists',
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight.w600,
                                                                  color: Color(constant.Color.crave_brown),
                                                                  fontSize: 14.0.sp)),
                                                        ),
                                                      ),

                                                    ),
                                                    this.widget.crave_list.length!=0?
                                                    Padding(
                                                      padding: EdgeInsets.only(left:20,right:20),
                                                      child:Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Container(
                                                            width: 35.0.w,
                                                            child:Stack(
                                                              children: [
                                                                Container(
                                                                  decoration: BoxDecoration(
                                                                      border: Border.all(
                                                                        color: Colors.grey.shade400,
                                                                      ),
                                                                      borderRadius: BorderRadius.all(Radius.circular(10))
                                                                  ),
                                                                  child: Container(
                                                                    padding: const EdgeInsets.only(left:10,right:10,top:12,bottom:15),
                                                                    child:Column(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Container(
                                                                          height:11.0.h,
                                                                          width: 30.0.w,
                                                                          margin:EdgeInsets.only(right:0),
                                                                          decoration: BoxDecoration(
                                                                              image: this.widget.crave_list[0].list_img!=""?
                                                                                DecorationImage(
                                                                                  image: NetworkImage(constant.Url.media_url+this.widget.crave_list[0].list_img),
                                                                                  fit: BoxFit.cover):
                                                                                DecorationImage(
                                                                                  image:AssetImage("images/crave_logo.jpg"),
                                                                                  fit: BoxFit.fill),
                                                                              // color: Color(0xffF2F2F2),
                                                                              // border: Border.all(
                                                                              //   color: Color(0xff2CBFC6),
                                                                              // ),
                                                                              borderRadius: BorderRadius.all(Radius.circular(5))
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(top:5),
                                                                          child:Text(this.widget.crave_list[0].list_name.replaceAll('', '\u200B'),
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w600,
                                                                                  color: Color(constant.Color.crave_brown),
                                                                                  fontSize: 12.0.sp)),
                                                                        ),

                                                                        Padding(
                                                                          padding: const EdgeInsets.only(top:2),
                                                                          child:Text(this.widget.crave_list[0].crave_amount+' Craves',
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  color: Color(constant.Color.crave_brown),
                                                                                  fontSize: 10.0.sp)),
                                                                        ),

                                                                      ],
                                                                    ),
                                                                  ),

                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets.only(top:1,right:1),
                                                                  child:Align(
                                                                      alignment: Alignment.topRight,
                                                                      child:Container(
                                                                        decoration: BoxDecoration(
                                                                            color:Color(constant.Color.crave_blue),
                                                                            border: Border.all(
                                                                              color: Color(constant.Color.crave_blue),
                                                                            ),
                                                                            borderRadius: BorderRadius.circular(10) // use instead of BorderRadius.all(Radius.circular(20))
                                                                        ),
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.only(top:5,left:5,right:5,bottom:5),
                                                                          child:Text('SAVED',
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w600,
                                                                                  color: Colors.white,
                                                                                  fontSize: 10.0.sp)),
                                                                        ),
                                                                      )

                                                                  ),
                                                                ),

                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(width:15),
                                                          this.widget.crave_list.length>1?
                                                          Container(
                                                            width: 35.0.w,
                                                            child:Stack(
                                                              children: [
                                                                Container(
                                                                  decoration: BoxDecoration(
                                                                      border: Border.all(
                                                                        color: Colors.grey.shade400,
                                                                      ),
                                                                      borderRadius: BorderRadius.all(Radius.circular(10))
                                                                  ),
                                                                  child: Container(
                                                                    padding: const EdgeInsets.only(left:10,right:10,top:12,bottom:15),
                                                                    child:Column(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Container(
                                                                          height:11.0.h,
                                                                          width: 30.0.w,
                                                                          margin:const EdgeInsets.only(right:0),
                                                                          decoration: BoxDecoration(
                                                                              image:this.widget.crave_list[1].list_img!=""?
                                                                              DecorationImage(
                                                                                  image: NetworkImage(constant.Url.media_url+this.widget.crave_list[1].list_img),
                                                                                  fit: BoxFit.cover):
                                                                              DecorationImage(
                                                                                  image:AssetImage("images/crave_logo.jpg"),
                                                                                  fit: BoxFit.fill),
                                                                              // color: Color(0xffF2F2F2),
                                                                              // border: Border.all(
                                                                              //   color: Color(0xff2CBFC6),
                                                                              // ),
                                                                              borderRadius: BorderRadius.all(Radius.circular(5))
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(top:5),
                                                                          child:Text(this.widget.crave_list[1].list_name.replaceAll('', '\u200B'),
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w600,
                                                                                  color: Color(constant.Color.crave_brown),
                                                                                  fontSize: 12.0.sp)),
                                                                        ),

                                                                        Padding(
                                                                          padding: const EdgeInsets.only(top:2),
                                                                          child:Text(this.widget.crave_list[1].crave_amount+' Craves',
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  color: Color(constant.Color.crave_brown),
                                                                                  fontSize: 10.0.sp)),
                                                                        ),

                                                                      ],
                                                                    ),
                                                                  ),

                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets.only(top:1,right:1),
                                                                  child:Align(
                                                                      alignment: Alignment.topRight,
                                                                      child:Container(
                                                                        decoration: BoxDecoration(
                                                                            color:Color(0xffF2EFED),
                                                                            border: Border.all(
                                                                              color: Color(0xffF2EFED),
                                                                            ),
                                                                            borderRadius: BorderRadius.circular(10) // use instead of BorderRadius.all(Radius.circular(20))
                                                                        ),
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.only(top:5,left:5,right:5,bottom:5),
                                                                          child:Text('SAVE',
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w600,
                                                                                  color: Color(constant.Color.crave_brown),
                                                                                  fontSize: 10.0.sp)),
                                                                        ),
                                                                      )

                                                                  ),
                                                                ),

                                                              ],
                                                            ),
                                                          ):
                                                          Container(height:0,width:0),
                                                        ],
                                                      ),
                                                    ):
                                                    Container(height:0,width:0),
                                                  ],
                                                ),

                                              ),
                                            ],
                                          ),

                                          //SizedBox(height:100),
                                        ],
                                      ),

                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top:60),
                                  child:Align(
                                    alignment: Alignment.topCenter,
                                    child:
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 65.0,
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(constant.Url.profile_url+returnedProfile[0].profile_img),
                                        radius: 60.0,
                                      ),
                                    ),
                                    // Image.asset(
                                    //   'images/user1.png',
                                    //   height: 15.0.h,
                                    // ),
                                  ),

                                ),
                                isMenuOpen?
                                Align(
                                  alignment: Alignment.topRight,
                                  child:Container(
                                      margin: EdgeInsets.only(top:160),
                                      // color:Colors.blue,
                                      height:120,
                                      width:270,
                                    child:Card(
                                      margin:EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                            bottomLeft:Radius.circular(20),
                                            bottomRight:Radius.circular(20),),
                                      ),
                                      child:Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding :EdgeInsets.only(top:25,left:20),
                                            child:Text('Blocked list',
                                                style: TextStyle(
                                                    color: Color(constant.Color.crave_brown),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12.0.sp)),
                                          ),
                                          SizedBox(height:25),
                                          Padding(
                                            padding :EdgeInsets.only(left:20),
                                            child:Text('Archived pictures',
                                                style: TextStyle(
                                                    color: Color(constant.Color.crave_brown),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12.0.sp)),
                                          ),

                                        ],
                                      ),
                                    )
                                  )
                                ):
                                Container(height:0,width:0),

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


