
import 'package:a_crave/settingsPage.dart';

import 'camera_screen.dart';
import 'cravingsPage.dart';
import 'dataClass.dart';
import 'filter_wheel.dart';
import 'myChat.dart';
import 'myHomepage.dart';
import 'myNavWheel.dart';

import 'chatPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'homepage.dart';
import 'package:circle_list/circle_list.dart';
import 'package:sizer/sizer.dart';

import 'myProfilePage.dart';
import 'myReels.dart';
import 'nav_wheel.dart';
import 'notificationsPage.dart';
import 'profileUser.dart';
import 'reelsDetails.dart';
import 'package:introduction_screen/introduction_screen.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';


class PageViewDemo extends StatefulWidget {
  static _PageViewDemoState? of(BuildContext context) => context.findAncestorStateOfType<_PageViewDemoState>();
  @override
  _PageViewDemoState createState() => _PageViewDemoState();

}

class _PageViewDemoState extends State<PageViewDemo> {
  PageController _controller = PageController(
    initialPage: 0,
  );

  bool isShowTutorial = true;
  String currentUser = "";
  String tutor1 = "false";
  String tutor2 = "false";
  String tutor3 = "false";
  String tutor4 = "false";

  void startLoad() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if(!prefs.containsKey('tutorial1_done')){
        prefs.setString("tutorial1_done", "false");
        tutor1 = prefs.getString("tutorial1_done")!;
      }
      else{
        tutor1 = prefs.getString("tutorial1_done")!;
      }

      if(!prefs.containsKey('tutorial2_done')){
        prefs.setString("tutorial2_done", "false");
        tutor2 = prefs.getString("tutorial2_done")!;
      }
      else{
        tutor2 = prefs.getString("tutorial2_done")!;
      }

      if(!prefs.containsKey('tutorial3_done')){
        prefs.setString("tutorial3_done", "false");
        tutor3 = prefs.getString("tutorial3_done")!;
      }
      else{
        tutor3 = prefs.getString("tutorial3_done")!;
      }

      if(!prefs.containsKey('tutorial4_done')){
        prefs.setString("tutorial4_done", "false");
        tutor4 = prefs.getString("tutorial4_done")!;
      }
      else{
        tutor4 = prefs.getString("tutorial4_done")!;
      }

