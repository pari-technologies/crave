import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:a_crave/profileBusiness.dart';
import 'package:a_crave/reelsDetails.dart';
import 'dataClass.dart';
import 'reels.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'constants.dart' as constant;
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';



class myReels extends StatefulWidget {
  const myReels({Key? key}) : super(key: key);

  @override
  myReelsState createState() => myReelsState();
}

class myReelsState extends State<myReels> {
  List<Media> returnedMedia = [];

  @override
  void initState() {
    super.initState();
    startLoad();
    // WidgetsBinding.instance!.addPostFrameCallback((_) => startLoad());
  }

  void startLoad() async{
    loadMedia();
  }


  Future<List<Media>> loadMedia() async {
    print("load mediaaa");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var url = Uri.parse(constant.Url.crave_url+'get_media_reels.php');
    // returnedMedia.clear();
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
                          PageView(
                            physics: NeverScrollableScrollPhysics(),
                            controller: _controller,
                            children: [
                              ReelsDetails(reelsPageController: _controller, medias :returnedMedia, startLoad:startLoad),
                              Reels(reelsPageController: _controller),
                            ],
                          ),
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
