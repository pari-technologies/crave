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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

class ProfileUserPosts extends StatefulWidget {
  final PageController profilePageController;
  final List<Media> medias;
  final List<UserProfile> user_profile;
  const ProfileUserPosts({Key? key,required this.profilePageController, required this.medias,required this.user_profile}) : super(key: key);

  @override
  ProfileUserPostsState createState() => ProfileUserPostsState();
}

class ProfileUserPostsState extends State<ProfileUserPosts> {
  final textController = TextEditingController();
  final addListTxtController = TextEditingController();

  bool isGridView = true;
  bool isMenuOpen = false;

  List<bool> isShowOptions = [];
  List<bool> isShowCraveList = [];
  List<String> addToCraveList = [];
  List<CraveList> currentCraveList = [];
  List<bool> currentCraveListChecked = [];
  List<String> shareToFollowers = [];

  List<Widget> followersWidget = [];
  List<Followers> returnedFollowers = [];
  List<bool> isChecked = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => startLoad());
  }

  void startLoad() async{
    // scrollDown();
    print(MediaQuery.of(context).size.width);
    loadCraveList();
    loadFollowers();
    setState(() {

      for (int i = 0; i < this.widget.medias.length; i++){
        isShowOptions.add(false);
        isShowCraveList.add(false);
      }

    });
  }

  void goToComments() {
    setState(() {
      Navigator.of(context).pushNamed("/feedDetails");
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

  void changeGridView(bool gridValue) {
    setState(() {
      isGridView = gridValue;
    });
  }

  void goToCraveLists() {
    this.widget.profilePageController.jumpToPage(2);
  }

  void openMenuOthers(){
    setState(() {
      isMenuOpen = !isMenuOpen;
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
      addToCraveList.clear();
      currentCraveListChecked.clear();
      for(int k=0;k<currentCraveList.length;k++){
        currentCraveListChecked.add(false);
      }
      isShowCraveList[index] = true;
    });
  }

  void hideCraveList(int index){
    setState(() {
      addToCraveListContent(this.widget.medias[index].media_id);
      isShowCraveList[index] = false;
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

        });
  }

  Future<http.Response> shareToFollower(String mediaId) async {

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

        setState(() {
          //isCarAvailable = true;
          // selectedMedia = media[0];
          returnedFollowers = followers;

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
                                      // color:Colors.black,
                                      height: MediaQuery.of(context).size.height,
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.only(bottom:0,top:15),
                                      child:SingleChildScrollView(
                                        child: Stack(
                                          children: [
                                            //Posts
                                            Container(
                                              padding: const EdgeInsets.only(left:10,right:10),
                                              margin:EdgeInsets.only(top:30,right:5),
                                              height:MediaQuery.of(context).size.height -230,
                                              decoration: BoxDecoration(
                                                // color:Colors.green,
                                                image: DecorationImage(
                                                  image: AssetImage("images/own_profile_bg3.png"),
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
                                                    Padding(
                                                      padding: const EdgeInsets.only(top:15,bottom:15),
                                                      child:Row(
                                                        children: [
                                                          Text('Posts',
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight.w600,
                                                                  color: Color(constant.Color.crave_brown),
                                                                  fontSize: 14.0.sp)),
                                                          Spacer(),
                                                          Row(
                                                            children: [
                                                              GestureDetector(
                                                                  onTap:(){
                                                                    changeGridView(true);
                                                                  },
                                                                  child:
                                                                  isGridView?
                                                                  Image.asset(
                                                                    'images/grid_icon_selected.png',
                                                                    height: 2.0.h,
                                                                  ):
                                                                  Image.asset(
                                                                    'images/grid_icon.png',
                                                                    height: 2.0.h,
                                                                  )
                                                              )
                                                              ,
                                                              SizedBox(width:10),
                                                              GestureDetector(
                                                                onTap:(){
                                                                  changeGridView(false);
                                                                },
                                                                child:isGridView?
                                                                Image.asset(
                                                                  'images/single_grid_icon.png',
                                                                  height: 2.3.h,
                                                                ):
                                                                Image.asset(
                                                                  'images/single_grid_icon_selected.png',
                                                                  height: 2.3.h,
                                                                ),
                                                              ),

                                                              SizedBox(width:20),

                                                            ],
                                                          ),
                                                        ],
                                                      ),

                                                    ),

                                                  ),

                                                  Container(
                                                    height:MediaQuery.of(context).size.height -320,
                                                    width:MediaQuery.of(context).size.width,
                                                    child:isGridView?

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
                                                    //
                                                    //   ],
                                                    // )
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
                                                        })
                                                        :

                                                    MediaQuery.removePadding(
                                                        removeTop: true,
                                                        context: context,
                                                        child:
                                                        ListView.builder(
                                                          // the number of items in the list
                                                            itemCount: this.widget.medias.length,
                                                            // display each item of the product list
                                                            itemBuilder: (context, index) {
                                                              return
                                                                Padding(
                                                                  padding: EdgeInsets.only(top:index!=0?15:0),
                                                                  child: Card(
                                                                    margin:EdgeInsets.zero,
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                                                    ),
                                                                    child:Container(
                                                                      // color:Colors.black,
                                                                      padding: EdgeInsets.only(right:5,bottom:15),
                                                                      child:Column(
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              CircleAvatar(
                                                                                radius: 28.0,
                                                                                backgroundImage:
                                                                                NetworkImage(constant.Url.profile_url+this.widget.medias[index].user_profile_img),
                                                                                backgroundColor: Colors.transparent,
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(left:5),
                                                                                child:Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    IntrinsicHeight(
                                                                                        child:Row(
                                                                                          children: [
                                                                                            Text(this.widget.medias[index].user_display_name,
                                                                                                style: TextStyle(
                                                                                                    fontWeight: FontWeight.w700,
                                                                                                    color: Colors.black,
                                                                                                    fontSize: 10.0.sp)),
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
                                                                                            Text('Following',
                                                                                                style: TextStyle(
                                                                                                    fontWeight: FontWeight.w700,
                                                                                                    color:Color(constant.Color.crave_blue),
                                                                                                    fontSize: 11.0.sp)),
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
                                                                                                  width:55.0.w,
                                                                                                  padding: const EdgeInsets.only(left:5),
                                                                                                  child: Text(this.widget.medias[index].media_location.replaceAll('', '\u200B'),
                                                                                                      overflow: TextOverflow.ellipsis,
                                                                                                      style: TextStyle(
                                                                                                          fontSize: 9.0.sp)),
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
                                                                                  padding: const EdgeInsets.only(left:10,right:15),
                                                                                  child: Image.asset(
                                                                                      'images/others_icon.png',
                                                                                      height: 1.0.h,
                                                                                      width:5.0.w
                                                                                  ),
                                                                                ),
                                                                              ),


                                                                            ],

                                                                          ),

                                                                          Stack(
                                                                            children: [
                                                                              GestureDetector(
                                                                                //onTap:goToComments,
                                                                                child:Container(
                                                                                  height:35.0.h,
                                                                                  margin: const EdgeInsets.only(bottom:23,top:10,right:3),
                                                                                  decoration: BoxDecoration(
                                                                                    image: DecorationImage(image: NetworkImage(constant.Url.media_url+this.widget.medias[index].media_name), fit: BoxFit.fitHeight),

                                                                                  ),
                                                                                ),
                                                                              ),

                                                                              isShowOptions[index]?
                                                                              Wrap(
                                                                                children: [
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
                                                                            ],
                                                                          ),


                                                                          Padding(
                                                                            padding:EdgeInsets.only(left:10),
                                                                            child: IntrinsicHeight(
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                   this.widget.medias[index].post_likes_user=='1'?
                                                                                      Image.asset(
                                                                                      'images/love_selected_icon.png',
                                                                                      height: 2.2.h,
                                                                                    ):
                                                                                    Image.asset(
                                                                                    'images/icon_love.png',
                                                                                    height: 2.2.h,
                                                                                  ),

                                                                                  Padding(
                                                                                    padding: EdgeInsets.only(left:2.0.w,right:6.0.w),
                                                                                    child:Text(this.widget.medias[index].post_likes,
                                                                                        style: TextStyle(
                                                                                            fontWeight: FontWeight.w600,
                                                                                            color: Colors.black,
                                                                                            fontSize: 10.0.sp)),
                                                                                  ),

                                                                                  this.widget.medias[index].post_craving_user=='1'?
                                                                                  Image.asset(
                                                                                    'images/icon_crave.png',
                                                                                    height: 2.2.h,
                                                                                  ):
                                                                                  Image.asset(
                                                                                    'images/icon_crave_grey.png',
                                                                                    height: 2.2.h,
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: EdgeInsets.only(left:2.0.w,right:6.0.w),
                                                                                    child:Text(this.widget.medias[index].post_craving,
                                                                                        style: TextStyle(
                                                                                            fontWeight: FontWeight.w600,
                                                                                            color: Colors.black,
                                                                                            fontSize: 10.0.sp)),
                                                                                  ),

                                                                                  GestureDetector(
                                                                                    onTap:goToComments,
                                                                                    child:Image.asset(
                                                                                      'images/comment_icon.png',
                                                                                      height: 2.2.h,
                                                                                    ),
                                                                                  ),
                                                                                  GestureDetector(
                                                                                    onTap:goToComments,
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
                                                                                style: TextStyle(
                                                                                    color: Colors.grey,
                                                                                    fontSize: 10.0.sp)),
                                                                          ),


                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                            })
                                                      // ListView(
                                                      //   shrinkWrap: true,
                                                      //   //physics: NeverScrollableScrollPhysics(),
                                                      //   // crossAxisCount: 2,
                                                      //   // mainAxisSpacing: 10.0,
                                                      //   // crossAxisSpacing: 10.0,
                                                      //   // childAspectRatio: aspectRatio,
                                                      //   children: <Widget>[
                                                      //     Card(
                                                      //       margin:EdgeInsets.zero,
                                                      //       shape: RoundedRectangleBorder(
                                                      //         borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                                      //       ),
                                                      //       child:Container(
                                                      //         // color:Colors.black,
                                                      //         padding: EdgeInsets.only(right:5,bottom:15),
                                                      //         child:Column(
                                                      //           children: [
                                                      //             Row(
                                                      //               children: [
                                                      //                 Image.asset(
                                                      //                   'images/user1.png',
                                                      //                   height: 6.0.h,
                                                      //                 ),
                                                      //                 Padding(
                                                      //                   padding: const EdgeInsets.only(left:5),
                                                      //                   child:Column(
                                                      //                     mainAxisAlignment: MainAxisAlignment.start,
                                                      //                     crossAxisAlignment: CrossAxisAlignment.start,
                                                      //                     children: [
                                                      //                       IntrinsicHeight(
                                                      //                           child:Row(
                                                      //                             children: [
                                                      //                               Text('KARHENGDESU',
                                                      //                                   style: TextStyle(
                                                      //                                       fontWeight: FontWeight.w700,
                                                      //                                       color: Colors.black,
                                                      //                                       fontSize: 10.0.sp)),
                                                      //                               Padding(
                                                      //                                 padding: EdgeInsets.only(left: 5.0),
                                                      //                                 child:Image.asset(
                                                      //                                   'images/verified_logo.png',
                                                      //                                   height: 2.0.h,
                                                      //                                 ),
                                                      //                               ),
                                                      //
                                                      //                               Container(
                                                      //                                 padding: const EdgeInsets.only(left:5,right:5,top:2,bottom:2),
                                                      //                                 child:VerticalDivider(
                                                      //                                   color: Colors.black,
                                                      //                                 ),
                                                      //                               ),
                                                      //                               Text('Follow',
                                                      //                                   style: TextStyle(
                                                      //                                       fontWeight: FontWeight.w700,
                                                      //                                       color:Color(constant.Color.crave_orange),
                                                      //                                       fontSize: 11.0.sp)),
                                                      //                             ],
                                                      //                           )
                                                      //                       ),
                                                      //                       Padding(
                                                      //                           padding: const EdgeInsets.only(top:5),
                                                      //                           child:IntrinsicHeight(
                                                      //                               child:Row(
                                                      //                                 children: [
                                                      //                                   Image.asset(
                                                      //                                     'images/location_icon.png',
                                                      //                                     height: 2.0.h,
                                                      //                                   ),
                                                      //                                   Padding(
                                                      //                                     padding: const EdgeInsets.only(left:5),
                                                      //                                     child: Text('RESTORAN INI, Petaling Jaya',
                                                      //                                         style: TextStyle(
                                                      //                                             fontSize: 9.0.sp)),
                                                      //                                   ),
                                                      //
                                                      //
                                                      //                                 ],
                                                      //                               )
                                                      //                           )
                                                      //                       ),
                                                      //
                                                      //
                                                      //                     ],
                                                      //                   ),
                                                      //                 ),
                                                      //                 Spacer(),
                                                      //                 GestureDetector(
                                                      //                   //onTap:onShareFeed,
                                                      //                   child: Image.asset(
                                                      //                     'images/forward_icon.png',
                                                      //                     height: 2.3.h,
                                                      //                   ),
                                                      //                 ),
                                                      //
                                                      //                 Padding(
                                                      //                   padding: const EdgeInsets.only(left:10,right:15),
                                                      //                   child: Image.asset(
                                                      //                       'images/others_icon.png',
                                                      //                       height: 1.0.h,
                                                      //                       width:5.0.w
                                                      //                   ),
                                                      //                 ),
                                                      //
                                                      //               ],
                                                      //
                                                      //             ),
                                                      //             GestureDetector(
                                                      //               //onTap:goToComments,
                                                      //               child:Container(
                                                      //                 height:38.0.h,
                                                      //                 margin: const EdgeInsets.only(bottom:23,top:10,right:3),
                                                      //                 decoration: BoxDecoration(
                                                      //                   image: DecorationImage(image: AssetImage("images/food1.png"), fit: BoxFit.cover),
                                                      //
                                                      //                 ),
                                                      //               ),
                                                      //             ),
                                                      //
                                                      //             Padding(
                                                      //               padding:EdgeInsets.only(left:10),
                                                      //               child: IntrinsicHeight(
                                                      //                 child: Row(
                                                      //                   mainAxisAlignment: MainAxisAlignment.start,
                                                      //                   crossAxisAlignment: CrossAxisAlignment.start,
                                                      //                   children: [
                                                      //                     Image.asset(
                                                      //                       'images/love_selected_icon.png',
                                                      //                       height: 2.2.h,
                                                      //                     ),
                                                      //                     Padding(
                                                      //                       padding: EdgeInsets.only(left:2.0.w,right:6.0.w),
                                                      //                       child:Text('4.5k',
                                                      //                           style: TextStyle(
                                                      //                               fontWeight: FontWeight.w600,
                                                      //                               color: Colors.black,
                                                      //                               fontSize: 10.0.sp)),
                                                      //                     ),
                                                      //
                                                      //                     Image.asset(
                                                      //                       'images/icon_crave.png',
                                                      //                       height: 2.2.h,
                                                      //                     ),
                                                      //                     Padding(
                                                      //                       padding: EdgeInsets.only(left:2.0.w,right:6.0.w),
                                                      //                       child:Text('1.4k',
                                                      //                           style: TextStyle(
                                                      //                               fontWeight: FontWeight.w600,
                                                      //                               color: Colors.black,
                                                      //                               fontSize: 10.0.sp)),
                                                      //                     ),
                                                      //
                                                      //                     GestureDetector(
                                                      //                       onTap:goToComments,
                                                      //                       child:Image.asset(
                                                      //                         'images/comment_icon.png',
                                                      //                         height: 2.2.h,
                                                      //                       ),
                                                      //                     ),
                                                      //                     GestureDetector(
                                                      //                       onTap:goToComments,
                                                      //                       child:Padding(
                                                      //                         padding: EdgeInsets.only(left:2.0.w,right:6.0.w),
                                                      //                         child:Text('2.2k',
                                                      //                             style: TextStyle(
                                                      //                                 fontWeight: FontWeight.w600,
                                                      //                                 color: Colors.black,
                                                      //                                 fontSize: 10.0.sp)),
                                                      //                       ),
                                                      //                     ),
                                                      //
                                                      //
                                                      //                   ],
                                                      //                 ),
                                                      //               ),
                                                      //             ),
                                                      //
                                                      //
                                                      //             Padding(
                                                      //               padding:EdgeInsets.only(top:10,left:10),
                                                      //               child:Text('Lorem ipsum dolor sit amet, consectetur adipiscing . . . ',
                                                      //                   maxLines: 1,
                                                      //                   overflow: TextOverflow.ellipsis,
                                                      //                   style: TextStyle(
                                                      //                       color: Colors.grey,
                                                      //                       fontSize: 10.0.sp)),
                                                      //             ),
                                                      //
                                                      //
                                                      //           ],
                                                      //         ),
                                                      //       ),
                                                      //     ),
                                                      //
                                                      //     Padding(
                                                      //       padding: const EdgeInsets.only(top:15),
                                                      //       child: Card(
                                                      //         margin:EdgeInsets.zero,
                                                      //         shape: RoundedRectangleBorder(
                                                      //           borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                                      //         ),
                                                      //         child:Container(
                                                      //           // color:Colors.black,
                                                      //           padding: EdgeInsets.only(right:5,bottom:15),
                                                      //           child:Column(
                                                      //             children: [
                                                      //               Row(
                                                      //                 children: [
                                                      //                   Image.asset(
                                                      //                     'images/user1.png',
                                                      //                     height: 6.0.h,
                                                      //                   ),
                                                      //                   Padding(
                                                      //                     padding: const EdgeInsets.only(left:5),
                                                      //                     child:Column(
                                                      //                       mainAxisAlignment: MainAxisAlignment.start,
                                                      //                       crossAxisAlignment: CrossAxisAlignment.start,
                                                      //                       children: [
                                                      //                         IntrinsicHeight(
                                                      //                             child:Row(
                                                      //                               children: [
                                                      //                                 Text('KARHENGDESU',
                                                      //                                     style: TextStyle(
                                                      //                                         fontWeight: FontWeight.w700,
                                                      //                                         color: Colors.black,
                                                      //                                         fontSize: 10.0.sp)),
                                                      //                                 Padding(
                                                      //                                   padding: EdgeInsets.only(left: 5.0),
                                                      //                                   child:Image.asset(
                                                      //                                     'images/verified_logo.png',
                                                      //                                     height: 2.0.h,
                                                      //                                   ),
                                                      //                                 ),
                                                      //
                                                      //                                 Container(
                                                      //                                   padding: const EdgeInsets.only(left:5,right:5,top:2,bottom:2),
                                                      //                                   child:VerticalDivider(
                                                      //                                     color: Colors.black,
                                                      //                                   ),
                                                      //                                 ),
                                                      //                                 Text('Following',
                                                      //                                     style: TextStyle(
                                                      //                                         fontWeight: FontWeight.w700,
                                                      //                                         color:Color(constant.Color.crave_blue),
                                                      //                                         fontSize: 11.0.sp)),
                                                      //                               ],
                                                      //                             )
                                                      //                         ),
                                                      //                         Padding(
                                                      //                             padding: const EdgeInsets.only(top:5),
                                                      //                             child:IntrinsicHeight(
                                                      //                                 child:Row(
                                                      //                                   children: [
                                                      //                                     Image.asset(
                                                      //                                       'images/location_icon.png',
                                                      //                                       height: 2.0.h,
                                                      //                                     ),
                                                      //                                     Padding(
                                                      //                                       padding: const EdgeInsets.only(left:5),
                                                      //                                       child: Text('RESTORAN INI, Petaling Jaya',
                                                      //                                           style: TextStyle(
                                                      //                                               fontSize: 9.0.sp)),
                                                      //                                     ),
                                                      //
                                                      //
                                                      //                                   ],
                                                      //                                 )
                                                      //                             )
                                                      //                         ),
                                                      //
                                                      //
                                                      //                       ],
                                                      //                     ),
                                                      //                   ),
                                                      //                   Spacer(),
                                                      //                   GestureDetector(
                                                      //                     //onTap:onShareFeed,
                                                      //                     child: Image.asset(
                                                      //                       'images/forward_icon.png',
                                                      //                       height: 2.3.h,
                                                      //                     ),
                                                      //                   ),
                                                      //
                                                      //                   Padding(
                                                      //                     padding: const EdgeInsets.only(left:10,right:15),
                                                      //                     child: Image.asset(
                                                      //                         'images/others_icon.png',
                                                      //                         height: 1.0.h,
                                                      //                         width:5.0.w
                                                      //                     ),
                                                      //                   ),
                                                      //
                                                      //                 ],
                                                      //
                                                      //               ),
                                                      //               GestureDetector(
                                                      //                 //onTap:goToComments,
                                                      //                 child:Container(
                                                      //                   height:35.0.h,
                                                      //                   margin: const EdgeInsets.only(bottom:23,top:10,right:3),
                                                      //                   decoration: BoxDecoration(
                                                      //                     image: DecorationImage(image: AssetImage("images/food2.png"), fit: BoxFit.cover),
                                                      //
                                                      //                   ),
                                                      //                 ),
                                                      //               ),
                                                      //
                                                      //               Padding(
                                                      //                 padding:EdgeInsets.only(left:10),
                                                      //                 child: IntrinsicHeight(
                                                      //                   child: Row(
                                                      //                     mainAxisAlignment: MainAxisAlignment.start,
                                                      //                     crossAxisAlignment: CrossAxisAlignment.start,
                                                      //                     children: [
                                                      //                       Image.asset(
                                                      //                         'images/love_selected_icon.png',
                                                      //                         height: 2.2.h,
                                                      //                       ),
                                                      //                       Padding(
                                                      //                         padding: EdgeInsets.only(left:2.0.w,right:6.0.w),
                                                      //                         child:Text('4.5k',
                                                      //                             style: TextStyle(
                                                      //                                 fontWeight: FontWeight.w600,
                                                      //                                 color: Colors.black,
                                                      //                                 fontSize: 10.0.sp)),
                                                      //                       ),
                                                      //
                                                      //                       Image.asset(
                                                      //                         'images/icon_crave.png',
                                                      //                         height: 2.2.h,
                                                      //                       ),
                                                      //                       Padding(
                                                      //                         padding: EdgeInsets.only(left:2.0.w,right:6.0.w),
                                                      //                         child:Text('1.4k',
                                                      //                             style: TextStyle(
                                                      //                                 fontWeight: FontWeight.w600,
                                                      //                                 color: Colors.black,
                                                      //                                 fontSize: 10.0.sp)),
                                                      //                       ),
                                                      //
                                                      //                       GestureDetector(
                                                      //                         onTap:goToComments,
                                                      //                         child:Image.asset(
                                                      //                           'images/comment_icon.png',
                                                      //                           height: 2.2.h,
                                                      //                         ),
                                                      //                       ),
                                                      //                       GestureDetector(
                                                      //                         onTap:goToComments,
                                                      //                         child:Padding(
                                                      //                           padding: EdgeInsets.only(left:2.0.w,right:6.0.w),
                                                      //                           child:Text('2.2k',
                                                      //                               style: TextStyle(
                                                      //                                   fontWeight: FontWeight.w600,
                                                      //                                   color: Colors.black,
                                                      //                                   fontSize: 10.0.sp)),
                                                      //                         ),
                                                      //                       ),
                                                      //
                                                      //
                                                      //                     ],
                                                      //                   ),
                                                      //                 ),
                                                      //               ),
                                                      //
                                                      //
                                                      //               Padding(
                                                      //                 padding:EdgeInsets.only(top:10,left:10),
                                                      //                 child:Text('Lorem ipsum dolor sit amet, consectetur adipiscing . . . ',
                                                      //                     maxLines: 1,
                                                      //                     overflow: TextOverflow.ellipsis,
                                                      //                     style: TextStyle(
                                                      //                         color: Colors.grey,
                                                      //                         fontSize: 10.0.sp)),
                                                      //               ),
                                                      //
                                                      //
                                                      //             ],
                                                      //           ),
                                                      //         ),
                                                      //       ),
                                                      //     ),
                                                      //
                                                      //   ],
                                                      // ),
                                                    ),
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
                                  alignment: Alignment.bottomRight,
                                  child:
                                  GestureDetector(
                                    onTap:goToCraveLists,
                                    child:Padding(
                                      padding: const EdgeInsets.only(bottom:15,left:10),
                                      child: Image.asset('images/craves_list_icon.png',height:80),
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


