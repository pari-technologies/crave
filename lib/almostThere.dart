// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:sizer/sizer.dart';

import 'login.dart';


class AlmostThere extends StatefulWidget {
  const AlmostThere({Key? key}) : super(key: key);

  @override
  AlmostThereState createState() => AlmostThereState();
}

class AlmostThereState extends State<AlmostThere> {
  bool _visible = false;
  bool _visible_box = false;


  languageBoxVisible(){
    setState(() {
      _visible_box = !_visible_box;
    });
  }


  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => loadData());

  }

  Future<Timer> loadData() async {
    setState(() {
      _visible = !_visible;
    });
    return Timer(const Duration(seconds: 2), onDoneLoading);
  }

  onDoneLoading() async {
    Navigator.of(context).pushReplacementNamed("/profileSetupPicture");
  }

  @override
  Widget build(BuildContext context) {

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
                          resizeToAvoidBottomInset: false,
                          backgroundColor: Colors.white,
                          body:
                          SingleChildScrollView(
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 2000),
                              opacity: _visible ? 1.0 : 0.0,
                              child: SizedBox(
                                height:MediaQuery.of(context).size.height,
                                child:Stack(
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          width: double.maxFinite,
                                          padding: const EdgeInsets.only(
                                              left: 35.0,bottom:10, top:100),
                                          child:Text("Almost there!",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black,
                                                  fontSize: 20.0.sp)),
                                        ),

                                        Container(
                                          width: double.maxFinite,
                                          padding: const EdgeInsets.only(
                                              left: 35.0),
                                          child:Text("All you need now is a profile.",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                  fontSize: 12.0.sp)),
                                        ),
                                        Spacer(),

                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: languageBoxVisible,
                                      child: Visibility(
                                        visible: _visible_box,
                                        child: Align(
                                          alignment: FractionalOffset.bottomRight,
                                          child: Wrap(
                                            children: [Padding(
                                              padding: EdgeInsets.only(bottom: 50.0,right:20),
                                              child:Container(
                                                // alignment: Alignment.bottomRight,
                                                // width:100,
                                                padding: const EdgeInsets.only( right:20.0,left:20,top: 10.0, bottom:5),
                                                decoration: BoxDecoration(
                                                    color: Color(0xFFF4F4F4),
                                                    borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(20.0),
                                                        bottomLeft: Radius.circular(20.0),
                                                        topRight: Radius.circular(20.0),
                                                        bottomRight: Radius.circular(20.0))),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    Text("English".toUpperCase(),
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 10.0.sp)),
                                                    SizedBox(height: 5),
                                                    Text("日本国".toUpperCase(),
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 10.0.sp)),
                                                    SizedBox(height: 5),
                                                    Text("한국어".toUpperCase(),
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 10.0.sp)),
                                                    SizedBox(height: 5),
                                                    Text("French".toUpperCase(),
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 10.0.sp)),
                                                    SizedBox(height: 5),
                                                  ],
                                                ),
                                              ),
                                            ),],
                                          ),

                                        ),
                                      ),
                                    ),

                                    GestureDetector(
                                      onTap: languageBoxVisible,
                                      child: Align(
                                        alignment: FractionalOffset.bottomRight,
                                        child: Padding(
                                          padding: EdgeInsets.only(bottom: 10.0),
                                          child:Container(
                                            padding: const EdgeInsets.only( right:20.0,top: 5.0, bottom:10),
                                            // width: double.maxFinite,
                                            //height:10.0.h,
                                            child:
                                            Container(
                                              // alignment: Alignment.bottomRight,
                                              width:23.0.w,
                                              decoration: BoxDecoration(
                                                  color: Color(0xFFF4F4F4),
                                                  borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(20.0),
                                                      bottomLeft: Radius.circular(20.0),
                                                      topRight: Radius.circular(20.0),
                                                      bottomRight: Radius.circular(20.0))),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Flexible(
                                                    child:Text("English".toUpperCase(),
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 10.0.sp)),
                                                  ),

                                                  const Icon(
                                                    Icons.keyboard_arrow_up,
                                                    color: Colors.grey,
                                                    size: 25.0,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                  ],
                                ),

                              ),
                            )

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