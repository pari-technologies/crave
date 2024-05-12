
import 'cravingsPage.dart';
import 'myHomepage.dart';
import 'myNavWheel.dart';

import 'chatPage.dart';

import 'package:flutter/material.dart';
import 'homepage.dart';
import 'package:circle_list/circle_list.dart';
import 'package:sizer/sizer.dart';


class PageViewDemo extends StatefulWidget {
  @override
  _PageViewDemoState createState() => _PageViewDemoState();
}

class _PageViewDemoState extends State<PageViewDemo> {
  PageController _controller = PageController(
    initialPage: 0,
  );

  bool isShowWheel = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void showWheel(){
    setState(() {
      isShowWheel = true;
    });
  }

  void hideWheel(){
    setState(() {
      isShowWheel = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return
      Stack(
        children: [
            PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: _controller,
            children: [
              // myHomepage(),
              CravingsPage(),
              //ChatPage(),
            ],
          ),
          isShowWheel?
          Padding(
            padding: const EdgeInsets.only(top:100),
            child:
            Transform.scale(
              scale:
              (MediaQuery.of(context).size.height / 600),
              child:CircleList(
                // showInitialAnimation: true,
                rotateMode:RotateMode.allRotate,
                innerCircleColor:Color(0xFF2CBFC6),
                outerCircleColor:Color(0xFF2CBFC6),
                origin: Offset(50.0.w, 0),
                children: [
                  Container(),
                  Container(),
                  Container(),
                  Container(),
                  Container(),
                  Container(),

                  Image(image: AssetImage('images/menu_settings.png'),height:30),
                  GestureDetector(
                    onTap:(){
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => CameraScreen()));
                    },
                    child: Image(image: AssetImage('images/menu_camera.png'),height:30),
                  ),

                  GestureDetector(
                    onTap:(){
                      // Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => Homepage()));
                      // Navigator.of(context).pushNamed('/');
                      setState(() {
                        _controller.jumpToPage(0);
                      });
                    },
                    child: Image(image: AssetImage('images/menu_home.png'),height:35),
                  ),
                  GestureDetector(
                    onTap:(){
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => CravingsPage()));
                      // Navigator.of(context).pushNamed('/cravingsPage');
                      _controller.jumpToPage(1);
                    },
                    child: Image(image: AssetImage('images/menu_cravings.png'),height:30),
                  ),

                  GestureDetector(
                    onTap:(){
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => ReelsDetails()));
                    },
                    child:Image(image: AssetImage('images/menu_reels.png'),height:35),
                  ),

                  GestureDetector(
                    onTap:(){
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => ProfileUser()));
                    },
                    child:Image(image: AssetImage('images/menu_me.png'),height:35),
                  ),

                  GestureDetector(
                    onTap:(){
                      // Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => ChatPage()));
                      // Navigator.of(context).pushNamed('/chatPage');
                      _controller.jumpToPage(2);
                    },
                    child: Image(image: AssetImage('images/menu_chat.png'),height:30),
                  ),

                  GestureDetector(
                    onTap:(){
                      // Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => NotificationsPage()));
                    },
                    child: Image(image: AssetImage('images/menu_bell.png'),height:40),
                  ),

                  Container(),
                  Container(),
                  Container(),
                  Container(),

                ],
              ),
            ),
          ):
          Container(),
        ],
      );

  }
}