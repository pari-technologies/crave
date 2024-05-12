// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:a_crave/profileUser.dart';
import 'package:a_crave/reels.dart';
import 'package:a_crave/reelsDetails.dart';
import 'package:flutter/material.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homeBase.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

import 'constants.dart' as constant;
import 'dataClass.dart';
import 'myHomepage.dart';

class Feed extends StatefulWidget {
  final PageController homepageController;
  final List<Media> medias;
  final Function(int) onDataChange;
  final Function() onLoadMedia;
  final Function(String) onSelectUser;
  final List<CraveList> craveList;
  final int selectedMediaIndex;
  const Feed({Key? key, required this.homepageController,required this.medias,required this.onDataChange, required this.onLoadMedia, required this.onSelectUser,required this.craveList,required this.selectedMediaIndex}) : super(key: key);
  static FeedState? of(BuildContext context) => context.findAncestorStateOfType<FeedState>();
  @override
  FeedState createState() => FeedState();
}

class FeedState extends State<Feed>{
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  final textController = TextEditingController();
  final addListTxtController = TextEditingController();
  final PageViewDemo homeB= new PageViewDemo();
  // bool isShowStats = false;
  bool isShowStatsPopup = false;
  // bool isShowOptions = false;
  int selectedIndex = 0;
  List<String> post_likes_list = [];
  List<String> post_likes = [];
  List<String> post_crave_list = [];
  List<String> post_crave = [];
  List<Followers> returnedFollowers = [];
  List<Followers> duplicateItems = [];
  List<String> shareToFollowers = [];
  List<bool> isShowStats = [];
  List<bool> isShowOptions = [];
  List<bool> isShowCraveList = [];
  List<CraveList> currentCraveList = [];
  List<bool> currentCraveListChecked = [];
  List<String> addToCraveList = [];

  String currentCraves = "0";
  String currentLikes = "0";
  String currentViews = "0";
  String currentComments = "0";
  String palette1 = "";
  String palette2 = "";
  String palette3 = "";

  String currentUserId = "";

  var cuisine1 = [
    {'name': 'Indian (North)', 'isSelected': false},
    {'name': 'Indian (South)', 'isSelected': false},
    {'name': 'Korean', 'isSelected': false},
    {'name': 'Italian', 'isSelected': false},
    {'name': 'French', 'isSelected': false},
    {'name': 'Japanese', 'isSelected': false},
    {'name': 'Continental', 'isSelected': false}];

  var cuisine2 = [
    {'name': 'Thai', 'isSelected': false},
    {'name': 'Vietnamese', 'isSelected': false},
    {'name': 'Mexican', 'isSelected': false},
    {'name': 'Middle-eastern', 'isSelected': false},
    {'name': 'Chinese', 'isSelected': false},
    {'name': 'Malay', 'isSelected': false}];


  var taste1 = [
    {'name': 'Sweet', 'isSelected': false},
    {'name': 'Sour', 'isSelected': false},
  ];

  var taste2 = [
    {'name': 'Savory', 'isSelected': false},
    {'name': 'Spicy', 'isSelected': false},
  ];


  var category1 = [
    {'name': 'DESSERT', 'isSelected': false},
    {'name': 'DRINK', 'isSelected': false}
  ];

  var category2 = [
    {'name': 'FOOD', 'isSelected': false},
    {'name': 'PASTRIES', 'isSelected': false},
  ];

  var type1 = [
    {'name': 'Halal', 'isSelected': false},
    {'name': 'Seafood', 'isSelected': false},
    {'name': 'Gluten-free', 'isSelected': false},
    {'name': 'Contains-nuts', 'isSelected': false}
  ];

  var type2 = [
    {'name': 'Alcoholic', 'isSelected': false},
    {'name': 'Coffee', 'isSelected': false},
    {'name': 'Vegetarian', 'isSelected': false},
  ];

  var ambiance1 = [
    {'name': 'CAFE', 'isSelected': false},
    {'name': 'FINE-DINING', 'isSelected': false},
    {'name': 'CASUAL', 'isSelected': false},
    {'name': 'PUBS-&-BARS', 'isSelected': false},
  ];

  var ambiance2 = [
    {'name': 'COFFEE-SHOP', 'isSelected': false},
    {'name': 'DESSERT-SHOP', 'isSelected': false},
    {'name': 'DRIVE-THRU', 'isSelected': false},
  ];

  List<bool> isChecked = [];
  List<Widget> followersWidget = [];

  ScrollController _scrollController = ScrollController();

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

  void goToComments(int index) {
    if(isShowStats[index]){
      setState(() {
        selectedIndex = index;
        isShowStats[index] = false;
      });
    }
    else{
      this.widget.onDataChange(index);
      this.widget.homepageController.nextPage(duration: Duration(milliseconds: 100), curve: Curves.easeIn);
    }

  }

  void showStats(int index){
    setState(() {
      selectedIndex = index;
      isShowStats[index] = true;
    });
  }

  void showStatsPopup(int index){
    setState(() {
      selectedIndex = index;
      isShowStats[index] = false;
      currentCraves = this.widget.medias[index].post_craving.toString();
      currentLikes = this.widget.medias[index].post_likes.toString();
      currentViews = (int.parse(this.widget.medias[index].post_likes) + int.parse(this.widget.medias[index].post_craving)).toString();
      currentComments = this.widget.medias[index].post_comments.toString();
      palette1 = this.widget.medias[index].tags1.toString();
      palette2 = this.widget.medias[index].tags2.toString();
      palette3 = this.widget.medias[index].tags3.toString();
      isShowStatsPopup = true;
    });
  }

  void showTravelToOld(int index){
    selectedIndex = index;
    List coord = this.widget.medias[index].media_latlng.split(',');
    MapsLauncher.launchCoordinates(double.parse(coord[0]),double.parse(coord[1]));
  }

  void launchWaze(int index) async {
    final new_dis = this.widget.medias[index].media_latlng.split(',');
    var url = 'waze://?ll=${new_dis[0]},${new_dis[1]}';
    var fallbackUrl =
        'https://waze.com/ul?ll=${new_dis[0]},${new_dis[1]}&navigate=yes';
    try {
      bool launched =
      await launch(url, forceSafariVC: false, forceWebView: false);
      if (!launched) {
        await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
      }
    } catch (e) {
      await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
    }
  }

  void launchGoogleMaps(int index) async {
    final new_dis = this.widget.medias[index].media_latlng.split(',');
    var url = 'google.navigation:q=${new_dis[0]},${new_dis[1]}';
    var fallbackUrl =
        'https://www.google.com/maps/search/?api=1&query=${new_dis[0]},${new_dis[1]}';
    try {
      bool launched =
      await launch(url, forceSafariVC: false, forceWebView: false);
      if (!launched) {
        await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
      }
    } catch (e) {
      await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
    }
  }

  void showTravelTo(int index){
    selectedIndex = index;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius:
                BorderRadius.circular(20.0),
              ),
              child: Container(
                padding: EdgeInsets.only(left:20.0,right:20.0),
                margin : EdgeInsets.only(left:20.0,right:20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('How would you like to get there?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight:FontWeight.w600
                      ),
                    ),
                    SizedBox(height:20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap:(){
                            launchGoogleMaps(index);
                          },
                          child:ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Image.asset('images/gmaps_icon.png',height: 60.0),
                          ),
                        ),

