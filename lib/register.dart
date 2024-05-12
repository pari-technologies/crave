// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:a_crave/verification.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'constants.dart' as constant;
import 'login.dart';


class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<Register> {

  final emailCtrl = TextEditingController();
  final usernameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final phoneCodeCtrl = TextEditingController();
  final phoneNoCtrl = TextEditingController();

  bool _visible = false;

  bool isEmailError = false;
  bool isPasswordError = false;
  bool isUsernameError = false;
  bool isPhoneError = false;
  bool isMissingErrorMsg = false;
  bool isExistErrorMsg = false;


  // String initialCountry = 'MY';
  // PhoneNumber number = PhoneNumber(isoCode: 'MY');

  // Future<void> setClearLogin() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString('userid', "");
  // }

  Future<http.Response> registerUser() async {
    setState(() {
      isEmailError = false;
      isPasswordError = false;
      isUsernameError = false;
      isPhoneError = false;
      isMissingErrorMsg = false;
    });

    if(emailCtrl.text.isEmpty || passwordCtrl.text.isEmpty || usernameCtrl.text.isEmpty || phoneNoCtrl.text.isEmpty){
      setState(() {
        isMissingErrorMsg = true;
        if(emailCtrl.text.isEmpty){
          isEmailError = true;
        }
        if(passwordCtrl.text.isEmpty){
          isPasswordError = true;
        }
        if(usernameCtrl.text.isEmpty){
          isUsernameError = true;
        }
        if(phoneNoCtrl.text.isEmpty){
          isPhoneError = true;
        }
      });
      // Navigator.of(context, rootNavigator: true).pop('dialog');
      // _showDialog("Please fill in your email and password");
    }
    else if(emailCtrl.text.isNotEmpty && passwordCtrl.text.isNotEmpty && usernameCtrl.text.isNotEmpty && phoneNoCtrl.text.isNotEmpty){
      showAlertDialog(context);
      var url = Uri.parse(constant.Url.crave_url+'register.php');
      final http.Response response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        },
        body: {
          "username":usernameCtrl.text,
          "password":passwordCtrl.text,
          "email":emailCtrl.text,
          "phone_code":phoneCodeCtrl.text,
          "phone_no":phoneNoCtrl.text
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
          setState(() {
            isExistErrorMsg = true;
          });
        }
        else{
          log("---check ic here---");
//          log(user['data']['token']);
          Navigator.of(context, rootNavigator: true).pop('dialog');
          setUserProfile(emailCtrl.text);
          goToVerification();
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

  languageBoxVisible(){
    setState(() {
      _visible = !_visible;
    });
  }


  void goToLogin() {
    // Navigator.of(context).pushReplacementNamed("/login");

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Login()));
  }

