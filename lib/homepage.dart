// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:a_crave/feedDetails.dart';
import 'package:a_crave/profileBusiness.dart';
import 'package:a_crave/reelsDetails.dart';

import 'camera_home.dart';
import 'camera_screen.dart';
import 'cravingsPage.dart';
import 'feed.dart';
import 'homeBase.dart';
import 'dataClass.dart';
import 'myNavWheel.dart';
import 'notificationsPage.dart';
import 'profileUser.dart';

import 'chatPage.dart';
import 'reels.dart';

import 'showStories.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';

import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;
import 'constants.dart' as constant;
import 'package:fluttertoast/fluttertoast.dart';
import 'circle_wheel_scroll/circle_wheel_scroll_view.dart';
import 'stories_for_flutter/lib/stories_for_flutter.dart';
import 'package:circle_list/circle_list.dart';
import 'package:visibility_detector/visibility_detector.dart';


class Homepage extends StatefulWidget {
  final PageController homepageController;
  final List<Media> medias;
  final List<Media> dummyMedia;
  final Function() onLoadNewData;
  final Function(int) onDataChange;
  final Function() onLoadDiscover;
  final Function() onLoadClosest;
  final Function() onLoadFollowing;
  const Homepage({Key? key, required this.homepageController, required this.medias,required this.dummyMedia,required this.onLoadNewData,required this.onDataChange,required this.onLoadDiscover,required this.onLoadClosest,required this.onLoadFollowing}) : super(key: key);

  @override
  HomepageState createState() => HomepageState();
}

class HomepageState extends State<Homepage> with AutomaticKeepAliveClientMixin{
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  final textController = TextEditingController();

  int currentMenuIndex = 4;
  bool isTabShown = true;
  double _kSearchHeight = 60.0;
  bool isSearchOn = false;
  late List<StoryItem> storyList = [];
  List returnedStories = [];
  List<TextEditingController> textEditingControllers = [];

  // scroll controller
  late ScrollController _scrollController = new ScrollController();

