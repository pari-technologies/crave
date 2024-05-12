// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:sizer/sizer.dart';


class ForgotPasswordSend extends StatefulWidget {
  const ForgotPasswordSend({Key? key}) : super(key: key);

  @override
  ForgotPasswordSendState createState() => ForgotPasswordSendState();
}

class ForgotPasswordSendState extends State<ForgotPasswordSend> {

  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  bool _visible = false;

  languageBoxVisible(){
    setState(() {
      _visible = !_visible;
    });
  }

  void goToRegister() {
    setState(() {
      Navigator.of(context).pushReplacementNamed("/register");
    });
  }

  void goToResetPass() {
    setState(() {
      Navigator.of(context).pushReplacementNamed("/resetPass");
    });
  }


  void initState() {
    super.initState();
    // WidgetsBinding.instance!.addPostFrameCallback((_) => loadProfile());

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
                                            left: 35.0,bottom:10),
                                        child:Text("Awesome!",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black,
                                                fontSize: 26.0.sp)),
                                      ),

                                      Container(
                                        width: double.maxFinite,
                                        padding: const EdgeInsets.only(
                                            left: 35.0),
                                        child:Text("Please click the link below to create a",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                                fontSize: 11.0.sp)),
                                      ),
                                      Container(
                                        width: double.maxFinite,
                                        padding: const EdgeInsets.only(
                                            left: 35.0,bottom:25),
                                        child:Text("new password",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                                fontSize: 11.0.sp)),
                                      ),


                                      SizedBox(
                                          width:60.w,
                                          height:6.h,
                                          child: ElevatedButton(
                                              child: Text(
                                                  "Reset Password".toUpperCase(),
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 14.0.sp)
                                              ),
                                              style: ButtonStyle(
                                                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                                  backgroundColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(44, 191, 198, 1.0)),
                                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(5.0),
                                                          side: const BorderSide(color: Color.fromRGBO(44, 191, 198, 1.0))
                                                      )
                                                  )
                                              ),
                                              onPressed: () => goToResetPass()
                                          )
                                      ),
                                      SizedBox(
                                          height:50.0.h
                                      ),

                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: languageBoxVisible,
                                    child: Visibility(
                                      visible: _visible,
                                      child: Align(
                                        alignment: FractionalOffset.bottomRight,
                                        child: Wrap(
                                          children: [Padding(
                                            padding: const EdgeInsets.only( right:30.0,top: 5.0, bottom:70),
                                            child:Container(
                                              // alignment: Alignment.bottomRight,
                                              // width:100,
                                              padding: const EdgeInsets.only( right:35.0,left:25,top: 10.0, bottom:5),
                                              decoration: BoxDecoration(
                                                  color: Color(0xFFF4F4F4),
                                                  borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(10.0),
                                                      bottomLeft: Radius.circular(10.0),
                                                      topRight: Radius.circular(10.0),
                                                      bottomRight: Radius.circular(10.0))),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text("English".toUpperCase(),
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12.0.sp)),
                                                  SizedBox(height: 6),
                                                  Text("日本国".toUpperCase(),
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12.0.sp)),
                                                  SizedBox(height: 6),
                                                  Text("한국어".toUpperCase(),
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12.0.sp)),
                                                  SizedBox(height: 6),
                                                  Text("French".toUpperCase(),
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12.0.sp)),
                                                  SizedBox(height: 6),
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
                                          padding: const EdgeInsets.only( right:30.0,top: 5.0, bottom:20),
                                          // width: double.maxFinite,
                                          //height:10.0.h,
                                          child:
                                          Container(
                                            // alignment: Alignment.bottomRight,
                                            width:32.0.w,
                                            height:3.5.h,
                                            padding: const EdgeInsets.only( right:5.0,left:5.0),
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
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.black,
                                                          fontSize: 12.0.sp)),
                                                ),
                                                SizedBox(width:8),
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