      print(tutor1);
      print(tutor2);
      print(tutor3);
      print(tutor4);
    });

  }

  final _nav_menu = [
    'images/menu_settings.png',
    'images/menu_camera.png',
    'images/menu_home.png',
    'images/menu_cravings.png',
    'images/menu_reels.png',
    'images/menu_me.png',
    'images/menu_chat.png',
    'images/menu_bell.png'

    // GestureDetector(
    //   onTap:(){
    //     // Navigator.push(
    //     //     context,
    //     //     MaterialPageRoute(
    //     //         builder: (context) => CameraScreen()));
    //   },
    //   child: Image(image: AssetImage('images/menu_camera.png'),height:30),
    // ),

    // GestureDetector(
    //   onTap:(){
    //     // Navigator.pushReplacement(
    //     //     context,
    //     //     MaterialPageRoute(
    //     //         builder: (context) => Homepage()));
    //     // Navigator.of(context).pushNamed('/');
    //     // setState(() {
    //     //   _controller.jumpToPage(0);
    //     // });
    //   },
    //   child: Image(image: AssetImage('images/menu_home.png'),height:35),
    // ),
    // GestureDetector(
    //   onTap:(){
    //     // Navigator.push(
    //     //     context,
    //     //     MaterialPageRoute(
    //     //         builder: (context) => CravingsPage()));
    //     // Navigator.of(context).pushNamed('/cravingsPage');
    //     // _controller.jumpToPage(1);
    //   },
    //   child: Image(image: AssetImage('images/menu_cravings.png'),height:30),
    // ),

    // GestureDetector(
    //   onTap:(){
    //     // Navigator.push(
    //     //     context,
    //     //     MaterialPageRoute(
    //     //         builder: (context) => ReelsDetails()));
    //   },
    //   child:Image(image: AssetImage('images/menu_reels.png'),height:35),
    // ),

    // GestureDetector(
    //   onTap:(){
    //     // Navigator.push(
    //     //     context,
    //     //     MaterialPageRoute(
    //     //         builder: (context) => ProfileUser()));
    //   },
    //   child:Image(image: AssetImage('images/menu_me.png'),height:35),
    // ),

    // GestureDetector(
    //   onTap:(){
    //     // Navigator.pushReplacement(
    //     //     context,
    //     //     MaterialPageRoute(
    //     //         builder: (context) => ChatPage()));
    //     // Navigator.of(context).pushNamed('/chatPage');
    //     // _controller.jumpToPage(2);
    //   },
    //   child: Image(image: AssetImage('images/menu_chat.png'),height:30),
    // ),

    // GestureDetector(
    //   onTap:(){
    //     // Navigator.pushReplacement(
    //     //     context,
    //     //     MaterialPageRoute(
    //     //         builder: (context) => NotificationsPage()));
    //   },
    //   child: Image(image: AssetImage('images/menu_bell.png'),height:40),
    // ),

    // Container(),
    // Container(),
    // Container(),
    // Container(),
  ];

  bool isShowWheel = false;
  bool isDisappearWheel = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void showWheel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('tutorial1_done') == "false"){
      prefs.setString("tutorial1_done", "true");
    }
    setState(() {
      isShowWheel = true;
      tutor1 = "true";
    });
  }

  void hideWheel(){
    setState(() {
      isShowWheel = false;
    });
  }

  void appearWheel(){
    setState(() {
      isDisappearWheel = true;
    });
  }

  void disappearWheel(){
    setState(() {
      isDisappearWheel = false;
    });
  }

  void _onNavChanged(int value) {
    // print("onnavchangeee");
    // print(value);
    // //_filterColor.value = value;
    // if(value == 2){
    //   _controller.jumpToPage(0);
    // }
    // else if(value == 3){
    //   _controller.jumpToPage(1);
    // }
  }

  void onClosePop(){
    _controller.previousPage(duration: Duration(milliseconds: 100), curve: Curves.easeIn);
  }

  void onWheelClicked(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('tutorial2_done') == "false"){
      prefs.setString("tutorial2_done", "true");
    }
    setState(() {
      tutor2 = "true";
    });

      if(value == 1){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CameraScreen()));
      }
      else if(value == 0){
        _controller.jumpToPage(6);
      }
     else if(value == 2){
        _controller.jumpToPage(0);
      }
      else if(value == 3){
        _controller.jumpToPage(1);
      }
      else if(value == 4){
        _controller.jumpToPage(4);
      }
      else if(value == 5){
        getMainUser();
        // _controller.jumpToPage(5);
      }
      else if(value == 6){
        _controller.jumpToPage(2);
      }
      else if(value == 7){
        _controller.jumpToPage(3);
      }
    print("value ");
    print(value.toString());
    print("current page ");
    print(_controller.page.toString());
  }

  Widget _buildNavigationSelector() {
    return NavigationSelector(
      onFilterChanged: _onNavChanged,
      filters: _nav_menu,
    );
  }

  void set_current_User(String email){
    setState(() {
      currentUser = email;
      _controller.jumpToPage(5);
      // _controller.jumpToPage(5);

    });
  }

  Future<void> getMainUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('user_email')!;
    set_current_User(email);
  }

  void setTutorialDone(String page) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(page == "3"){
      if(prefs.getString('tutorial3_done') == "false"){
        prefs.setString("tutorial3_done", "true");
      }
      setState(() {
        tutor3 = "true";
      });
    }

    else if(page == "4"){
      if(prefs.getString('tutorial4_done') == "false"){
        prefs.setString("tutorial4_done", "true");
      }
      setState(() {
        tutor4 = "true";
      });
    }

  }


  @override
  void initState() {
    super.initState();
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   PushNotification notification = PushNotification(
    //     title: message.notification?.title,
    //     body: message.notification?.body,
    //   );
    //
    // });
    WidgetsBinding.instance!.addPostFrameCallback((_) => startLoad());
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = const PageDecoration(
      // titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      // bodyTextStyle: bodyStyle,
      // bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      // pageColor: Colors.green,
      // imagePadding: EdgeInsets.zero,
    );
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
                                print("is wheel shown top");
                                print(details.delta.dx);
                                if(isShowWheel){
                                  hideWheel();
                                }

                              }
                              else if(details.delta.dx < -sensitivity){
                                //Left Swipe
                                print("is wheel hide top");
                                print(details.delta.dx);
                                if(!isShowWheel){
                                  showWheel();
                                }
                                print("swipe left");
                              }
                            },
                            child:Stack(
                              children: [
                                PageView(
                                  physics: NeverScrollableScrollPhysics(),
                                  controller: _controller,
                                  children: [
                                    MyHomepage(setCurrentUser:set_current_User),
                                    CravingsPage(),
                                    myChat(),
                                    NotificationsPage(),
                                    myReels(),
                                    myProfilePage(currentUser:currentUser),
                                    SettingsPage()
                                  ],
                                ),


                                tutor1=="false"?
                                    SafeArea(
                                      bottom: false,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: AssetImage(
                                                  "images/homepage_tutorial1.png")
                                          ),
                                        ),
                                      )
                                    )
                                    :
                                    tutor2=="false"?
                                    SafeArea(
                                      bottom:false,
                                      child:Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: AssetImage(
                                                  "images/homepage_tutorial2.png")
                                          ),
                                        ),
                                      )
                                    )
                                    :
                                        tutor3 == "false"&&_controller.page==1?
                                            GestureDetector(
                                              onTap:(){
                                                setTutorialDone("3");
                                              },
                                                child:Container(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        fit: BoxFit.fill,
                                                        image: AssetImage(
                                                            "images/homepage_tutorial3.jpg")
                                                    ),
                                                  ),
                                                )
                                            )
                                        :
                                        tutor4 == "false"&&_controller.page==1?
                                        GestureDetector(
                                            onTap:(){
                                              setTutorialDone("4");
                                            },
                                            child:Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: AssetImage(
                                                        "images/homepage_tutorial4.jpg")
                                                ),
                                              ),
                                            )
                                        ):
                                        Container(height:0, width:0),

                                Visibility(
                                  visible: isDisappearWheel,
                                  child:AnimatedPositioned(
                                      height:MediaQuery.of(context).size.height ,
                                      width:MediaQuery.of(context).size.width ,
                                      right: isShowWheel ? 0.0 : -30.0.w,
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.fastOutSlowIn,
                                      child: Align(
                                          alignment: Alignment.center,
                                          child:Padding(
                                            padding: const EdgeInsets.only(top:0),
                                            child:
                                            RotatedBox(
                                              quarterTurns: 3,
                                              child:Align(
                                                alignment:Alignment.bottomRight,
                                                child:
                                                Container(
                                                  // color:Colors.yellow,
                                                  height:isShowWheel?MediaQuery.of(context).size.width:35.0.w ,
                                                  width:isShowWheel?MediaQuery.of(context).size.height:100.0.h ,
                                                  child:GestureDetector(
                                                    onTap: () {
                                                      print("is wheel shown ontap");
                                                      setState(() {
                                                        isShowWheel = !isShowWheel;
                                                      });
                                                    },
                                                    child:_buildNavigationSelector(),
                                                  ),


                                                ),


                                              ),

                                            ),
                                            // Transform.scale(
                                            //   scale:
                                            //   (MediaQuery.of(context).size.height / 600),
                                            //   child:CircleList(
                                            //     // showInitialAnimation: true,
                                            //     rotateMode:RotateMode.allRotate,
                                            //     innerCircleColor:Color(0xFF2CBFC6),
                                            //     outerCircleColor:Color(0xFF2CBFC6),
                                            //     origin: Offset(50.0.w, 0),
                                            //     children: [
                                            //       Container(),
                                            //       Container(),
                                            //       Container(),
                                            //       Container(),
                                            //       Container(),
                                            //       Container(),
                                            //
                                            //       Image(image: AssetImage('images/menu_settings.png'),height:30),
                                            //       GestureDetector(
                                            //         onTap:(){
                                            //           // Navigator.push(
                                            //           //     context,
                                            //           //     MaterialPageRoute(
                                            //           //         builder: (context) => CameraScreen()));
                                            //         },
                                            //         child: Image(image: AssetImage('images/menu_camera.png'),height:30),
                                            //       ),
                                            //
                                            //       GestureDetector(
                                            //         onTap:(){
                                            //           // Navigator.pushReplacement(
                                            //           //     context,
                                            //           //     MaterialPageRoute(
                                            //           //         builder: (context) => Homepage()));
                                            //           // Navigator.of(context).pushNamed('/');
                                            //           setState(() {
                                            //             _controller.jumpToPage(0);
                                            //           });
                                            //         },
                                            //         child: Image(image: AssetImage('images/menu_home.png'),height:35),
                                            //       ),
                                            //       GestureDetector(
                                            //         onTap:(){
                                            //           // Navigator.push(
                                            //           //     context,
                                            //           //     MaterialPageRoute(
                                            //           //         builder: (context) => CravingsPage()));
                                            //           // Navigator.of(context).pushNamed('/cravingsPage');
                                            //           _controller.jumpToPage(1);
                                            //         },
                                            //         child: Image(image: AssetImage('images/menu_cravings.png'),height:30),
                                            //       ),
                                            //
                                            //       GestureDetector(
                                            //         onTap:(){
                                            //           // Navigator.push(
                                            //           //     context,
                                            //           //     MaterialPageRoute(
                                            //           //         builder: (context) => ReelsDetails()));
                                            //         },
                                            //         child:Image(image: AssetImage('images/menu_reels.png'),height:35),
                                            //       ),
                                            //
                                            //       GestureDetector(
                                            //         onTap:(){
                                            //           // Navigator.push(
                                            //           //     context,
                                            //           //     MaterialPageRoute(
                                            //           //         builder: (context) => ProfileUser()));
                                            //         },
                                            //         child:Image(image: AssetImage('images/menu_me.png'),height:35),
                                            //       ),
                                            //
                                            //       GestureDetector(
                                            //         onTap:(){
                                            //           // Navigator.pushReplacement(
                                            //           //     context,
                                            //           //     MaterialPageRoute(
                                            //           //         builder: (context) => ChatPage()));
                                            //           // Navigator.of(context).pushNamed('/chatPage');
                                            //           _controller.jumpToPage(2);
                                            //         },
                                            //         child: Image(image: AssetImage('images/menu_chat.png'),height:30),
                                            //       ),
                                            //
                                            //       GestureDetector(
                                            //         onTap:(){
                                            //           // Navigator.pushReplacement(
                                            //           //     context,
                                            //           //     MaterialPageRoute(
                                            //           //         builder: (context) => NotificationsPage()));
                                            //         },
                                            //         child: Image(image: AssetImage('images/menu_bell.png'),height:40),
                                            //       ),
                                            //
                                            //       Container(),
                                            //       Container(),
                                            //       Container(),
                                            //       Container(),
                                            //
                                            //     ],
                                            //   ),
                                            // ),
                                          )
                                      )
                                  ),
                                ),

                                // SafeArea(
                                //     bottom: false,
                                //     child:IntroductionScreen(
                                //       pages: [
                                //         PageViewModel(
                                //           title: "",
                                //           body: "",
                                //           image:Image.asset(
                                //             "images/homepage_tutorial1.jpg",
                                //             fit: BoxFit.fill,
                                //             height: double.infinity,
                                //             width: double.infinity,
                                //             alignment: Alignment.center,
                                //           ),
                                //           decoration: pageDecoration.copyWith(
                                //             // contentMargin: const EdgeInsets.symmetric(horizontal: 16),
                                //             fullScreen: true,
                                //             // bodyFlex: 1,
                                //             // imageFlex: 1,
                                //           ),
                                //         ),
                                //         PageViewModel(
                                //           title: "",
                                //           body: "",
                                //           image: Image.asset(
                                //             "images/homepage_tutorial2.jpg",
                                //             fit: BoxFit.fill,
                                //             height: double.infinity,
                                //             width: double.infinity,
                                //             alignment: Alignment.center,
                                //           ),
                                //           decoration: pageDecoration.copyWith(
                                //             contentMargin: const EdgeInsets.symmetric(horizontal: 16),
                                //             fullScreen: true,
                                //             bodyFlex: 2,
                                //             imageFlex: 3,
                                //           ),
                                //         )
                                //       ],
                                //       done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
                                //       onDone: () {
                                //         // When done button is press
                                //         setState(() {
                                //           isShowTutorial = false;
                                //         });
                                //       },
                                //       showSkipButton: false,
                                //       skipOrBackFlex: 0,
                                //       nextFlex: 0,
                                //       showBackButton: true,
                                //       //rtl: true, // Display as right-to-left
                                //       back: const Icon(Icons.arrow_back),
                                //       skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
                                //       next: const Icon(Icons.arrow_forward),
                                //       curve: Curves.fastLinearToSlowEaseIn,
                                //       dotsDecorator: const DotsDecorator(
                                //         size: Size(0.0,0.0),
                                //         color: Colors.transparent,
                                //         activeSize: Size(0.0, 0.0),
                                //         activeColor: Colors.transparent,
                                //         // activeShape: RoundedRectangleBorder(
                                //         //   borderRadius: BorderRadius.all(Radius.circular(25.0)),
                                //         // ),
                                //       ),
                                //     )
                                // )


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