                        SizedBox(width:20),
                        GestureDetector(
                          onTap:(){
                            launchWaze(index);
                          },
                          child:ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Image.asset('images/waze_icon.png',height: 60.0),
                          ),
                        ),


                      ],
                    ),
                    SizedBox(height:20),
                    GestureDetector(
                        onTap:(){
                          Navigator.pop(context);
                        },
                        child:SizedBox(
                            width: 320.0,
                            child: Text('Nevermind',
                                textAlign: TextAlign.center,
                                style:TextStyle(
                                  color:Colors.white,
                                  fontSize: 18,
                                  decoration: TextDecoration.underline,
                                ))
                        )
                    ),

                  ],
                ),
              ),
            ),
          );
        });
  }

  void hideStatsPopup(){
    setState(() {
      currentCraves = "0";
      currentLikes = "0";
      currentViews = "0";
      currentComments = "0";
      palette1 = "";
      palette2 = "";
      palette3 = "";
      isShowStatsPopup = false;
    });
  }

  void showOptions(int index){
    setState(() {
      isShowOptions[index] = true;
    });
  }

  void hideOptions(int index){
    setState(() {
      isShowOptions[index] = false;
    });
  }

  void showCraveList(int index){
    setState(() {
      isShowCraveList[index] = true;
    });
  }

  void hideCraveList(int index){
    setState(() {
      addToCraveListContent(this.widget.medias[index].media_id);
      isShowCraveList[index] = false;
    });
  }

  void onShowFoodPalette(){
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
            return Container(
              height:MediaQuery.of(context).size.height,
              // padding:
              padding: MediaQuery.of(context).viewInsets,
              //height:30.0.h,
              child:
              SingleChildScrollView(
                child:Stack(
                  children: [
                    Column(
                      children: [
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
                                    child:
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.only(left: 20.0,top:60),
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
                                                top: 60.0,bottom:0,left:10),
                                            //width:MediaQuery.of(context).size.width,
                                            child:Text("Suggest Palatte",
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
                        //Cuisine
                        Container(
                          width: double.maxFinite,
                          padding: const EdgeInsets.only(
                              left: 30.0,right:30.0,top:30,bottom:15),
                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Cuisine",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(constant.Color.crave_orange),
                                      fontSize: 11.0.sp)),
                              // Row(
                              //   children: [
                              //     Text("Please select",
                              //         textAlign: TextAlign.right,
                              //         style: TextStyle(
                              //             fontWeight: FontWeight.w500,
                              //             color: Colors.black,
                              //             fontSize: 11.0.sp)),
                              //     Text(" at least",
                              //         textAlign: TextAlign.right,
                              //         style: TextStyle(
                              //             fontWeight: FontWeight.w500,
                              //             color: Color(constant.Color.crave_orange),
                              //             fontSize: 11.0.sp)),
                              //     Text(" 3.",
                              //         textAlign: TextAlign.right,
                              //         style: TextStyle(
                              //             fontWeight: FontWeight.w500,
                              //             color: Colors.black,
                              //             fontSize: 11.0.sp)),
                              //   ],
                              // ),

                            ],
                          ),
                        ),

                        Stack(
                          children: [
                            Wrap(
                              children: [
                                Container(
                                  //height:_height,
                                  margin: const EdgeInsets.only(
                                      left: 25.0,right:25.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFFF2F2F2),
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        topLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                      ),
                                    ),
                                    // margin: const EdgeInsets.only(
                                    //     top: 10.0),
                                    padding: const EdgeInsets.only(
                                        left: 10.0,right:10.0,top:10),
                                    //height:70.0.h,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Expanded(
                                          child:
                                          ListView.builder(
                                            padding:  EdgeInsets.only(right:0.0),
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemCount: cuisine1.length,
                                            itemBuilder: (BuildContext ctx, index) {
                                              return
                                                cuisine1[index]['name'].toString().length != 1?
                                                Container(
                                                    decoration: BoxDecoration(
                                                      color: cuisine1[index]['isSelected'] == true
                                                          ? Color(constant.Color.crave_blue)
                                                          : Color(0xFFF2F2F2),
                                                      borderRadius: BorderRadius.only(
                                                        topRight: Radius.circular(10),
                                                        topLeft: Radius.circular(10),
                                                        bottomRight: Radius.circular(10),
                                                        bottomLeft: Radius.circular(10),
                                                      ),

                                                    ),
                                                    margin:  EdgeInsets.only(bottom:5.0),

                                                    child: ListTile(
                                                      dense: true,
                                                      contentPadding: EdgeInsets.only(
                                                          left: 5.0,right:5.0),
                                                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                                                      onTap: () {
                                                        // if this item isn't selected yet, "isSelected": false -> true
                                                        // If this item already is selected: "isSelected": true -> false
                                                        setState(() {
                                                          if(cuisine1[index]['isSelected'] == true){
                                                            cuisine1[index]['isSelected'] = false;
                                                          }
                                                          else{
                                                            cuisine1[index]['isSelected'] = true;
                                                          }

                                                        });
                                                      },
                                                      title:
                                                      Text(
                                                          cuisine1[index]['name'].toString().toUpperCase(),
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.w600,
                                                            color: cuisine1[index]['isSelected'] == true
                                                                ? Colors.white
                                                                : Colors.black,)
                                                      ),

                                                    )):
                                                index==0?
                                                Container(
                                                  child:Text(
                                                      cuisine1[index]['name'].toString().toUpperCase(),
                                                      style: TextStyle(
                                                          color: Color(constant.Color.crave_orange),
                                                          fontWeight: FontWeight.w700,
                                                          fontSize: 14.0.sp)
                                                  ),
                                                ):
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 10.0),
                                                  child:Text(
                                                      cuisine1[index]['name'].toString().toUpperCase(),
                                                      style: TextStyle(
                                                          color: Color(constant.Color.crave_orange),
                                                          fontWeight: FontWeight.w700,
                                                          fontSize: 14.0.sp)
                                                  ),
                                                );
                                            },
                                          ),
                                        ),
                                        IntrinsicHeight(
                                          child:Container(
                                              padding: const EdgeInsets.only(
                                                  top: 10.0,bottom:10,right:5),
                                              child: VerticalDivider(
                                                color: Color(0xFFE0E0E0),thickness: 1,),height:28.0.h),
                                        ),

                                        Expanded(
                                          child:  ListView.builder(
                                            padding:  EdgeInsets.only(right:0.0),
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemCount: cuisine2.length,
                                            itemBuilder: (BuildContext ctx, index) {
                                              return
                                                cuisine2[index]['name'].toString().length != 1?
                                                Container(
                                                    decoration: BoxDecoration(
                                                      color: cuisine2[index]['isSelected'] == true
                                                          ? Color(constant.Color.crave_blue)
                                                          : Color(0xFFF2F2F2),
                                                      borderRadius: BorderRadius.only(
                                                        topRight: Radius.circular(10),
                                                        topLeft: Radius.circular(10),
                                                        bottomRight: Radius.circular(10),
                                                        bottomLeft: Radius.circular(10),
                                                      ),

                                                    ),
                                                    margin:  EdgeInsets.only(bottom:5.0),

                                                    child: ListTile(
                                                      dense: true,
                                                      contentPadding: EdgeInsets.only(
                                                          left: 5.0,right:5.0),
                                                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                                                      onTap: () {
                                                        // if this item isn't selected yet, "isSelected": false -> true
                                                        // If this item already is selected: "isSelected": true -> false
                                                        setState(() {
                                                          if(cuisine2[index]['isSelected'] == true){
                                                            cuisine2[index]['isSelected'] = false;
                                                          }
                                                          else{
                                                            cuisine2[index]['isSelected'] = true;
                                                          }

                                                        });
                                                      },
                                                      title:
                                                      Text(
                                                          cuisine2[index]['name'].toString().toUpperCase(),
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.w600,
                                                            color: cuisine2[index]['isSelected'] == true
                                                                ? Colors.white
                                                                : Colors.black,)
                                                      ),

                                                    )):
                                                index==0?
                                                Container(
                                                  child:Text(
                                                      cuisine2[index]['name'].toString().toUpperCase(),
                                                      style: TextStyle(
                                                          color: Color(constant.Color.crave_orange),
                                                          fontWeight: FontWeight.w700,
                                                          fontSize: 14.0.sp)
                                                  ),
                                                ):
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 10.0),
                                                  child:Text(
                                                      cuisine2[index]['name'].toString().toUpperCase(),
                                                      style: TextStyle(
                                                          color: Color(constant.Color.crave_orange),
                                                          fontWeight: FontWeight.w700,
                                                          fontSize: 14.0.sp)
                                                  ),
                                                );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // GestureDetector(
                            //   onTap:onExpand,
                            //   child: Container(
                            //     height:25,
                            //     margin: EdgeInsets.only(
                            //         left: 25.0,right:25.0,top:_height-1.0.h),
                            //     decoration: BoxDecoration(
                            //       color: Color(0xFFEAEAEA),
                            //       borderRadius: BorderRadius.only(
                            //         bottomRight: Radius.circular(10),
                            //         bottomLeft: Radius.circular(10),
                            //       ),
                            //
                            //     ),
                            //     child:Center(
                            //       child:Icon(
                            //         _height==70.0.h?Icons.keyboard_arrow_up:Icons.keyboard_arrow_down,
                            //         color: Colors.grey,
                            //         size: 25.0,
                            //       ),
                            //     ),
                            //
                            //   ),
                            // ),

                          ],
                        ),


                        //Taste
                        Container(
                          width: double.maxFinite,
                          padding: const EdgeInsets.only(
                              left: 30.0,right:30.0,top:30,bottom:10),
                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Taste",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(constant.Color.crave_orange),
                                      fontSize: 11.0.sp)),
                              Row(
                                children: [
                                  Text("Please select",
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                          fontSize: 11.0.sp)),
                                  Text(" at least",
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Color(constant.Color.crave_orange),
                                          fontSize: 11.0.sp)),
                                  Text(" 1",
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                          fontSize: 11.0.sp)),
                                ],
                              ),

                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 25.0,right:25.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFF2F2F2),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                topLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),

                            ),

                            // margin: const EdgeInsets.only(
                            //     top: 10.0),
                            padding: const EdgeInsets.only(
                                left: 10.0,right:10.0,top:10),
                            //height:70.0.h,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child:
                                  ListView.builder(
                                    padding:  EdgeInsets.only(right:10.0),
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: taste1.length,
                                    itemBuilder: (BuildContext ctx, index) {
                                      return
                                        taste1[index]['name'].toString().length != 1?
                                        Container(
                                            decoration: BoxDecoration(
                                              color: taste1[index]['isSelected'] == true
                                                  ? Color(constant.Color.crave_blue)
                                                  : Color(0xFFF2F2F2),
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(10),
                                                topLeft: Radius.circular(10),
                                                bottomRight: Radius.circular(10),
                                                bottomLeft: Radius.circular(10),
                                              ),

                                            ),
                                            margin:  EdgeInsets.only(bottom:5.0),

                                            child: ListTile(
                                              dense: true,
                                              contentPadding: EdgeInsets.only(
                                                  left: 5.0,right:5.0),
                                              visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                                              onTap: () {
                                                // if this item isn't selected yet, "isSelected": false -> true
                                                // If this item already is selected: "isSelected": true -> false
                                                setState(() {
                                                  if(taste1[index]['isSelected'] == true){
                                                    taste1[index]['isSelected'] = false;
                                                  }
                                                  else{
                                                    taste1[index]['isSelected'] = true;
                                                  }

                                                });
                                              },
                                              title:
                                              Text(
                                                  taste1[index]['name'].toString().toUpperCase(),
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: taste1[index]['isSelected'] == true
                                                        ? Colors.white
                                                        : Colors.black,)
                                              ),

                                            )):
                                        index==0?
                                        Container(
                                          child:Text(
                                              taste1[index]['name'].toString().toUpperCase(),
                                              style: TextStyle(
                                                  color: Color(constant.Color.crave_orange),
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14.0.sp)
                                          ),
                                        ):
                                        Container(
                                          margin: const EdgeInsets.only(
                                              top: 10.0),
                                          child:Text(
                                              taste1[index]['name'].toString().toUpperCase(),
                                              style: TextStyle(
                                                  color: Color(constant.Color.crave_orange),
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14.0.sp)
                                          ),
                                        );
                                    },
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                      top: 5.0,bottom:10,right:10),
                                  child: VerticalDivider(
                                    color: Color(0xFFE0E0E0),thickness: 1,),
                                  height:9.0.h,),

                                Expanded(
                                  child:  ListView.builder(
                                    padding:  EdgeInsets.only(right:10.0),
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: taste2.length,
                                    itemBuilder: (BuildContext ctx, index) {
                                      return
                                        taste2[index]['name'].toString().length != 1?
                                        Container(
                                            decoration: BoxDecoration(
                                              color: taste2[index]['isSelected'] == true
                                                  ? Color(constant.Color.crave_blue)
                                                  : Color(0xFFF2F2F2),
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(10),
                                                topLeft: Radius.circular(10),
                                                bottomRight: Radius.circular(10),
                                                bottomLeft: Radius.circular(10),
                                              ),

                                            ),
                                            margin:  EdgeInsets.only(bottom:5.0),

                                            child: ListTile(
                                              dense: true,
                                              contentPadding: EdgeInsets.only(
                                                  left: 5.0,right:5.0),
                                              visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                                              onTap: () {
                                                // if this item isn't selected yet, "isSelected": false -> true
                                                // If this item already is selected: "isSelected": true -> false
                                                setState(() {
                                                  if(taste2[index]['isSelected'] == true){
                                                    taste2[index]['isSelected'] = false;
                                                  }
                                                  else{
                                                    taste2[index]['isSelected'] = true;
                                                  }

                                                });
                                              },
                                              title:
                                              Text(
                                                  taste2[index]['name'].toString().toUpperCase(),
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: taste2[index]['isSelected'] == true
                                                        ? Colors.white
                                                        : Colors.black,)
                                              ),

                                            )):
                                        index==0?
                                        Container(
                                          child:Text(
                                              taste2[index]['name'].toString().toUpperCase(),
                                              style: TextStyle(
                                                  color: Color(constant.Color.crave_orange),
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14.0.sp)
                                          ),
                                        ):
                                        Container(
                                          margin: const EdgeInsets.only(
                                              top: 10.0),
                                          child:Text(
                                              taste2[index]['name'].toString().toUpperCase(),
                                              style: TextStyle(
                                                  color: Color(constant.Color.crave_orange),
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14.0.sp)
                                          ),
                                        );
                                    },
                                  ),
                                ),


                              ],
                            ),



                          ),
                        ),

                        //Category
                        Container(
                          width: double.maxFinite,
                          padding: const EdgeInsets.only(
                              left: 30.0,right:30.0,top:30,bottom:10),
                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Category",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(constant.Color.crave_orange),
                                      fontSize: 11.0.sp)),
                              Row(
                                children: [
                                  Text("Please select",
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                          fontSize: 11.0.sp)),
                                  Text(" at least",
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Color(constant.Color.crave_orange),
                                          fontSize: 11.0.sp)),
                                  Text(" 1",
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                          fontSize: 11.0.sp)),
                                ],
                              ),

                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 25.0,right:25.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFF2F2F2),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                topLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),

                            ),

                            // margin: const EdgeInsets.only(
                            //     top: 10.0),
                            padding: const EdgeInsets.only(
                                left: 10.0,right:10.0,top:10),
                            //height:70.0.h,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child:
                                  ListView.builder(
                                    padding:  EdgeInsets.only(right:10.0),
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: category1.length,
                                    itemBuilder: (BuildContext ctx, index) {
                                      return
                                        category1[index]['name'].toString().length != 1?
                                        Container(
                                            decoration: BoxDecoration(
                                              color: category1[index]['isSelected'] == true
                                                  ? Color(constant.Color.crave_blue)
                                                  : Color(0xFFF2F2F2),
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(10),
                                                topLeft: Radius.circular(10),
                                                bottomRight: Radius.circular(10),
                                                bottomLeft: Radius.circular(10),
                                              ),

                                            ),
                                            margin:  EdgeInsets.only(bottom:5.0),

                                            child: ListTile(
                                              dense: true,
                                              contentPadding: EdgeInsets.only(
                                                  left: 5.0,right:5.0),
                                              visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                                              onTap: () {
                                                // if this item isn't selected yet, "isSelected": false -> true
                                                // If this item already is selected: "isSelected": true -> false
                                                setState(() {
                                                  if(category1[index]['isSelected'] == true){
                                                    category1[index]['isSelected'] = false;
                                                  }
                                                  else{
                                                    category1[index]['isSelected'] = true;
                                                  }

                                                });
                                              },
                                              title:
                                              Text(
                                                  category1[index]['name'].toString(),
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: category1[index]['isSelected'] == true
                                                        ? Colors.white
                                                        : Colors.black,)
                                              ),

                                            )):
                                        index==0?
                                        Container(
                                          child:Text(
                                              category1[index]['name'].toString(),
                                              style: TextStyle(
                                                  color: Color(constant.Color.crave_orange),
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14.0.sp)
                                          ),
                                        ):
                                        Container(
                                          margin: const EdgeInsets.only(
                                              top: 10.0),
                                          child:Text(
                                              category1[index]['name'].toString(),
                                              style: TextStyle(
                                                  color: Color(constant.Color.crave_orange),
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14.0.sp)
                                          ),
                                        );
                                    },
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                      top: 5.0,bottom:10,right:10),
                                  child: VerticalDivider(
                                    color: Color(0xFFE0E0E0),thickness: 1,),
                                  height: 9.0.h,),

                                Expanded(
                                  child:  ListView.builder(
                                    padding:  EdgeInsets.only(right:10.0),
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: category2.length,
                                    itemBuilder: (BuildContext ctx, index) {
                                      return
                                        category2[index]['name'].toString().length != 1?
                                        Container(
                                            decoration: BoxDecoration(
                                              color: category2[index]['isSelected'] == true
                                                  ? Color(constant.Color.crave_blue)
                                                  : Color(0xFFF2F2F2),
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(10),
                                                topLeft: Radius.circular(10),
                                                bottomRight: Radius.circular(10),
                                                bottomLeft: Radius.circular(10),
                                              ),

                                            ),
                                            margin:  EdgeInsets.only(bottom:5.0),

                                            child: ListTile(
                                              dense: true,
                                              contentPadding: EdgeInsets.only(
                                                  left: 5.0,right:5.0),
                                              visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                                              onTap: () {
                                                // if this item isn't selected yet, "isSelected": false -> true
                                                // If this item already is selected: "isSelected": true -> false
                                                setState(() {
                                                  if(category2[index]['isSelected'] == true){
                                                    category2[index]['isSelected'] = false;
                                                  }
                                                  else{
                                                    category2[index]['isSelected'] = true;
                                                  }

                                                });
                                              },
                                              title:
                                              Text(
                                                  category2[index]['name'].toString().toUpperCase(),
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: category2[index]['isSelected'] == true
                                                        ? Colors.white
                                                        : Colors.black,)
                                              ),

                                            )):
                                        index==0?
                                        Container(
                                          child:Text(
                                              category2[index]['name'].toString().toUpperCase(),
                                              style: TextStyle(
                                                  color: Color(constant.Color.crave_orange),
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14.0.sp)
                                          ),
                                        ):
                                        Container(
                                          margin: const EdgeInsets.only(
                                              top: 10.0),
                                          child:Text(
                                              category2[index]['name'].toString().toUpperCase(),
                                              style: TextStyle(
                                                  color: Color(constant.Color.crave_orange),
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14.0.sp)
                                          ),
                                        );
                                    },
                                  ),
                                ),


                              ],
                            ),



                          ),
                        ),

                        //Type
                        Container(
                          width: double.maxFinite,
                          padding: const EdgeInsets.only(
                              left: 30.0,right:30.0,top:30,bottom:10),
                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Type",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(constant.Color.crave_orange),
                                      fontSize: 11.0.sp)),
                              Row(
                                children: [
                                  Text("Please select",
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                          fontSize: 11.0.sp)),
                                  Text(" at least",
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Color(constant.Color.crave_orange),
                                          fontSize: 11.0.sp)),
                                  Text(" 1",
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                          fontSize: 11.0.sp)),
                                ],
                              ),

                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 25.0,right:25.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFF2F2F2),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                topLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),

                            ),

                            // margin: const EdgeInsets.only(
                            //     top: 10.0),
                            padding: const EdgeInsets.only(
                                left: 10.0,right:10.0,top:10),
                            //height:70.0.h,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child:
                                  ListView.builder(
                                    padding:  EdgeInsets.only(right:10.0),
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: type1.length,
                                    itemBuilder: (BuildContext ctx, index) {
                                      return
                                        type1[index]['name'].toString().length != 1?
                                        Container(
                                            decoration: BoxDecoration(
                                              color: type1[index]['isSelected'] == true
                                                  ? Color(constant.Color.crave_blue)
                                                  : Color(0xFFF2F2F2),
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(10),
                                                topLeft: Radius.circular(10),
                                                bottomRight: Radius.circular(10),
                                                bottomLeft: Radius.circular(10),
                                              ),

                                            ),
                                            margin:  EdgeInsets.only(bottom:5.0),

                                            child: ListTile(
                                              dense: true,
                                              contentPadding: EdgeInsets.only(
                                                  left: 5.0,right:5.0),
                                              visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                                              onTap: () {
                                                // if this item isn't selected yet, "isSelected": false -> true
                                                // If this item already is selected: "isSelected": true -> false
                                                setState(() {
                                                  if(type1[index]['isSelected'] == true){
                                                    type1[index]['isSelected'] = false;
                                                  }
                                                  else{
                                                    type1[index]['isSelected'] = true;
                                                  }

                                                });
                                              },
                                              title:
                                              Text(
                                                  type1[index]['name'].toString().toUpperCase(),
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: type1[index]['isSelected'] == true
                                                        ? Colors.white
                                                        : Colors.black,)
                                              ),

                                            )):
                                        index==0?
                                        Container(
                                          child:Text(
                                              type1[index]['name'].toString().toUpperCase(),
                                              style: TextStyle(
                                                  color: Color(constant.Color.crave_orange),
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14.0.sp)
                                          ),
                                        ):
                                        Container(
                                          margin: const EdgeInsets.only(
                                              top: 10.0),
                                          child:Text(
                                              type1[index]['name'].toString().toUpperCase(),
                                              style: TextStyle(
                                                  color: Color(constant.Color.crave_orange),
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14.0.sp)
                                          ),
                                        );
                                    },
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                      top: 10.0,bottom:10,right:10),
                                  child: VerticalDivider(
                                    color: Color(0xFFE0E0E0),thickness: 1,),
                                  height: 15.0.h,),

                                Expanded(
                                  child:  ListView.builder(
                                    padding:  EdgeInsets.only(right:10.0),
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: type2.length,
                                    itemBuilder: (BuildContext ctx, index) {
                                      return
                                        type2[index]['name'].toString().length != 1?
                                        Container(
                                            decoration: BoxDecoration(
                                              color: type2[index]['isSelected'] == true
                                                  ? Color(constant.Color.crave_blue)
                                                  : Color(0xFFF2F2F2),
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(10),
                                                topLeft: Radius.circular(10),
                                                bottomRight: Radius.circular(10),
                                                bottomLeft: Radius.circular(10),
                                              ),

                                            ),
                                            margin:  EdgeInsets.only(bottom:5.0),

                                            child: ListTile(
                                              dense: true,
                                              contentPadding: EdgeInsets.only(
                                                  left: 5.0,right:5.0),
                                              visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                                              onTap: () {
                                                // if this item isn't selected yet, "isSelected": false -> true
                                                // If this item already is selected: "isSelected": true -> false
                                                setState(() {
                                                  if(type2[index]['isSelected'] == true){
                                                    type2[index]['isSelected'] = false;
                                                  }
                                                  else{
                                                    type2[index]['isSelected'] = true;
                                                  }

                                                });
                                              },
                                              title:
                                              Text(
                                                  type2[index]['name'].toString().toUpperCase(),
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: type2[index]['isSelected'] == true
                                                        ? Colors.white
                                                        : Colors.black,)
                                              ),

                                            )):
                                        index==0?
                                        Container(
                                          child:Text(
                                              type2[index]['name'].toString().toUpperCase(),
                                              style: TextStyle(
                                                  color: Color(constant.Color.crave_orange),
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14.0.sp)
                                          ),
                                        ):
                                        Container(
                                          margin: const EdgeInsets.only(
                                              top: 10.0),
                                          child:Text(
                                              type2[index]['name'].toString().toUpperCase(),
                                              style: TextStyle(
                                                  color: Color(constant.Color.crave_orange),
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14.0.sp)
                                          ),
                                        );
                                    },
                                  ),
                                ),


                              ],
                            ),



                          ),
                        ),

                        //Ambiance
                        Container(
                          width: double.maxFinite,
                          padding: const EdgeInsets.only(
                              left: 30.0,right:30.0,top:30,bottom:10),
                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Ambiance",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(constant.Color.crave_orange),
                                      fontSize: 11.0.sp)),
                              Row(
                                children: [
                                  Text("(Optional)",
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                          fontSize: 11.0.sp)),

                                ],
                              ),

                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 25.0,right:25.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFF2F2F2),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                topLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),

                            ),

                            // margin: const EdgeInsets.only(
                            //     top: 10.0),
                            padding: const EdgeInsets.only(
                                left: 10.0,right:10.0,top:10),
                            //height:70.0.h,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child:
                                  ListView.builder(
                                    padding:  EdgeInsets.only(right:10.0),
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: ambiance1.length,
                                    itemBuilder: (BuildContext ctx, index) {
                                      return
                                        ambiance1[index]['name'].toString().length != 1?
                                        Container(
                                            decoration: BoxDecoration(
                                              color: ambiance1[index]['isSelected'] == true
                                                  ? Color(constant.Color.crave_blue)
                                                  : Color(0xFFF2F2F2),
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(10),
                                                topLeft: Radius.circular(10),
                                                bottomRight: Radius.circular(10),
                                                bottomLeft: Radius.circular(10),
                                              ),

                                            ),
                                            margin:  EdgeInsets.only(bottom:5.0),

                                            child: ListTile(
                                              dense: true,
                                              contentPadding: EdgeInsets.only(
                                                  left: 5.0,right:5.0),
                                              visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                                              onTap: () {
                                                // if this item isn't selected yet, "isSelected": false -> true
                                                // If this item already is selected: "isSelected": true -> false
                                                setState(() {
                                                  if(ambiance1[index]['isSelected'] == true){
                                                    ambiance1[index]['isSelected'] = false;
                                                  }
                                                  else{
                                                    ambiance1[index]['isSelected'] = true;
                                                  }

                                                });
                                              },
                                              title:
                                              Text(
                                                  ambiance1[index]['name'].toString(),
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: ambiance1[index]['isSelected'] == true
                                                        ? Colors.white
                                                        : Colors.black,)
                                              ),

                                            )):
                                        index==0?
                                        Container(
                                          child:Text(
                                              ambiance1[index]['name'].toString(),
                                              style: TextStyle(
                                                  color: Color(constant.Color.crave_orange),
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14.0.sp)
                                          ),
                                        ):
                                        Container(
                                          margin: const EdgeInsets.only(
                                              top: 10.0),
                                          child:Text(
                                              ambiance1[index]['name'].toString(),
                                              style: TextStyle(
                                                  color: Color(constant.Color.crave_orange),
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14.0.sp)
                                          ),
                                        );
                                    },
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                      top: 10.0,bottom:10,right:10),
                                  child: VerticalDivider(
                                    color: Color(0xFFE0E0E0),thickness: 1,),
                                  height: 15.0.h,),

                                Expanded(
                                  child:  ListView.builder(
                                    padding:  EdgeInsets.only(right:10.0),
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: ambiance2.length,
                                    itemBuilder: (BuildContext ctx, index) {
                                      return
                                        ambiance2[index]['name'].toString().length != 1?
                                        Container(
                                            decoration: BoxDecoration(
                                              color: ambiance2[index]['isSelected'] == true
                                                  ? Color(constant.Color.crave_blue)
                                                  : Color(0xFFF2F2F2),
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(10),
                                                topLeft: Radius.circular(10),
                                                bottomRight: Radius.circular(10),
                                                bottomLeft: Radius.circular(10),
                                              ),

                                            ),
                                            margin:  EdgeInsets.only(bottom:5.0),

                                            child: ListTile(
                                              dense: true,
                                              contentPadding: EdgeInsets.only(
                                                  left: 5.0,right:5.0),
                                              visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                                              onTap: () {
                                                // if this item isn't selected yet, "isSelected": false -> true
                                                // If this item already is selected: "isSelected": true -> false
                                                setState(() {
                                                  if(ambiance2[index]['isSelected'] == true){
                                                    ambiance2[index]['isSelected'] = false;
                                                  }
                                                  else{
                                                    ambiance2[index]['isSelected'] = true;
                                                  }

                                                });
                                              },
                                              title:
                                              Text(
                                                  ambiance2[index]['name'].toString().toUpperCase(),
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: ambiance2[index]['isSelected'] == true
                                                        ? Colors.white
                                                        : Colors.black,)
                                              ),

                                            )):
                                        index==0?
                                        Container(
                                          child:Text(
                                              ambiance2[index]['name'].toString().toUpperCase(),
                                              style: TextStyle(
                                                  color: Color(constant.Color.crave_orange),
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14.0.sp)
                                          ),
                                        ):
                                        Container(
                                          margin: const EdgeInsets.only(
                                              top: 10.0),
                                          child:Text(
                                              ambiance2[index]['name'].toString().toUpperCase(),
                                              style: TextStyle(
                                                  color: Color(constant.Color.crave_orange),
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14.0.sp)
                                          ),
                                        );
                                    },
                                  ),
                                ),


                              ],
                            ),



                          ),
                        ),

                        Container(
                            width:45.w,
                            height:6.h,
                            margin: const EdgeInsets.only(top:30.0,bottom:30.0),
                            child: ElevatedButton(
                                child: Text(
                                    "Confirm".toUpperCase(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14.0.sp)
                                ),
                                style: ButtonStyle(
                                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                    backgroundColor: MaterialStateProperty.all<Color>(const Color(constant.Color.crave_orange)),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5.0),
                                            side: const BorderSide(color: Color(constant.Color.crave_orange))
                                        )
                                    )
                                ),
                                onPressed: () => Navigator.pop(context)
                            )
                        ),

                      ],
                    ),
                    // Align(
                    //   alignment: Alignment.bottomCenter,
                    //   child:
                    // ),
                  ],
                ),
              ),


            );
          });
        });
  }

  Widget createFollowersList(mystate,mediaId){

    followersWidget.clear();
    followersWidget.add(
      Container(
        //width:250,
        height:55,
        margin: const EdgeInsets.only(bottom: 15.0),
        padding: const EdgeInsets.only(left: 30.0, right: 30.0,top:20),
        child:TextField(
          autofocus: false,
          controller: textController,
          cursorColor: Colors.black,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.go,
          textCapitalization: TextCapitalization.sentences,
          onChanged: (value) {
            print(value);
            print(duplicateItems.length);
            List<Followers> dummySearchList = [];
            dummySearchList.addAll(duplicateItems);
            if(value.isNotEmpty) {
              List<Followers> dummyListData = [];
              dummySearchList.forEach((item) {
                if(item.f_display_name.contains(value)) {
                  dummyListData.add(item);
                }
              });
              mystate(() {
                returnedFollowers.clear();
                returnedFollowers.addAll(dummyListData);
              });
              return;
            } else {
              print("in else");
              print(duplicateItems);
              mystate(() {
                returnedFollowers.clear();
                returnedFollowers.addAll(duplicateItems);
              });
            }
          },
          decoration: InputDecoration(
              counterText: '',
              filled: true,
              // Color(0xFFD6D6D6)
              fillColor: Color(0xFFF2F2F2),
              contentPadding:EdgeInsets.symmetric(horizontal: 15,vertical:0),
              labelStyle: TextStyle(
                  fontSize: 14,
                  color:Colors.black
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color:Color(0xFFF2F2F2),),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color:Color(0xFFF2F2F2),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color:Color(0xFFF2F2F2),),
              ),
              suffixIcon: Icon(
                Icons.search,
                color: Colors.grey,
                size: 20.0,
              ),
              hintStyle: TextStyle(
                  fontSize: 14,
                  color:Colors.grey[400]),
              hintText: "Search"),
        ),
      ),
    );
    for(int i=0;i<returnedFollowers.length;i++){
      isChecked.add(false);
      followersWidget.add(
        Padding(
          padding: const EdgeInsets.only(bottom:15, left:30, right:30),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28.0,
                backgroundImage:
                NetworkImage(constant.Url.profile_url+returnedFollowers[i].f_profile_img),
                backgroundColor: Colors.transparent,
              ),
              SizedBox(width:3.0.w),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(returnedFollowers[i].f_display_name,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(constant.Color.crave_brown),
                          fontSize: 11.0.sp)),
                  SizedBox(height:3),
                  Text(returnedFollowers[i].f_username,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 9.0.sp)),
                ],
              ),
              Spacer(),
              Transform.scale(
                scale: 1.3,
                child:Checkbox(
                  checkColor: Colors.white,
                  //fillColor: MaterialStateProperty.all(Color(0xFF2CBFC6)),
                  activeColor:Color(constant.Color.crave_blue),
                  value: isChecked[i],
                  shape: CircleBorder(
                  ),
                  onChanged: (bool? value) {
                    mystate(() {
                      isChecked[i] = value!;
                      if(isChecked[i]){
                        shareToFollowers.add(returnedFollowers[i].f_email);
                      }
                      else{
                        shareToFollowers.remove(returnedFollowers[i].f_email);
                      }
                      print(isChecked[i]);
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }
    followersWidget.add(
      Padding(
        padding: const EdgeInsets.only(bottom:50,top:10),
        child:SizedBox(
            width:55.0.w,
            height:5.h,
            child: ElevatedButton(
                child: Text(
                    "Confirm".toUpperCase(),
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15.0.sp)
                ),
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(44, 191, 198, 1.0)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: const BorderSide(color: Color.fromRGBO(44, 191, 198, 1.0))
                        )
                    )
                ),
                onPressed: () => shareToFollower(mediaId)
            )
        ),
      ),
    );
    return SingleChildScrollView(
      child:Container(
        // padding:
        padding: MediaQuery.of(context).viewInsets,
        //height:30.0.h,
        child:Column(
          children: followersWidget,
          // [
          //   Container(
          //     //width:250,
          //     height:55,
          //     margin: const EdgeInsets.only(bottom: 15.0),
          //     padding: const EdgeInsets.only(left: 30.0, right: 30.0,top:20),
          //     child:TextField(
          //       autofocus: false,
          //       controller: textController,
          //       cursorColor: Colors.black,
          //       keyboardType: TextInputType.text,
          //       textInputAction: TextInputAction.go,
          //       textCapitalization: TextCapitalization.sentences,
          //       decoration: InputDecoration(
          //           counterText: '',
          //           filled: true,
          //           // Color(0xFFD6D6D6)
          //           fillColor: Color(0xFFF2F2F2),
          //           contentPadding:EdgeInsets.symmetric(horizontal: 15,vertical:0),
          //           labelStyle: TextStyle(
          //               fontSize: 14,
          //               color:Colors.black
          //           ),
          //           enabledBorder: OutlineInputBorder(
          //             borderRadius: BorderRadius.all(Radius.circular(10)),
          //             borderSide: BorderSide(color:Color(0xFFF2F2F2),),
          //           ),
          //           border: OutlineInputBorder(
          //             borderRadius: BorderRadius.all(Radius.circular(10)),
          //             borderSide: BorderSide(color:Color(0xFFF2F2F2),
          //             ),
          //           ),
          //           focusedBorder: OutlineInputBorder(
          //             borderRadius: BorderRadius.all(Radius.circular(10)),
          //             borderSide: BorderSide(color:Color(0xFFF2F2F2),),
          //           ),
          //           suffixIcon: Icon(
          //             Icons.search,
          //             color: Colors.grey,
          //             size: 20.0,
          //           ),
          //           hintStyle: TextStyle(
          //               fontSize: 14,
          //               color:Colors.grey[400]),
          //           hintText: "Search"),
          //     ),
          //   ),
          //   Padding(
          //     padding: const EdgeInsets.only(bottom:15, left:30, right:30),
          //     child: Row(
          //       children: [
          //         Image.asset(
          //           'images/user1.png',
          //           height: 6.0.h,
          //         ),
          //         SizedBox(width:3.0.w),
          //         Column(
          //           mainAxisAlignment: MainAxisAlignment.start,
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Text('KARMENNDESU',
          //                 style: TextStyle(
          //                     fontWeight: FontWeight.w700,
          //                     color: Color(constant.Color.crave_brown),
          //                     fontSize: 11.0.sp)),
          //             SizedBox(height:3),
          //             Text('LEE KARMEN',
          //                 style: TextStyle(
          //                     color: Colors.black,
          //                     fontSize: 9.0.sp)),
          //           ],
          //         ),
          //         Spacer(),
          //         Transform.scale(
          //           scale: 1.3,
          //           child:Checkbox(
          //             checkColor: Colors.white,
          //             //fillColor: MaterialStateProperty.all(Color(0xFF2CBFC6)),
          //             activeColor:Color(constant.Color.crave_blue),
          //             value: isChecked1,
          //             shape: CircleBorder(
          //             ),
          //             onChanged: (bool? value) {
          //               mystate(() {
          //                 isChecked1 = value!;
          //               });
          //             },
          //           ),
          //         ),
          //
          //       ],
          //     ),
          //   ),
          //   Padding(
          //     padding: const EdgeInsets.only(bottom:15, left:30, right:30),
          //     child:  Row(
          //       children: [
          //         Image.asset(
          //           'images/user1.png',
          //           height: 6.0.h,
          //         ),
          //         SizedBox(width:3.0.w),
          //         Column(
          //           mainAxisAlignment: MainAxisAlignment.start,
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Text('KARMENNDESU',
          //                 style: TextStyle(
          //                     fontWeight: FontWeight.w700,
          //                     color: Color(constant.Color.crave_brown),
          //                     fontSize: 11.0.sp)),
          //             SizedBox(height:3),
          //             Text('LEE KARMEN',
          //                 style: TextStyle(
          //                     color: Colors.black,
          //                     fontSize: 9.0.sp)),
          //           ],
          //         ),
          //         Spacer(),
          //         Transform.scale(
          //           scale: 1.3,
          //           child:Checkbox(
          //             checkColor: Colors.white,
          //             //fillColor: MaterialStateProperty.all(Color(0xFF2CBFC6)),
          //             activeColor:Color(constant.Color.crave_blue),
          //             value: isChecked2,
          //             shape: CircleBorder(
          //             ),
          //             onChanged: (bool? value) {
          //               mystate(() {
          //                 isChecked2 = value!;
          //               });
          //             },
          //           ),
          //         ),
          //
          //       ],
          //     ),
          //   ),
          //   Padding(
          //     padding: const EdgeInsets.only(bottom:15, left:30, right:30),
          //     child:  Row(
          //       children: [
          //         Image.asset(
          //           'images/user1.png',
          //           height: 6.0.h,
          //         ),
          //         SizedBox(width:3.0.w),
          //         Column(
          //           mainAxisAlignment: MainAxisAlignment.start,
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Text('KARMENNDESU',
          //                 style: TextStyle(
          //                     fontWeight: FontWeight.w700,
          //                     color: Color(constant.Color.crave_brown),
          //                     fontSize: 11.0.sp)),
          //             SizedBox(height:3),
          //             Text('LEE KARMEN',
          //                 style: TextStyle(
          //                     color: Colors.black,
          //                     fontSize: 9.0.sp)),
          //           ],
          //         ),
          //         Spacer(),
          //         Transform.scale(
          //           scale: 1.3,
          //           child:Checkbox(
          //             checkColor: Colors.white,
          //             //fillColor: MaterialStateProperty.all(Color(0xFF2CBFC6)),
          //             activeColor:Color(constant.Color.crave_blue),
          //             value: isChecked3,
          //             shape: CircleBorder(
          //             ),
          //             onChanged: (bool? value) {
          //               mystate(() {
          //                 isChecked3 = value!;
          //               });
          //             },
          //           ),
          //         ),
          //
          //       ],
          //     ),
          //   ),
          //   Padding(
          //     padding: const EdgeInsets.only(bottom:50,top:10),
          //     child:SizedBox(
          //         width:55.0.w,
          //         height:5.h,
          //         child: ElevatedButton(
          //             child: Text(
          //                 "Confirm".toUpperCase(),
          //                 style: TextStyle(
          //                     fontWeight: FontWeight.w700,
          //                     fontSize: 15.0.sp)
          //             ),
          //             style: ButtonStyle(
          //                 foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          //                 backgroundColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(44, 191, 198, 1.0)),
          //                 shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          //                     RoundedRectangleBorder(
          //                         borderRadius: BorderRadius.circular(8.0),
          //                         side: const BorderSide(color: Color.fromRGBO(44, 191, 198, 1.0))
          //                     )
          //                 )
          //             ),
          //             onPressed: () => null
          //         )
          //     ),
          //   ),
          //
          // ],
        ),

      ),
    );

  }

  void onShareFeed(String mediaId){
    isChecked.clear();
    shareToFollowers.clear();
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (context) {
          // bool isChecked1 = true;
          // bool isChecked2 = false;
          // bool isChecked3 = true;
          return StatefulBuilder(builder: (BuildContext context, StateSetter mystate) {

            return createFollowersList(mystate,mediaId);
          });

        }).whenComplete(() {
      setState(() {
        textController.clear();
        loadFollowers();
      });
      print('Hey there, I\'m calling after hide bottomSheet');
    });
  }

  void startLoad() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUserId = prefs.getString('user_email')!;
    });
    scrollDown();
    print(MediaQuery.of(context).size.width);
    loadFollowers();

    setState(() {
      currentCraveList = this.widget.craveList;
      print("currentCraveList---");
      print(currentCraveList.length);
      for(int k=0;k<currentCraveList.length;k++){
        currentCraveListChecked.add(false);
      }

      for (int i = 0; i < this.widget.medias.length; i++){
        post_likes_list.add(this.widget.medias[i].post_likes_user);
        post_likes.add(this.widget.medias[i].post_likes);
        post_crave_list.add(this.widget.medias[i].post_craving_user);
        post_crave.add(this.widget.medias[i].post_craving);
        isShowStats.add(false);
        isShowOptions.add(false);
        isShowCraveList.add(false);
      }

    });
  }

  Future<http.Response> likePost(int index) async {
      var url = Uri.parse(constant.Url.crave_url+'like_post.php');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final http.Response response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        },
        body: {
          "email":prefs.getString('user_email'),
          "post_id":this.widget.medias[index].media_id,
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
          setState(() {
            if(user['message'] == "Success like"){
              post_likes_list[index] = "1";
            }
            else{
              post_likes_list[index] = "0";
            }

            post_likes[index] = user['current_likes'];

          });
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

  Future<http.Response> cravePost(int index) async {
    var url = Uri.parse(constant.Url.crave_url+'crave_post.php');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        "email":prefs.getString('user_email'),
        "post_id":this.widget.medias[index].media_id,
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
        setState(() {
          if(user['message'] == "Success crave"){
            post_crave_list[index] = "1";
          }
          else{
            post_crave_list[index] = "0";
          }

          post_crave[index] = user['current_crave'].toString();

        });
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

  Future<http.Response> followUser(String user_following,index) async {
    var url = Uri.parse(constant.Url.crave_url+'send_follow_user.php');
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
        setState(() {
          if(this.widget.medias[index].is_follow == "0"){
            for(int k=0;k<this.widget.medias.length;k++){
              if(this.widget.medias[k].user_display_name == this.widget.medias[index].user_display_name){
                this.widget.medias[k].is_follow = "1";
              }
            }

          }
          else{
            for(int k=0;k<this.widget.medias.length;k++){
              if(this.widget.medias[k].user_display_name == this.widget.medias[index].user_display_name){
                this.widget.medias[k].is_follow = "0";
              }
            }

          }
        });

        // this.widget.onLoadMedia();
        // scrollDown();
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
          returnedFollowers = followers;
          duplicateItems = dummyfollowers;

        });

        print(returnedFollowers);
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

  Future<http.Response> shareToFollower(String mediaId) async {

    if(shareToFollowers.isNotEmpty){
      var url = Uri.parse(constant.Url.crave_url+'send_share.php');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final http.Response response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        },
        body: {
          "email":prefs.getString('user_email'),
          "followersList":jsonEncode(shareToFollowers),
          "mediaId":mediaId
        },
      );

      log("send sherarea");
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
          Fluttertoast.showToast(
              msg: "Feed shared!",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0
          );
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
    }
    else{
      Navigator.pop(context);
    }

    throw Exception('Failed to send data');
  }

  Future<http.Response> createList() async {
    var url = Uri.parse(constant.Url.crave_url+'send_crave_list.php');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        "email":prefs.getString('user_email'),
        "list_name":addListTxtController.text,
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
        setState(() {
          print("load aftererer");
          loadCraveList();
          addListTxtController.text = "";
          Fluttertoast.showToast(
              msg: "Created a new crave's list!",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0
          );
        });


        // Navigator.pop(context);
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

  Future<List<CraveList>> loadCraveList() async {
    // showAlertDialog(context);
    print("load crave list");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('user_email'));
    var url = Uri.parse(constant.Url.crave_url+'get_crave_lists.php');
    currentCraveList.clear();
    currentCraveListChecked.clear();
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
      print("get response crave list");
      print(response.body);

      Map<String, dynamic> user = jsonDecode(response.body);

      if(user['crave'] != null){

        List<dynamic> body = user['crave'];

        List<CraveList> craveList = body
            .map(
              (dynamic item) => CraveList.fromJson(item),
        ).toList();

        setState(() {
          //isCarAvailable = true;
          // selectedMedia = media[0];
          currentCraveList = craveList;
          print("currentCraveList---1111");
          print(currentCraveList.length);

          for(int k=0;k<currentCraveList.length;k++){
            currentCraveListChecked.add(false);
          }
          // Navigator.of(context, rootNavigator: true).pop('dialog');
        });


        //suggestions = location;
        // print("--avaialbel carr---");
        print(currentCraveList);
        return currentCraveList;
      }
      else{
        setState(() {
          // isCarAvailable = false;
          //carList.;
        });

        return [];
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }

  }

  Future<http.Response> addToCraveListContent(String mediaId) async {

    if(addToCraveList.isNotEmpty){
      var url = Uri.parse(constant.Url.crave_url+'send_crave_list_content.php');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final http.Response response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        },
        body: {
          "email":prefs.getString('user_email'),
          "craveList":jsonEncode(addToCraveList),
          "mediaId":mediaId
        },
      );

      log("send sherarea");
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
          Fluttertoast.showToast(
              msg: "Added to crave list!",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0
          );
        }

      } else {
        // If the server did not return a 201 CREATED response,
        // then throw an exception.
        print(response.body);
        print(response.statusCode);
        // Navigator.of(context, rootNavigator: true).pop('dialog');
//        List<String> return_res = new List<String>.from(user['response']);
//        log(return_res[0]);
        throw Exception('Failed to send data');
      }
      return response;
    }

    throw Exception('Failed to send data');

  }

  void scrollDown() {
    print("in scroll down!");
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
    double contentHeight = MediaQuery.of(context).size.height > 700 ? MediaQuery.of(context).size.height * 0.89 : MediaQuery.of(context).size.height * 0.85;


    print("aksbdabsoajsodn");
    setState(() {
      print( MyHomepage.of(context)!.getselectedMediaIndex());
      _scrollController.jumpTo(MyHomepage.of(context)!.getselectedMediaIndex() * (MediaQuery.of(context).size.height * 0.6));
    });

  }

  void onClickNotInterested(){
    Fluttertoast.showToast(
        msg: "Sorry you are not interested in this post",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  void onClickReportNotFood(){
    Fluttertoast.showToast(
        msg: "Report has been sent",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  Color stringToColor(colorString){
    String valueString = colorString.split('(0x')[1].split(')')[0]; // kind of hacky..
    int value = int.parse(valueString, radix: 16);
    Color otherColor = new Color(value);
    return otherColor;
  }

  TextAlign getTextAlign(align){

    TextAlign textAlign = TextAlign.values.firstWhere((e) => e.toString() == align);
    return textAlign;
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);

    var maxWidth = 500.0;
    var width = MediaQuery.of(context).size.width;
    var columns = (width ~/ maxWidth) + 1;
    var columnWidth = width / columns;
    var aspectRatio = columnWidth / 390;

    final screenSize = MediaQuery.of(context).size;

    return WillPopScope(
        onWillPop:()async{
          // this.widget.homepageController.jumpToPage(0);
          this.widget.homepageController.animateTo(0, duration: new Duration(milliseconds: 100), curve: Curves.easeOut);
          return false;
        },
        child:LayoutBuilder(
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
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(20),
                                            bottomLeft: Radius.circular(20),
                                          ),
                                          border: Border.all(
                                            width: 2,
                                            color: Color(constant.Color.crave_grey),
                                            style: BorderStyle.solid,
                                          ),
                                        ),
                                        child:Stack(
                                          children: [
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    top: 55.0,left:30),
                                                //width:MediaQuery.of(context).size.width,
                                                child:GestureDetector(
                                                    onTap:(){
                                                      // Navigator.pop(context);
                                                      // this.widget.homepageController.jumpToPage(0);
                                                      this.widget.homepageController.animateTo(0, duration: new Duration(milliseconds: 100), curve: Curves.easeOut);
                                                    },
                                                    child:
                                                    Icon(Icons.arrow_back_ios,size: 25,color: Colors.grey,)
                                                ),
                                              ),
                                            ),

                                            Align(
                                              alignment: Alignment.center,
                                              child:Container(
                                                  padding: const EdgeInsets.only(
                                                      top: 50.0,bottom:10),
                                                  //width:MediaQuery.of(context).size.width,
                                                  child:Image.asset(
                                                    'images/crave_logo_word.png',
                                                    height: 4.5.h,
                                                  )
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
                                          itemCount: this.widget.medias.length,
                                          controller: _scrollController,
                                          // display each item of the product list
                                          itemBuilder: (context, index) {
                                              return
                                                Padding(
                                                  padding: EdgeInsets.only(top:index!=0?10:0),
                                                  // child:Card(
                                                  //   margin:EdgeInsets.zero,
                                                  //   shape: RoundedRectangleBorder(
                                                  //     borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                                  //   ),
                                                    child:Container(
                                                      //color:Colors.black,
                                                      padding: const EdgeInsets.only(bottom:0,top:10),
                                                      child:Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Container(
                                                            padding: const EdgeInsets.only(left:15,right:17),
                                                            child:Row(
                                                              children: [
                                                                GestureDetector(
                                                                  onTap:(){
                                                                    this.widget.onSelectUser(this.widget.medias[index].media_user_id);
                                                                  },
                                                                  child:CircleAvatar(
                                                                    radius: 28.0,
                                                                    backgroundImage:
                                                                    NetworkImage(constant.Url.profile_url+this.widget.medias[index].user_profile_img),
                                                                    backgroundColor: Colors.transparent,
                                                                  ),
                                                                ),

                                                                // Image.network(constant.Url.profile_url+this.widget.medias[index].user_profile_img,height:6.0.h),
                                                                // Image.asset(
                                                                //   'images/user1.png',
                                                                //   height: 6.0.h,
                                                                // ),
                                                                Padding(
                                                                  padding: const EdgeInsets.only(left:5),
                                                                  child:Column(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      IntrinsicHeight(
                                                                          child:Row(
                                                                            children: [
                                                                              GestureDetector(
                                                                                onTap:(){
                                                                                  this.widget.onSelectUser(this.widget.medias[index].media_user_id);
                                                                                },
                                                                                child: Text(this.widget.medias[index].user_display_name,
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.w700,
                                                                                        color: Colors.black,
                                                                                        fontSize: 10.0.sp)),
                                                                              ),

                                                                              Padding(
                                                                                padding: EdgeInsets.only(left: 5.0),
                                                                                child:Image.asset(
                                                                                  'images/verified_logo.png',
                                                                                  height: 2.0.h,
                                                                                ),
                                                                              ),

                                                                              Container(
                                                                                padding: const EdgeInsets.only(left:5,right:5,top:2,bottom:2),
                                                                                child:VerticalDivider(
                                                                                  color: Colors.black,
                                                                                ),
                                                                              ),
                                                                              GestureDetector(
                                                                                onTap:(){
                                                                                  followUser(this.widget.medias[index].media_user_id,index);
                                                                                },
                                                                                child:
                                                                                this.widget.medias[index].is_follow=="0"?
                                                                                Text('Follow',
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.w700,
                                                                                        color:Color(constant.Color.crave_orange),
                                                                                        fontSize: 11.0.sp)):
                                                                                Text('Following',
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.w700,
                                                                                        color:Color(constant.Color.crave_blue),
                                                                                        fontSize: 11.0.sp)),
                                                                              ),

                                                                            ],
                                                                          )
                                                                      ),
                                                                      Padding(
                                                                          padding: const EdgeInsets.only(top:5),
                                                                          child:IntrinsicHeight(
                                                                              child:Row(
                                                                                children: [
                                                                                  Image.asset(
                                                                                    'images/location_icon.png',
                                                                                    height: 2.0.h,
                                                                                  ),
                                                                                  Container(
                                                                                    width:60.0.w,
                                                                                    padding: const EdgeInsets.only(left:5),
                                                                                    child: Text(this.widget.medias[index].media_location.replaceAll('', '\u200B'),
                                                                                      style: TextStyle(
                                                                                          fontSize: 9.0.sp),
                                                                                      overflow: TextOverflow.ellipsis,),
                                                                                  ),


                                                                                ],
                                                                              )
                                                                          )
                                                                      ),


                                                                    ],
                                                                  ),
                                                                ),
                                                                Spacer(),
                                                                GestureDetector(
                                                                  onTap:(){
                                                                    onShareFeed(this.widget.medias[index].media_id);
                                                                  },
                                                                  child: Image.asset(
                                                                    'images/forward_icon.png',
                                                                    height: 2.3.h,
                                                                  ),
                                                                ),

                                                                GestureDetector(
                                                                  onTap:(){
                                                                    showOptions(index);
                                                                  },
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.only(left:10),
                                                                    child: Image.asset(
                                                                        'images/others_icon.png',
                                                                        height: 1.0.h,
                                                                        width:5.0.w
                                                                    ),
                                                                  ),
                                                                ),

                                                              ],

                                                            ),
                                                          ),

                                                          GestureDetector(
                                                            onTap:(){
                                                              goToComments(index);
                                                            },
                                                            onLongPress : (){
                                                              showStats(index);
                                                            },
                                                            onDoubleTap: (){
                                                              likePost(index);
                                                            },
                                                            child:Container(
                                                              height:35.0.h,
                                                              margin: const EdgeInsets.only(bottom:23,top:10),
                                                              // decoration: BoxDecoration(
                                                              //   image: DecorationImage(image: NetworkImage(constant.Url.media_url+this.widget.medias[index].media_name), fit: BoxFit.cover),
                                                              // ),
                                                              child:Stack(
                                                                  children:[
                                                                    Container(
                                                                      height:35.0.h,
                                                                      child:PinchZoom(
                                                                        child:
                                                                        Container(
                                                                          // height: 100.0.h,
                                                                          // width: 100.0.w,
                                                                          // margin: EdgeInsets.only(left:15.0.w,bottom:40.0.w),
                                                                          // padding: EdgeInsets.only(top:30.w,right:15.0.w),
                                                                          decoration:
                                                                          BoxDecoration(
                                                                              // color:Colors.yellow,
                                                                              image: DecorationImage(
                                                                                  fit:BoxFit.fitWidth,
                                                                                  image: NetworkImage(constant.Url.media_url+this.widget.medias[index].media_name))),
                                                                          child: Center(
                                                                            child: Text(
                                                                              this.widget.medias[index].c_textfilter,
                                                                              // style: getTextStyle(returnedStories[i].storyItems[k].cTextStyle),
                                                                              style: TextStyle(
                                                                                  fontSize: this.widget.medias[index].c_textSize!=''?double.parse(this.widget.medias[index].c_textSize):0,
                                                                                  color: this.widget.medias[index].c_textColor!=''?stringToColor(this.widget.medias[index].c_textColor):Colors.transparent,
                                                                                  backgroundColor: this.widget.medias[index].c_textBgColor!=''?stringToColor(this.widget.medias[index].c_textBgColor):Colors.transparent,
                                                                                  fontFamily: this.widget.medias[index].c_textFamily!=''?this.widget.medias[index].c_textFamily:'Billabong'
                                                                              ),
                                                                              textAlign: getTextAlign(this.widget.medias[index].c_textalign),
                                                                            ),
                                                                          ),

                                                                        ),
                                                                        resetDuration: const Duration(milliseconds: 100),
                                                                        maxScale: 2.5,
                                                                        onZoomStart: (){print('Start zooming');},
                                                                        onZoomEnd: (){print('Stop zooming');},
                                                                      ),
                                                                    ),

                                                                    isShowStats[index]?
                                                                    Container(
                                                                        color:Colors.black45,
                                                                        padding: const EdgeInsets.only(top:25),
                                                                        height:35.0.h,
                                                                        width:screenSize.width,
                                                                        child:Column(
                                                                          children: [
                                                                            GestureDetector(
                                                                              onTap:(){
                                                                                showStatsPopup(index);
                                                                              },
                                                                              child:Container(
                                                                                height:15.0.h,
                                                                                width:70.0.w,
                                                                                decoration: BoxDecoration(
                                                                                  color:Color(constant.Color.crave_blue),
                                                                                  borderRadius: BorderRadius.only(
                                                                                    topRight: Radius.circular(10.0),
                                                                                    topLeft: Radius.circular(10.0),),
                                                                                ),

                                                                                child:Center(
                                                                                  child:Text('STATISTICS',
                                                                                      textAlign: TextAlign.center,
                                                                                      style: TextStyle(
                                                                                          fontWeight: FontWeight.w700,
                                                                                          color: Colors.white,
                                                                                          fontSize: 12.0.sp)),
                                                                                ),

                                                                              ),
                                                                            ),

                                                                            GestureDetector(
                                                                              onTap:(){
                                                                                showTravelTo(index);
                                                                              },
                                                                              child:Container(
                                                                                height:15.0.h,
                                                                                width:70.0.w,
                                                                                decoration: BoxDecoration(
                                                                                  color:Color(constant.Color.crave_orange),
                                                                                  borderRadius: BorderRadius.only(
                                                                                    bottomRight: Radius.circular(10.0),
                                                                                    bottomLeft: Radius.circular(10.0),),
                                                                                ),
                                                                                child:Center(
                                                                                  child:Text('TRAVEL TO',
                                                                                      textAlign: TextAlign.center,
                                                                                      style: TextStyle(
                                                                                          fontWeight: FontWeight.w700,
                                                                                          color: Colors.white,
                                                                                          fontSize: 12.0.sp)),
                                                                                ),
                                                                              )
                                                                            ),

                                                                          ],
                                                                        )

                                                                    ):
                                                                    Container(),
                                                                    isShowOptions[index]?
                                                                    Wrap(
                                                                          children: [
                                                                            this.widget.medias[index].media_user_id != currentUserId?
                                                                            Container(
                                                                                padding: const EdgeInsets.only(top:10,bottom:25),
                                                                                margin: EdgeInsets.only(top:10,left:10,right:10),
                                                                                // height:22.0.h,
                                                                                width:screenSize.width,
                                                                                decoration: BoxDecoration(
                                                                                  color:Colors.black.withOpacity(0.75),
                                                                                  borderRadius: BorderRadius.only(
                                                                                    bottomRight: Radius.circular(20),
                                                                                    bottomLeft: Radius.circular(20),
                                                                                    topRight: Radius.circular(20),
                                                                                    topLeft: Radius.circular(20),
                                                                                  ),
                                                                                ),
                                                                                child:Column(
                                                                                  // mainAxisAlignment: MainAxisAlignment.end,
                                                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                                                  children: [
                                                                                    GestureDetector(
                                                                                      onTap:(){
                                                                                        hideOptions(index);
                                                                                      },
                                                                                      child:Container(
                                                                                          padding: const EdgeInsets.only(top:5,right:20),
                                                                                          child:Icon(Icons.close,size: 20,color:Colors.white)
                                                                                      ),
                                                                                    ),
                                                                                    GestureDetector(
                                                                                      onTap:(){
                                                                                        showCraveList(index);
                                                                                      },
                                                                                      child:Container(
                                                                                        padding: const EdgeInsets.only(top:10,left:20),
                                                                                        child:Row(
                                                                                          children: [
                                                                                            Image.asset('images/icon_add_to_crave.png',height: 25,),
                                                                                            SizedBox(width:15),
                                                                                            Row(
                                                                                              children: [
                                                                                                Text('Add to ',
                                                                                                    textAlign: TextAlign.center,
                                                                                                    style: TextStyle(
                                                                                                        fontWeight: FontWeight.w600,
                                                                                                        color: Colors.white,
                                                                                                        fontSize: 16.0.sp)),
                                                                                                Text("Crave's ",
                                                                                                    textAlign: TextAlign.center,
                                                                                                    style: TextStyle(
                                                                                                        fontWeight: FontWeight.w600,
                                                                                                        color: Color(constant.Color.crave_orange),
                                                                                                        fontSize: 16.0.sp)),
                                                                                                Text('List',
                                                                                                    textAlign: TextAlign.center,
                                                                                                    style: TextStyle(
                                                                                                        fontWeight: FontWeight.w600,
                                                                                                        color: Colors.white,
                                                                                                        fontSize: 16.0.sp)),
                                                                                              ],
                                                                                            ),

                                                                                          ],
                                                                                        ),


                                                                                      ),
                                                                                    ),

                                                                                    GestureDetector(
                                                                                      onTap:onClickNotInterested,
                                                                                      child:Container(
                                                                                        padding: const EdgeInsets.only(top:20,left:20),
                                                                                        child:Row(
                                                                                          children: [
                                                                                            Image.asset('images/icon_not_interested.png',height: 25,),
                                                                                            SizedBox(width:15),
                                                                                            Text('Not interested',
                                                                                                textAlign: TextAlign.center,
                                                                                                style: TextStyle(
                                                                                                    fontWeight: FontWeight.w600,
                                                                                                    color: Colors.white,
                                                                                                    fontSize: 16.0.sp)),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),


                                                                                    GestureDetector(
                                                                                      onTap:onClickReportNotFood,
                                                                                      child:Container(
                                                                                        padding: const EdgeInsets.only(top:20,left:20),
                                                                                        child:Row(
                                                                                          children: [
                                                                                            Image.asset('images/icon_report_not_food.png',height: 25,),
                                                                                            SizedBox(width:15),
                                                                                            Text('Report not food',
                                                                                                textAlign: TextAlign.center,
                                                                                                style: TextStyle(
                                                                                                    fontWeight: FontWeight.w600,
                                                                                                    color: Colors.white,
                                                                                                    fontSize: 16.0.sp)),
                                                                                          ],
                                                                                        ),
                                                                                      )
                                                                                    ),

                                                                                  ],
                                                                                )

                                                                            ):
                                                                            Container(
                                                                                padding: const EdgeInsets.only(top:10,bottom:25),
                                                                                margin: EdgeInsets.only(top:10,left:10,right:10),
                                                                                // height:22.0.h,
                                                                                width:screenSize.width,
                                                                                decoration: BoxDecoration(
                                                                                  color:Colors.black.withOpacity(0.75),
                                                                                  borderRadius: BorderRadius.only(
                                                                                    bottomRight: Radius.circular(20),
                                                                                    bottomLeft: Radius.circular(20),
                                                                                    topRight: Radius.circular(20),
                                                                                    topLeft: Radius.circular(20),
                                                                                  ),
                                                                                ),
                                                                                child:Column(
                                                                                  // mainAxisAlignment: MainAxisAlignment.end,
                                                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                                                  children: [
                                                                                    GestureDetector(
                                                                                      onTap:(){
                                                                                        hideOptions(index);
                                                                                      },
                                                                                      child:Container(
                                                                                          padding: const EdgeInsets.only(top:5,right:20),
                                                                                          child:Icon(Icons.close,size: 20,color:Colors.white)
                                                                                      ),
                                                                                    ),

                                                                                    GestureDetector(
                                                                                     // onTap:onClickNotInterested,
                                                                                      child:Container(
                                                                                        padding: const EdgeInsets.only(top:10,left:20),
                                                                                        child:Row(
                                                                                          children: [
                                                                                            Image.asset('images/icon_edit_feed.png',height: 25,),
                                                                                            SizedBox(width:15),
                                                                                            Text('Edit',
                                                                                                textAlign: TextAlign.center,
                                                                                                style: TextStyle(
                                                                                                    fontWeight: FontWeight.w600,
                                                                                                    color: Colors.white,
                                                                                                    fontSize: 16.0.sp)),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),

                                                                                    GestureDetector(
                                                                                      onTap:(){
                                                                                        //showCraveList(index);
                                                                                      },
                                                                                      child:Container(
                                                                                        padding: const EdgeInsets.only(top:20,left:20),
                                                                                        child:Row(
                                                                                          children: [
                                                                                            Image.asset('images/icon_delete_feed.png',height: 25,),
                                                                                            SizedBox(width:15),
                                                                                            Text('Delete',
                                                                                                textAlign: TextAlign.center,
                                                                                                style: TextStyle(
                                                                                                    fontWeight: FontWeight.w600,
                                                                                                    color: Colors.white,
                                                                                                    fontSize: 16.0.sp)),

                                                                                          ],
                                                                                        ),


                                                                                      ),
                                                                                    ),




                                                                                    // GestureDetector(
                                                                                    //     onTap:onClickReportNotFood,
                                                                                    //     child:Container(
                                                                                    //       padding: const EdgeInsets.only(top:20,left:20),
                                                                                    //       child:Row(
                                                                                    //         children: [
                                                                                    //           Image.asset('images/icon_report_not_food.png',height: 25,),
                                                                                    //           SizedBox(width:15),
                                                                                    //           Text('Report not food',
                                                                                    //               textAlign: TextAlign.center,
                                                                                    //               style: TextStyle(
                                                                                    //                   fontWeight: FontWeight.w600,
                                                                                    //                   color: Colors.white,
                                                                                    //                   fontSize: 16.0.sp)),
                                                                                    //         ],
                                                                                    //       ),
                                                                                    //     )
                                                                                    // ),

                                                                                  ],
                                                                                )

                                                                            )
                                                                          ],
                                                                        )
                                                                   :
                                                                    Container(),
                                                                    isShowCraveList[index]?
                                                                    Wrap(
                                                                      children: [
                                                                        Container(
                                                                            padding: const EdgeInsets.only(top:10,bottom:25),
                                                                            margin: EdgeInsets.only(top:10,left:10,right:10),
                                                                            // height:25.0.h,
                                                                            width:screenSize.width,
                                                                            decoration: BoxDecoration(
                                                                              color:Colors.black,
                                                                              borderRadius: BorderRadius.only(
                                                                                bottomRight: Radius.circular(20),
                                                                                bottomLeft: Radius.circular(20),
                                                                                topRight: Radius.circular(20),
                                                                                topLeft: Radius.circular(20),
                                                                              ),
                                                                            ),
                                                                            child:Column(
                                                                              // mainAxisAlignment: MainAxisAlignment.end,
                                                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                                              children: [
                                                                                SizedBox(height:10),
                                                                                Row(
                                                                                  children: [
                                                                                    GestureDetector(
                                                                                      onTap:(){
                                                                                        hideCraveList(index);
                                                                                      },
                                                                                      child:Container(
                                                                                          padding: const EdgeInsets.only(right:10,left:30),
                                                                                          child:Icon(Icons.arrow_back_ios,size: 20,color:Colors.white)
                                                                                      ),
                                                                                    ),
                                                                                    Row(
                                                                                      children: [
                                                                                        Text('Add to ',
                                                                                            textAlign: TextAlign.center,
                                                                                            style: TextStyle(
                                                                                                fontWeight: FontWeight.w600,
                                                                                                color: Colors.white,
                                                                                                fontSize: 14.0.sp)),
                                                                                        Text("Crave's ",
                                                                                            textAlign: TextAlign.center,
                                                                                            style: TextStyle(
                                                                                                fontWeight: FontWeight.w600,
                                                                                                color: Color(constant.Color.crave_orange),
                                                                                                fontSize: 14.0.sp)),
                                                                                        Text('List',
                                                                                            textAlign: TextAlign.center,
                                                                                            style: TextStyle(
                                                                                                fontWeight: FontWeight.w600,
                                                                                                color: Colors.white,
                                                                                                fontSize: 14.0.sp)),
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                SizedBox(height:15),
                                                                                Container(
                                                                                    height:15.0.h,
                                                                                    width:screenSize.width,
                                                                                    child:ListView.builder(
                                                                                      itemCount: currentCraveList.length,
                                                                                      itemBuilder: (context, index) {
                                                                                        return
                                                                                          Padding(
                                                                                            padding: const EdgeInsets.only(bottom:0, left:15, right:30),
                                                                                            child: Row(
                                                                                              children: [
                                                                                                Transform.scale(
                                                                                                  scale: 1.3,
                                                                                                  child:
                                                                                                  Checkbox(
                                                                                                    checkColor: Colors.grey,
                                                                                                    fillColor: MaterialStateProperty.all(Colors.white),
                                                                                                    // activeColor:Colors.grey,
                                                                                                    value: currentCraveListChecked[index],
                                                                                                    // shape: CircleBorder(),
                                                                                                    onChanged: (bool? value) {
                                                                                                      setState(() {
                                                                                                        currentCraveListChecked[index] = value!;
                                                                                                        if(currentCraveListChecked[index]){
                                                                                                          addToCraveList.add(currentCraveList[index].list_id);
                                                                                                        }
                                                                                                        else{
                                                                                                          addToCraveList.remove(currentCraveList[index].list_id);
                                                                                                        }
                                                                                                        print(currentCraveListChecked[index]);
                                                                                                      });
                                                                                                    },
                                                                                                  ),

                                                                                                ),
                                                                                                Text(currentCraveList[index].list_name,
                                                                                                    style: TextStyle(
                                                                                                        fontWeight: FontWeight.w700,
                                                                                                        color: Colors.grey,
                                                                                                        fontSize: 11.0.sp)),
                                                                                                Spacer(),

                                                                                              ],
                                                                                            ),
                                                                                          );
                                                                                      },
                                                                                    ),
                                                                                  ),
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                  children: [
                                                                                    Container(
                                                                                      width:80.0.w,
                                                                                      height:40,
                                                                                      margin: const EdgeInsets.only(top: 30.0),
                                                                                      padding: const EdgeInsets.only(left: 30.0, right: 10.0),
                                                                                      child:TextField(
                                                                                        autofocus: false,
                                                                                        controller: addListTxtController,
                                                                                        cursorColor: Colors.black,
                                                                                        keyboardType: TextInputType.text,
                                                                                        textInputAction: TextInputAction.go,
                                                                                        textCapitalization: TextCapitalization.sentences,
                                                                                        decoration: InputDecoration(
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
                                                                                            // suffixText: "Post",
                                                                                            // suffixStyle: TextStyle(
                                                                                            //   fontWeight: FontWeight.w700,
                                                                                            //   color:Color(constant.Color.crave_blue),
                                                                                            // ),
                                                                                            hintText: ""),
                                                                                      ),
                                                                                    ),
                                                                                    GestureDetector(
                                                                                      onTap:createList,
                                                                                      child:Container(
                                                                                          margin: const EdgeInsets.only(top:30,right:10),
                                                                                          child:Icon(Icons.add,size: 25,color:Colors.white)
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),

                                                                              ],
                                                                            )

                                                                        )
                                                                      ],
                                                                    )
                                                                    :
                                                                    Container(),
                                                                  ]
                                                              ),

                                                            ),
                                                          ),

                                                          Padding(
                                                            padding:EdgeInsets.only(left:10),
                                                            child: IntrinsicHeight(
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  GestureDetector(
                                                                    onTap:(){
                                                                      likePost(index);
                                                                    },
                                                                    child:post_likes_list[index]=='1'?
                                                                    Image.asset(
                                                                      'images/love_selected_icon.png',
                                                                      height: 2.2.h,
                                                                    ):
                                                                    Image.asset(
                                                                      'images/icon_love.png',
                                                                      height: 2.2.h,
                                                                    ),
                                                                  ),
                                                                  GestureDetector(
                                                                    onTap:(){
                                                                      likePost(index);
                                                                    },
                                                                    child:Padding(
                                                                      padding: EdgeInsets.only(left:2.0.w,right:6.0.w),
                                                                      child:Text(post_likes[index],
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w600,
                                                                              color: Colors.black,
                                                                              fontSize: 10.0.sp)),
                                                                    ),
                                                                  ),

                                                                  GestureDetector(
                                                                    onTap:(){
                                                                      cravePost(index);
                                                                    },
                                                                    child:post_crave_list[index]=='1'?
                                                                    Image.asset(
                                                                      'images/icon_crave.png',
                                                                      height: 2.2.h,
                                                                    ):
                                                                    Image.asset(
                                                                      'images/icon_crave_grey.png',
                                                                      height: 2.2.h,
                                                                    ),
                                                                  ),

                                                                  GestureDetector(
                                                                    onTap:(){
                                                                      cravePost(index);
                                                                    },
                                                                    child:Padding(
                                                                      padding: EdgeInsets.only(left:2.0.w,right:6.0.w),
                                                                      child:Text(post_crave[index],
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w600,
                                                                              color: Colors.black,
                                                                              fontSize: 10.0.sp)),
                                                                    ),
                                                                  ),

                                                                  GestureDetector(
                                                                    onTap:(){
                                                                      goToComments(index);
                                                                    },
                                                                    child:Image.asset(
                                                                      'images/comment_icon.png',
                                                                      height: 2.2.h,
                                                                    ),
                                                                  ),
                                                                  GestureDetector(
                                                                    onTap:(){
                                                                      goToComments(index);
                                                                    },
                                                                    child:Padding(
                                                                      padding: EdgeInsets.only(left:2.0.w,right:6.0.w),
                                                                      child:Text(this.widget.medias[index].post_comments,
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w600,
                                                                              color: Colors.black,
                                                                              fontSize: 10.0.sp)),
                                                                    ),
                                                                  ),


                                                                ],
                                                              ),
                                                            ),
                                                          ),

                                                          Padding(
                                                            padding:EdgeInsets.only(top:10,left:10),
                                                            child:Text(this.widget.medias[index].media_desc,
                                                                maxLines: 1,
                                                                overflow: TextOverflow.ellipsis,
                                                                textAlign: TextAlign.right,
                                                                style: TextStyle(
                                                                    color: Colors.grey,
                                                                    fontSize: 10.0.sp)),
                                                          ),


                                                        ],
                                                      ),
                                                    ),
                                                  // )
                                                );
                                          })

                                        ),

                                      )


                                    ],
                                  ),
                                  isShowStatsPopup?
                                  Center(
                                    child:Card(
                                      color: Colors.transparent,
                                        child:Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Wrap(
                                              children: [
                                                Container(
                                                    width:100.0.w,
                                                    decoration: BoxDecoration(
                                                      color:Colors.black87,
                                                      borderRadius: BorderRadius.only(
                                                        topRight: Radius.circular(20.0),
                                                        topLeft: Radius.circular(20.0),),
                                                    ),
                                                    child:Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            GestureDetector(
                                                              onTap:hideStatsPopup,
                                                              child:Container(
                                                                  padding: const EdgeInsets.only(top:15,left:10),
                                                                  child:Icon(Icons.arrow_back_ios,size: 20,color:Colors.white)
                                                              ),
                                                            ),

                                                            Spacer(),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          children: [
                                                            Column(
                                                              children: [
                                                                Text(currentCraves,
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w700,
                                                                        color: Colors.white,
                                                                        fontSize: 18.0.sp)),
                                                                Text('CRAVES',
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w600,
                                                                        color: Color(constant.Color.crave_orange),
                                                                        fontSize: 10.0.sp)),
                                                              ],
                                                            ),
                                                            Column(
                                                              children: [
                                                                Text(currentLikes,
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w700,
                                                                        color: Colors.white,
                                                                        fontSize: 18.0.sp)),
                                                                Text('LIKES',
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w600,
                                                                        color: Color(constant.Color.crave_blue),
                                                                        fontSize: 10.0.sp)),
                                                              ],
                                                            ),

                                                          ],
                                                        ),
                                                        SizedBox(height:20.0),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          children: [
                                                            Column(
                                                              children: [
                                                                Text(currentViews,
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w700,
                                                                        color: Colors.white,
                                                                        fontSize: 18.0.sp)),
                                                                Text('VIEWS',
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w600,
                                                                        color: Color(constant.Color.crave_blue),
                                                                        fontSize: 10.0.sp)),
                                                              ],
                                                            ),
                                                            Column(
                                                              children: [
                                                                Text(currentComments,
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w700,
                                                                        color: Colors.white,
                                                                        fontSize: 18.0.sp)),
                                                                Text('COMMENTS',
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w600,
                                                                        color: Color(constant.Color.crave_orange),
                                                                        fontSize: 10.0.sp)),
                                                              ],
                                                            ),

                                                          ],
                                                        ),
                                                        SizedBox(height:50.0),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Container(
                                                              margin: EdgeInsets.only(left:20),
                                                              child:Text('Palette',
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.w500,
                                                                      color: Colors.grey,
                                                                      fontSize: 10.0.sp)),
                                                            ),
                                                            Container(
                                                              padding: const EdgeInsets.only(top:3,bottom:3,left:8,right:8),
                                                              margin: EdgeInsets.only(right:20),
                                                              decoration: BoxDecoration(
                                                                color:Color(constant.Color.crave_orange),
                                                                borderRadius: BorderRadius.only(
                                                                  topRight: Radius.circular(10.0),
                                                                  topLeft: Radius.circular(10.0),
                                                                  bottomRight: Radius.circular(10.0),
                                                                  bottomLeft: Radius.circular(10.0),),
                                                              ),
                                                              child:GestureDetector(
                                                                onTap:onShowFoodPalette,
                                                                child:Center(
                                                                  child:Text('SUGGEST',
                                                                      textAlign: TextAlign.center,
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w700,
                                                                          color: Colors.white,
                                                                          fontSize: 8.0.sp)),
                                                                ),

                                                              ),
                                                            )

                                                          ],
                                                        ),
                                                        SizedBox(height:10.0),
                                                        Row(
                                                          children: [
                                                            palette1!=""?
                                                            Container(
                                                              padding: const EdgeInsets.only(top:3,bottom:3,left:5,right:5),
                                                              margin: EdgeInsets.only(left:20),
                                                              decoration: BoxDecoration(
                                                                color:Color(constant.Color.crave_charcoal),
                                                                borderRadius: BorderRadius.only(
                                                                  topRight: Radius.circular(10.0),
                                                                  topLeft: Radius.circular(10.0),
                                                                  bottomRight: Radius.circular(10.0),
                                                                  bottomLeft: Radius.circular(10.0),),
                                                              ),
                                                              child:Center(
                                                                child:Text(palette1.toUpperCase(),
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w600,
                                                                        color: Color(constant.Color.crave_blue),
                                                                        fontSize: 10.0.sp)),
                                                              ),
                                                            )
                                                                :Container(height:0,width:0),
                                                            palette2!=""?
                                                            Container(
                                                              padding: const EdgeInsets.only(top:3,bottom:3,left:5,right:5),
                                                              margin: EdgeInsets.only(left:10),
                                                              decoration: BoxDecoration(
                                                                color:Color(constant.Color.crave_charcoal),
                                                                borderRadius: BorderRadius.only(
                                                                  topRight: Radius.circular(10.0),
                                                                  topLeft: Radius.circular(10.0),
                                                                  bottomRight: Radius.circular(10.0),
                                                                  bottomLeft: Radius.circular(10.0),),
                                                              ),
                                                              child:Center(
                                                                child:Text(palette2.toUpperCase(),
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w600,
                                                                        color: Color(constant.Color.crave_blue),
                                                                        fontSize: 10.0.sp)),
                                                              ),
                                                            )
                                                              :Container(height:0,width:0),
                                                            palette3!=""?
                                                            Container(
                                                              padding: const EdgeInsets.only(top:3,bottom:3,left:5,right:5),
                                                              margin: EdgeInsets.only(left:10),
                                                              decoration: BoxDecoration(
                                                                color:Color(constant.Color.crave_charcoal),
                                                                borderRadius: BorderRadius.only(
                                                                  topRight: Radius.circular(10.0),
                                                                  topLeft: Radius.circular(10.0),
                                                                  bottomRight: Radius.circular(10.0),
                                                                  bottomLeft: Radius.circular(10.0),),
                                                              ),
                                                              child:Center(
                                                                child:Text(palette3.toUpperCase(),
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w600,
                                                                        color: Color(constant.Color.crave_blue),
                                                                        fontSize: 10.0.sp)),
                                                              ),
                                                            )
                                                                :Container(height:0,width:0),
                                                            // Container(
                                                            //   padding: const EdgeInsets.only(top:3,bottom:3,left:5,right:5),
                                                            //   margin: EdgeInsets.only(left:10),
                                                            //   decoration: BoxDecoration(
                                                            //     color:Color(constant.Color.crave_charcoal),
                                                            //     borderRadius: BorderRadius.only(
                                                            //       topRight: Radius.circular(10.0),
                                                            //       topLeft: Radius.circular(10.0),
                                                            //       bottomRight: Radius.circular(10.0),
                                                            //       bottomLeft: Radius.circular(10.0),),
                                                            //   ),
                                                            //   child:Center(
                                                            //     child:Text('MEDITERREAN',
                                                            //         textAlign: TextAlign.center,
                                                            //         style: TextStyle(
                                                            //             fontWeight: FontWeight.w600,
                                                            //             color: Color(constant.Color.crave_blue),
                                                            //             fontSize: 10.0.sp)),
                                                            //   ),
                                                            // )
                                                          ],
                                                        ),
                                                        // SizedBox(height:10.0),
                                                        // Row(
                                                        //   children: [
                                                        //     Container(
                                                        //       padding: const EdgeInsets.only(top:3,bottom:3,left:5,right:5),
                                                        //       margin: EdgeInsets.only(left:20),
                                                        //       decoration: BoxDecoration(
                                                        //         color:Color(constant.Color.crave_charcoal),
                                                        //         borderRadius: BorderRadius.only(
                                                        //           topRight: Radius.circular(10.0),
                                                        //           topLeft: Radius.circular(10.0),
                                                        //           bottomRight: Radius.circular(10.0),
                                                        //           bottomLeft: Radius.circular(10.0),),
                                                        //       ),
                                                        //       child:Center(
                                                        //         child:Text('FAST FOOD',
                                                        //             textAlign: TextAlign.center,
                                                        //             style: TextStyle(
                                                        //                 fontWeight: FontWeight.w600,
                                                        //                 color: Color(constant.Color.crave_blue),
                                                        //                 fontSize: 10.0.sp)),
                                                        //       ),
                                                        //     ),
                                                        //     Container(
                                                        //       padding: const EdgeInsets.only(top:3,bottom:3,left:5,right:5),
                                                        //       margin: EdgeInsets.only(left:10),
                                                        //       decoration: BoxDecoration(
                                                        //         color:Color(constant.Color.crave_charcoal),
                                                        //         borderRadius: BorderRadius.only(
                                                        //           topRight: Radius.circular(10.0),
                                                        //           topLeft: Radius.circular(10.0),
                                                        //           bottomRight: Radius.circular(10.0),
                                                        //           bottomLeft: Radius.circular(10.0),),
                                                        //       ),
                                                        //       child:Center(
                                                        //         child:Text('ETC',
                                                        //             textAlign: TextAlign.center,
                                                        //             style: TextStyle(
                                                        //                 fontWeight: FontWeight.w600,
                                                        //                 color: Color(constant.Color.crave_blue),
                                                        //                 fontSize: 10.0.sp)),
                                                        //       ),
                                                        //     ),
                                                        //
                                                        //   ],
                                                        // ),
                                                        SizedBox(height:40.0),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Container(
                                                              margin: EdgeInsets.only(left:20),
                                                              child:Text('Opening Hours',
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.w500,
                                                                      color: Colors.grey,
                                                                      fontSize: 10.0.sp)),
                                                            ),
                                                            Container(
                                                              padding: const EdgeInsets.only(top:3,bottom:3,left:8,right:8),
                                                              margin: EdgeInsets.only(right:20),
                                                              decoration: BoxDecoration(
                                                                color:Color(constant.Color.crave_orange),
                                                                borderRadius: BorderRadius.only(
                                                                  topRight: Radius.circular(10.0),
                                                                  topLeft: Radius.circular(10.0),
                                                                  bottomRight: Radius.circular(10.0),
                                                                  bottomLeft: Radius.circular(10.0),),
                                                              ),
                                                              child:Center(
                                                                child:Text('SUGGEST',
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w700,
                                                                        color: Colors.white,
                                                                        fontSize: 8.0.sp)),
                                                              ),
                                                            )

                                                          ],
                                                        ),
                                                        SizedBox(height:20.0),
                                                        Row(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          mainAxisSize: MainAxisSize.max,
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text('MONDAY',
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w600,
                                                                        color: Color(constant.Color.crave_blue),
                                                                        fontSize: 10.0.sp)),
                                                                SizedBox(height:5.0),
                                                                Text('TUESDAY',
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w600,
                                                                        color: Color(constant.Color.crave_blue),
                                                                        fontSize: 10.0.sp)),
                                                                SizedBox(height:5.0),
                                                                Text('WEDNESDAY',
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w600,
                                                                        color: Color(constant.Color.crave_blue),
                                                                        fontSize: 10.0.sp)),
                                                                SizedBox(height:5.0),
                                                                Text('THURSDAY',
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w600,
                                                                        color: Color(constant.Color.crave_blue),
                                                                        fontSize: 10.0.sp)),
                                                                SizedBox(height:5.0),
                                                                Text('FRIDAY',
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w600,
                                                                        color: Color(constant.Color.crave_blue),
                                                                        fontSize: 10.0.sp)),
                                                                SizedBox(height:5.0),
                                                                Text('SATURDAY',
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w600,
                                                                        color: Color(constant.Color.crave_blue),
                                                                        fontSize: 10.0.sp)),
                                                                SizedBox(height:5.0),
                                                                Text('SUNDAY',
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w600,
                                                                        color: Color(constant.Color.crave_blue),
                                                                        fontSize: 10.0.sp)),
                                                              ],
                                                            ),
                                                            Container(
                                                              padding: const EdgeInsets.only(left:15,right:15),
                                                              child: VerticalDivider(
                                                                color: Color(constant.Color.crave_charcoal),thickness: 2,),
                                                              height:16.0.h,),
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text('9:00 am - 5:00 pm',
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w600,
                                                                        color: Colors.white,
                                                                        fontSize: 10.0.sp)),
                                                                SizedBox(height:5.0),
                                                                Text('9:00 am - 5:00 pm',
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w600,
                                                                        color: Colors.white,
                                                                        fontSize: 10.0.sp)),
                                                                SizedBox(height:5.0),
                                                                Text('9:00 am - 5:00 pm',
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w600,
                                                                        color: Colors.white,
                                                                        fontSize: 10.0.sp)),
                                                                SizedBox(height:5.0),
                                                                Text('9:00 am - 5:00 pm',
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w600,
                                                                        color: Colors.white,
                                                                        fontSize: 10.0.sp)),
                                                                SizedBox(height:5.0),
                                                                Text('9:00 am - 5:00 pm',
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w600,
                                                                        color: Colors.white,
                                                                        fontSize: 10.0.sp)),
                                                                SizedBox(height:5.0),
                                                                Text('9:00 am - 5:00 pm',
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w600,
                                                                        color: Colors.white,
                                                                        fontSize: 10.0.sp)),
                                                                SizedBox(height:5.0),
                                                                Text('CLOSED',
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.w600,
                                                                        color: Color(constant.Color.crave_orange),
                                                                        fontSize: 10.0.sp)),
                                                              ],
                                                            ),

                                                          ],
                                                        ),
                                                        SizedBox(height:15),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Container(
                                                              margin: EdgeInsets.only(left:15,bottom:15),
                                                              child:Text('Disclaimer: Opening times shown here are esimations.',
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                    fontStyle: FontStyle.italic,
                                                                      fontWeight: FontWeight.w500,
                                                                      color: Colors.grey,
                                                                      fontSize: 9.0.sp)),
                                                            ),

                                                          ],
                                                        ),
                                                      ],
                                                    )
                                                ),
                                              ],
                                            ),

                                            GestureDetector(
                                              onTap:(){
                                                showTravelTo(selectedIndex);
                                              },
                                              child:Container(
                                                height:12.0.h,
                                                width:100.0.w,
                                                decoration: BoxDecoration(
                                                  color:Color(constant.Color.crave_orange),
                                                  borderRadius: BorderRadius.only(
                                                    bottomRight: Radius.circular(10.0),
                                                    bottomLeft: Radius.circular(10.0),),
                                                ),
                                                child:Center(
                                                  child:Text('TRAVEL TO',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.w700,
                                                          color: Colors.white,
                                                          fontSize: 12.0.sp)),
                                                ),
                                              )
                                            ),

                                          ],
                                        )
                                    )
                                  ):
                                  Container(height:0,width:0),

                                ],
                              ),

                            ),
                          );
                        });
                  }
              );
            }
        ),

    );


  }
}


