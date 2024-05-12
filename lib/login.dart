// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:a_crave/forgotPassword.dart';
import 'package:a_crave/register.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'homeBase.dart';
import 'constants.dart' as constant;


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {

  final usernameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  bool _visible = false;
  bool isShowErrorMsg = false;

  languageBoxVisible(){
    setState(() {
      _visible = !_visible;
    });
  }

  Future<http.Response> loginUser() async {
    setState(() {
      isShowErrorMsg = false;
    });
    showAlertDialog(context);

    if(usernameCtrl.text.isEmpty || passwordCtrl.text.isEmpty){
      Navigator.of(context, rootNavigator: true).pop('dialog');
      setState(() {
        isShowErrorMsg = true;
      });
      // _showDialog("Please fill in your email and password");
    }

    // else if(passwordCtrl.text != repasswordCtrl.text){
    //   Navigator.of(context, rootNavigator: true).pop('dialog');
    //   _showDialog("Password is not the same");
    // }
    else{
      var url = Uri.parse(constant.Url.crave_url+'login.php');
      final http.Response response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        },
        body: {
          "password":passwordCtrl.text,
          "username":usernameCtrl.text,
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
          Navigator.of(context, rootNavigator: true).pop('dialog');
          // _showDialog(user['message']);
          setState(() {
            isShowErrorMsg = true;
          });
        }
        else{
          log("---check ic here---");
//          log(user['data']['token']);
          Navigator.of(context, rootNavigator: true).pop('dialog');
          setUserProfile(user['email']);
          goToHomepage();
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

  setUserProfile(email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('isFirstTime', "false");
    prefs.setString('user_email', email);
  }

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

  void goToRegister() {
    // Navigator.of(context).pushReplacementNamed("/register");

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Register()));
  }

  void goToForgotPass() {
    // setState(() {
    //   Navigator.of(context).pushNamed("/forgotPassword");
    // });

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ForgotPassword()));
  }

  void goToHomepage() {
    // setState(() {
    //   Navigator.of(context).pushReplacementNamed("/homepage");
    // });
    Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PageViewDemo()));
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
                                        padding: EdgeInsets.only(
                                            left: 25.0,bottom:20),
                                        child:Text("Welcome Back!",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: Color(constant.Color.crave_brown),
                                                fontSize: 24.0.sp)),
                                      ),

                                      isShowErrorMsg?
                                      Column(
                                        children: [
                                          Container(
                                            width: double.maxFinite,
                                            padding: const EdgeInsets.only(
                                                left: 30.0),
                                            child:Text("Oh no! Looks like either your username or",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(constant.Color.crave_brown),
                                                    fontSize: 11.0.sp)),
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.only(left: 30.0,bottom:30),
                                                child:Text("password was entered ",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        color: Color(constant.Color.crave_brown),
                                                        fontSize: 11.0.sp)),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(bottom:30),
                                                child:Text("incorrectly ",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        color: Color(constant.Color.crave_orange),
                                                        fontSize: 11.0.sp)),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(bottom:30),
                                                child:Text(":(",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        color: Color(constant.Color.crave_brown),
                                                        fontSize: 11.0.sp)),
                                              ),
                                            ],
                                          ),

                                        ],
                                      ):
                                      Container(height:20),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                                            child: Text("Username",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    color: Color(constant.Color.crave_brown),
                                                    fontSize: 12.0.sp)),
                                          ),

                                          Row(
                                            children: [
                                              Container(
                                                width:90.0.w,
                                                height:45,
                                                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                                                child:TextField(
                                                  autofocus: false,
                                                  controller: usernameCtrl,
                                                  cursorColor: Colors.black,
                                                  keyboardType: TextInputType.text,
                                                  textInputAction: TextInputAction.go,
                                                  textCapitalization: TextCapitalization.sentences,
                                                  decoration:  InputDecoration(
                                                      counterText: '',
                                                      filled: false,
                                                      // Color(0xFFD6D6D6)
                                                      fillColor: Color(0xFFF2F2F2),
                                                      contentPadding:EdgeInsets.symmetric(horizontal: 0,vertical:10),
                                                      labelStyle: TextStyle(
                                                          fontSize: 14,
                                                          color:Colors.black
                                                      ),
                                                      enabledBorder: UnderlineInputBorder(
                                                        borderSide: BorderSide(color:Colors.transparent ),
                                                      ),
                                                      border: UnderlineInputBorder(
                                                        borderSide: BorderSide(color:Colors.transparent ),
                                                      ),
                                                      focusedBorder: UnderlineInputBorder(
                                                        borderSide: BorderSide(color:Colors.transparent, ),
                                                      ),
                                                      hintStyle: TextStyle(
                                                          fontSize: 17,
                                                          color:Colors.grey[300]
                                                      ),
                                                      hintText: "Username"),
                                                ),
                                              ),
                                              Container(
                                                width:isShowErrorMsg?10:0,
                                                height:isShowErrorMsg?10:0,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Color(constant.Color.crave_orange)),)
                                            ],
                                          ),

                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(left:30,right:30,top:0,bottom:10),
                                        child:Divider(
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                                            child: Text("Password",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    color: Color(constant.Color.crave_brown),
                                                    fontSize: 12.0.sp)),
                                          ),

                                          Row(
                                            children: [
                                              Container(
                                                width:90.0.w,
                                                height:50,
                                                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                                                child:TextField(
                                                  autofocus: false,
                                                  controller: passwordCtrl,
                                                  obscureText: true,
                                                  enableSuggestions: false,
                                                  autocorrect: false,
                                                  cursorColor: Colors.black,
                                                  keyboardType: TextInputType.text,
                                                  textInputAction: TextInputAction.go,
                                                  textCapitalization: TextCapitalization.sentences,
                                                  decoration: InputDecoration(
                                                      counterText: '',
                                                      filled: false,
                                                      fillColor: Color(0xFFF2F2F2),
                                                      contentPadding:EdgeInsets.symmetric(horizontal: 0,vertical:10),
                                                      labelStyle: TextStyle(
                                                          fontSize: 14,
                                                          color:Colors.black
                                                      ),
                                                      enabledBorder: UnderlineInputBorder(
                                                        borderSide: BorderSide(color:Colors.transparent ),
                                                      ),
                                                      border: UnderlineInputBorder(
                                                        borderSide: BorderSide(color:Colors.transparent ),
                                                      ),
                                                      focusedBorder: UnderlineInputBorder(
                                                        borderSide: BorderSide(color:Colors.transparent, ),
                                                      ),
                                                      hintStyle: TextStyle(
                                                        fontSize: 17,
                                                        color:Colors.grey[300],
                                                      ),
                                                      hintText: "Password"),
                                                ),
                                              ),
                                              Container(
                                                width:isShowErrorMsg?10:0,
                                                height:isShowErrorMsg?10:0,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Color(constant.Color.crave_orange)),)
                                            ],
                                          ),

                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(left:30,right:30,top:0,bottom:20),
                                        child:Divider(
                                          color: Colors.grey[400]
                                        ),
                                      ),

                                      SizedBox(
                                          width:50.w,
                                          height:6.h,
                                          child: ElevatedButton(
                                              child: Text(
                                                  "Login".toUpperCase(),
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 16.0.sp)
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
                                              onPressed: () => loginUser()
                                          )
                                      ),
                                      GestureDetector(
                                        onTap: goToForgotPass,
                                        child:Container(
                                          decoration: BoxDecoration(
                                            border:Border(
                                              bottom: BorderSide(
                                                color:Color(constant.Color.crave_brown),
                                              )
                                            )
                                          ),
                                          //width: double.maxFinite,
                                          padding: const EdgeInsets.only(bottom:1,top:20),
                                          child:Text("FORGOT YOUR PASSWORD?",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  // decoration: TextDecoration.underline,
                                                  fontWeight: FontWeight.w700,
                                                  color: Color(constant.Color.crave_brown),
                                                  fontSize: 12.0.sp)),
                                        ),
                                      ),

                                      SizedBox(
                                        height:8.0.h
                                      ),
                                      Container(
                                        width: double.maxFinite,
                                        padding: const EdgeInsets.only(top:10),
                                        child:Text("Not a member?",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                // fontWeight: FontWeight.w600,
                                                color: Colors.grey,
                                                fontSize: 15.0.sp)),
                                      ),
                                      // Container(
                                      //   width: double.maxFinite,
                                      //   padding: const EdgeInsets.only(top:20),
                                      //   child:Row(
                                      //     mainAxisAlignment: MainAxisAlignment.center,
                                      //     crossAxisAlignment: CrossAxisAlignment.center,
                                      //     mainAxisSize: MainAxisSize.max,
                                      //     children: [
                                      //       Image.asset('images/logo_google.png',height:5.0.h),
                                      //       const SizedBox(width: 30),
                                      //       Image.asset('images/logo_facebook.png',height:5.0.h),
                                      //       const SizedBox(width: 30),
                                      //       Image.asset('images/logo_apple.png',height:5.0.h),
                                      //     ],
                                      //   ),
                                      // ),
                                      GestureDetector(
                                        onTap:goToRegister,
                                        child:Container(
                                          decoration: BoxDecoration(
                                              border:Border(
                                                  bottom: BorderSide(
                                                    color:Color(constant.Color.crave_brown),
                                                  )
                                              )
                                          ),
                                          padding: const EdgeInsets.only(bottom:1,top:15),
                                          child:Text("SIGN UP NOW",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black,
                                                  fontSize: 12.0.sp)),
                                        ),
                                      ),
                                      SizedBox(
                                          height:10.0.h
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