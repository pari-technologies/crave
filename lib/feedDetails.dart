// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:a_crave/profileUser.dart';
import 'package:a_crave/reelsDetails.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dataClass.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import 'constants.dart' as constant;

class FeedDetails extends StatefulWidget {
  final PageController homepageController;
  final Media selectedMedia;
  final List<Comment> commentList;
  final Function(int) onDataChange;
  final int selectedMediaIndex;
  final Function(String) onSelectUser;
  const FeedDetails({Key? key, required this.homepageController,required this.selectedMedia, required this.commentList,required this.onDataChange,required this.selectedMediaIndex, required this.onSelectUser}) : super(key: key);

  @override
  FeedDetailsState createState() => FeedDetailsState();
}

class FeedDetailsState extends State<FeedDetails> {

  final textController = TextEditingController();
  final textReplyController = TextEditingController();
  final searchTextController = TextEditingController();
  final addListTxtController = TextEditingController();
  bool showPostButton = false;
  bool showPostReplyButton = false;

  String isUserFollow = "";
  bool isShowComments = false;
  FocusNode _focus = FocusNode();
  FocusNode _focusReply = FocusNode();
  List<bool> isChecked = [];
  List<Widget> followersWidget = [];
  List<Followers> returnedFollowers = [];
  List<Followers> duplicateItems = [];
  List<String> shareToFollowers = [];

  bool isShowOptions = false;
  bool isShowCraveList = false;
  bool isShowStats = false;
  bool isShowStatsPopup = false;

  String currentUserId = "";

  String currentCraves = "0";
  String currentLikes = "0";
  String currentViews = "0";
  String currentComments = "0";
  String palette1 = "";
  String palette2 = "";
  String palette3 = "";

  List<CraveList> currentCraveList = [];
  List<bool> currentCraveListChecked = [];
  List<String> addToCraveList = [];
  List<Comment> returnedComment = [];

