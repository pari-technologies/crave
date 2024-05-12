import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:a_crave/profileBusiness.dart';
import 'package:a_crave/reelsDetails.dart';

import 'camera_home.dart';
import 'camera_screen.dart';
import 'chatDetailPage.dart';
import 'cravingsPage.dart';
import 'dataClass.dart';
import 'feed.dart';
import 'feedDetails.dart';
import 'homeBase.dart';
import 'homepage.dart';
import 'notificationsPage.dart';
import 'profileUser.dart';

import 'chatPage.dart';
import 'reels.dart';

import 'showStories.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';

import 'constants.dart' as constant;
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';


class myChat extends StatefulWidget {
  const myChat({Key? key}) : super(key: key);

  @override
  myChatState createState() => myChatState();
}

class myChatState extends State<myChat> {

  List<Chatroom> returnedChatroom = [];
  List<Chatroom> dummyChatroom = [];
  late String user_email = "";
  String selectedChatroom = "0";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => startLoad());
  }

  void startLoad() async{
    loadChatroom();
    setState(() {
      // PageViewDemo.of(context)!.hideWheel();
    });
    print("startLoad homepageee");
    print(MediaQuery.of(context).size.width);
  }

  Future<List<Chatroom>> loadChatroom() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user_email = prefs.getString('user_email')!;
      print("user maillll");
      print(user_email);
    });
    var url = Uri.parse(constant.Url.crave_url+'get_chatroom.php');
    // returnedEvent.clear();
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

      if(user['chatroom'] != null){

        List<dynamic> body = user['chatroom'];

        List<Chatroom> chatroom = body
            .map(
              (dynamic item) => Chatroom.fromJson(item),
        ).toList();

        List<Chatroom> dchatroom = body
            .map(
              (dynamic item) => Chatroom.fromJson(item),
        ).toList();

        setState(() {
          //isCarAvailable = true;
          returnedChatroom = chatroom;
          dummyChatroom = dchatroom;
        });

        print(returnedChatroom);
        return returnedChatroom;
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

  void goToFeed() {
    // setState(() {
    //   Navigator.of(context).pushNamed("/feed");
    // });
    setState(() {
    // this.widget.homepageController.jumpToPage(1);
    });
  }

  void onDataChange(String newData) {
    setState(() {
      selectedChatroom = newData;
    });
  }

  PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  void dispose() {
    _controller.dispose();
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
                          resizeToAvoidBottomInset: false,
                          backgroundColor: Colors.white,
                          body:
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
                                    _controller.previousPage(duration: Duration(milliseconds: 100), curve: Curves.easeIn);
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
                            child:PageView(
                              physics: NeverScrollableScrollPhysics(),
                              controller: _controller,
                              children: [
                                ChatPage(chatPageController: _controller,chatroom:returnedChatroom,dummychatroom:dummyChatroom, user_email:user_email,onDataChange:onDataChange),
                                ChatDetailPage(chatPageController: _controller,selectedChatroom:selectedChatroom),
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
