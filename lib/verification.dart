// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'constants.dart' as constant;


class Verification extends StatefulWidget {
  const Verification({Key? key}) : super(key: key);

  @override
  VerificationState createState() => VerificationState();
}

class VerificationState extends State<Verification> {

  bool _visible = false;
  late Timer _timer;
  int _start = 60;

  TextEditingController textEditingController = TextEditingController();
  // ..text = "123456";

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;
  bool hasError = false;
  bool isResendCode = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();


  showAlertDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content:  Row(
        children: [
          const CircularProgressIndicator(),
          Container(margin: const EdgeInsets.only(left: 5),child:const Text("Loading")),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

  void goToFiller() {
    setState(() {
      Navigator.of(context).pushReplacementNamed("/profileSetupPicture");
    });
  }

  languageBoxVisible(){
    setState(() {
      _visible = !_visible;
    });
  }

  Future<http.Response> verifyUser() async {
    showAlertDialog(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user_email =prefs.getString('user_email');
    if(textEditingController.text.isEmpty){
      Navigator.of(context, rootNavigator: true).pop('dialog');
      // _showDialog("Please fill in your email and password");
    }
    else{
      var url = Uri.parse(constant.Url.crave_url+'verify_user.php');
      final http.Response response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        },
        body: {
          "email":user_email,
          "verification_code":textEditingController.text,
        },
      );
      if (response.statusCode == 200) {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        // If the server did return a 201 CREATED response,
        // then parse the JSON.
        //return Album.fromJson(json.decode(response.body));
        print(response.body);
        Map<String, dynamic> user = jsonDecode(response.body);
        log(response.body);
        log(user['result'].toString());
        if(user['result'].toString() == "0"){
          // Navigator.of(context, rootNavigator: true).pop('dialog');
          // _showDialog(user['message']);
        }
        else{
          log("---check ic here---");
//          log(user['data']['token']);
//           Navigator.of(context, rootNavigator: true).pop('dialog');
          goToFiller();
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
    throw '';
  }

  Future<http.Response> resendCode() async {
    startTimer();
    showAlertDialog(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user_email =prefs.getString('user_email');
    // if(textEditingController.text.isEmpty){
    //   Navigator.of(context, rootNavigator: true).pop('dialog');
    //   // _showDialog("Please fill in your email and password");
    // }
    // else{
      var url = Uri.parse(constant.Url.crave_url+'send_verification_code.php');
      final http.Response response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        },
        body: {
          "email":user_email
        },
      );
      if (response.statusCode == 200) {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        // If the server did return a 201 CREATED response,
        // then parse the JSON.
        //return Album.fromJson(json.decode(response.body));
        print(response.body);
        Map<String, dynamic> user = jsonDecode(response.body);
        log(response.body);
        log(user['result'].toString());
        if(user['result'].toString() == "0"){
          // Navigator.of(context, rootNavigator: true).pop('dialog');
          // _showDialog(user['message']);
        }
        else{
          log("---sent new code---");
//          log(user['data']['token']);
//           Navigator.of(context, rootNavigator: true).pop('dialog');
//           goToFiller();
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
    // }
    // throw '';
  }

  void startTimer() {
    setState(() {
      _start = 60;
      isResendCode = false;
    });
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            isResendCode = true;
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => startTimer());

  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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
                                            left: 35.0,bottom:20),
                                        child:Text("Verification",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: Color(constant.Color.crave_brown),
                                                fontSize: 22.0.sp)),
                                      ),
                                      Container(
                                        width: double.maxFinite,
                                        padding: const EdgeInsets.only(
                                            left: 35.0),
                                        child:Text("Please enter the 6-digit code sent to your",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                                fontSize: 10.0.sp)),
                                      ),
                                      Container(
                                        width: double.maxFinite,
                                        padding: const EdgeInsets.only(
                                            left: 35.0,bottom:20),
                                        child:Text("phone number",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 10.0.sp)),
                                      ),
                                      Container(
                                        //width:250,
                                        height:70,
                                        margin: const EdgeInsets.only(bottom: 30.0),
                                        padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                                        child:PinCodeTextField(
                                          // hintCharacter: "-",
                                          length: 6,
                                          obscureText: false,
                                          animationType: AnimationType.fade,
                                          pinTheme: PinTheme(
                                            // shape: PinCodeFieldShape.underline,
                                            // borderRadius: BorderRadius.circular(5),
                                            fieldHeight: 60,
                                            fieldWidth: 40,
                                            activeFillColor: Colors.white,
                                            activeColor: Color(constant.Color.crave_grey),
                                            inactiveFillColor: Colors.white,
                                            inactiveColor: Color(constant.Color.crave_grey),
                                            selectedColor: Color(constant.Color.crave_grey),
                                            selectedFillColor: Colors.white,
                                          ),
                                          animationDuration: Duration(milliseconds: 300),
                                          backgroundColor: Colors.white,
                                          enableActiveFill: true,
                                          cursorColor: Colors.black,
                                          errorAnimationController: errorController,
                                          controller: textEditingController,
                                          onCompleted: (v) {
                                            print("Completed");
                                          },
                                          onChanged: (value) {
                                            print(value);
                                            setState(() {
                                              currentText = value;
                                            });
                                          },
                                          beforeTextPaste: (text) {
                                            print("Allowing to paste $text");
                                            //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                            //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                            return true;
                                          }, appContext: context,
                                        )
                                      ),

                                      SizedBox(
                                          width:60.w,
                                          height:6.h,
                                          child: ElevatedButton(
                                              child: Text(
                                                  "Verify".toUpperCase(),
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 16.0.sp)
                                              ),
                                              style: ButtonStyle(
                                                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                                  backgroundColor: MaterialStateProperty.all<Color>(const Color(constant.Color.crave_blue)),
                                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(8.0),
                                                          side: const BorderSide(color: Color(constant.Color.crave_blue))
                                                      )
                                                  )
                                              ),
                                              onPressed: () => verifyUser()
                                          )
                                      ),
                                      SizedBox(
                                          height:33.0.h
                                      ),
                                      GestureDetector(
                                        onTap:isResendCode?resendCode:null,
                                        child:Container(
                                          decoration: BoxDecoration(
                                              border:Border(
                                                  bottom: BorderSide(
                                                    color:Color(constant.Color.crave_brown),
                                                  )
                                              )
                                          ),
                                          padding: const EdgeInsets.only(bottom:1,top:10),
                                          child:Text(isResendCode?"RESEND CODE":"CODE SENT",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                  fontSize: 12.0.sp)),
                                        ),
                                      ),
                                      isResendCode?
                                      Container(height:15):
                                      Container(
                                        padding: const EdgeInsets.only(top:15),
                                        child:Text("Resend available in ($_start)",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Color(constant.Color.crave_orange),
                                                fontSize: 11.0.sp))),
                                      SizedBox(
                                          height:2.0.h
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