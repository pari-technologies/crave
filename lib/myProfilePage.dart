import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:a_crave/profileBusiness.dart';
import 'dataClass.dart';
import 'profileManageCraveList.dart';
import 'profileUserCraveList.dart';
import 'profileUserPosts.dart';
import 'package:a_crave/reelsDetails.dart';

import 'camera_home.dart';
import 'camera_screen.dart';
import 'cravingsPage.dart';
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
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart' as constant;
import 'dart:math' as math;



class myProfilePage extends StatefulWidget {
  final String currentUser;
  const myProfilePage({Key? key, required this.currentUser}) : super(key: key);

  @override
  myProfilePageState createState() => myProfilePageState();
}

class myProfilePageState extends State<myProfilePage> {

  List<Media> returnedMedia = [];
  List<UserProfile> returnedProfile = [];
  List<CraveList> returnedCraveList = [];
  List<CraveContent> returnedCraveContent = [];
  late CraveList selectedCrave;
  late String craveListName = "";
  late String craveListId = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => startLoad());
    // startLoad();
  }

  void startLoad(){
    craveListName = "";
    craveListId = "";
    loadUserProfile();
    loadMedia();
    loadCraveList();
  }

  Future<List<Media>> loadMedia() async {

    var url = Uri.parse(constant.Url.crave_url+'get_own_post.php');
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
      // print(response.body);

      Map<String, dynamic> user = jsonDecode(response.body);

      if(user['media'] != null){

        List<dynamic> body = user['media'];

        List<Media> media = body
            .map(
              (dynamic item) => Media.fromJson(item),
        ).toList();

        setState(() {
          //isCarAvailable = true;
          returnedMedia = media;
        });


        //suggestions = location;
        // print("--avaialbel carr---");
        print(returnedMedia);
        return returnedMedia;
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

  Future<List<UserProfile>> loadUserProfile() async {

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
        print(returnedProfile);
        return returnedProfile;
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

  Future<List<CraveList>> loadCraveList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var url = Uri.parse(constant.Url.crave_url+'get_crave_lists.php');
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

      Map<String, dynamic> crave_list = jsonDecode(response.body);

      if(crave_list['crave'] != null){

        List<dynamic> body = crave_list['crave'];
        print("asdasda");
        print(body);

        List<CraveList> c_list = body.map((dynamic item) => CraveList.fromJson(item),).toList();

        setState(() {
          //isCarAvailable = true;
          // print("get response body carlist");
          // print(response.body);
          // print(c_list.toString());
          returnedCraveList = c_list;
        });


        //suggestions = location;
        // print("--avaialbel carr---");
        print(returnedCraveList);
        return returnedCraveList;
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

  Future<List<CraveContent>> loadCraveContent(String crave_list_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var url = Uri.parse(constant.Url.crave_url+'get_crave_content.php');
    // returnedEvent.clear();
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        "email":this.widget.currentUser,
        "crave_list_id":crave_list_id
      },
    );

    if (response.statusCode == 200) {

      Map<String, dynamic> crave_list = jsonDecode(response.body);

      if(crave_list['crave_content'] != null){

        List<dynamic> body = crave_list['crave_content'];

        List<CraveContent> c_list = body
            .map(
              (dynamic item) => CraveContent.fromJson(item),
        ).toList();

        setState(() {
          //isCarAvailable = true;
          print("get response body carlist");
          print(response.body);
          print(c_list.toString());
          returnedCraveContent = c_list;
        });


        //suggestions = location;
        // print("--avaialbel carr---");
        print(returnedCraveContent);
        return returnedCraveContent;
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

  void onDataChange(int newData) {
    setState(() {
      selectedCrave = returnedCraveList[newData];
      craveListName = returnedCraveList[newData].list_name;
      craveListId = returnedCraveList[newData].list_id;
      loadCraveContent(selectedCrave.list_id);
    });

  }

  PageController _controller = PageController(
    initialPage: 0,
  );

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }

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
                              //physics: NeverScrollableScrollPhysics(),
                              controller: _controller,
                              children: [
                                ProfileUser(profilePageController: _controller,medias:returnedMedia, user_profile:returnedProfile,loadCraveList:loadCraveList,crave_list:returnedCraveList,currentUser:this.widget.currentUser),
                                ProfileUserPosts(profilePageController: _controller,medias:returnedMedia,user_profile:returnedProfile),
                                ProfileUserCraveList(profilePageController: _controller,crave_list:returnedCraveList,user_profile:returnedProfile,onDataChange: onDataChange,loadCraveList:loadCraveList),
                                ProfileManageCraveList(profilePageController: _controller,crave_content:returnedCraveContent,craveListName:craveListName,craveListId:craveListId,loadCraveList:loadCraveList),
                              ],
                            ),
                          ),
                          // Listener(
                          //     onPointerMove: (moveEvent){
                          //       if(moveEvent.delta.dx > 0) {
                          //         if(PageViewDemo.of(context)!.isShowWheel){
                          //           PageViewDemo.of(context)!.hideWheel();
                          //         }
                          //         else{
                          //           _controller.previousPage(duration: Duration(milliseconds: 100), curve: Curves.easeIn);
                          //         }
                          //         print("swipe right");
                          //       }
                          //       else if(moveEvent.delta.dx < 0) {
                          //         if(!PageViewDemo.of(context)!.isShowWheel){
                          //           PageViewDemo.of(context)!.showWheel();
                          //         }
                          //         print("swipe left");
                          //       }
                          //     },
                          //     child:
                          //     // or any other widget
                          // )

                          // endDrawer:
                          //   MyNavWheel(),
                          //   Padding(
                          //     padding: const EdgeInsets.only(top:100),
                          //     child:
                          //     Transform.scale(
                          //       scale:
                          //       (MediaQuery.of(context).size.height / 600),
                          //       child:CircleList(
                          //         // showInitialAnimation: true,
                          //          rotateMode:RotateMode.allRotate,
                          //         innerCircleColor:Color(0xFF2CBFC6),
                          //         outerCircleColor:Color(0xFF2CBFC6),
                          //         origin: Offset(50.0.w, 0),
                          //         children: [
                          //           Container(),
                          //           Container(),
                          //           Container(),
                          //           Container(),
                          //           Container(),
                          //           Container(),
                          //
                          //           Image(image: AssetImage('images/menu_settings.png'),height:30),
                          //           GestureDetector(
                          //             onTap:(){
                          //               Navigator.push(
                          //                   context,
                          //                   MaterialPageRoute(
                          //                       builder: (context) => CameraScreen()));
                          //             },
                          //             child: Image(image: AssetImage('images/menu_camera.png'),height:30),
                          //           ),
                          //
                          //           GestureDetector(
                          //             onTap:(){
                          //               Navigator.pushReplacement(
                          //                   context,
                          //                   MaterialPageRoute(
                          //                       builder: (context) => Homepage()));
                          //             },
                          //             child: Image(image: AssetImage('images/menu_home.png'),height:35),
                          //           ),
                          //           GestureDetector(
                          //             onTap:(){
                          //               Navigator.push(
                          //                   context,
                          //                   MaterialPageRoute(
                          //                       builder: (context) => CravingsPage()));
                          //             },
                          //             child: Image(image: AssetImage('images/menu_cravings.png'),height:30),
                          //           ),
                          //
                          //           GestureDetector(
                          //             onTap:(){
                          //               Navigator.push(
                          //                   context,
                          //                   MaterialPageRoute(
                          //                       builder: (context) => ReelsDetails()));
                          //             },
                          //             child:Image(image: AssetImage('images/menu_reels.png'),height:35),
                          //           ),
                          //
                          //           GestureDetector(
                          //             onTap:(){
                          //               Navigator.push(
                          //                   context,
                          //                   MaterialPageRoute(
                          //                       builder: (context) => ProfileUser()));
                          //             },
                          //             child:Image(image: AssetImage('images/menu_me.png'),height:35),
                          //           ),
                          //
                          //           GestureDetector(
                          //             onTap:(){
                          //               Navigator.pushReplacement(
                          //                   context,
                          //                   MaterialPageRoute(
                          //                       builder: (context) => ChatPage()));
                          //             },
                          //             child: Image(image: AssetImage('images/menu_chat.png'),height:30),
                          //           ),
                          //
                          //           GestureDetector(
                          //             onTap:(){
                          //               Navigator.pushReplacement(
                          //                   context,
                          //                   MaterialPageRoute(
                          //                       builder: (context) => NotificationsPage()));
                          //             },
                          //             child: Image(image: AssetImage('images/menu_bell.png'),height:40),
                          //           ),
                          //
                          //           Container(),
                          //           Container(),
                          //           Container(),
                          //           Container(),
                          //
                          //         ],
                          //       ),
                          //     ),
                          //
                          //
                          //   // Transform(
                          //   //   alignment: Alignment.center,
                          //   //   transform: Matrix4.rotationY(math.pi),
                          //   //   child:  CircleListScrollView(
                          //   //     // controller: _scrollController,
                          //   //     // controller: _controllerFixed,
                          //   //     physics: CircleFixedExtentScrollPhysics(),
                          //   //     axis: Axis.vertical,
                          //   //     itemExtent: 65,
                          //   //     // children: List.generate(20, _buildItem),
                          //   //     children: [
                          //   //       Transform(
                          //   //         alignment: Alignment.center,
                          //   //         transform: Matrix4.rotationY(math.pi),
                          //   //         child:
                          //   //         TextButton(
                          //   //           onPressed: () {
                          //   //             Navigator.pushReplacement(
                          //   //                 context,
                          //   //                 MaterialPageRoute(
                          //   //                     builder: (context) => NotificationsPage()));
                          //   //           },
                          //   //
                          //   //           child: Text("TEXT BUTTON",style: TextStyle(
                          //   //               fontWeight: FontWeight.w700,
                          //   //               color: Colors.white,
                          //   //               fontSize: 10.0.sp)),
                          //   //         ),
                          //   //
                          //   //       ),
                          //   //
                          //   //       Transform(
                          //   //         alignment: Alignment.center,
                          //   //         transform: Matrix4.rotationY(math.pi),
                          //   //         child:
                          //   //         GestureDetector(
                          //   //           onTap:(){
                          //   //             Navigator.pushReplacement(
                          //   //                               context,
                          //   //                               MaterialPageRoute(
                          //   //                                   builder: (context) => NotificationsPage()));
                          //   //           },
                          //   //           child: Center(
                          //   //             child: Container(
                          //   //                 padding: EdgeInsets.all(5),
                          //   //                 child: Image(image: AssetImage('images/menu_chat.png'),height:40)
                          //   //             ),
                          //   //           ),
                          //   //         ),
                          //   //
                          //   //       ),
                          //   //       Transform(
                          //   //         alignment: Alignment.center,
                          //   //         transform: Matrix4.rotationY(math.pi),
                          //   //         child:  Center(
                          //   //           child: Container(
                          //   //               padding: EdgeInsets.all(5),
                          //   //               child: Image(image: AssetImage('images/menu_chat.png'),height:40)
                          //   //           ),
                          //   //         ),
                          //   //       ),
                          //   //       Transform(
                          //   //         alignment: Alignment.center,
                          //   //         transform: Matrix4.rotationY(math.pi),
                          //   //         child:  Center(
                          //   //           child: Container(
                          //   //               padding: EdgeInsets.all(5),
                          //   //               child: Image(image: AssetImage('images/menu_switch_account.png'),height:80)
                          //   //           ),
                          //   //         ),
                          //   //       ),
                          //   //       Transform(
                          //   //         alignment: Alignment.center,
                          //   //         transform: Matrix4.rotationY(math.pi),
                          //   //         child:  Center(
                          //   //           child: Container(
                          //   //               padding: EdgeInsets.all(5),
                          //   //               child: Image(image: AssetImage('images/menu_me.png'),height:50)
                          //   //           ),
                          //   //         ),
                          //   //       ),
                          //   //       Transform(
                          //   //         alignment: Alignment.center,
                          //   //         transform: Matrix4.rotationY(math.pi),
                          //   //         child:
                          //   //         Center(
                          //   //           child: Container(
                          //   //               padding: EdgeInsets.all(5),
                          //   //               child: Image(image: AssetImage('images/menu_reels.png'),height:50)
                          //   //           ),
                          //   //         ),
                          //   //
                          //   //       ),
                          //   //
                          //   //       Transform(
                          //   //         alignment: Alignment.center,
                          //   //         transform: Matrix4.rotationY(math.pi),
                          //   //         child:  Center(
                          //   //           child: Container(
                          //   //               padding: EdgeInsets.all(5),
                          //   //               child: Image(image: AssetImage('images/menu_cravings.png'),height:50)
                          //   //           ),
                          //   //         ),
                          //   //       ),
                          //   //       Transform(
                          //   //         alignment: Alignment.center,
                          //   //         transform: Matrix4.rotationY(math.pi),
                          //   //         child:  Center(
                          //   //           child: Container(
                          //   //               padding: EdgeInsets.all(5),
                          //   //               child: Image(image: AssetImage('images/menu_home.png'),height:50)
                          //   //           ),
                          //   //         ),
                          //   //       ),
                          //   //       Transform(
                          //   //         alignment: Alignment.center,
                          //   //         transform: Matrix4.rotationY(math.pi),
                          //   //         child:  Center(
                          //   //           child: Container(
                          //   //               padding: EdgeInsets.all(5),
                          //   //               child: Image(image: AssetImage('images/menu_camera.png'),height:40)
                          //   //           ),
                          //   //         ),
                          //   //       ),
                          //   //       Transform(
                          //   //         alignment: Alignment.center,
                          //   //         transform: Matrix4.rotationY(math.pi),
                          //   //         child:  Center(
                          //   //           child: Container(
                          //   //               padding: EdgeInsets.all(5),
                          //   //               child: Image(image: AssetImage('images/menu_run_ads.png'),height:40)
                          //   //           ),
                          //   //         ),
                          //   //       ),
                          //   //       Transform(
                          //   //         alignment: Alignment.center,
                          //   //         transform: Matrix4.rotationY(math.pi),
                          //   //         child:  Center(
                          //   //           child: Container(
                          //   //               padding: EdgeInsets.all(5),
                          //   //               child: Image(image: AssetImage('images/menu_settings.png'),height:50)
                          //   //           ),
                          //   //         ),
                          //   //       ),
                          //   //     ],
                          //   //     radius: MediaQuery.of(context).size.width * 0.6,
                          //   //     onSelectedItemChanged: (index){
                          //   //       onChangedMenu(index);
                          //   //       print('Current index: $index');
                          //   //     },
                          //   //
                          //   //   ),
                          //   //
                          //   // ),
                          // ),
                          // drawerScrimColor: Colors.transparent,
                          // drawerEdgeDragWidth: MediaQuery.of(context).size.width,
                        ),
                      );
                    });
              }
          );
        }
    );
  }
}