  void goToVerification() {
    // Navigator.of(context).pushReplacementNamed("/verification");
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Verification()));
  }


  void loadProfile() {
    setState(() {
      phoneCodeCtrl.text = "+60";
    });
  }

  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => loadProfile());

  }

  void _onCountryChange(CountryCode countryCode) {
    //TODO : manipulate the selected country code here
    print("New Country selected: " + countryCode.toString());
    setState(() {
      phoneCodeCtrl.text = countryCode.toString();
    });
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
                          // resizeToAvoidBottomInset: false,
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
                                            left: 30.0,bottom:10,top:0),
                                        child:Text("Sign Up!",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: Color(constant.Color.crave_brown),
                                                fontSize: 24.0.sp)),
                                      ),
                                      isMissingErrorMsg?
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.only(left: 30.0,bottom:20),
                                                child:Text("Oh no! The following fields are ",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        color: Color(constant.Color.crave_brown),
                                                        fontSize: 11.0.sp)),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(bottom:20),
                                                child:Text("missing ",
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
                                      Container(height:10),
                                      isExistErrorMsg?
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width:100.0.w,
                                            padding: const EdgeInsets.only(left: 30.0,bottom:00),
                                            child:Text("Sorry but this username has been taken. Don't worry,",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(constant.Color.crave_brown),
                                                    fontSize: 9.0.sp)),
                                          ),
                                          Container(
                                            width:100.0.w,
                                            padding: const EdgeInsets.only(left: 30.0,bottom:20),
                                            child:Text("this name will not be displayed to your friends.",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(constant.Color.crave_brown),
                                                    fontSize: 9.0.sp)),
                                          ),

                                        ],
                                      ):
                                      Container(height:10),
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
                                                height:50,
                                                // margin: const EdgeInsets.only(bottom: 10.0),
                                                padding: EdgeInsets.only(left: 30.0, right: 30.0),
                                                child:TextField(
                                                  autofocus: false,
                                                  controller: usernameCtrl,
                                                  cursorColor: Colors.black,
                                                  keyboardType: TextInputType.text,
                                                  textInputAction: TextInputAction.go,
                                                  textCapitalization: TextCapitalization.sentences,
                                                  decoration: InputDecoration(
                                                      counterText: '',
                                                      filled: false,
                                                      // Color(0xFFD6D6D6)
                                                      fillColor: Color(0xFFF2F2F2),
                                                      contentPadding:EdgeInsets.only(top:10,left:3),
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
                                                          color: Colors.grey[300]
                                                      ),
                                                      hintText: "Username"),
                                                ),
                                              ),
                                              Container(
                                                width:isUsernameError?10:0,
                                                height:isUsernameError?10:0,
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
                                          color: Colors.grey[400]
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
                                                          color:Colors.grey[300]
                                                      ),
                                                      hintText: "Password"),
                                                ),
                                              ),
                                              Container(
                                                width:isPasswordError?10:0,
                                                height:isPasswordError?10:0,
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
                                          color: Colors.grey[400]
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                                            child: Text("Phone Number",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    color: Color(constant.Color.crave_brown),
                                                    fontSize: 12.0.sp)),
                                          ),

                                          Row(
                                            children: [
                                              Container(
                                                width:25.0.w,
                                                height:45,
                                                margin: const EdgeInsets.only(bottom:0.0,top:10),
                                                padding: const EdgeInsets.only(left: 30.0),
                                                child:
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.only(
                                                      bottomRight: Radius.circular(15),
                                                      bottomLeft: Radius.circular(15),
                                                      topRight: Radius.circular(15),
                                                      topLeft: Radius.circular(15),
                                                    ),
                                                    border: Border.all(
                                                      width: 1,
                                                      color: Color(constant.Color.crave_grey),
                                                      style: BorderStyle.solid,
                                                    ),
                                                  ),
                                                  child: Stack(
                                                    children: [
                                                      Center(
                                                        child: Container(
                                                          height:50,
                                                        child:
                                                        Wrap(
                                                          children: [
                                                            CountryCodePicker(
                                                              padding: EdgeInsets.zero,
                                                              onChanged: _onCountryChange,
                                                              flagWidth: 45,
                                                              // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                                              initialSelection: 'MY',
                                                              favorite: ['+60','MY'],
                                                              // optional. Shows only country name and flag
                                                              showCountryOnly: false,
                                                              hideMainText: true,
                                                              // optional. Shows only country name and flag when popup is closed.
                                                              showOnlyCountryWhenClosed: true,
                                                              // optional. aligns the flag and the Text left
                                                              alignLeft: false,
                                                            ),
                                                          ],
                                                        ),

                                                      ),

                                                      ),

                                                      Align(
                                                        alignment: Alignment.centerRight,
                                                        child: Icon(
                                                          Icons.keyboard_arrow_down,
                                                          color: Colors.grey,
                                                          size: 25.0,
                                                        ),
                                                      ),

                                                    ],
                                                  ),


                                                ),

                                              ),
                                              Container(
                                                width:12.0.w,
                                                height:45,
                                                padding: const EdgeInsets.only(left: 10.0, top: 10.0),
                                                child:TextField(
                                                  readOnly: true,
                                                  autofocus: false,
                                                  controller: phoneCodeCtrl,
                                                  cursorColor: Colors.black,
                                                  keyboardType: TextInputType.text,
                                                  textInputAction: TextInputAction.go,
                                                  textCapitalization: TextCapitalization.sentences,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w700,
                                                      color:Colors.grey[400]
                                                    ),
                                                  decoration: InputDecoration(
                                                      counterText: '',
                                                      filled: false,
                                                      // Color(0xFFD6D6D6)
                                                      fillColor: Color(0xFFF2F2F2),
                                                      contentPadding:EdgeInsets.symmetric(horizontal: 0,vertical:10),
                                                      labelStyle: TextStyle(
                                                          fontSize: 14,
                                                          color:Colors.green
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
                                                      hintText: "Phone Code"),
                                                ),
                                              ),
                                              Container(
                                                width:53.0.w,
                                                height:45,
                                                padding: const EdgeInsets.only(left: 0.0, right: 30.0,top: 10.0),
                                                child:TextField(
                                                  autofocus: false,
                                                  controller: phoneNoCtrl,
                                                  cursorColor: Colors.black,
                                                  keyboardType: TextInputType.text,
                                                  textInputAction: TextInputAction.go,
                                                  textCapitalization: TextCapitalization.sentences,
                                                  decoration: InputDecoration(
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
                                                        color: Colors.grey[300]
                                                      ),
                                                      hintText: "Phone Number"),
                                                ),
                                              ),
                                              Container(
                                                width:isPhoneError?10:0,
                                                height:isPhoneError?10:0,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Color(constant.Color.crave_orange)),)
                                            ],
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(left:30,right:30,top:5,bottom:10),
                                        child:Divider(
                                          color: Colors.grey[400]
                                        ),
                                      ),

                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                                            child: Text("Email",
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
                                                  controller: emailCtrl,
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
                                                      hintText: "Email"),
                                                ),
                                              ),
                                              Container(
                                                width:isEmailError?10:0,
                                                height:isEmailError?10:0,
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
                                          width:55.w,
                                          height:6.h,
                                          child: ElevatedButton(
                                              child: Text(
                                                  "Register".toUpperCase(),
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 14.0.sp)
                                              ),
                                              style: ButtonStyle(
                                                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                                  backgroundColor: MaterialStateProperty.all<Color>(const Color(constant.Color.crave_blue)),
                                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10.0),
                                                          side: const BorderSide(color: Color(constant.Color.crave_blue))
                                                      )
                                                  )
                                              ),
                                              onPressed: () => registerUser()
                                          )
                                      ),

                                      SizedBox(
                                        height:3.0.h
                                      ),
                                      Container(
                                        width: double.maxFinite,
                                        padding: const EdgeInsets.only(top:10),
                                        child:Text("Sign up with:",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey,
                                                fontSize: 14.0.sp)),
                                      ),
                                      // Container(
                                      //   width: double.maxFinite,
                                      //   padding: const EdgeInsets.only(top:10),
                                      //   child:Row(
                                      //     mainAxisAlignment: MainAxisAlignment.center,
                                      //     crossAxisAlignment: CrossAxisAlignment.center,
                                      //     mainAxisSize: MainAxisSize.max,
                                      //     children: [
                                      //
                                      //       Image.asset('images/logo_google.png',height:5.0.h),
                                      //       const SizedBox(width: 30),
                                      //       Image.asset('images/logo_facebook.png',height:5.0.h),
                                      //       const SizedBox(width: 30),
                                      //       Image.asset('images/logo_apple.png',height:5.0.h),
                                      //     ],
                                      //   ),
                                      // ),
                                      GestureDetector(
                                        onTap: goToLogin,
                                        child:Container(
                                          decoration: BoxDecoration(
                                              border:Border(
                                                  bottom: BorderSide(
                                                    color:Color(constant.Color.crave_brown),
                                                  )
                                              )
                                          ),
                                          padding: const EdgeInsets.only(bottom:1,top:15),
                                          child:Text("ALREADY A MEMBER?",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  // decoration: TextDecoration.underline,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black,
                                                  fontSize: 12.0.sp)),
                                        ),
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