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
import 'followersPage.dart';
import 'followingPage.dart';
import 'homeBase.dart';
import 'homepage.dart';
import 'notificationsPage.dart';
import 'profileBusiness.dart';
import 'reelsDetails.dart';
import 'stories_for_flutter/lib/stories_for_flutter.dart';
import 'constants.dart' as constant;

class ProfileUserCraveList extends StatefulWidget {
  final PageController profilePageController;
  final List<CraveList> crave_list;
  final List<UserProfile> user_profile;
  final Function(int) onDataChange;
  final Function() loadCraveList;
  const ProfileUserCraveList({Key? key,required this.profilePageController,required this.crave_list,required this.user_profile,required this.onDataChange,required this.loadCraveList}) : super(key: key);

  @override
  ProfileUserCraveListState createState() => ProfileUserCraveListState();
}

class ProfileUserCraveListState extends State<ProfileUserCraveList> {
  final textController = TextEditingController();
  final addCraveListCtrl = TextEditingController();
  bool isGridView = true;
  bool isMenuOpen = false;

  @override
  void initState() {
    super.initState();
    //WidgetsBinding.instance!.addPostFrameCallback((_) => startLoad());
  }

  void goToManageCraveLists(int index) {
    this.widget.onDataChange(index);
    this.widget.profilePageController.jumpToPage(3);
  }

  void goToPosts() {
    this.widget.profilePageController.jumpToPage(1);
  }

  void openMenuOthers(){
    setState(() {
      isMenuOpen = !isMenuOpen;
    });
  }

