// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:a_crave/profileUser.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:circle_list/circle_list.dart';

import 'constants.dart' as constant;
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

import 'camera_screen.dart';
import 'chatPage.dart';
import 'circle_wheel_scroll/circle_wheel_scroll_view.dart';
import 'cravingsPage.dart';
import 'dataClass.dart';
import 'homeBase.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'homepage.dart';
import 'notificationsPage.dart';

class ReelsDetails extends StatefulWidget {
  final PageController reelsPageController;
  final List<Media> medias;
  final Function() startLoad;
  const ReelsDetails({Key? key, required this.reelsPageController,required this.medias, required this.startLoad}) : super(key: key);


  @override
  ReelsDetailsState createState() => ReelsDetailsState();
}

class ReelsDetailsState extends State<ReelsDetails> {

  final textController = TextEditingController();
  final textSearchController = TextEditingController();
  final textReplyController = TextEditingController();
  FocusNode _focus = FocusNode();
  FocusNode _focusReply = FocusNode();
  bool showPostButton = false;
  bool showPostReplyButton = false;

  bool isShowComments = false;
  bool isShowCommentsPart = false;
  final player = AudioPlayer();
  String songName = "";
  String m_media_id = "0";
  int comment_count = 0;

  List<String> post_likes_list = [];
  List<String> post_likes = [];
  List<String> post_crave_list = [];
  List<String> post_crave = [];
  List<String> post_comment_list = [];
  List<String> post_comment = [];

  List<Comment> returnedComment = [];
  List<Followers> returnedFollowers = [];
  List<Followers> duplicateItems = [];
  List<String> shareToFollowers = [];
  List<Widget> followersWidget = [];
  List<bool> isChecked = [];

  List<CommentReplied> isCommentReplied = [];

  @override
  void initState() {
    super.initState();
    // startLoad();
    WidgetsBinding.instance!.addPostFrameCallback((_) => startLoad());
  }

  onChangeTab(int nowTab){
    setState(() {
     // currentTab = nowTab;
    });
  }

  void onShowComments(){
    print(isShowComments);
    setState(() {
      isShowComments = !isShowComments;
    });
  }

  void onShowCommentsPart(index){
    setState(() {
      isCommentReplied[index].isOpenReplied = !isCommentReplied[index].isOpenReplied;
    });


  }