  String post_likes_list = "";
  String post_likes = "";
  String post_crave_list = "";
  String post_crave = "";
  List<String> post_comment_list = [];
  List<String> post_comment = [];
  List<CommentReplied> isCommentReplied = [];


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => startLoad());
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
          controller: searchTextController,
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
        searchTextController.clear();
        loadFollowers();
      });
      print('Hey there, I\'m calling after hide bottomSheet');
    });
  }

  void onShowComments(index){
    setState(() {
      isCommentReplied[index].isOpenReplied = !isCommentReplied[index].isOpenReplied;
    });
  }

  void startLoad() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUserId = prefs.getString('user_email')!;
    });
    loadFollowers();
    loadCraveList();
    _focus.addListener(_onFocusChange);
    _focusReply.addListener(_onFocusReplyChange);
    print(MediaQuery.of(context).size.width);
    loadComment(this.widget.selectedMedia.media_id);
    setState(() {
      isUserFollow = this.widget.selectedMedia.is_follow;
      post_likes_list = this.widget.selectedMedia.post_likes_user;
      post_likes = this.widget.selectedMedia.post_likes;
      post_crave_list = this.widget.selectedMedia.post_craving_user;
      post_crave = this.widget.selectedMedia.post_craving;
      currentComments = this.widget.selectedMedia.post_comments.toString();

    });

  }

  Future<List<Comment>> loadComment(m_media_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var url = Uri.parse(constant.Url.crave_url+'get_post_comments.php');
    returnedComment.clear();
    post_comment_list.clear();
    post_comment.clear();

    print("ajsbdajbsd");
    print(prefs.getString('user_email'));
    print(m_media_id);
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        "email":prefs.getString('user_email'),
        "post_id":m_media_id,
      },
    );

    if (response.statusCode == 200) {
      print("get response load comment");
      print(response.body);

      Map<String, dynamic> user = jsonDecode(response.body);

      if(user['comments'] != null){

        List<dynamic> body = user['comments'];

        // List<Comment> comment = body
        //     .map(
        //       (dynamic item) => Comment.fromJson(item),
        // ).toList();

        final comment = commentsFromJson(response.body);

        setState(() {
          //isCarAvailable = true;
          print("comment length");
          print(comment.comments.length);
          returnedComment = comment.comments;

          for(int k=0;k<comment.comments.length ; k++){
            post_comment_list.add(comment.comments[k].commentLikesUser);
            post_comment.add(comment.comments[k].commentLikes);

            if(comment.comments[k].replied.length > 0){
              isCommentReplied.add(CommentReplied(isReplied:true, isOpenReplied:false));
            }
            else{
              isCommentReplied.add(CommentReplied(isReplied:false, isOpenReplied:false));
            }
            // for(int i=0;i<comment.comments[k].replied.length;i++){
            //
            // }
          }


        });


        //suggestions = location;
        // print("--avaialbel carr---");
        print(returnedComment);
        return returnedComment;
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
        "post_id":this.widget.selectedMedia.media_id,
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
            post_likes_list = "1";
          }
          else{
            post_likes_list = "0";
          }

          post_likes = user['current_likes'];

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

  Future<http.Response> likeComment(int index) async {
    var url = Uri.parse(constant.Url.crave_url+'like_comment.php');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        "email":prefs.getString('user_email'),
        "post_id":returnedComment[index].cMcommentId,
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
            post_comment_list[index] = "1";
          }
          else{
            post_comment_list[index] = "0";
          }

          post_comment[index] = user['current_likes'];

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

  Future<http.Response> likeReplyComment(int index,int indexR) async {
    var url = Uri.parse(constant.Url.crave_url+'like_comment.php');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        "email":prefs.getString('user_email'),
        "post_id":returnedComment[index].replied[indexR].cMcommentId,
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
            post_comment_list[index] = "1";
          }
          else{
            post_comment_list[index] = "0";
          }

          post_comment[index] = user['current_likes'];

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
        "post_id":this.widget.selectedMedia.media_id,
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
            post_crave_list = "1";
          }
          else{
            post_crave_list = "0";
          }

          post_crave = user['current_crave'].toString();

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

  void launchWaze() async {
    final new_dis = this.widget.selectedMedia.media_latlng.split(',');
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

  void launchGoogleMaps() async {
    final new_dis = this.widget.selectedMedia.media_latlng.split(',');
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

  void showTravelTo(){
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
                            launchGoogleMaps();
                          },
                          child:ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Image.asset('images/gmaps_icon.png',height: 60.0),
                          ),
                        ),

                        SizedBox(width:20),
                        GestureDetector(
                          onTap:(){
                            launchWaze();
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
  void dispose() {
    super.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
    _focusReply.removeListener(_onFocusChange);
    _focusReply.dispose();
  }

  void _onFocusChange() {
    debugPrint("Focus: ${_focus.hasFocus.toString()}");
    if(_focus.hasFocus){
      setState(() {
        showPostButton = true;
      });
    }
    else{
      setState(() {
        showPostButton = false;
      });
    }

  }

  void _onFocusReplyChange() {
    debugPrint("Focus: ${_focusReply.hasFocus.toString()}");
    if(_focusReply.hasFocus){
      setState(() {
        showPostReplyButton = true;
      });
    }
    else{
      setState(() {
        showPostReplyButton = false;
      });
    }

  }

  Future<http.Response> sendComment() async {
    var url = Uri.parse(constant.Url.crave_url+'send_comment.php');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        "email":prefs.getString('user_email'),
        "post_id":this.widget.selectedMedia.media_id,
        "reply_comment":'0',
        "comment":textController.text,
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
        textController.clear();
        FocusScope.of(context).requestFocus(FocusNode());
        loadComment(this.widget.selectedMedia.media_id);
        this.widget.onDataChange(this.widget.selectedMediaIndex);

        int newCommentCount = int.parse(currentComments) + 1;
        setState(() {
          currentComments = newCommentCount.toString();
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

  Future<http.Response> sendReplyComment(String replyId) async {
    var url = Uri.parse(constant.Url.crave_url+'send_comment.php');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        "email":prefs.getString('user_email'),
        "post_id":this.widget.selectedMedia.media_id,
        "comment":textReplyController.text,
        "reply_comment":replyId,
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
        textController.clear();
        textReplyController.clear();
        FocusScope.of(context).requestFocus(FocusNode());
        loadComment(this.widget.selectedMedia.media_id);
        this.widget.onDataChange(this.widget.selectedMediaIndex);

        int newCommentCount = int.parse(currentComments) + 1;
        setState(() {
          currentComments = newCommentCount.toString();
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

  Future<http.Response> followUser(String user_following) async {
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
        this.widget.onDataChange(this.widget.selectedMediaIndex);
        setState(() {
          if(isUserFollow == "0"){
            isUserFollow = "1";
          }
          else{
            isUserFollow = "0";
          }
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

  void showOptions(){
    setState(() {
      isShowOptions = true;
    });
  }

  void hideOptions(){
    setState(() {
      isShowOptions = false;
    });
  }

  void showCraveList(){
    setState(() {
      isShowCraveList = true;
    });
  }

  void hideCraveList(){
    setState(() {
      addToCraveListContent(this.widget.selectedMedia.media_id);
      isShowCraveList = false;
    });
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

  void showStatsPopup(){
    setState(() {
      isShowStats= false;
      currentCraves = this.widget.selectedMedia.post_craving.toString();
      currentLikes = this.widget.selectedMedia.post_likes.toString();
      currentViews = (int.parse(this.widget.selectedMedia.post_likes) + int.parse(this.widget.selectedMedia.post_craving)).toString();
      currentComments = this.widget.selectedMedia.post_comments.toString();
      palette1 = this.widget.selectedMedia.tags1.toString();
      palette2 = this.widget.selectedMedia.tags2.toString();
      palette3 = this.widget.selectedMedia.tags3.toString();
      isShowStatsPopup = true;
    });
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

  @override
  Widget build(BuildContext context) {

    var maxWidth = 500.0;
    var width = MediaQuery.of(context).size.width;
    var columns = (width ~/ maxWidth) + 1;
    var columnWidth = width / columns;
    var aspectRatio = columnWidth / 390;

    final screenSize = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop:()async{
        // this.widget.homepageController.jumpToPage(0);
        this.widget.homepageController.previousPage(duration: Duration(milliseconds: 100), curve: Curves.easeOut);
        // this.widget.homepageController.animateTo(1, duration: new Duration(milliseconds: 100), curve: Curves.easeOut);
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
                            body:
                                SingleChildScrollView(
                                  child:
                                  Container(
                                    height:MediaQuery.of(context).size.height,
                                    child: Column(
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
                                                        // this.widget.homepageController.animateTo(1, duration: new Duration(milliseconds: 100), curve: Curves.easeOut);
                                                        this.widget.homepageController.previousPage(duration: Duration(milliseconds: 100), curve: Curves.easeOut);
                                                      },
                                                      child:
                                                      Icon(Icons.arrow_back_ios,size: 25,)
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
                                        Column(
                                          children: [
                                            // Card(
                                            //   margin:EdgeInsets.zero,
                                            //   shape: RoundedRectangleBorder(
                                            //     borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                            //   ),
                                            //   child:
                                              Container(
                                                padding: const EdgeInsets.only(bottom:20,top:15),
                                                child:Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets.only(left:15,right:15),
                                                      child:Row(
                                                        children: [
                                                          CircleAvatar(
                                                            radius: 28.0,
                                                            backgroundImage:
                                                            NetworkImage(constant.Url.profile_url+this.widget.selectedMedia.user_profile_img),
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
                                                                        Text(this.widget.selectedMedia.user_display_name,
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

                                                                        GestureDetector(
                                                                          onTap:(){
                                                                            followUser(this.widget.selectedMedia.media_user_id);
                                                                          },
                                                                          child:isUserFollow=="0"?
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
                                                                              child: Text(this.widget.selectedMedia.media_location.replaceAll('', '\u200B'),
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
                                                              onShareFeed(this.widget.selectedMedia.media_id);
                                                            },
                                                            child: Image.asset(
                                                              'images/forward_icon.png',
                                                              height: 2.3.h,
                                                            ),
                                                          ),

                                                          GestureDetector(
                                                            onTap:(){
                                                              showOptions();
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

                                                    Container(
                                                      height:35.0.h,
                                                      margin: const EdgeInsets.only(bottom:20,top:10),
                                                      // decoration: BoxDecoration(
                                                      //   image: DecorationImage(image: NetworkImage(constant.Url.media_url+this.widget.selectedMedia.media_name), fit: BoxFit.cover),
                                                      //
                                                      // ),
                                                      child:Stack(
                                                          children:[
                                                            PinchZoom(
                                                              child: Container(
                                                                // height: 100.0.h,
                                                                // width: 100.0.w,
                                                                // margin: EdgeInsets.only(left:15.0.w,bottom:40.0.w),
                                                                // padding: EdgeInsets.only(top:30.w,right:15.0.w),
                                                                decoration:
                                                                BoxDecoration(
                                                                  // color:Colors.yellow,
                                                                    image: DecorationImage(
                                                                        fit:BoxFit.cover,
                                                                        image: NetworkImage(constant.Url.media_url+this.widget.selectedMedia.media_name))),
                                                                child: Center(
                                                                  child: Text(
                                                                    this.widget.selectedMedia.c_textfilter,
                                                                    // style: getTextStyle(returnedStories[i].storyItems[k].cTextStyle),
                                                                    style: TextStyle(
                                                                        fontSize: this.widget.selectedMedia.c_textSize!=''?double.parse(this.widget.selectedMedia.c_textSize):0,
                                                                        color: this.widget.selectedMedia.c_textColor!=''?stringToColor(this.widget.selectedMedia.c_textColor):Colors.transparent,
                                                                        backgroundColor: this.widget.selectedMedia.c_textBgColor!=''?stringToColor(this.widget.selectedMedia.c_textBgColor):Colors.transparent,
                                                                        fontFamily: this.widget.selectedMedia.c_textFamily!=''?this.widget.selectedMedia.c_textFamily:'Billabong'
                                                                    ),
                                                                    textAlign: getTextAlign(this.widget.selectedMedia.c_textalign),
                                                                  ),
                                                                ),

                                                              ),
                                                              resetDuration: const Duration(milliseconds: 100),
                                                              maxScale: 2.5,
                                                              onZoomStart: (){print('Start zooming');},
                                                              onZoomEnd: (){print('Stop zooming');},
                                                            ),
                                                            isShowStats?
                                                            Container(
                                                                color:Colors.black45,
                                                                padding: const EdgeInsets.only(top:25),
                                                                height:35.0.h,
                                                                width:screenSize.width,
                                                                child:Column(
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap:(){
                                                                        showStatsPopup();
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
                                                                          showTravelTo();
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
                                                            isShowOptions?
                                                            Wrap(
                                                              children: [
                                                                this.widget.selectedMedia.media_user_id != currentUserId?
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
                                                                            hideOptions();
                                                                          },
                                                                          child:Container(
                                                                              padding: const EdgeInsets.only(top:5,right:20),
                                                                              child:Icon(Icons.close,size: 20,color:Colors.white)
                                                                          ),
                                                                        ),
                                                                        GestureDetector(
                                                                          onTap:(){
                                                                            showCraveList();
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
                                                                            hideOptions();
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
                                                            isShowCraveList?
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
                                                                                hideCraveList();
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
                                                                            padding: EdgeInsets.zero,
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

                                                    Padding(
                                                      padding:EdgeInsets.only(left:15,right:15),
                                                      child: IntrinsicHeight(
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            GestureDetector(
                                                              onTap:(){
                                                                likePost(this.widget.selectedMediaIndex);
                                                              },
                                                              child:Row(
                                                                children: [
                                                                  post_likes_list=='1'?
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
                                                                    child:Text(post_likes,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.w600,
                                                                            color: Colors.black,
                                                                            fontSize: 10.0.sp)),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),

                                                            GestureDetector(
                                                              onTap:(){
                                                                cravePost(this.widget.selectedMediaIndex);
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  post_crave_list=='1'?
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
                                                                    child:Text(post_crave,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.w600,
                                                                            color: Colors.black,
                                                                            fontSize: 10.0.sp)),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),


                                                            GestureDetector(
                                                              child:Image.asset(
                                                                'images/comment_icon.png',
                                                                height: 2.2.h,
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              child:Padding(
                                                                padding: EdgeInsets.only(left:2.0.w,right:6.0.w),
                                                                child:Text(currentComments,
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
                                                      child:Text(this.widget.selectedMedia.media_desc,
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: TextStyle(
                                                              color: Colors.grey,
                                                              fontSize: 10.0.sp)),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                            // ),

                                            Container(
                                              height:20.0.h,
                                              child:ListView.builder(
                                                  padding: EdgeInsets.zero,
                                                  // the number of items in the list
                                                  itemCount: returnedComment.length,
                                                  // display each item of the product list
                                                  itemBuilder: (context, index) {
                                                    return
                                                      Padding(
                                                        padding:EdgeInsets.only(top:20,left:40,right:40),
                                                        child:
                                                        Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                GestureDetector(
                                                                  onTap:(){
                                                                    onShowComments(index);
                                                                  },
                                                                  child:Text(returnedComment[index].cDisplayName,
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w700,
                                                                          color: Colors.black,
                                                                          fontSize: 10.0.sp)),
                                                                ),

                                                                GestureDetector(
                                                                  onTap:(){
                                                                    onShowComments(index);
                                                                  },
                                                                  child:Padding(
                                                                    padding:EdgeInsets.only(left:10),
                                                                    child:Text(returnedComment[index].cComment,
                                                                        style: TextStyle(
                                                                            color: Colors.black,
                                                                            fontSize: 10.0.sp)),
                                                                  ),
                                                                ),


                                                                isCommentReplied[index].isReplied?
                                                                isCommentReplied[index].isOpenReplied?
                                                                GestureDetector(
                                                                    onTap:(){
                                                                      onShowComments(index);
                                                                    },
                                                                    child:
                                                                    Icon(Icons.keyboard_arrow_up,size: 25,)
                                                                )
                                                                    :
                                                                GestureDetector(
                                                                    onTap:(){
                                                                      onShowComments(index);
                                                                    },
                                                                    child:Icon(Icons.keyboard_arrow_down,size: 25,)
                                                                )
                                                                    :Container(),
                                                                Spacer(),

                                                                GestureDetector(
                                                                  onTap:(){
                                                                    likeComment(index);
                                                                  },
                                                                  child:Row(
                                                                    children: [
                                                                      Padding(
                                                                        padding:EdgeInsets.only(right:5),
                                                                        child:Text(post_comment[index].toString(),
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.w700,
                                                                                color:Color(constant.Color.crave_charcoal),
                                                                                fontSize: 9.0.sp)),
                                                                      ),

                                                                      post_comment_list[index]=='1'?
                                                                      Image.asset(
                                                                        'images/love_selected_icon.png',
                                                                        height: 1.5.h,
                                                                      ):
                                                                      Image.asset(
                                                                        'images/icon_love.png',
                                                                        height: 1.5.h,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),

                                                              ],
                                                            ),
                                                            Visibility(
                                                              visible:isCommentReplied[index].isOpenReplied,
                                                              // visible:true,
                                                              child:
                                                                  Wrap(
                                                                    children: [
                                                                      Container(
                                                                        // color:Colors.yellow,
                                                                        height:returnedComment[index].replied.length!=0?10.0.h:0.0.h,
                                                                        // width:100.0.w,
                                                                          child:ListView.builder(
                                                                              padding: EdgeInsets.zero,
                                                                              // the number of items in the list
                                                                              itemCount: returnedComment[index].replied.length,
                                                                              // display each item of the product list
                                                                              itemBuilder: (context, indexR) {
                                                                                return
                                                                                  Padding(
                                                                                    padding:EdgeInsets.only(top:10,left:10,right:0),
                                                                                    child:
                                                                                    Column(
                                                                                      children: [
                                                                                        Row(
                                                                                          children: [
                                                                                            Padding(
                                                                                              padding:EdgeInsets.only(bottom:10),
                                                                                              child: Image.asset(
                                                                                                'images/subComments.png',
                                                                                                height: 1.3.h,
                                                                                              ),
                                                                                            ),
                                                                                            Text(returnedComment[index].replied[indexR].cDisplayName,
                                                                                                style: TextStyle(
                                                                                                    fontWeight: FontWeight.w700,
                                                                                                    color: Colors.black,
                                                                                                    fontSize: 10.0.sp)),
                                                                                            Padding(
                                                                                              padding:EdgeInsets.only(left:10),
                                                                                              child:Text(returnedComment[index].replied[indexR].cComment,
                                                                                                  style: TextStyle(
                                                                                                      color: Colors.black,
                                                                                                      fontSize: 10.0.sp)),
                                                                                            ),
                                                                                            Spacer(),

                                                                                            GestureDetector(
                                                                                              onTap:(){
                                                                                                likeReplyComment(index,indexR);
                                                                                              },
                                                                                              child:Row(
                                                                                                children: [
                                                                                                  Padding(
                                                                                                    padding:EdgeInsets.only(right:5),
                                                                                                    child:Text('',
                                                                                                        style: TextStyle(
                                                                                                            fontWeight: FontWeight.w700,
                                                                                                            color:Color(constant.Color.crave_charcoal),
                                                                                                            fontSize: 9.0.sp)),
                                                                                                  ),

                                                                                                  returnedComment[index].replied[indexR].commentLikesUser=='1'?
                                                                                                  Image.asset(
                                                                                                    'images/love_selected_icon.png',
                                                                                                    height: 1.5.h,
                                                                                                  ):
                                                                                                  Image.asset(
                                                                                                    'images/icon_love.png',
                                                                                                    height: 1.5.h,
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),

                                                                                          ],
                                                                                        ),

                                                                                      ],
                                                                                    ),

                                                                                  );
                                                                              })
                                                                      ),
                                                                      Container(
                                                                        //width:250,
                                                                        height:40,
                                                                        margin: const EdgeInsets.only(bottom: 40.0),
                                                                        padding: const EdgeInsets.only(left: 0.0, right: 0.0,top:10.0),
                                                                        child:TextField(
                                                                          autofocus: false,
                                                                          controller: textReplyController,
                                                                          focusNode: _focusReply,
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
                                                                              suffixIcon:
                                                                              showPostReplyButton?
                                                                              Padding(
                                                                                padding:EdgeInsets.only(top: 10.0),
                                                                                child:GestureDetector(
                                                                                    onTap:(){
                                                                                      sendReplyComment(returnedComment[index].cMcommentId);
                                                                                    },
                                                                                    child:Text("Post",
                                                                                      style: TextStyle(
                                                                                        fontWeight: FontWeight.w700,
                                                                                        color:Color(constant.Color.crave_blue),
                                                                                      ),
                                                                                    )
                                                                                ),
                                                                              ):
                                                                              Container(height:0,width:0),

                                                                              // suffixStyle: TextStyle(
                                                                              //   fontWeight: FontWeight.w700,
                                                                              //   color:Color(constant.Color.crave_blue),
                                                                              // ),
                                                                              hintText: "Comment"),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),



                                                            ),
                                                          ],
                                                        ),

                                                      );
                                                  })
                                            ),
                                            // SingleChildScrollView(
                                            //   child:Column(
                                            //     children: [
                                            //       Padding(
                                            //         padding:EdgeInsets.only(top:20,left:40,right:40),
                                            //         child:Row(
                                            //           children: [
                                            //             Text('Kar Heng',
                                            //                 style: TextStyle(
                                            //                     fontWeight: FontWeight.w700,
                                            //                     color: Colors.black,
                                            //                     fontSize: 10.0.sp)),
                                            //             Padding(
                                            //               padding:EdgeInsets.only(left:10),
                                            //               child:Text('Lorem ipsum?',
                                            //                   style: TextStyle(
                                            //                       color: Colors.black,
                                            //                       fontSize: 10.0.sp)),
                                            //             ),
                                            //
                                            //             Spacer(),
                                            //             Row(
                                            //               children: [
                                            //                 Padding(
                                            //                   padding:EdgeInsets.only(right:5),
                                            //                   child:Text('2.2K',
                                            //                       style: TextStyle(
                                            //                           fontWeight: FontWeight.w700,
                                            //                           color:Color(constant.Color.crave_blue),
                                            //                           fontSize: 9.0.sp)),
                                            //                 ),
                                            //
                                            //                 Image.asset(
                                            //                   'images/love_selected_icon.png',
                                            //                   height: 1.5.h,
                                            //                 ),
                                            //               ],
                                            //             ),
                                            //           ],
                                            //         ),
                                            //       ),
                                            //
                                            //       Padding(
                                            //         padding:EdgeInsets.only(top:10,left:40,right:40),
                                            //         child:Row(
                                            //           children: [
                                            //             Text('Kar Heng',
                                            //                 style: TextStyle(
                                            //                     fontWeight: FontWeight.w700,
                                            //                     color: Colors.black,
                                            //                     fontSize: 10.0.sp)),
                                            //             GestureDetector(
                                            //               onTap:onShowComments,
                                            //               child:Padding(
                                            //                 padding:EdgeInsets.only(left:10,right:5),
                                            //                 child:Text('Lorem ipsum?',
                                            //                     style: TextStyle(
                                            //                         color: Colors.black,
                                            //                         fontSize: 10.0.sp)),
                                            //               ),
                                            //             ),
                                            //
                                            //             isShowComments?
                                            //             GestureDetector(
                                            //                 onTap:onShowComments,
                                            //                 child:
                                            //                 Icon(Icons.keyboard_arrow_up,size: 25,)
                                            //             )
                                            //                 :
                                            //             GestureDetector(
                                            //                 onTap:onShowComments,
                                            //                 child:Icon(Icons.keyboard_arrow_down,size: 25,)
                                            //             ),
                                            //
                                            //
                                            //
                                            //             Spacer(),
                                            //             Row(
                                            //               children: [
                                            //                 Padding(
                                            //                   padding:EdgeInsets.only(right:5),
                                            //                   child:Text('155',
                                            //                       style: TextStyle(
                                            //                           fontWeight: FontWeight.w700,
                                            //                           color:Colors.grey,
                                            //                           fontSize: 9.0.sp)),
                                            //                 ),
                                            //
                                            //                 Image.asset(
                                            //                   'images/icon_love.png',
                                            //                   height: 1.5.h,
                                            //                 ),
                                            //               ],
                                            //             ),
                                            //           ],
                                            //         ),
                                            //       ),
                                            //       Visibility(
                                            //         visible:isShowComments,
                                            //         child:
                                            //         Column(
                                            //           children: [
                                            //             Padding(
                                            //               padding:EdgeInsets.only(top:10,left:50,right:40),
                                            //               child:Row(
                                            //                 children: [
                                            //                   Padding(
                                            //                     padding:EdgeInsets.only(bottom:10),
                                            //                     child: Image.asset(
                                            //                       'images/subComments.png',
                                            //                       height: 1.3.h,
                                            //                     ),
                                            //                   ),
                                            //
                                            //                   Padding(
                                            //                     padding:EdgeInsets.only(left:5),
                                            //                     child:Text('Kar Heng',
                                            //                         style: TextStyle(
                                            //                             fontWeight: FontWeight.w700,
                                            //                             color: Colors.black,
                                            //                             fontSize: 10.0.sp)),
                                            //                   ),
                                            //
                                            //                   Padding(
                                            //                     padding:EdgeInsets.only(left:10),
                                            //                     child:Text('Lorem?',
                                            //                         style: TextStyle(
                                            //                             color: Colors.black,
                                            //                             fontSize: 10.0.sp)),
                                            //                   ),
                                            //
                                            //                   Spacer(),
                                            //                   Row(
                                            //                     children: [
                                            //                       Padding(
                                            //                         padding:EdgeInsets.only(right:5),
                                            //                         child:Text('',
                                            //                             style: TextStyle(
                                            //                                 fontWeight: FontWeight.w700,
                                            //                                 color:Colors.grey,
                                            //                                 fontSize: 9.0.sp)),
                                            //                       ),
                                            //
                                            //                       Image.asset(
                                            //                         'images/icon_love.png',
                                            //                         height: 1.5.h,
                                            //                       ),
                                            //                     ],
                                            //                   ),
                                            //                 ],
                                            //               ),
                                            //             ),
                                            //             Padding(
                                            //               padding:EdgeInsets.only(top:10,left:50,right:40),
                                            //               child:Row(
                                            //                 children: [
                                            //                   Padding(
                                            //                     padding:EdgeInsets.only(bottom:10),
                                            //                     child: Image.asset(
                                            //                       'images/subComments.png',
                                            //                       height: 1.3.h,
                                            //                     ),
                                            //                   ),
                                            //
                                            //                   Padding(
                                            //                     padding:EdgeInsets.only(left:5),
                                            //                     child:Text('Kar Heng',
                                            //                         style: TextStyle(
                                            //                             fontWeight: FontWeight.w700,
                                            //                             color: Colors.black,
                                            //                             fontSize: 10.0.sp)),
                                            //                   ),
                                            //
                                            //                   Padding(
                                            //                     padding:EdgeInsets.only(left:10),
                                            //                     child:Text('Ipsum?',
                                            //                         style: TextStyle(
                                            //                             color: Colors.black,
                                            //                             fontSize: 10.0.sp)),
                                            //                   ),
                                            //
                                            //                   Spacer(),
                                            //                   Row(
                                            //                     children: [
                                            //                       Padding(
                                            //                         padding:EdgeInsets.only(right:5),
                                            //                         child:Text('',
                                            //                             style: TextStyle(
                                            //                                 fontWeight: FontWeight.w700,
                                            //                                 color:Colors.grey,
                                            //                                 fontSize: 9.0.sp)),
                                            //                       ),
                                            //
                                            //                       Image.asset(
                                            //                         'images/icon_love.png',
                                            //                         height: 1.5.h,
                                            //                       ),
                                            //                     ],
                                            //                   ),
                                            //                 ],
                                            //               ),
                                            //             ),
                                            //           ],
                                            //         ),
                                            //
                                            //       ),
                                            //       Padding(
                                            //         padding:EdgeInsets.only(top:10,left:40,right:40),
                                            //         child:Row(
                                            //           children: [
                                            //             Text('Kar Heng',
                                            //                 style: TextStyle(
                                            //                     fontWeight: FontWeight.w700,
                                            //                     color: Colors.black,
                                            //                     fontSize: 10.0.sp)),
                                            //             Padding(
                                            //               padding:EdgeInsets.only(left:10),
                                            //               child:Text('dolor sit... amet',
                                            //                   style: TextStyle(
                                            //                       color: Colors.black,
                                            //                       fontSize: 10.0.sp)),
                                            //             ),
                                            //
                                            //             Spacer(),
                                            //             Row(
                                            //               children: [
                                            //                 Padding(
                                            //                   padding:EdgeInsets.only(right:5),
                                            //                   child:Text('12',
                                            //                       style: TextStyle(
                                            //                           fontWeight: FontWeight.w700,
                                            //                           color:Colors.grey,
                                            //                           fontSize: 9.0.sp)),
                                            //                 ),
                                            //
                                            //                 Image.asset(
                                            //                   'images/icon_love.png',
                                            //                   height: 1.5.h,
                                            //                 ),
                                            //               ],
                                            //             ),
                                            //           ],
                                            //         ),
                                            //       ),
                                            //
                                            //     ],
                                            //   ),
                                            //
                                            // ),

                                          ],
                                        ),
                                        Spacer(),
                                        Container(
                                          //width:250,
                                          height:40,
                                          margin: const EdgeInsets.only(bottom: 40.0),
                                          padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                                          child:TextField(
                                            autofocus: false,
                                            controller: textController,
                                            focusNode: _focus,
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
                                                suffixIcon:
                                                showPostButton?
                                                Padding(
                                                  padding:EdgeInsets.only(top: 10.0),
                                                  child:GestureDetector(
                                                      onTap:(){
                                                        sendComment();
                                                      },
                                                      child:Text("Post",
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w700,
                                                          color:Color(constant.Color.crave_blue),
                                                        ),
                                                      )
                                                  ),
                                                ):
                                                Container(height:0,width:0),

                                                // suffixStyle: TextStyle(
                                                //   fontWeight: FontWeight.w700,
                                                //   color:Color(constant.Color.crave_blue),
                                                // ),
                                                hintText: "Comment"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

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