  void onShowAddCraveList(){
    showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (context) {
          return  StatefulBuilder(builder: (BuildContext context, StateSetter mystate) {
            return
              Container(
                //height:MediaQuery.of(context).size.height,
                // padding:
                padding: MediaQuery.of(context).viewInsets,
                //height:30.0.h,
                child:
                Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(bottom:15,top:30),
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
                                child:
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(left: 20.0,top:50),
                                      child: GestureDetector(
                                          onTap:(){
                                            Navigator.pop(context);
                                          },
                                          child:
                                          Icon(Icons.arrow_back_ios,size: 20,color:Colors.grey)
                                      ),
                                    ),
                                    Container(
                                        padding: const EdgeInsets.only(
                                            top: 50.0,bottom:0,left:10),
                                        //width:MediaQuery.of(context).size.width,
                                        child:Text("Add a List",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: Color(constant.Color.crave_brown),
                                                fontSize: 16.0.sp))
                                    ),


                                  ],
                                ),

                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                    //location name
                    SizedBox(height:2.0.h),
                    Row(
                      children: [
                        Container(
                          width:90.0.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                                child: Text("List Name",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Color(constant.Color.crave_brown),
                                        fontSize: 12.0.sp)),
                              ),

                              Container(
                                //width:250,
                                height:45,
                                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                                child:TextField(
                                  autofocus: false,
                                  controller: addCraveListCtrl,
                                  cursorColor: Colors.black,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.go,
                                  textCapitalization: TextCapitalization.sentences,
                                  decoration: const InputDecoration(
                                      counterText: '',
                                      filled: false,
                                      // Color(0xFFD6D6D6)
                                      fillColor: Color(0xFFF2F2F2),
                                      contentPadding:EdgeInsets.symmetric(horizontal: 0,vertical:10),
                                      labelStyle: TextStyle(
                                          fontSize: 14,
                                          color:Colors.black
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color:Colors.transparent ),
                                      ),
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(color:Colors.transparent ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color:Colors.transparent, ),
                                      ),
                                      hintStyle: TextStyle(
                                        fontSize: 17,
                                      ),
                                      hintText: "List name"),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          width:10,
                          height:10,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(constant.Color.crave_orange)),)
                      ],
                    ),

                    SizedBox(height:5.0.h),
                    SizedBox(
                        width:60.w,
                        height:6.h,
                        child: ElevatedButton(
                            child: Text(
                                "Confirm".toUpperCase(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16.0.sp)
                            ),
                            style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                backgroundColor: MaterialStateProperty.all<Color>(const Color(constant.Color.crave_orange)),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                        side: const BorderSide(color: Color(constant.Color.crave_orange))
                                    )
                                )
                            ),
                            onPressed: () =>  createList(0)
                        )
                    ),

                  ],
                ),


              );


          });
        });
  }

  Future<http.Response> createList(int index) async {
    var url = Uri.parse(constant.Url.crave_url+'send_crave_list.php');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        "email":prefs.getString('user_email'),
        "list_name":addCraveListCtrl.text,
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
        this.widget.loadCraveList();
        Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {

    var maxWidth = 500.0;
    var width = MediaQuery.of(context).size.width;
    var columns = (width ~/ maxWidth) + 1;
    var columnWidth = width / columns;
    var aspectRatio = columnWidth / 565;

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
                              else{
                                widget.profilePageController.animateToPage(0,duration: Duration(milliseconds: 100), curve: Curves.easeIn);
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
                                    height:190,
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
                                      height: MediaQuery.of(context).size.height,
                                      padding: EdgeInsets.only(bottom:0,top:15.0),
                                      child:SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Stack(
                                              children: [
                                                //Posts
                                                Container(
                                                  padding: const EdgeInsets.only(left:15,right:15,top:20),
                                                  margin:EdgeInsets.only(left:10,top:20),
                                                  height:MediaQuery.of(context).size.height -200,
                                                  decoration: BoxDecoration(
                                                    // color:Colors.green,
                                                    image: DecorationImage(
                                                      image: AssetImage("images/own_profile_bg4.png"),
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
                                                        alignment: Alignment.centerRight,
                                                        child:Row(
                                                          children: [
                                                            Spacer(),
                                                            GestureDetector(
                                                              onTap:onShowAddCraveList,
                                                              child:Padding(
                                                                padding: const EdgeInsets.only(top:15,bottom:15),
                                                                child: Text('ADD A LIST',
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w600,
                                                                        color: Color(constant.Color.crave_orange),
                                                                        fontSize: 10.0.sp)),
                                                              ),
                                                            ),

                                                            SizedBox(width:20.0.w),
                                                            Padding(
                                                              padding: const EdgeInsets.only(top:15,bottom:15),
                                                              child: Text('Craves Lists',
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.w600,
                                                                      color: Colors.black,
                                                                      fontSize: 14.0.sp)),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        height:MediaQuery.of(context).size.height -320,
                                                          padding: EdgeInsets.only(left:40,right:40,top:10),
                                                        child:
                                                        GridView.builder(
                                                            padding: EdgeInsets.zero,
                                                            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                                              maxCrossAxisExtent: 150,
                                                              childAspectRatio: aspectRatio,
                                                              mainAxisSpacing: 10,
                                                              crossAxisSpacing: 10,
                                                            ),
                                                            itemCount: this.widget.crave_list.length,
                                                            itemBuilder: (BuildContext ctx, index) {
                                                              return GestureDetector(
                                                                onTap:(){
                                                                  goToManageCraveLists(index);
                                                              },
                                                                child:Container(
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
                                                                          height:115,
                                                                          width: 150.0,
                                                                          margin:const EdgeInsets.only(right:0),
                                                                          decoration: BoxDecoration(
                                                                              image:this.widget.crave_list[index].list_img!=""?
                                                                              DecorationImage(
                                                                                  image: NetworkImage(constant.Url.media_url+this.widget.crave_list[index].list_img),
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
                                                                          child:Text(this.widget.crave_list[index].list_name.replaceAll('', '\u200B'),
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w600,
                                                                                  color: Color(constant.Color.crave_brown),
                                                                                  fontSize: 12.0.sp)),
                                                                        ),

                                                                        Padding(
                                                                          padding: const EdgeInsets.only(top:2),
                                                                          child:Text(this.widget.crave_list[index].crave_amount+' Craves',
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  color: Color(constant.Color.crave_brown),
                                                                                  fontSize: 10.0.sp)),
                                                                        ),

                                                                      ],
                                                                    ),
                                                                  ),

                                                                ),
                                                              );
                                                            }),


                                                        // Padding(
                                                        //   padding: EdgeInsets.only(left:20,right:20),
                                                        //   child:Column(
                                                        //     children: [
                                                        //       Row(
                                                        //         mainAxisSize: MainAxisSize.max,
                                                        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        //         children: [
                                                        //           Container(
                                                        //             width: 160.0,
                                                        //             height:180,
                                                        //             child:Stack(
                                                        //               children: [
                                                        //                 Container(
                                                        //                   decoration: BoxDecoration(
                                                        //                       border: Border.all(
                                                        //                         color: Colors.grey,
                                                        //                       ),
                                                        //                       borderRadius: BorderRadius.all(Radius.circular(10))
                                                        //                   ),
                                                        //                   child: Container(
                                                        //                     padding: const EdgeInsets.only(left:15,right:15,top:15,bottom:15),
                                                        //                     width: 160.0,
                                                        //                     child:Column(
                                                        //                       mainAxisAlignment: MainAxisAlignment.start,
                                                        //                       crossAxisAlignment: CrossAxisAlignment.start,
                                                        //                       children: [
                                                        //                         Container(
                                                        //                           height:100,
                                                        //                           width: 150.0,
                                                        //                           margin:const EdgeInsets.only(right:5),
                                                        //                           decoration: BoxDecoration(
                                                        //                               image: DecorationImage(image: AssetImage("images/reelsList1.png"), fit: BoxFit.cover),
                                                        //                               // color: Color(0xffF2F2F2),
                                                        //                               // border: Border.all(
                                                        //                               //   color: Color(0xff2CBFC6),
                                                        //                               // ),
                                                        //                               borderRadius: BorderRadius.all(Radius.circular(10))
                                                        //                           ),
                                                        //                         ),
                                                        //                         Padding(
                                                        //                           padding: const EdgeInsets.only(top:5),
                                                        //                           child:Text('Penang Holiday',
                                                        //                               overflow: TextOverflow.ellipsis,
                                                        //                               style: TextStyle(
                                                        //                                   fontWeight: FontWeight.w600,
                                                        //                                   color: Color(constant.Color.crave_brown),
                                                        //                                   fontSize: 14.0.sp)),
                                                        //                         ),
                                                        //
                                                        //                         Padding(
                                                        //                           padding: const EdgeInsets.only(top:2),
                                                        //                           child:Text('18 Craves',
                                                        //                               style: TextStyle(
                                                        //                                   fontWeight: FontWeight.w500,
                                                        //                                   color: Colors.black,
                                                        //                                   fontSize: 10.0.sp)),
                                                        //                         ),
                                                        //
                                                        //                       ],
                                                        //                     ),
                                                        //                   ),
                                                        //
                                                        //                 ),
                                                        //                 Padding(
                                                        //                   padding: EdgeInsets.only(top:2,right:2),
                                                        //                   child:Align(
                                                        //                       alignment: Alignment.topRight,
                                                        //                       child:Container(
                                                        //                         decoration: BoxDecoration(
                                                        //                             color:Color(constant.Color.crave_blue),
                                                        //                             border: Border.all(
                                                        //                               color: Color(constant.Color.crave_blue),
                                                        //                             ),
                                                        //                             borderRadius: BorderRadius.circular(10) // use instead of BorderRadius.all(Radius.circular(20))
                                                        //                         ),
                                                        //                         child: Padding(
                                                        //                           padding: const EdgeInsets.only(top:5,left:5,right:5,bottom:5),
                                                        //                           child:Text('SAVED',
                                                        //                               style: TextStyle(
                                                        //                                   fontWeight: FontWeight.w600,
                                                        //                                   color: Colors.white,
                                                        //                                   fontSize: 12.0.sp)),
                                                        //                         ),
                                                        //                       )
                                                        //
                                                        //                   ),
                                                        //                 ),
                                                        //
                                                        //               ],
                                                        //             ),
                                                        //           ),
                                                        //           Container(
                                                        //             width: 160.0,
                                                        //             height:180,
                                                        //             child:Stack(
                                                        //               children: [
                                                        //                 Container(
                                                        //                   decoration: BoxDecoration(
                                                        //                       border: Border.all(
                                                        //                         color: Colors.grey,
                                                        //                       ),
                                                        //                       borderRadius: BorderRadius.all(Radius.circular(10))
                                                        //                   ),
                                                        //                   child: Container(
                                                        //                     padding: const EdgeInsets.only(left:15,right:15,top:15,bottom:15),
                                                        //                     width: 160.0,
                                                        //                     child:Column(
                                                        //                       mainAxisAlignment: MainAxisAlignment.start,
                                                        //                       crossAxisAlignment: CrossAxisAlignment.start,
                                                        //                       children: [
                                                        //                         Container(
                                                        //                           height:100,
                                                        //                           width: 150.0,
                                                        //                           margin:const EdgeInsets.only(right:5),
                                                        //                           decoration: BoxDecoration(
                                                        //                               image: DecorationImage(image: AssetImage("images/reelsList2.png"), fit: BoxFit.cover),
                                                        //                               // color: Color(0xffF2F2F2),
                                                        //                               // border: Border.all(
                                                        //                               //   color: Color(0xff2CBFC6),
                                                        //                               // ),
                                                        //                               borderRadius: BorderRadius.all(Radius.circular(10))
                                                        //                           ),
                                                        //                         ),
                                                        //                         Padding(
                                                        //                           padding: const EdgeInsets.only(top:5),
                                                        //                           child:Text('Road Trip',
                                                        //                               overflow: TextOverflow.ellipsis,
                                                        //                               style: TextStyle(
                                                        //                                   fontWeight: FontWeight.w600,
                                                        //                                   color: Color(constant.Color.crave_brown),
                                                        //                                   fontSize: 14.0.sp)),
                                                        //                         ),
                                                        //
                                                        //                         Padding(
                                                        //                           padding: const EdgeInsets.only(top:2),
                                                        //                           child:Text('2 Craves',
                                                        //                               style: TextStyle(
                                                        //                                   fontWeight: FontWeight.w500,
                                                        //                                   color: Colors.black,
                                                        //                                   fontSize: 10.0.sp)),
                                                        //                         ),
                                                        //
                                                        //                       ],
                                                        //                     ),
                                                        //                   ),
                                                        //
                                                        //                 ),
                                                        //                 Padding(
                                                        //                   padding: EdgeInsets.only(top:2,right:2),
                                                        //                   child: Align(
                                                        //                       alignment: Alignment.topRight,
                                                        //                       child:Container(
                                                        //                         decoration: BoxDecoration(
                                                        //                             color:Color(0xffF2EFED),
                                                        //                             border: Border.all(
                                                        //                               color:Color(0xffF2EFED),
                                                        //                             ),
                                                        //                             borderRadius: BorderRadius.circular(10) // use instead of BorderRadius.all(Radius.circular(20))
                                                        //                         ),
                                                        //                         child: Padding(
                                                        //                           padding: const EdgeInsets.only(top:5,left:5,right:5,bottom:5),
                                                        //                           child:Text('SAVE',
                                                        //                               style: TextStyle(
                                                        //                                   fontWeight: FontWeight.w600,
                                                        //                                   color: Color(constant.Color.crave_brown),
                                                        //                                   fontSize: 12.0.sp)),
                                                        //                         ),
                                                        //                       )
                                                        //
                                                        //                   ),
                                                        //                 ),
                                                        //
                                                        //               ],
                                                        //             ),
                                                        //           ),
                                                        //         ],
                                                        //       ),
                                                        //       SizedBox(height:10),
                                                        //       Row(
                                                        //         mainAxisSize: MainAxisSize.max,
                                                        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        //         children: [
                                                        //           Container(
                                                        //             width: 160.0,
                                                        //             height:180,
                                                        //             child:Stack(
                                                        //               children: [
                                                        //                 Container(
                                                        //                   decoration: BoxDecoration(
                                                        //                       border: Border.all(
                                                        //                         color: Colors.grey,
                                                        //                       ),
                                                        //                       borderRadius: BorderRadius.all(Radius.circular(10))
                                                        //                   ),
                                                        //                   child: Container(
                                                        //                     padding: const EdgeInsets.only(left:15,right:15,top:15,bottom:15),
                                                        //                     width: 160.0,
                                                        //                     child:Column(
                                                        //                       mainAxisAlignment: MainAxisAlignment.start,
                                                        //                       crossAxisAlignment: CrossAxisAlignment.start,
                                                        //                       children: [
                                                        //                         Container(
                                                        //                           height:100,
                                                        //                           width: 150.0,
                                                        //                           margin:const EdgeInsets.only(right:5),
                                                        //                           decoration: BoxDecoration(
                                                        //                               image: DecorationImage(image: AssetImage("images/reelsList1.png"), fit: BoxFit.cover),
                                                        //                               // color: Color(0xffF2F2F2),
                                                        //                               // border: Border.all(
                                                        //                               //   color: Color(0xff2CBFC6),
                                                        //                               // ),
                                                        //                               borderRadius: BorderRadius.all(Radius.circular(10))
                                                        //                           ),
                                                        //                         ),
                                                        //                         Padding(
                                                        //                           padding: const EdgeInsets.only(top:5),
                                                        //                           child:Text('Penang Holiday',
                                                        //                               overflow: TextOverflow.ellipsis,
                                                        //                               style: TextStyle(
                                                        //                                   fontWeight: FontWeight.w600,
                                                        //                                   color: Color(constant.Color.crave_brown),
                                                        //                                   fontSize: 14.0.sp)),
                                                        //                         ),
                                                        //
                                                        //                         Padding(
                                                        //                           padding: const EdgeInsets.only(top:2),
                                                        //                           child:Text('18 Craves',
                                                        //                               style: TextStyle(
                                                        //                                   fontWeight: FontWeight.w500,
                                                        //                                   color: Colors.black,
                                                        //                                   fontSize: 10.0.sp)),
                                                        //                         ),
                                                        //
                                                        //                       ],
                                                        //                     ),
                                                        //                   ),
                                                        //
                                                        //                 ),
                                                        //                 Padding(
                                                        //                   padding: EdgeInsets.only(top:2,right:2),
                                                        //                   child:Align(
                                                        //                       alignment: Alignment.topRight,
                                                        //                       child:Container(
                                                        //                         decoration: BoxDecoration(
                                                        //                             color:Color(constant.Color.crave_blue),
                                                        //                             border: Border.all(
                                                        //                               color: Color(constant.Color.crave_blue),
                                                        //                             ),
                                                        //                             borderRadius: BorderRadius.circular(10) // use instead of BorderRadius.all(Radius.circular(20))
                                                        //                         ),
                                                        //                         child: Padding(
                                                        //                           padding: const EdgeInsets.only(top:5,left:5,right:5,bottom:5),
                                                        //                           child:Text('SAVED',
                                                        //                               style: TextStyle(
                                                        //                                   fontWeight: FontWeight.w600,
                                                        //                                   color: Colors.white,
                                                        //                                   fontSize: 12.0.sp)),
                                                        //                         ),
                                                        //                       )
                                                        //
                                                        //                   ),
                                                        //                 ),
                                                        //
                                                        //               ],
                                                        //             ),
                                                        //           ),
                                                        //           Container(
                                                        //             width: 160.0,
                                                        //             height:180,
                                                        //             child:Stack(
                                                        //               children: [
                                                        //                 Container(
                                                        //                   decoration: BoxDecoration(
                                                        //                       border: Border.all(
                                                        //                         color: Colors.grey,
                                                        //                       ),
                                                        //                       borderRadius: BorderRadius.all(Radius.circular(10))
                                                        //                   ),
                                                        //                   child: Container(
                                                        //                     padding: const EdgeInsets.only(left:15,right:15,top:15,bottom:15),
                                                        //                     width: 160.0,
                                                        //                     child:Column(
                                                        //                       mainAxisAlignment: MainAxisAlignment.start,
                                                        //                       crossAxisAlignment: CrossAxisAlignment.start,
                                                        //                       children: [
                                                        //                         Container(
                                                        //                           height:100,
                                                        //                           width: 150.0,
                                                        //                           margin:const EdgeInsets.only(right:5),
                                                        //                           decoration: BoxDecoration(
                                                        //                               image: DecorationImage(image: AssetImage("images/reelsList2.png"), fit: BoxFit.cover),
                                                        //                               // color: Color(0xffF2F2F2),
                                                        //                               // border: Border.all(
                                                        //                               //   color: Color(0xff2CBFC6),
                                                        //                               // ),
                                                        //                               borderRadius: BorderRadius.all(Radius.circular(10))
                                                        //                           ),
                                                        //                         ),
                                                        //                         Padding(
                                                        //                           padding: const EdgeInsets.only(top:5),
                                                        //                           child:Text('Road Trip',
                                                        //                               overflow: TextOverflow.ellipsis,
                                                        //                               style: TextStyle(
                                                        //                                   fontWeight: FontWeight.w600,
                                                        //                                   color: Color(constant.Color.crave_brown),
                                                        //                                   fontSize: 14.0.sp)),
                                                        //                         ),
                                                        //
                                                        //                         Padding(
                                                        //                           padding: const EdgeInsets.only(top:2),
                                                        //                           child:Text('2 Craves',
                                                        //                               style: TextStyle(
                                                        //                                   fontWeight: FontWeight.w500,
                                                        //                                   color: Colors.black,
                                                        //                                   fontSize: 10.0.sp)),
                                                        //                         ),
                                                        //
                                                        //                       ],
                                                        //                     ),
                                                        //                   ),
                                                        //
                                                        //                 ),
                                                        //                 Padding(
                                                        //                   padding: EdgeInsets.only(top:2,right:2),
                                                        //                   child: Align(
                                                        //                       alignment: Alignment.topRight,
                                                        //                       child:Container(
                                                        //                         decoration: BoxDecoration(
                                                        //                             color:Color(0xffF2EFED),
                                                        //                             border: Border.all(
                                                        //                               color:Color(0xffF2EFED),
                                                        //                             ),
                                                        //                             borderRadius: BorderRadius.circular(10) // use instead of BorderRadius.all(Radius.circular(20))
                                                        //                         ),
                                                        //                         child: Padding(
                                                        //                           padding: const EdgeInsets.only(top:5,left:5,right:5,bottom:5),
                                                        //                           child:Text('SAVE',
                                                        //                               style: TextStyle(
                                                        //                                   fontWeight: FontWeight.w600,
                                                        //                                   color: Color(constant.Color.crave_brown),
                                                        //                                   fontSize: 12.0.sp)),
                                                        //                         ),
                                                        //                       )
                                                        //
                                                        //                   ),
                                                        //                 ),
                                                        //
                                                        //               ],
                                                        //             ),
                                                        //           ),
                                                        //         ],
                                                        //       ),
                                                        //       SizedBox(height:10),
                                                        //       Row(
                                                        //         mainAxisSize: MainAxisSize.max,
                                                        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        //         children: [
                                                        //           Container(
                                                        //             width: 160.0,
                                                        //             height:180,
                                                        //             child:Stack(
                                                        //               children: [
                                                        //                 Container(
                                                        //                   decoration: BoxDecoration(
                                                        //                       border: Border.all(
                                                        //                         color: Colors.grey,
                                                        //                       ),
                                                        //                       borderRadius: BorderRadius.all(Radius.circular(10))
                                                        //                   ),
                                                        //                   child: Container(
                                                        //                     padding: const EdgeInsets.only(left:15,right:15,top:15,bottom:15),
                                                        //                     width: 160.0,
                                                        //                     child:Column(
                                                        //                       mainAxisAlignment: MainAxisAlignment.start,
                                                        //                       crossAxisAlignment: CrossAxisAlignment.start,
                                                        //                       children: [
                                                        //                         Container(
                                                        //                           height:100,
                                                        //                           width: 150.0,
                                                        //                           margin:const EdgeInsets.only(right:5),
                                                        //                           decoration: BoxDecoration(
                                                        //                               image: DecorationImage(image: AssetImage("images/reelsList1.png"), fit: BoxFit.cover),
                                                        //                               // color: Color(0xffF2F2F2),
                                                        //                               // border: Border.all(
                                                        //                               //   color: Color(0xff2CBFC6),
                                                        //                               // ),
                                                        //                               borderRadius: BorderRadius.all(Radius.circular(10))
                                                        //                           ),
                                                        //                         ),
                                                        //                         Padding(
                                                        //                           padding: const EdgeInsets.only(top:5),
                                                        //                           child:Text('Penang Holiday',
                                                        //                               overflow: TextOverflow.ellipsis,
                                                        //                               style: TextStyle(
                                                        //                                   fontWeight: FontWeight.w600,
                                                        //                                   color: Color(constant.Color.crave_brown),
                                                        //                                   fontSize: 14.0.sp)),
                                                        //                         ),
                                                        //
                                                        //                         Padding(
                                                        //                           padding: const EdgeInsets.only(top:2),
                                                        //                           child:Text('18 Craves',
                                                        //                               style: TextStyle(
                                                        //                                   fontWeight: FontWeight.w500,
                                                        //                                   color: Colors.black,
                                                        //                                   fontSize: 10.0.sp)),
                                                        //                         ),
                                                        //
                                                        //                       ],
                                                        //                     ),
                                                        //                   ),
                                                        //
                                                        //                 ),
                                                        //                 Padding(
                                                        //                   padding: EdgeInsets.only(top:2,right:2),
                                                        //                   child:Align(
                                                        //                       alignment: Alignment.topRight,
                                                        //                       child:Container(
                                                        //                         decoration: BoxDecoration(
                                                        //                             color:Color(constant.Color.crave_blue),
                                                        //                             border: Border.all(
                                                        //                               color: Color(constant.Color.crave_blue),
                                                        //                             ),
                                                        //                             borderRadius: BorderRadius.circular(10) // use instead of BorderRadius.all(Radius.circular(20))
                                                        //                         ),
                                                        //                         child: Padding(
                                                        //                           padding: const EdgeInsets.only(top:5,left:5,right:5,bottom:5),
                                                        //                           child:Text('SAVED',
                                                        //                               style: TextStyle(
                                                        //                                   fontWeight: FontWeight.w600,
                                                        //                                   color: Colors.white,
                                                        //                                   fontSize: 12.0.sp)),
                                                        //                         ),
                                                        //                       )
                                                        //
                                                        //                   ),
                                                        //                 ),
                                                        //
                                                        //               ],
                                                        //             ),
                                                        //           ),
                                                        //           Container(
                                                        //             width: 160.0,
                                                        //             height:180,
                                                        //             child:Stack(
                                                        //               children: [
                                                        //                 Container(
                                                        //                   decoration: BoxDecoration(
                                                        //                       border: Border.all(
                                                        //                         color: Colors.grey,
                                                        //                       ),
                                                        //                       borderRadius: BorderRadius.all(Radius.circular(10))
                                                        //                   ),
                                                        //                   child: Container(
                                                        //                     padding: const EdgeInsets.only(left:15,right:15,top:15,bottom:15),
                                                        //                     width: 160.0,
                                                        //                     child:Column(
                                                        //                       mainAxisAlignment: MainAxisAlignment.start,
                                                        //                       crossAxisAlignment: CrossAxisAlignment.start,
                                                        //                       children: [
                                                        //                         Container(
                                                        //                           height:100,
                                                        //                           width: 150.0,
                                                        //                           margin:const EdgeInsets.only(right:5),
                                                        //                           decoration: BoxDecoration(
                                                        //                               image: DecorationImage(image: AssetImage("images/reelsList2.png"), fit: BoxFit.cover),
                                                        //                               // color: Color(0xffF2F2F2),
                                                        //                               // border: Border.all(
                                                        //                               //   color: Color(0xff2CBFC6),
                                                        //                               // ),
                                                        //                               borderRadius: BorderRadius.all(Radius.circular(10))
                                                        //                           ),
                                                        //                         ),
                                                        //                         Padding(
                                                        //                           padding: const EdgeInsets.only(top:5),
                                                        //                           child:Text('Road Trip',
                                                        //                               overflow: TextOverflow.ellipsis,
                                                        //                               style: TextStyle(
                                                        //                                   fontWeight: FontWeight.w600,
                                                        //                                   color: Color(constant.Color.crave_brown),
                                                        //                                   fontSize: 14.0.sp)),
                                                        //                         ),
                                                        //
                                                        //                         Padding(
                                                        //                           padding: const EdgeInsets.only(top:2),
                                                        //                           child:Text('2 Craves',
                                                        //                               style: TextStyle(
                                                        //                                   fontWeight: FontWeight.w500,
                                                        //                                   color: Colors.black,
                                                        //                                   fontSize: 10.0.sp)),
                                                        //                         ),
                                                        //
                                                        //                       ],
                                                        //                     ),
                                                        //                   ),
                                                        //
                                                        //                 ),
                                                        //                 Padding(
                                                        //                   padding: EdgeInsets.only(top:2,right:2),
                                                        //                   child: Align(
                                                        //                       alignment: Alignment.topRight,
                                                        //                       child:Container(
                                                        //                         decoration: BoxDecoration(
                                                        //                             color:Color(0xffF2EFED),
                                                        //                             border: Border.all(
                                                        //                               color:Color(0xffF2EFED),
                                                        //                             ),
                                                        //                             borderRadius: BorderRadius.circular(10) // use instead of BorderRadius.all(Radius.circular(20))
                                                        //                         ),
                                                        //                         child: Padding(
                                                        //                           padding: const EdgeInsets.only(top:5,left:5,right:5,bottom:5),
                                                        //                           child:Text('SAVE',
                                                        //                               style: TextStyle(
                                                        //                                   fontWeight: FontWeight.w600,
                                                        //                                   color: Color(constant.Color.crave_brown),
                                                        //                                   fontSize: 12.0.sp)),
                                                        //                         ),
                                                        //                       )
                                                        //
                                                        //                   ),
                                                        //                 ),
                                                        //
                                                        //               ],
                                                        //             ),
                                                        //           ),
                                                        //         ],
                                                        //       ),
                                                        //     ],
                                                        //   ),
                                                        //
                                                        // ),
                                                      )
                                                    ],
                                                  ),


                                                ),
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
                                              ],
                                            ),

                                            //SizedBox(height:100),
                                          ],
                                        ),
                                      ),

                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top:70),
                                  child:Align(
                                    alignment: Alignment.topCenter,
                                    child:
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 65.0,
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(constant.Url.profile_url+this.widget.user_profile[0].profile_img),
                                        radius: 60.0,
                                      ),
                                    ),
                                    // Image.asset(
                                    //   'images/user1.png',
                                    //   height: 15.0.h,
                                    // ),
                                  ),

                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child:
                                  GestureDetector(
                                    onTap:goToPosts,
                                    child:Padding(
                                      padding: const EdgeInsets.only(top:200),
                                      child: Image.asset('images/post_icon.png',height:80),
                                    ),
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