  void onHideComments(){
    if(isShowComments){
      setState(() {
        isShowComments = false;
      });
    }
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

  Future<http.Response> sendComment(m_media_id) async {
    var url = Uri.parse(constant.Url.crave_url+'send_comment.php');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        "email":prefs.getString('user_email'),
        "post_id":m_media_id,
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
        loadComment(m_media_id);
        // this.widget.onDataChange(this.widget.selectedMediaIndex);
        //
        // int newCommentCount = int.parse(this.widget.selectedMedia.post_comments) + 1;
        // setState(() {
        //   this.widget.selectedMedia.post_comments = newCommentCount.toString();
        // });

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

  Future<http.Response> sendReplyComment(m_media_id,replyId) async {
    var url = Uri.parse(constant.Url.crave_url+'send_comment.php');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        "email":prefs.getString('user_email'),
        "post_id":m_media_id,
        "reply_comment":replyId,
        "comment":textReplyController.text,
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
        loadComment(m_media_id);
        // this.widget.onDataChange(this.widget.selectedMediaIndex);
        //
        // int newCommentCount = int.parse(this.widget.selectedMedia.post_comments) + 1;
        // setState(() {
        //   this.widget.selectedMedia.post_comments = newCommentCount.toString();
        // });

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

  void filterSearchResultsFollowers(String query) {
    print(query);
    List<Followers> dummySearchList = [];
    dummySearchList.addAll(duplicateItems);
    if(query.isNotEmpty) {
      List<Followers> dummyListData = [];
      dummySearchList.forEach((item) {
        if(item.f_display_name.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        returnedFollowers.clear();
        returnedFollowers.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        returnedFollowers.clear();
        returnedFollowers.addAll(duplicateItems);
      });
    }
  }


  void startLoad() async{
    _focus.addListener(_onFocusChange);
    _focusReply.addListener(_onFocusReplyChange);
    player.stop();
    player.dispose();
    loadFollowers();
    Future.delayed(const Duration(milliseconds: 1000), () {
      print("Start loaddd");
      setState(() {
        for (int i = 0; i < this.widget.medias.length; i++){
          post_likes_list.add(this.widget.medias[i].post_likes_user);
          post_likes.add(this.widget.medias[i].post_likes);
          post_crave_list.add(this.widget.medias[i].post_craving_user);
          post_crave.add(this.widget.medias[i].post_craving);
          print(post_likes_list[i]);
        }



        m_media_id = this.widget.medias[0].media_id;
        loadComment(this.widget.medias[0].media_id);
      });

    });

  }

  void playMusic(String musicName) async{
    setState(() {
      if(musicName == "music1"){
        songName = "Happy Upbeat Accoustic";
      }
      else if(musicName == "music2"){
        songName = "Be Like a child";
      }
      else if(musicName == "music3"){
        songName = "Spook";
      }
      else if(musicName == "music4"){
        songName = "Palms";
      }
      else if(musicName == "music5"){
        songName = "Seaside";
      }
    });
    String url = constant.Url.music_audio_url+musicName+".mp3";
    print(url);
    await player.setUrl(url);
    player.play(url);
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
          print("after like");
          print(post_likes_list[index]);
          print(index);
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
          print("after like");
          print(post_comment_list[index]);
          print(index);
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

  Future<List<Comment>> loadComment(m_media_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var url = Uri.parse(constant.Url.crave_url+'get_post_comments.php');
    returnedComment.clear();
    post_comment_list.clear();
    post_comment.clear();
    comment_count = 0;
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
          comment_count = comment.comments.length;

          for(int k=0;k<comment.comments.length ; k++){
            post_comment_list.add(comment.comments[k].commentLikesUser);
            post_comment.add(comment.comments[k].commentLikes);

            if(comment.comments[k].replied.length > 0){
              isCommentReplied.add(CommentReplied(isReplied:true, isOpenReplied:false));
            }
            else{
              isCommentReplied.add(CommentReplied(isReplied:false, isOpenReplied:false));
            }
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

        print("duppppp");
        print(duplicateItems);
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
              msg: "Reels shared!",
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
          controller: textSearchController,
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
            textSearchController.clear();
            loadFollowers();
          });
      print('Hey there, I\'m calling after hide bottomSheet');
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
    player.stop();
    player.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
    _focusReply.removeListener(_onFocusChange);
    _focusReply.dispose();
    super.dispose();
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
                          backgroundColor: Colors.white,
                          body:GestureDetector(
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
                            child:

                            PageView.builder(
                                onPageChanged: (int page) {
                                  if(page == this.widget.medias.length-1){
                                    this.widget.startLoad();
                                  }
                                  if(this.widget.medias[page].media_audio != "" && this.widget.medias[page].media_audio != "music0" && this.widget.medias[page].media_audio != "0"){
                                    playMusic(this.widget.medias[page].media_audio);
                                    print(this.widget.medias[page].media_audio);
                                    print("play audiooo");
                                  }
                                  else{
                                    player.stop();
                                    setState(() {
                                      songName = "";
                                    });
                                  }

                                  loadComment(this.widget.medias[page].media_id);
                                  loadFollowers();
                                  setState(() {
                                    m_media_id = this.widget.medias[page].media_id;
                                  });
                                },
                                scrollDirection: Axis.vertical,
                                itemCount: this.widget.medias.length,
                                itemBuilder:(context, index){
                                return
                                  Stack(
                                  children: [
                                    // Container(
                                    //   height:100.0.h,
                                    //   decoration: BoxDecoration(
                                    //     gradient: LinearGradient(
                                    //       begin: Alignment.topCenter,
                                    //       end: Alignment.bottomCenter,
                                    //       colors: [
                                    //         Colors.transparent,
                                    //         Colors.black,
                                    //       ],
                                    //     ),
                                    //   ),
                                    //   //color:Colors.black,
                                    //   padding: const EdgeInsets.only(left:20,bottom:20,right:20),
                                    //
                                    // ),


                                    GestureDetector(
                                      onTap:onHideComments,
                                      child:Container(
                                        child:Center(
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
                                        height: MediaQuery.of(context).size.height,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                constant.Url.media_url+this.widget.medias[index].media_name
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child:Container(
                                        height:30.0.h,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.transparent,
                                              Colors.black,
                                            ],
                                          ),
                                        ),
                                        //color:Colors.black,
                                        padding: const EdgeInsets.only(left:20,bottom:20,right:20),
                                        child:Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Spacer(),
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 24.0,
                                                  backgroundImage:
                                                  NetworkImage(constant.Url.profile_url+this.widget.medias[index].user_profile_img),
                                                  backgroundColor: Colors.transparent,
                                                ),
                                                // Image.asset(
                                                //   'images/user1.png',
                                                //   height: 5.0.h,
                                                // ),
                                                Padding(
                                                  padding: const EdgeInsets.only(left:15),
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
                                                                      color: Colors.white,
                                                                      fontSize: 11.0.sp)),


                                                              Container(
                                                                padding: const EdgeInsets.only(left:5,right:5,top:2,bottom:2),
                                                                child:VerticalDivider(
                                                                  color: Colors.white,
                                                                ),
                                                              ),
                                                              Text('Follow',
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.w700,
                                                                      // color:Color(0xFF2CBFC6),
                                                                      color:Colors.white,
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
                                                                    height: 1.8.h,
                                                                  ),
                                                                  Container(
                                                                    width:70.0.w,
                                                                    padding: const EdgeInsets.only(left:5),
                                                                    child: Text(this.widget.medias[index].media_location.replaceAll('', '\u200B'),
                                                                        overflow: TextOverflow.ellipsis,
                                                                        style: TextStyle(
                                                                            color: Colors.white,
                                                                            fontSize: 9.5.sp)),
                                                                  ),


                                                                ],
                                                              )
                                                          )
                                                      ),


                                                    ],
                                                  ),
                                                ),


                                              ],

                                            ),
                                            Padding(
                                              padding:EdgeInsets.only(top:10,bottom:5),
                                              child:Text(this.widget.medias[index].media_desc,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10.0.sp)),
                                            ),

                                            songName != ""?
                                            Padding(
                                              padding:EdgeInsets.only(top:5,bottom:20,left:10),
                                              child:Row(
                                                children: [
                                                  Image.asset(
                                                    'images/icon_music.png',
                                                    height: 2.0.h,
                                                  ),
                                                  Padding(
                                                    padding:EdgeInsets.only(left:10),
                                                    child: Text(songName,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10.0.sp)),
                                                  ),

                                                ],
                                              ),
                                            ):
                                            Container(height:10),
                                            Padding(
                                              padding:EdgeInsets.only(bottom:30),
                                              child:IntrinsicHeight(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    GestureDetector(
                                                      onTap:(){
                                                        likePost(index);
                                                      },
                                                      child:
                                                          index>=0?
                                                      post_likes_list[index]=='1'?
                                                      Image.asset(
                                                        'images/love_selected_icon.png',
                                                        height: 2.5.h,
                                                      ):
                                                      Image.asset(
                                                        'images/icon_love.png',
                                                        height: 2.5.h,
                                                      )
                                                      : Image.asset(
                                                            'images/icon_love.png',
                                                            height: 2.5.h,
                                                          ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(left:2.0.w,right:7.0.w),
                                                      child:Text(
                                                        index>=0?
                                                          post_likes[index]:"0",
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w700,
                                                              color: Colors.white,
                                                              fontSize: 12.0.sp)),
                                                    ),

                                                    GestureDetector(
                                                      onTap:(){
                                                        cravePost(index);
                                                      },
                                                      child:
                                                          index>=0?
                                                      post_crave_list[index]=='1'?
                                                      Image.asset(
                                                        'images/icon_crave.png',
                                                        height: 2.5.h,
                                                      ):
                                                      Image.asset(
                                                        'images/icon_crave_grey.png',
                                                        height: 2.5.h,
                                                      )
                                                        :Image.asset(
                                                            'images/icon_crave_grey.png',
                                                            height: 2.5.h,
                                                          ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(left:2.0.w,right:7.0.w),
                                                      child:Text(
                                                        index>=0?
                                                          post_crave[index]:"0",
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w700,
                                                              color: Colors.white,
                                                              fontSize: 12.0.sp)),
                                                    ),
                                                    GestureDetector(
                                                      onTap: (){
                                                        // onShowCommentsPart(this.widget.medias[index].media_id);
                                                        onShowComments();
                                                      },
                                                      child:Image.asset(
                                                        'images/comment_icon_fill.png',
                                                        height: 2.5.h,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: (){
                                                        // onShowCommentsPart(this.widget.medias[index].media_id);
                                                        onShowComments();
                                                      },
                                                      child:Padding(
                                                        padding: EdgeInsets.only(left:2.0.w,right:7.0.w),
                                                        child:Text(comment_count.toString(),
                                                            //this.widget.medias[index].post_comments,
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.w700,
                                                                color: Colors.white,
                                                                fontSize: 12.0.sp)),
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    GestureDetector(
                                                      onTap:(){
                                                        onShareFeed(m_media_id);
                                                      },
                                                      child:Image.asset(
                                                          'images/forward_icon.png',
                                                          height: 2.0.h,
                                                          color:Colors.white
                                                      ),
                                                    ),

                                                    Padding(
                                                      padding: const EdgeInsets.only(left:10,top:5,right:10),
                                                      child: Image.asset(
                                                          'images/others_icon.png',
                                                          color:Colors.white,
                                                          height: 1.0.h,
                                                          width:5.0.w
                                                      ),
                                                    ),


                                                  ],
                                                ),
                                              ),
                                            ),


                                          ],
                                        ),
                                      ),
                                    ),
                                    isShowComments?
                                        GestureDetector(
                                          onTap:onShowComments,
                                          child:Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Container(
                                                  color:Colors.white,
                                                  height:returnedComment.length==0?10.0.h:30.0.h,
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        height:returnedComment.length==0?0.0.h:20.0.h,
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
                                                                              onShowCommentsPart(index);
                                                                            },
                                                                            child:Text(returnedComment[index].cDisplayName,
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.w700,
                                                                                    color: Colors.black,
                                                                                    fontSize: 10.0.sp)),
                                                                          ),

                                                                          GestureDetector(
                                                                            onTap:(){
                                                                              onShowCommentsPart(index);
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
                                                                                onShowCommentsPart(index);
                                                                              },
                                                                              child:
                                                                              Icon(Icons.keyboard_arrow_up,size: 25,)
                                                                          )
                                                                              :
                                                                          GestureDetector(
                                                                              onTap:(){
                                                                                onShowCommentsPart(index);
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
                                                                                            sendReplyComment(m_media_id,returnedComment[index].cMcommentId);
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
                                                      Container(
                                                        //width:250,
                                                        height:40,
                                                        margin: const EdgeInsets.only(bottom: 40.0,top:10),
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
                                                                      sendComment(m_media_id);
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
                                                  )
                                              )
                                          )
                                        )
                                    :
                                    Container(height:0,width:0),
                                  ],
                                );
                                }
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


