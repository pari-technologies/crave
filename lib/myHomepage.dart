import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:a_crave/profileBusiness.dart';
import 'package:a_crave/reelsDetails.dart';

import 'camera_home.dart';
import 'camera_screen.dart';
import 'cravingsPage.dart';
import 'feed.dart';
import 'feedDetails.dart';
import 'homeBase.dart';
import 'homepage.dart';
import 'dataClass.dart';
import 'notificationsPage.dart';
import 'profileUser.dart';
import 'package:permission_handler/permission_handler.dart';
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
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

class MyHomepage extends StatefulWidget {
  final Function(String) setCurrentUser;
  const MyHomepage({Key? key,required this.setCurrentUser}) : super(key: key);
  static myHomepageState? of(BuildContext context) => context.findAncestorStateOfType<myHomepageState>();
  @override
  myHomepageState createState() => myHomepageState();
}

class myHomepageState extends State<MyHomepage> {
  final textController = TextEditingController();
  int currentMenuIndex = 4;
  bool isTabShown = true;
  double _kSearchHeight = 60.0;
  bool isSearchOn = false;
  List<Media> returnedMedia = [];
  List<Media> dummyMedia = [];
  List<Comment> returnedComment = [];
  List<CraveList> returnedCraveList = [];
  List returnedStories = [];
  Media selectedMedia = Media(
    media_id:'0',
    media_name:'',
    media_user_id:'',
    media_type:'',
    media_desc:'',
    media_filter:'',
    media_audio:'',
    media_latlng:'',
    media_location:'',
    post_likes:'',
    post_likes_user:'',
    post_craving:'',
    post_craving_user:'',
    post_comments:'',
    user_display_name:'',
    user_profile_img:'',
    is_follow: '',
    tags1 : '',
    tags2 : '',
    tags3 : '',
    c_textfilter : '',
    c_textColor : '',
    c_textBgColor : '',
    c_textFamily : '',
    c_textSize : '',
    c_textstyle : "TextStyle(fontSize: 50,color: Colors.white,fontFamily: 'Billabong')",
    c_textalign : 'TextAlign.center'

  );
  int selectedMediaIndex = 0;
  // bool isOnPageTurning = false;
  // int current = 0;

  int currentTab = 0;
  void onTabChange(int newTab) {
    setState(() {
      currentTab = newTab;
    });
  }

  @override
  void initState() {
    super.initState();
    // _controller.addListener(scrollListener);
    // startLoad();
    WidgetsBinding.instance!.addPostFrameCallback((_) => startLoad());
  }