  int currentTab = 0;
  void onTabChange(int newTab) {
    setState(() {

      if(newTab == 0){
        this.widget.onLoadDiscover();
      }
      else if(newTab == 1){
        this.widget.onLoadClosest();
      }
      else if(newTab == 2){
        this.widget.onLoadFollowing();
      }
      // this.widget.onLoadNewData();
      currentTab = newTab;
    });
  }


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => loadStories());
  }

  void goToFeed(int index) {
      this.widget.onDataChange(index);
      this.widget.homepageController.nextPage(duration: Duration(milliseconds: 100), curve: Curves.easeIn);
      PageViewDemo.of(context)!.hideWheel();
      // Feed.of(context)!.scrollDown();
  }
  
  onSearchOn(){
    setState(() {
      isSearchOn = !isSearchOn;
    });
  }

  // TextStyle getTextStyle(style){
  //
  //   TextStyle textStyle = TextStyle.values.firstWhere((e) => e.toString() == style);
  //   return textStyle;
  // }

  TextAlign getTextAlign(align){

    TextAlign textAlign = TextAlign.values.firstWhere((e) => e.toString() == align);
    return textAlign;
  }

  Future<List<Story>> loadStories() async {
    print("load storiess");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var url = Uri.parse(constant.Url.crave_url+'get_stories.php');
    returnedStories.clear();
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

      final story = storyFromJson(response.body);

      setState(() {
        returnedStories = story.stories;
        loadStories2();
      });

      return [];
      // }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }

  }

  Future<http.Response> commentStories(String mediaId,String receiver_email,String comment) async {

    var url = Uri.parse(constant.Url.crave_url+'send_story_comment.php');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        "email":prefs.getString('user_email'),
        "receiver_email":receiver_email,
        "comment":comment,
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
            msg: "Comment shared!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0
        );
        for (TextEditingController textEditingController in textEditingControllers) {
          textEditingController.text = "";
        }
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

  Color stringToColor(colorString){
    String valueString = colorString.split('(0x')[1].split(')')[0]; // kind of hacky..
    int value = int.parse(valueString, radix: 16);
    Color otherColor = new Color(value);
    return otherColor;
  }

  void loadStories2(){
    print("ashadk storiss");
    storyList.clear();
    setState(() {

      for(int i=0;i<returnedStories.length;i++){
        List<Scaffold> storiesItem = [];
        for(int k=0;k<returnedStories[i].storyItems.length;k++){
          var textEditingController = TextEditingController();
          textEditingControllers.add(textEditingController);
          storiesItem.add(
            Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.white,
              body: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            constant.Url.media_url+returnedStories[i].storyItems[k].cMediaName,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    // color:Colors.yellow,
                    height: 100.0.h,
                    width: 100.0.w,
                    margin: EdgeInsets.only(left:15.0.w,bottom:40.0.w),
                    padding: EdgeInsets.only(top:30.w,right:15.0.w),
                    child: Center(
                      child: Text(
                        returnedStories[i].storyItems[k].cTextFilter,
                       // style: getTextStyle(returnedStories[i].storyItems[k].cTextStyle),
                        style: TextStyle(
                            fontSize: returnedStories[i].storyItems[k].cTextSize!=''?double.parse(returnedStories[i].storyItems[k].cTextSize):0,
                            color: returnedStories[i].storyItems[k].cTextColor!=''?stringToColor(returnedStories[i].storyItems[k].cTextColor):Colors.transparent,
                            backgroundColor: returnedStories[i].storyItems[k].cTextBgColor!=''?stringToColor(returnedStories[i].storyItems[k].cTextBgColor):Colors.transparent,
                            fontFamily: returnedStories[i].storyItems[k].cTextFamily!=''?returnedStories[i].storyItems[k].cTextFamily:'Billabong'
                        ),
                        textAlign: getTextAlign(returnedStories[i].storyItems[k].cTextAlign),
                      ),
                    ),

                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child:
                    Row(
                      children: [
                        Container(
                          width:90.0.w,
                          height:40,
                          margin: const EdgeInsets.only(bottom: 25.0),
                          padding: const EdgeInsets.only(left: 30.0, right: 10.0),
                          child:TextField(
                            autofocus: false,
                            controller: textEditingControllers[k],
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
                                hintStyle:TextStyle(
                                    color:Colors.grey[400]
                                ),
                                hintText: "Comment"),
                          ),
                        ),
                        GestureDetector(
                          onTap:(){
                            commentStories(returnedStories[i].storyItems[k].cMediaId,returnedStories[i].storyItems[k].cMediaUserId,textEditingControllers[k].text);
                          },
                          child:Container(
                              padding: const EdgeInsets.only(right: 10.0,bottom:20),
                              child:Image.asset(
                                'images/stories_share.png',
                                height: 20,
                              )
                          ),
                        ),


                      ],
                    ),
                  ),
                ],
              ),

            ),
          );
        }
        print(returnedStories[i].storyItems.length);
        print("looooppp");
        print(i);
        print(storiesItem);

        storyList.add(
            StoryItem(
            name: returnedStories[i].cDisplayName,
            timepass:timeDiffStories(returnedStories[i].storyItems[0].cMediaCreateDate),
            thumbnail: NetworkImage(
              constant.Url.media_url+returnedStories[i].storyItems[0].cMediaName
            ),
            user_thumbnail: NetworkImage(
                constant.Url.profile_url+returnedStories[i].cProfileImg
            ),
            stories: storiesItem
            ));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    // dispose textEditingControllers to prevent memory leaks
    for (TextEditingController textEditingController in textEditingControllers) {
      textEditingController.dispose();
    }
  }

  Future<void> loadAllData() async {
    setState(() {
      this.widget.onLoadNewData();
      loadStories();
    });
  }

  void filterSearchHomepage(String query) {
    print(query);
    print(this.widget.dummyMedia.length);
    List<Media> dummySearchList = [];
    dummySearchList.addAll(this.widget.dummyMedia);
    if(query.isNotEmpty) {
      List<Media> dummyListData = [];
      dummySearchList.forEach((item) {
        if(item.user_display_name.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        this.widget.medias.clear();
        this.widget.medias.addAll(dummyListData);
      });
      // return;
    } else {
      setState(() {
        this.widget.medias.clear();
        this.widget.medias.addAll(this.widget.dummyMedia);
        // loadMediaDiscoverSearch();
      });
    }
  }

  String timeDiffStories(timepass){
    print("timeee");
    print(timepass);
    String result = "";
    final birthday = timepass;
    final date2 = DateTime. now();
    final difference = date2. difference(birthday). inHours;
    if(difference < 1){
      result = date2. difference(birthday). inMinutes.toString()+" minutes ago";
    }
    else{
      result = date2. difference(birthday). inHours.toString()+" hours ago";
    }
    print("resulllt");
    print(result);

    return result;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    var maxWidth = 500.0;
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var columns = (width ~/ maxWidth) + 1;
    var columnWidth = width / columns;
    var aspectRatio = columnWidth / 360;

    final screenSize = MediaQuery.of(context).size;

    Widget _buildImageWidget(Media medias,int index) {
      return
        GestureDetector(
          onTap: (){
            goToFeed(index);
          },
          child:Container(
            //color:Colors.black,
            padding: const EdgeInsets.only(left:15,bottom:10,right:10),
            child:Column(
              children: [
                Container(
                  height:140,
                  margin: const EdgeInsets.only(bottom:10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                      image: DecorationImage(
                          image: NetworkImage(constant.Url.media_url+medias.media_name),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(bottom:5),
                //   child:Image.asset(
                //     'images/food1.png',
                //     height: 20.0.h,
                //   ),
                // ),

                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(medias.post_craving,
                          style: TextStyle(
                              fontWeight: FontWeight.w600)),
                      medias.post_craving_user=='1'?
                      Image.asset(
                        'images/icon_crave.png',
                        height: 2.0.h,
                      ):
                      Image.asset(
                        'images/icon_crave_grey.png',
                        height: 2.0.h,
                      ),
                      Container(
                        // padding: const EdgeInsets.only(top:15,bottom:15),
                        child:VerticalDivider(
                          color:Colors.black54,
                        ),
                      ),
                      Text(medias.post_likes,
                          style: TextStyle(
                              fontWeight: FontWeight.w600)),
                      medias.post_likes_user!='0'?
                      Image.asset(
                        'images/love_selected_icon.png',
                        height: 2.0.h,
                      ):
                      Image.asset(
                        'images/icon_love.png',
                        height: 2.0.h,
                      ),

                    ],
                  ),
                ),

              ],
            ),
          ),
        );
    }

    Widget _buildImageWidgetRight(Media medias, int index) {
      return
        GestureDetector(
          onTap: (){
            goToFeed(index);
          },
          child:Container(
            //color:Colors.black,
            padding: const EdgeInsets.only(left:10,bottom:10,right:15),
            child:Column(
              children: [
                Container(
                  height:140,
                  margin: const EdgeInsets.only(bottom:10),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      image: DecorationImage(image: NetworkImage(constant.Url.media_url+medias.media_name), fit: BoxFit.cover),
                      borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(bottom:5),
                //   child:Image.asset(
                //     'images/food1.png',
                //     height: 20.0.h,
                //   ),
                // ),

                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(medias.post_craving,
                          style: TextStyle(
                              fontWeight: FontWeight.w600)),
                      medias.post_craving_user=='1'?
                      Image.asset(
                        'images/icon_crave.png',
                        height: 2.0.h,
                      ):
                      Image.asset(
                        'images/icon_crave_grey.png',
                        height: 2.0.h,
                      ),
                      Container(
                        // padding: const EdgeInsets.only(top:15,bottom:15),
                        child:VerticalDivider(
                          color:Colors.black54,
                        ),
                      ),
                      Text(medias.post_likes,
                          style: TextStyle(
                              fontWeight: FontWeight.w600)),
                      medias.post_likes_user=='1'?
                      Image.asset(
                        'images/love_selected_icon.png',
                        height: 2.0.h,
                      ):
                      Image.asset(
                        'images/icon_love.png',
                        height: 2.0.h,
                      ),

                    ],
                  ),
                ),

              ],
            ),
          ),
        );
    }

    SliverGrid _buildContent(List<Media> medias) {
      return
        SliverGrid(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: columnWidth/2,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 0.0,
            childAspectRatio: aspectRatio,
          ),
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              if(index % 2 == 0){
                return _buildImageWidget(medias[index],index);
              }
              else{
                return _buildImageWidgetRight(medias[index],index);
              }

            },
            childCount: medias.length,
          ),
        );
    }

    return
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
            else{
              PageViewDemo.of(context)!.disappearWheel();
              Navigator.push(
                context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => CameraScreen(),
                    transitionDuration: Duration(milliseconds: 500),
                    // transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        const end = Offset(0.0, 0.0);
                        const begin = Offset(-1.0, 0.0);
                        const curve = Curves.ease;

                        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
                  ),
              );

              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => CameraScreen()));
            }
            print("swipe right");
          }
          else if(details.delta.dx < -sensitivity){
            //Left Swipe
            if(!PageViewDemo.of(context)!.isShowWheel){
              PageViewDemo.of(context)!.appearWheel();
              PageViewDemo.of(context)!.showWheel();
            }
            print("swipe left");
          }
        },
        child:Stack(
          children: <Widget>[
            RefreshIndicator(
              child: CustomScrollView(
                controller:_scrollController,
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          VisibilityDetector(
                            key: Key('headerkey'),
                            onVisibilityChanged: (visibilityInfo) {
                              var visiblePercentage = visibilityInfo.visibleFraction * 100;
                              if(visiblePercentage < 20.0){
                                setState(() {
                                  isTabShown = false;
                                });
                              }
                              else if(visiblePercentage > 20.0){
                                setState(() {
                                  isTabShown = true;
                                });
                              }
                              debugPrint(
                                  'Widget ${visibilityInfo.key} is ${visiblePercentage}% visible');
                            },
                            child:
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
                                  child:Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                          padding: const EdgeInsets.only(
                                              top: 50.0,bottom:15, left:20),
                                          width:MediaQuery.of(context).size.width * 0.80,
                                          child:Image.asset(
                                            'images/crave_logo_word.png',
                                            height: 35,
                                          )
                                      ),
                                      Column(
                                        children: [
                                          SizedBox(
                                              height:4.0.h
                                          ),
                                          GestureDetector(
                                              onTap:onSearchOn,
                                              child:Icon(Icons.search,size: 25,color:isSearchOn?Colors.grey:Colors.grey)
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),
                                ),

                                Stack(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(left:15,right:15),
                                      margin:const EdgeInsets.only(bottom:25,top:25),
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
                                                      builder: (context) => CameraScreen()));
                                            },
                                            child:Container(
                                                margin:const EdgeInsets.only(right:8),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                                ),
                                                width: 68.0,
                                                child:DottedBorder(
                                                  borderType: BorderType.RRect,
                                                  dashPattern: [5],
                                                  radius: Radius.circular(10),
                                                  color: Colors.grey,
                                                  strokeWidth: 1,
                                                  child: Center(
                                                    child:Icon(Icons.add,size: 40,color:Colors.grey,),
                                                  ),
                                                )
                                            ),
                                          ),



                                          //Comment a while to do later
                                          Stories(
                                              circlePadding: 2,
                                              fullpageVisitedColor:Colors.white,
                                              fullpageUnisitedColor: Colors.grey,
                                              // autoPlayDuration : Duration(seconds: 6),
                                              displayProgress : true,
                                              storyItemList:
                                              storyList

                                          ),
                                        ],
                                      ),
                                    ),
                                    Visibility(
                                      visible:isSearchOn,
                                      child:Container(
                                        decoration: BoxDecoration(
                                          color:Colors.white,
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
                                        //width:250,
                                        height:60,
                                        // margin:const EdgeInsets.only(top:10),
                                        padding: const EdgeInsets.only(left: 30.0, right: 30.0,bottom:10,top:10),
                                        child:TextField(
                                          autofocus: false,
                                          // controller: textController,
                                          cursorColor: Colors.black,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.go,
                                          textCapitalization: TextCapitalization.sentences,
                                          onChanged:(value){
                                            filterSearchHomepage(value);
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
                                    ),

                                  ],
                                ),

                                Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 20.0),
                                    child:IntrinsicHeight(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          SizedBox(width:2.0.w),
                                          GestureDetector(
                                            onTap:(){
                                              onTabChange(0);
                                            },
                                            child:Text("DISCOVER",
                                                style: TextStyle(
                                                    color: currentTab==0?Colors.black:Color(0xFFDEDDDD),
                                                    fontSize: 11.0.sp)),
                                          ),

                                          Container(
                                            //padding: const EdgeInsets.only(top:15,bottom:15),
                                            child:VerticalDivider(color:Colors.grey),
                                          ),

                                          GestureDetector(
                                            onTap:(){
                                              onTabChange(1);
                                            },
                                            child:Text("CLOSEST",
                                                style: TextStyle(
                                                    color: currentTab==1?Colors.black:Color(0xFFDEDDDD),
                                                    fontSize: 11.0.sp)),
                                          ),
                                          Container(
                                            //padding: const EdgeInsets.only(top:15,bottom:15),
                                            child:VerticalDivider(color:Colors.grey),
                                          ),
                                          GestureDetector(
                                            onTap:(){
                                              onTabChange(2);
                                            },
                                            child:Text("FOLLOWING",
                                                style: TextStyle(
                                                    color: currentTab==2?Colors.black:Color(0xFFDEDDDD),
                                                    fontSize: 11.0.sp)),
                                          ),
                                          SizedBox(width:2.0.w),
                                        ],
                                      ),
                                    )
                                ),

                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                    //list of events
                    _buildContent( this.widget.medias),

                  ]
              ),
              onRefresh: () =>
                  loadAllData(),
            ),
            isTabShown?
            Container():
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: const EdgeInsets.only(left:10,right:10,top:50),
                height: isSearchOn?_kSearchHeight+90:_kSearchHeight+30,
                color: Colors.white,
                alignment: Alignment.center,
                child:Column(
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            'images/crave_logo.jpg',
                            height: 30,
                          ),
                          GestureDetector(
                            onTap:(){
                              onTabChange(0);
                            },
                            child:Text("DISCOVER",
                                style: TextStyle(
                                    color: currentTab==0?Colors.black:Color(0xFFDEDDDD),
                                    fontSize: 11.0.sp)),
                          ),

                          Container(
                            //padding: const EdgeInsets.only(top:15,bottom:15),
                            child:VerticalDivider(),
                          ),

                          GestureDetector(
                            onTap:(){
                              onTabChange(1);
                            },
                            child:Text("CLOSEST",
                                style: TextStyle(
                                    color: currentTab==1?Colors.black:Color(0xFFDEDDDD),
                                    fontSize: 11.0.sp)),
                          ),
                          Container(
                            // padding: const EdgeInsets.only(top:15,bottom:15),
                            child:VerticalDivider(),
                          ),
                          GestureDetector(
                            onTap:(){
                              onTabChange(2);
                            },
                            child:Text("FOLLOWING",
                                style: TextStyle(
                                    color: currentTab==2?Colors.black:Color(0xFFDEDDDD),
                                    fontSize: 11.0.sp)),
                          ),
                          GestureDetector(
                              onTap:onSearchOn,
                              child:Icon(Icons.search,size: 20,color:isSearchOn?Colors.grey:Colors.black)
                          ),

                        ],
                      ),
                    ),
                    Visibility(
                      visible:isSearchOn,
                      child:Container(
                        //width:250,
                        height:40,
                        margin: const EdgeInsets.only(bottom: 10.0,top:15),
                        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                        child:TextField(
                          autofocus: false,
                          // controller: textController,
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.go,
                          textCapitalization: TextCapitalization.sentences,
                          onChanged: (value){
                            filterSearchHomepage(value);
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
                    ),
                  ],
                ),

              ),

            ),

            isTabShown?
            Container():
                Align(
                  alignment: Alignment.bottomRight,
                  child:Padding(
                    padding: const EdgeInsets.only(bottom:10,right:10),
                    child: SizedBox.fromSize(
                      size: Size(45, 45),
                      child: ClipOval(
                        child: Material(
                          color: Colors.white,
                          child: InkWell(
                            splashColor: Colors.grey,
                            onTap: () {
                              _scrollController.animateTo(0,
                                  duration: const Duration(milliseconds: 300), curve: Curves.linear);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.arrow_upward,size: 30,), // <-- Icon
                                //Text("Buy"), // <-- Text
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ),

                ),


          ],
        ),
      );



  }
}