  // void scrollListener() {
  //   if (isOnPageTurning &&
  //       _controller.page == _controller.page!.roundToDouble()) {
  //     setState(() {
  //       current = _controller.page!.toInt();
  //       isOnPageTurning = false;
  //     });
  //   } else if (!isOnPageTurning && current.toDouble() != _controller.page) {
  //     if ((current.toDouble() - _controller.page!.toDouble()).abs() > 0.1) {
  //       setState(() {
  //         isOnPageTurning = true;
  //       });
  //     }
  //   }
  // }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      Fluttertoast.showToast(
          msg: "Location services are disabled.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        Fluttertoast.showToast(
            msg: "Location permissions are denied",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0
        );
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      Fluttertoast.showToast(
          msg: "Location permissions are permanently denied, we cannot request permissions.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void startLoad() {
    loadMedia();
    loadStories();
    loadCraveList();
  }

  Future<List<Media>> loadMedia() async {
    // showAlertDialog(context);
    print("load mediaaa");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var url = Uri.parse(constant.Url.crave_url+'get_media_feed.php');
    returnedMedia.clear();
    dummyMedia.clear();
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

      if(user['media'] != null){

        List<dynamic> body = user['media'];

        List<Media> media = body
            .map(
              (dynamic item) => Media.fromJson(item),
        ).toList();

        List<Media> dmedia = body
            .map(
              (dynamic item) => Media.fromJson(item),
        ).toList();

        setState(() {
          //isCarAvailable = true;
          // selectedMedia = media[0];
          returnedMedia = media;
          dummyMedia = dmedia;
          loadComment();
          // Navigator.of(context, rootNavigator: true).pop('dialog');
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

  Future<List<Media>> loadMediaClosest() async {
    // showAlertDialog(context);
    print("load mediaaa");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var url = Uri.parse(constant.Url.crave_url+'get_media_feed_closest.php');
    returnedMedia.clear();
    dummyMedia.clear();
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

      if(user['media'] != null){

        List<dynamic> body = user['media'];

        List<Media> media = body
            .map(
              (dynamic item) => Media.fromJson(item),
        ).toList();

        List<Media> dmedia = body
            .map(
              (dynamic item) => Media.fromJson(item),
        ).toList();

        setState(() {
          //isCarAvailable = true;
          // selectedMedia = media[0];
          returnedMedia = media;
          dummyMedia = dmedia;
          loadComment();
          // Navigator.of(context, rootNavigator: true).pop('dialog');
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

  Future<List<Media>> loadMediaFollowing() async {
    // showAlertDialog(context);
    print("load mediaaa");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var url = Uri.parse(constant.Url.crave_url+'get_media_feed_following.php');
    returnedMedia.clear();
    dummyMedia.clear();
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

      if(user['media'] != null){

        List<dynamic> body = user['media'];

        List<Media> media = body
            .map(
              (dynamic item) => Media.fromJson(item),
        ).toList();

        List<Media> dmedia = body
            .map(
              (dynamic item) => Media.fromJson(item),
        ).toList();

        setState(() {
          //isCarAvailable = true;
          // selectedMedia = media[0];
          returnedMedia = media;
          dummyMedia = dmedia;
          loadComment();
          // Navigator.of(context, rootNavigator: true).pop('dialog');
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

  Future<List<Comment>> loadComment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var url = Uri.parse(constant.Url.crave_url+'get_post_comments.php');
    returnedComment.clear();
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        "email":prefs.getString('user_email'),
        "post_id":selectedMedia.media_id,
      },
    );

    if (response.statusCode == 200) {
      print("get response load comment");
      print(response.body);

      Map<String, dynamic> user = jsonDecode(response.body);

      if(user['comments'] != null){

        List<dynamic> body = user['comments'];

        List<Comment> comment = body
            .map(
              (dynamic item) => Comment.fromJson(item),
        ).toList();

        setState(() {
          //isCarAvailable = true;
          returnedComment = comment;
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
      });

        return [];
      // }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }

  }

  Future<List<CraveList>> loadCraveList() async {
    // showAlertDialog(context);
    print("load crave list");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('user_email'));
    var url = Uri.parse(constant.Url.crave_url+'get_crave_lists.php');
    returnedCraveList.clear();
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
          returnedCraveList = craveList;
          print("currentCraveList---1111");
          print(returnedCraveList.length);
          loadComment();
          // Navigator.of(context, rootNavigator: true).pop('dialog');
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

  void getLocation() async{
    Position position = await _determinePosition();
    setState(() {
      setLatlng(position.latitude,position.longitude);
      print("curentl attaa");
      print(position.latitude);
      print(position.longitude);
    });
  }

  setLatlng(lat,lng) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('lat', lat);
    prefs.setDouble('lng', lng);
  }

  void onDataChange(int newData) {
    setState(() {
      loadMedia();
      selectedMedia = returnedMedia[newData];
      selectedMediaIndex = newData;
      loadComment();
    });
  }

  void onLoadCraveList(){
    loadCraveList();
  }

  void onHomepageSelect(int newData) {
    setState(() {
      selectedMediaIndex = newData;
      print("from myhomepage");
      print(selectedMediaIndex);
    });
  }

  void onSelectUser(String email) {
    this.widget.setCurrentUser(email);
  }

  int getselectedMediaIndex(){
    return selectedMediaIndex;
  }


  // void onSendComment(int newData) {
  //   setState(() {
  //     loadMedia();
  //     selectedMedia = returnedMedia[newData];
  //     selectedMediaIndex = newData;
  //     loadComment();
  //   });
  //
  // }

  void onLoadNewData(){
    startLoad();
  }

  void onLoadDiscover(){
    loadMedia();
  }


  void onLoadClosest(){
    loadMediaClosest();
  }

  void onLoadFollowing(){
    loadMediaFollowing();
  }


  onChangeTab(int nowTab){
    setState(() {
      currentTab = nowTab;
    });
  }

  onChangedMenu(int menuItem){
    setState(() {
      currentMenuIndex = menuItem;
    });
  }

  showAlertDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content:  Row(
        children: [
          const CircularProgressIndicator(),
          // Container(margin: const EdgeInsets.only(left: 5),child:const Text("Loading")),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

  void triggerLoad(){
    Feed.of(this.context)!.startLoad();
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
                              onPageChanged: (int page) {
                                print("im in pageee");
                                print(page);
                                if(page == 1){
                                  setState(() {
                                    triggerLoad();
                                  });

                                }
                              },
                              physics: NeverScrollableScrollPhysics(),
                              controller: _controller,
                              children: [
                                Homepage(homepageController: _controller, medias:returnedMedia,dummyMedia:dummyMedia,onLoadNewData: onLoadNewData,onDataChange: onHomepageSelect,onLoadDiscover:onLoadDiscover,onLoadClosest:onLoadClosest,onLoadFollowing:onLoadFollowing),
                                Feed(homepageController: _controller,medias:returnedMedia,onDataChange: onDataChange,onLoadMedia:startLoad,onSelectUser:onSelectUser,craveList:returnedCraveList,selectedMediaIndex:selectedMediaIndex),
                                FeedDetails(homepageController: _controller, selectedMedia:selectedMedia,commentList:returnedComment,onDataChange: onDataChange,selectedMediaIndex:selectedMediaIndex,onSelectUser:onSelectUser)
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
