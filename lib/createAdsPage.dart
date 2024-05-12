// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';

import 'package:sizer/sizer.dart';
import 'constants.dart' as constant;

class CreateAdsPage extends StatefulWidget {
  const CreateAdsPage({Key? key}) : super(key: key);

  @override
  CreateAdsPageState createState() => CreateAdsPageState();
}

class CreateAdsPageState extends State<CreateAdsPage> {

  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final itemNameCtrl = TextEditingController();
  final startDateCtrl = TextEditingController();
  final startMonthCtrl = TextEditingController();
  final endDateCtrl = TextEditingController();
  final endMonthCtrl = TextEditingController();
  bool isChecked1 = false;
  bool isChecked2 = false;
  bool isChecked3 = false;
  bool isChecked4 = false;

  String selectedStartDate = "";
  String selectedStartMonth = "";
  String selectedEndDate = "";
  String selectedEndMonth = "";

  List <Widget> months = [
    Text("January"),
    Text("February"),
    Text("March"),
    Text("April"),
    Text("May"),
    Text("June"),
    Text("July"),
    Text("August"),
    Text("September"),
    Text("October"),
    Text("November"),
    Text("December"),
  ];

  List <Widget> days = [
    Text("01"),
    Text("02"),
    Text("03"),
    Text("04"),
    Text("05"),
    Text("06"),
    Text("07"),
    Text("08"),
    Text("09"),
    Text("10"),
    Text("11"),
    Text("12"),
    Text("13"),
    Text("14"),
    Text("15"),
    Text("16"),
    Text("17"),
    Text("18"),
    Text("19"),
    Text("20"),
    Text("21"),
    Text("22"),
    Text("23"),
    Text("24"),
    Text("25"),
    Text("26"),
    Text("27"),
    Text("28"),
    Text("29"),
    Text("30"),
    Text("31"),
  ];

  var cuisine1 = [
    {'name': 'C', 'isSelected': false},
    {'name': 'Cajun', 'isSelected': false},
    {'name': 'Chinese', 'isSelected': false},
    {'name': 'F', 'isSelected': false},
    {'name': 'French', 'isSelected': false},
    {'name': 'G', 'isSelected': false},
    {'name': 'Greek', 'isSelected': false},
    {'name': 'I', 'isSelected': false},
    {'name': 'Indian', 'isSelected': false},
    {'name': 'Italian', 'isSelected': false},
    {'name': 'J', 'isSelected': false},
    {'name': 'Japanese', 'isSelected': false},
    {'name': 'L', 'isSelected': false},
    {'name': 'Lebanese', 'isSelected': false},];

  var cuisine2 = [
    {'name': 'M', 'isSelected': false},
    {'name': 'Mediterranean', 'isSelected': false},
    {'name': 'Mexican', 'isSelected': false},
    {'name': 'Moroccan', 'isSelected': false},
    {'name': 'S', 'isSelected': false},
    {'name': 'Spanish', 'isSelected': false},
    {'name': 'T', 'isSelected': false},
    {'name': 'Thai', 'isSelected': false},
    {'name': 'Turkish', 'isSelected': false},
    {'name': 'W', 'isSelected': false},
    {'name': 'Western', 'isSelected': false}];


  var taste1 = [
    {'name': 'Salty', 'isSelected': false},
    {'name': 'Spicy', 'isSelected': false},
    {'name': 'Sweet', 'isSelected': false},
  ];

  var taste2 = [
    {'name': 'Umami', 'isSelected': false},
    {'name': 'Sour', 'isSelected': false},
  ];


  var diet1 = [
    {'name': 'BEEF-FREE', 'isSelected': false},
    {'name': 'HALAL', 'isSelected': false},
    {'name': 'VEGAN', 'isSelected': false},
  ];

  var diet2 = [
    {'name': 'VEGETARIAN', 'isSelected': false},
    {'name': 'Pescatarian', 'isSelected': false},
  ];


  void goToHomepage() {
    setState(() {
      Navigator.of(context).pushReplacementNamed("/homepage");
    });
  }

  void goToForgotPass() {
    setState(() {
      Navigator.of(context).pushNamed("/forgotPassword");
    });
  }


  void initState() {
    super.initState();
    // WidgetsBinding.instance!.addPostFrameCallback((_) => loadProfile());

  }

  void showStartDayPicker() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          return Container(
              height: MediaQuery
                  .of(context)
                  .copyWith()
                  .size
                  .height * 0.25,
              color: Colors.white,
              child: CupertinoPicker(
                children: days,
                onSelectedItemChanged: (value) {
                  print(days[value]);
                  Text text = days[value] as Text;
                  selectedStartDate = text.data.toString();
                  setState(() {
                    startDateCtrl.text = selectedStartDate;
                  });
                },
                itemExtent: 25,
                diameterRatio: 1,
                useMagnifier: true,
                magnification: 1.3,
                looping: true,
              )
          );
        }
    );
  }

  void showEndDayPicker() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          return Container(
              height: MediaQuery
                  .of(context)
                  .copyWith()
                  .size
                  .height * 0.25,
              color: Colors.white,
              child: CupertinoPicker(
                children: days,
                onSelectedItemChanged: (value) {
                  print(days[value]);
                  Text text = days[value] as Text;
                  selectedEndDate = text.data.toString();
                  setState(() {
                    endDateCtrl.text = selectedEndDate;
                  });
                },
                itemExtent: 25,
                diameterRatio: 1,
                useMagnifier: true,
                magnification: 1.3,
                looping: true,
              )
          );
        }
    );
  }

  void showStartMonthPicker() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          return Container(
              height: MediaQuery
                  .of(context)
                  .copyWith()
                  .size
                  .height * 0.25,
              color: Colors.white,
              child: CupertinoPicker(
                children: months,
                onSelectedItemChanged: (value) {
                  print(months[value]);
                  Text text = months[value] as Text;
                  selectedStartMonth = text.data.toString();
                  setState(() {
                    if(selectedStartMonth == "January"){
                      startMonthCtrl.text = "Jan";
                    }
                    else if(selectedStartMonth == "February"){
                      startMonthCtrl.text = "Feb";
                    }
                    else if(selectedStartMonth == "March"){
                      startMonthCtrl.text = "Mar";
                    }
                    else if(selectedStartMonth == "April"){
                      startMonthCtrl.text = "Apr";
                    }
                    else if(selectedStartMonth == "May"){
                      startMonthCtrl.text = "May";
                    }
                    else if(selectedStartMonth == "June"){
                      startMonthCtrl.text = "Jun";
                    }
                    else if(selectedStartMonth == "July"){
                      startMonthCtrl.text = "Jul";
                    }
                    else if(selectedStartMonth == "August"){
                      startMonthCtrl.text = "Aug";
                    }
                    else if(selectedStartMonth == "September"){
                      startMonthCtrl.text = "Sep";
                    }
                    else if(selectedStartMonth == "October"){
                      startMonthCtrl.text = "Oct";
                    }
                    else if(selectedStartMonth == "November"){
                      startMonthCtrl.text = "Nov";
                    }
                    else if(selectedStartMonth == "December"){
                      startMonthCtrl.text = "Dec";
                    }

                  });
                },
                itemExtent: 25,
                diameterRatio: 1,
                useMagnifier: true,
                magnification: 1.3,
                looping: true,
              )
          );
        }
    );
  }

  void showEndMonthPicker() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          return Container(
              height: MediaQuery
                  .of(context)
                  .copyWith()
                  .size
                  .height * 0.25,
              color: Colors.white,
              child: CupertinoPicker(
                children: months,
                onSelectedItemChanged: (value) {
                  print(months[value]);
                  Text text = months[value] as Text;
                  selectedEndMonth = text.data.toString();
                  setState(() {
                    if(selectedEndMonth == "January"){
                      endMonthCtrl.text = "Jan";
                    }
                    else if(selectedEndMonth == "February"){
                      endMonthCtrl.text = "Feb";
                    }
                    else if(selectedEndMonth == "March"){
                      endMonthCtrl.text = "Mar";
                    }
                    else if(selectedEndMonth == "April"){
                      endMonthCtrl.text = "Apr";
                    }
                    else if(selectedEndMonth == "May"){
                      endMonthCtrl.text = "May";
                    }
                    else if(selectedEndMonth == "June"){
                      endMonthCtrl.text = "Jun";
                    }
                    else if(selectedEndMonth == "July"){
                      endMonthCtrl.text = "Jul";
                    }
                    else if(selectedEndMonth == "August"){
                      endMonthCtrl.text = "Aug";
                    }
                    else if(selectedEndMonth == "September"){
                      endMonthCtrl.text = "Sep";
                    }
                    else if(selectedEndMonth == "October"){
                      endMonthCtrl.text = "Oct";
                    }
                    else if(selectedEndMonth == "November"){
                      endMonthCtrl.text = "Nov";
                    }
                    else if(selectedEndMonth == "December"){
                      endMonthCtrl.text = "Dec";
                    }

                  });
                },
                itemExtent: 25,
                diameterRatio: 1,
                useMagnifier: true,
                magnification: 1.3,
                looping: true,
              )
          );
        }
    );
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
                            child: Stack(
                              children: <Widget>[
                                SafeArea(
                                  child:Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width: double.maxFinite,
                                        padding: const EdgeInsets.only(
                                            left: 30.0),
                                        child:Text("Create Ad",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black,
                                                fontSize: 14.0.sp)),
                                      ),
                                      Container(
                                          margin:const EdgeInsets.only(right:5,top:20),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(10))
                                          ),
                                          width: 60.0.w,
                                          height: 20.0.h,
                                          child:DottedBorder(
                                            borderType: BorderType.RRect,
                                            dashPattern: [5],
                                            radius: Radius.circular(10),
                                            color: Colors.black,
                                            strokeWidth: 1,
                                            child: Center(
                                              child:Image.asset(
                                                'images/add_team_member_icon.png',
                                                height: 6.0.h,
                                              ),
                                            ),
                                          )
                                      ),



                                      Container(
                                        padding: EdgeInsets.only(left: 30.0, right: 30.0, top:20),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Ad Campaign Name",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    color: Color(constant.Color.crave_orange),
                                                    fontSize: 11.0.sp)),
                                            Container(
                                              //width:250,
                                              height:50,
                                              margin: const EdgeInsets.only(bottom: 10.0,top:5),

                                              child:TextField(
                                                autofocus: false,
                                                controller: itemNameCtrl,
                                                cursorColor: Colors.black,
                                                keyboardType: TextInputType.text,
                                                textInputAction: TextInputAction.go,
                                                textCapitalization: TextCapitalization.sentences,
                                                decoration: const InputDecoration(
                                                    counterText: '',
                                                    filled: true,
                                                    // Color(0xFFD6D6D6)
                                                    fillColor: Color(0xFFF2F2F2),
                                                    contentPadding:EdgeInsets.symmetric(horizontal: 15,vertical:10),
                                                    labelStyle: TextStyle(
                                                        fontSize: 14,
                                                        color:Colors.black
                                                    ),
                                                    enabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color:Color(0xFFF2F2F2) ),
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderSide: BorderSide(color:Color(0xFFF2F2F2) ),
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color:Color(0xFFF2F2F2), ),
                                                    ),
                                                    hintText: "Ad Campaign Name"),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      Container(
                                        padding: EdgeInsets.only(left: 30.0, right: 30.0, top:5),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Duration",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    color: Color(constant.Color.crave_orange),
                                                    fontSize: 11.0.sp)),
                                            Row(
                                              children:[
                                                GestureDetector(
                                                  onTap:showStartDayPicker,
                                                  child:Container(
                                                    width:60,
                                                    height:40,
                                                    margin: const EdgeInsets.only(bottom: 20.0,top:5),
                                                    child:TextField(
                                                      // enableInteractiveSelection: false,
                                                      // focusNode: FocusNode(),
                                                      enabled:false,
                                                      autofocus: false,
                                                      controller: startDateCtrl,
                                                      cursorColor: Colors.black,
                                                      keyboardType: TextInputType.text,
                                                      textInputAction: TextInputAction.go,
                                                      textCapitalization: TextCapitalization.sentences,
                                                      decoration: const InputDecoration(
                                                          counterText: '',
                                                          filled: true,
                                                          // Color(0xFFD6D6D6)
                                                          fillColor: Color(0xFFF2F2F2),
                                                          contentPadding:EdgeInsets.symmetric(horizontal: 15,vertical:10),
                                                          labelStyle: TextStyle(
                                                            fontSize: 10,
                                                            color:Colors.black,
                                                          ),
                                                          enabledBorder: OutlineInputBorder(
                                                            borderSide: BorderSide(color:Color(0xFFF2F2F2) ),
                                                          ),
                                                          border: OutlineInputBorder(
                                                            borderSide: BorderSide(color:Color(0xFFF2F2F2) ),
                                                          ),
                                                          focusedBorder: OutlineInputBorder(
                                                            borderSide: BorderSide(color:Color(0xFFF2F2F2), ),
                                                          ),
                                                          hintStyle: TextStyle(
                                                            fontSize: 12,
                                                          ),
                                                          hintText: "DD"),
                                                    ),
                                                  ),
                                                ),

                                                GestureDetector(
                                                  onTap:showStartMonthPicker,
                                                  child: Container(
                                                    padding: EdgeInsets.only(left: 10.0),
                                                    width:80,
                                                    height:40,
                                                    margin: const EdgeInsets.only(bottom: 20.0,top:5),
                                                    child:TextField(
                                                      // enableInteractiveSelection: false,
                                                      // focusNode: FocusNode(),
                                                      enabled:false,
                                                      autofocus: false,
                                                      controller: startMonthCtrl,
                                                      cursorColor: Colors.black,
                                                      keyboardType: TextInputType.text,
                                                      textInputAction: TextInputAction.go,
                                                      textCapitalization: TextCapitalization.sentences,
                                                      decoration: const InputDecoration(
                                                          counterText: '',
                                                          filled: true,
                                                          // Color(0xFFD6D6D6)
                                                          fillColor: Color(0xFFF2F2F2),
                                                          contentPadding:EdgeInsets.symmetric(horizontal: 15,vertical:10),
                                                          labelStyle: TextStyle(
                                                            fontSize: 10,
                                                            color:Colors.black,
                                                          ),
                                                          enabledBorder: OutlineInputBorder(
                                                            borderSide: BorderSide(color:Color(0xFFF2F2F2) ),
                                                          ),
                                                          border: OutlineInputBorder(
                                                            borderSide: BorderSide(color:Color(0xFFF2F2F2) ),
                                                          ),
                                                          focusedBorder: OutlineInputBorder(
                                                            borderSide: BorderSide(color:Color(0xFFF2F2F2), ),
                                                          ),
                                                          hintStyle: TextStyle(
                                                            fontSize: 12,
                                                          ),
                                                          hintText: "MMM"),
                                                    ),
                                                  ),
                                                ),


                                                Container(
                                                  height:10,
                                                  width:30,
                                                  padding: EdgeInsets.only(left:10,right:10,bottom:10),
                                                  child:Divider(
                                                      color:Colors.black
                                                  ),
                                                ),

                                                GestureDetector(
                                                  onTap:showEndDayPicker,
                                                  child: Container(
                                                    width:60,
                                                    height:40,
                                                    margin: const EdgeInsets.only(bottom: 20.0,top:5),
                                                    child:TextField(
                                                      // enableInteractiveSelection: false,
                                                      // focusNode: FocusNode(),
                                                      enabled:false,
                                                      autofocus: false,
                                                      controller: endDateCtrl,
                                                      cursorColor: Colors.black,
                                                      keyboardType: TextInputType.text,
                                                      textInputAction: TextInputAction.go,
                                                      textCapitalization: TextCapitalization.sentences,
                                                      decoration: const InputDecoration(
                                                          counterText: '',
                                                          filled: true,
                                                          // Color(0xFFD6D6D6)
                                                          fillColor: Color(0xFFF2F2F2),
                                                          contentPadding:EdgeInsets.symmetric(horizontal: 15,vertical:10),
                                                          labelStyle: TextStyle(
                                                            fontSize: 10,
                                                            color:Colors.black,
                                                          ),
                                                          enabledBorder: OutlineInputBorder(
                                                            borderSide: BorderSide(color:Color(0xFFF2F2F2) ),
                                                          ),
                                                          border: OutlineInputBorder(
                                                            borderSide: BorderSide(color:Color(0xFFF2F2F2) ),
                                                          ),
                                                          focusedBorder: OutlineInputBorder(
                                                            borderSide: BorderSide(color:Color(0xFFF2F2F2), ),
                                                          ),
                                                          hintStyle: TextStyle(
                                                            fontSize: 12,
                                                          ),
                                                          hintText: "DD"),
                                                    ),
                                                  ),
                                                ),

                                                GestureDetector(
                                                  onTap:showEndMonthPicker,
                                                  child:Container(
                                                    padding: EdgeInsets.only(left: 10.0),
                                                    width:80,
                                                    height:40,
                                                    margin: const EdgeInsets.only(bottom: 20.0,top:5),
                                                    child:TextField(
                                                      // enableInteractiveSelection: false,
                                                      // focusNode: FocusNode(),
                                                      enabled:false,
                                                      autofocus: false,
                                                      controller: endMonthCtrl,
                                                      cursorColor: Colors.black,
                                                      keyboardType: TextInputType.text,
                                                      textInputAction: TextInputAction.go,
                                                      textCapitalization: TextCapitalization.sentences,
                                                      decoration: const InputDecoration(
                                                          counterText: '',
                                                          filled: true,
                                                          // Color(0xFFD6D6D6)
                                                          fillColor: Color(0xFFF2F2F2),
                                                          contentPadding:EdgeInsets.symmetric(horizontal: 15,vertical:10),
                                                          labelStyle: TextStyle(
                                                            fontSize: 10,
                                                            color:Colors.black,
                                                          ),
                                                          enabledBorder: OutlineInputBorder(
                                                            borderSide: BorderSide(color:Color(0xFFF2F2F2) ),
                                                          ),
                                                          border: OutlineInputBorder(
                                                            borderSide: BorderSide(color:Color(0xFFF2F2F2) ),
                                                          ),
                                                          focusedBorder: OutlineInputBorder(
                                                            borderSide: BorderSide(color:Color(0xFFF2F2F2), ),
                                                          ),
                                                          hintStyle: TextStyle(
                                                            fontSize: 12,
                                                          ),
                                                          hintText: "MMM"),
                                                    ),
                                                  ),
                                                ),

                                              ]
                                            ),

                                          ],
                                        ),
                                      ),

                                      Container(
                                        padding: EdgeInsets.only(left:20,right:20),
                                        child:Divider(
                                          color:Colors.grey
                                        ),
                                      ),

                                      Container(
                                        padding: EdgeInsets.only(left: 30.0, right: 30.0, top:5),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Demographic",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    color: Color(constant.Color.crave_orange),
                                                    fontSize: 11.0.sp)),
                                            Padding(
                                              padding: EdgeInsets.only(top:10),
                                              child: Text("GENDER",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      decoration: TextDecoration.underline,
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.black,
                                                      fontSize: 11.0.sp)),
                                            ),

                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width:30,
                                                  child: Checkbox(
                                                    checkColor: Colors.white,
                                                    //fillColor: MaterialStateProperty.all(Color(0xFF2CBFC6)),
                                                    activeColor: Color(constant.Color.crave_blue),
                                                    value: isChecked1,
                                                    shape: CircleBorder(
                                                    ),
                                                    onChanged: (bool? value) {
                                                      setState(() {
                                                        isChecked1 = value!;
                                                      });
                                                    },
                                                  ),
                                                ),

                                                Padding(
                                                  padding: EdgeInsets.only(right:10),
                                                  child: Text("Male",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                          color: Colors.black,
                                                          fontSize: 11.0.sp)),
                                                ),

                                                SizedBox(
                                                  width:30,
                                                  child: Checkbox(
                                                    checkColor: Colors.white,
                                                    //fillColor: MaterialStateProperty.all(Color(0xFF2CBFC6)),
                                                    activeColor: Color(constant.Color.crave_blue),
                                                    value: isChecked2,
                                                    shape: CircleBorder(
                                                    ),
                                                    onChanged: (bool? value) {
                                                      setState(() {
                                                        isChecked2 = value!;
                                                      });
                                                    },
                                                  ),
                                                ),

                                                Padding(
                                                  padding: EdgeInsets.only(right:10),
                                                  child: Text("Female",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                          color: Colors.black,
                                                          fontSize: 11.0.sp)),
                                                ),

                                                SizedBox(
                                                  width:30,
                                                  child: Checkbox(
                                                    checkColor: Colors.white,
                                                    //fillColor: MaterialStateProperty.all(Color(0xFF2CBFC6)),
                                                    activeColor: Color(constant.Color.crave_blue),
                                                    value: isChecked3,
                                                    shape: CircleBorder(
                                                    ),
                                                    onChanged: (bool? value) {
                                                      setState(() {
                                                        isChecked3 = value!;
                                                      });
                                                    },
                                                  ),
                                                ),

                                                Padding(
                                                  padding: EdgeInsets.only(right:10),
                                                  child: Text("Others",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                          color: Colors.black,
                                                          fontSize: 11.0.sp)),
                                                ),
                                              ],
                                            ),


                                          ],
                                        ),
                                      ),

                                      Container(
                                        padding: EdgeInsets.only(left:20,right:20),
                                        child:Divider(
                                            color:Colors.grey
                                        ),
                                      ),


                                      //Cuisine
                                      Container(
                                        width: double.maxFinite,
                                        padding: const EdgeInsets.only(
                                            left: 30.0,right:30.0,top:15,bottom:10),
                                        child:Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Cuisine",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(constant.Color.crave_orange),
                                                    fontSize: 11.0.sp)),
                                            Row(
                                              children: [
                                                Text("Please select",
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.black,
                                                        fontSize: 11.0.sp)),
                                                Text(" at least",
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        color: Color(constant.Color.crave_orange),
                                                        fontSize: 11.0.sp)),
                                                Text(" 3.",
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.black,
                                                        fontSize: 11.0.sp)),
                                              ],
                                            ),

                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 25.0,right:25.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xFFF2F2F2),
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              topLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                            ),

                                          ),

                                          // margin: const EdgeInsets.only(
                                          //     top: 10.0),
                                          padding: const EdgeInsets.only(
                                              left: 10.0,right:10.0,top:10),
                                          //height:70.0.h,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Expanded(
                                                child:
                                                ListView.builder(
                                                  padding:  EdgeInsets.only(right:0.0),
                                                  shrinkWrap: true,
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  itemCount: cuisine1.length,
                                                  itemBuilder: (BuildContext ctx, index) {
                                                    return
                                                      cuisine1[index]['name'].toString().length != 1?
                                                      Container(
                                                          decoration: BoxDecoration(
                                                            color: cuisine1[index]['isSelected'] == true
                                                                ? Color(constant.Color.crave_orange)
                                                                : Color(0xFFF2F2F2),
                                                            borderRadius: BorderRadius.only(
                                                              topRight: Radius.circular(10),
                                                              topLeft: Radius.circular(10),
                                                              bottomRight: Radius.circular(10),
                                                              bottomLeft: Radius.circular(10),
                                                            ),

                                                          ),
                                                          margin:  EdgeInsets.only(bottom:5.0),

                                                          child: ListTile(
                                                            dense: true,
                                                            contentPadding: EdgeInsets.only(
                                                                left: 5.0,right:5.0),
                                                            visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                                                            onTap: () {
                                                              // if this item isn't selected yet, "isSelected": false -> true
                                                              // If this item already is selected: "isSelected": true -> false
                                                              setState(() {
                                                                if(cuisine1[index]['isSelected'] == true){
                                                                  cuisine1[index]['isSelected'] = false;
                                                                }
                                                                else{
                                                                  cuisine1[index]['isSelected'] = true;
                                                                }

                                                              });
                                                            },
                                                            title:
                                                            Text(
                                                                cuisine1[index]['name'].toString().toUpperCase(),
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.w600,
                                                                  color: cuisine1[index]['isSelected'] == true
                                                                      ? Colors.white
                                                                      : Colors.black,)
                                                            ),

                                                          )):
                                                      index==0?
                                                      Container(
                                                        child:Text(
                                                            cuisine1[index]['name'].toString().toUpperCase(),
                                                            style: TextStyle(
                                                                color: Color(constant.Color.crave_orange),
                                                                fontWeight: FontWeight.w700,
                                                                fontSize: 14.0.sp)
                                                        ),
                                                      ):
                                                      Container(
                                                        margin: const EdgeInsets.only(
                                                            top: 10.0),
                                                        child:Text(
                                                            cuisine1[index]['name'].toString().toUpperCase(),
                                                            style: TextStyle(
                                                                color: Color(constant.Color.crave_orange),
                                                                fontWeight: FontWeight.w700,
                                                                fontSize: 14.0.sp)
                                                        ),
                                                      );
                                                  },
                                                ),
                                              ),

                                              Container(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0,bottom:10,right:5),
                                                child: VerticalDivider(
                                                  color: Color(0xFFE0E0E0),thickness: 1,),
                                                height: 57.0.h,),

                                              Expanded(
                                                child:  ListView.builder(
                                                  padding:  EdgeInsets.only(right:0.0),
                                                  shrinkWrap: true,
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  itemCount: cuisine2.length,
                                                  itemBuilder: (BuildContext ctx, index) {
                                                    return
                                                      cuisine2[index]['name'].toString().length != 1?
                                                      Container(
                                                          decoration: BoxDecoration(
                                                            color: cuisine2[index]['isSelected'] == true
                                                                ? Color(constant.Color.crave_blue)
                                                                : Color(0xFFF2F2F2),
                                                            borderRadius: BorderRadius.only(
                                                              topRight: Radius.circular(10),
                                                              topLeft: Radius.circular(10),
                                                              bottomRight: Radius.circular(10),
                                                              bottomLeft: Radius.circular(10),
                                                            ),

                                                          ),
                                                          margin:  EdgeInsets.only(bottom:5.0),

                                                          child: ListTile(
                                                            dense: true,
                                                            contentPadding: EdgeInsets.only(
                                                                left: 5.0,right:5.0),
                                                            visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                                                            onTap: () {
                                                              // if this item isn't selected yet, "isSelected": false -> true
                                                              // If this item already is selected: "isSelected": true -> false
                                                              setState(() {
                                                                if(cuisine2[index]['isSelected'] == true){
                                                                  cuisine2[index]['isSelected'] = false;
                                                                }
                                                                else{
                                                                  cuisine2[index]['isSelected'] = true;
                                                                }

                                                              });
                                                            },
                                                            title:
                                                            Text(
                                                                cuisine2[index]['name'].toString().toUpperCase(),
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.w600,
                                                                  color: cuisine2[index]['isSelected'] == true
                                                                      ? Colors.white
                                                                      : Colors.black,)
                                                            ),

                                                          )):
                                                      index==0?
                                                      Container(
                                                        child:Text(
                                                            cuisine2[index]['name'].toString().toUpperCase(),
                                                            style: TextStyle(
                                                                color: Color(constant.Color.crave_orange),
                                                                fontWeight: FontWeight.w700,
                                                                fontSize: 14.0.sp)
                                                        ),
                                                      ):
                                                      Container(
                                                        margin: const EdgeInsets.only(
                                                            top: 10.0),
                                                        child:Text(
                                                            cuisine2[index]['name'].toString().toUpperCase(),
                                                            style: TextStyle(
                                                                color: Color(constant.Color.crave_orange),
                                                                fontWeight: FontWeight.w700,
                                                                fontSize: 14.0.sp)
                                                        ),
                                                      );
                                                  },
                                                ),
                                              ),


                                            ],
                                          ),



                                        ),
                                      ),

                                      //Taste
                                      Container(
                                        width: double.maxFinite,
                                        padding: const EdgeInsets.only(
                                            left: 30.0,right:30.0,top:30,bottom:10),
                                        child:Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Taste",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(constant.Color.crave_orange),
                                                    fontSize: 11.0.sp)),
                                            Row(
                                              children: [
                                                Text("Please select",
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.black,
                                                        fontSize: 11.0.sp)),
                                                Text(" at least",
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        color: Color(constant.Color.crave_orange),
                                                        fontSize: 11.0.sp)),
                                                Text(" 1",
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.black,
                                                        fontSize: 11.0.sp)),
                                              ],
                                            ),

                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 25.0,right:25.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xFFF2F2F2),
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              topLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                            ),

                                          ),

                                          // margin: const EdgeInsets.only(
                                          //     top: 10.0),
                                          padding: const EdgeInsets.only(
                                              left: 10.0,right:10.0,top:10),
                                          //height:70.0.h,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Expanded(
                                                child:
                                                ListView.builder(
                                                  padding:  EdgeInsets.only(right:10.0),
                                                  shrinkWrap: true,
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  itemCount: taste1.length,
                                                  itemBuilder: (BuildContext ctx, index) {
                                                    return
                                                      taste1[index]['name'].toString().length != 1?
                                                      Container(
                                                          decoration: BoxDecoration(
                                                            color: taste1[index]['isSelected'] == true
                                                                ? Color(constant.Color.crave_blue)
                                                                : Color(0xFFF2F2F2),
                                                            borderRadius: BorderRadius.only(
                                                              topRight: Radius.circular(10),
                                                              topLeft: Radius.circular(10),
                                                              bottomRight: Radius.circular(10),
                                                              bottomLeft: Radius.circular(10),
                                                            ),

                                                          ),
                                                          margin:  EdgeInsets.only(bottom:5.0),

                                                          child: ListTile(
                                                            dense: true,
                                                            contentPadding: EdgeInsets.only(
                                                                left: 5.0,right:5.0),
                                                            visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                                                            onTap: () {
                                                              // if this item isn't selected yet, "isSelected": false -> true
                                                              // If this item already is selected: "isSelected": true -> false
                                                              setState(() {
                                                                if(taste1[index]['isSelected'] == true){
                                                                  taste1[index]['isSelected'] = false;
                                                                }
                                                                else{
                                                                  taste1[index]['isSelected'] = true;
                                                                }

                                                              });
                                                            },
                                                            title:
                                                            Text(
                                                                taste1[index]['name'].toString().toUpperCase(),
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.w600,
                                                                  color: taste1[index]['isSelected'] == true
                                                                      ? Colors.white
                                                                      : Colors.black,)
                                                            ),

                                                          )):
                                                      index==0?
                                                      Container(
                                                        child:Text(
                                                            taste1[index]['name'].toString().toUpperCase(),
                                                            style: TextStyle(
                                                                color: Color(constant.Color.crave_orange),
                                                                fontWeight: FontWeight.w700,
                                                                fontSize: 14.0.sp)
                                                        ),
                                                      ):
                                                      Container(
                                                        margin: const EdgeInsets.only(
                                                            top: 10.0),
                                                        child:Text(
                                                            taste1[index]['name'].toString().toUpperCase(),
                                                            style: TextStyle(
                                                                color: Color(constant.Color.crave_orange),
                                                                fontWeight: FontWeight.w700,
                                                                fontSize: 14.0.sp)
                                                        ),
                                                      );
                                                  },
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0,bottom:10,right:10),
                                                child: VerticalDivider(
                                                  color: Color(0xFFE0E0E0),thickness: 1,),
                                                height: 15.0.h,),

                                              Expanded(
                                                child:  ListView.builder(
                                                  padding:  EdgeInsets.only(right:10.0),
                                                  shrinkWrap: true,
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  itemCount: taste2.length,
                                                  itemBuilder: (BuildContext ctx, index) {
                                                    return
                                                      taste2[index]['name'].toString().length != 1?
                                                      Container(
                                                          decoration: BoxDecoration(
                                                            color: taste2[index]['isSelected'] == true
                                                                ? Color(constant.Color.crave_blue)
                                                                : Color(0xFFF2F2F2),
                                                            borderRadius: BorderRadius.only(
                                                              topRight: Radius.circular(10),
                                                              topLeft: Radius.circular(10),
                                                              bottomRight: Radius.circular(10),
                                                              bottomLeft: Radius.circular(10),
                                                            ),

                                                          ),
                                                          margin:  EdgeInsets.only(bottom:5.0),

                                                          child: ListTile(
                                                            dense: true,
                                                            contentPadding: EdgeInsets.only(
                                                                left: 5.0,right:5.0),
                                                            visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                                                            onTap: () {
                                                              // if this item isn't selected yet, "isSelected": false -> true
                                                              // If this item already is selected: "isSelected": true -> false
                                                              setState(() {
                                                                if(taste2[index]['isSelected'] == true){
                                                                  taste2[index]['isSelected'] = false;
                                                                }
                                                                else{
                                                                  taste2[index]['isSelected'] = true;
                                                                }

                                                              });
                                                            },
                                                            title:
                                                            Text(
                                                                taste2[index]['name'].toString().toUpperCase(),
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.w600,
                                                                  color: taste2[index]['isSelected'] == true
                                                                      ? Colors.white
                                                                      : Colors.black,)
                                                            ),

                                                          )):
                                                      index==0?
                                                      Container(
                                                        child:Text(
                                                            taste2[index]['name'].toString().toUpperCase(),
                                                            style: TextStyle(
                                                                color: Color(constant.Color.crave_orange),
                                                                fontWeight: FontWeight.w700,
                                                                fontSize: 14.0.sp)
                                                        ),
                                                      ):
                                                      Container(
                                                        margin: const EdgeInsets.only(
                                                            top: 10.0),
                                                        child:Text(
                                                            taste2[index]['name'].toString().toUpperCase(),
                                                            style: TextStyle(
                                                                color: Color(constant.Color.crave_orange),
                                                                fontWeight: FontWeight.w700,
                                                                fontSize: 14.0.sp)
                                                        ),
                                                      );
                                                  },
                                                ),
                                              ),


                                            ],
                                          ),



                                        ),
                                      ),

                                      //Diet
                                      Container(
                                        width: double.maxFinite,
                                        padding: const EdgeInsets.only(
                                            left: 30.0,right:30.0,top:30,bottom:10),
                                        child:Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Diet",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(constant.Color.crave_orange),
                                                    fontSize: 11.0.sp)),
                                            Row(
                                              children: [
                                                Text("Please select",
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.black,
                                                        fontSize: 11.0.sp)),
                                                Text(" at least",
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        color: Color(constant.Color.crave_orange),
                                                        fontSize: 11.0.sp)),
                                                Text(" 1.",
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.black,
                                                        fontSize: 11.0.sp)),
                                              ],
                                            ),

                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 25.0,right:25.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xFFF2F2F2),
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              topLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                            ),

                                          ),

                                          // margin: const EdgeInsets.only(
                                          //     top: 10.0),
                                          padding: const EdgeInsets.only(
                                              left: 10.0,right:10.0,top:10),
                                          //height:70.0.h,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Expanded(
                                                child:
                                                ListView.builder(
                                                  padding:  EdgeInsets.only(right:10.0),
                                                  shrinkWrap: true,
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  itemCount: diet1.length,
                                                  itemBuilder: (BuildContext ctx, index) {
                                                    return
                                                      diet1[index]['name'].toString().length != 1?
                                                      Container(
                                                          decoration: BoxDecoration(
                                                            color: diet1[index]['isSelected'] == true
                                                                ? Color(constant.Color.crave_blue)
                                                                : Color(0xFFF2F2F2),
                                                            borderRadius: BorderRadius.only(
                                                              topRight: Radius.circular(10),
                                                              topLeft: Radius.circular(10),
                                                              bottomRight: Radius.circular(10),
                                                              bottomLeft: Radius.circular(10),
                                                            ),

                                                          ),
                                                          margin:  EdgeInsets.only(bottom:5.0),

                                                          child: ListTile(
                                                            dense: true,
                                                            contentPadding: EdgeInsets.only(
                                                                left: 5.0,right:5.0),
                                                            visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                                                            onTap: () {
                                                              // if this item isn't selected yet, "isSelected": false -> true
                                                              // If this item already is selected: "isSelected": true -> false
                                                              setState(() {
                                                                if(diet1[index]['isSelected'] == true){
                                                                  diet1[index]['isSelected'] = false;
                                                                }
                                                                else{
                                                                  diet1[index]['isSelected'] = true;
                                                                }

                                                              });
                                                            },
                                                            title:
                                                            Text(
                                                                diet1[index]['name'].toString(),
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.w600,
                                                                  color: diet1[index]['isSelected'] == true
                                                                      ? Colors.white
                                                                      : Colors.black,)
                                                            ),

                                                          )):
                                                      index==0?
                                                      Container(
                                                        child:Text(
                                                            diet1[index]['name'].toString(),
                                                            style: TextStyle(
                                                                color: Color(constant.Color.crave_orange),
                                                                fontWeight: FontWeight.w700,
                                                                fontSize: 14.0.sp)
                                                        ),
                                                      ):
                                                      Container(
                                                        margin: const EdgeInsets.only(
                                                            top: 10.0),
                                                        child:Text(
                                                            diet1[index]['name'].toString(),
                                                            style: TextStyle(
                                                                color: Color(constant.Color.crave_orange),
                                                                fontWeight: FontWeight.w700,
                                                                fontSize: 14.0.sp)
                                                        ),
                                                      );
                                                  },
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0,bottom:10,right:10),
                                                child: VerticalDivider(
                                                  color: Color(0xFFE0E0E0),thickness: 1,),
                                                height: 15.0.h,),

                                              Expanded(
                                                child:  ListView.builder(
                                                  padding:  EdgeInsets.only(right:10.0),
                                                  shrinkWrap: true,
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  itemCount: diet2.length,
                                                  itemBuilder: (BuildContext ctx, index) {
                                                    return
                                                      diet2[index]['name'].toString().length != 1?
                                                      Container(
                                                          decoration: BoxDecoration(
                                                            color: diet2[index]['isSelected'] == true
                                                                ? Color(constant.Color.crave_blue)
                                                                : Color(0xFFF2F2F2),
                                                            borderRadius: BorderRadius.only(
                                                              topRight: Radius.circular(10),
                                                              topLeft: Radius.circular(10),
                                                              bottomRight: Radius.circular(10),
                                                              bottomLeft: Radius.circular(10),
                                                            ),

                                                          ),
                                                          margin:  EdgeInsets.only(bottom:5.0),

                                                          child: ListTile(
                                                            dense: true,
                                                            contentPadding: EdgeInsets.only(
                                                                left: 5.0,right:5.0),
                                                            visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                                                            onTap: () {
                                                              // if this item isn't selected yet, "isSelected": false -> true
                                                              // If this item already is selected: "isSelected": true -> false
                                                              setState(() {
                                                                if(diet2[index]['isSelected'] == true){
                                                                  diet2[index]['isSelected'] = false;
                                                                }
                                                                else{
                                                                  diet2[index]['isSelected'] = true;
                                                                }

                                                              });
                                                            },
                                                            title:
                                                            Text(
                                                                diet2[index]['name'].toString().toUpperCase(),
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.w600,
                                                                  color: diet2[index]['isSelected'] == true
                                                                      ? Colors.white
                                                                      : Colors.black,)
                                                            ),

                                                          )):
                                                      index==0?
                                                      Container(
                                                        child:Text(
                                                            diet2[index]['name'].toString().toUpperCase(),
                                                            style: TextStyle(
                                                                color: Color(constant.Color.crave_orange),
                                                                fontWeight: FontWeight.w700,
                                                                fontSize: 14.0.sp)
                                                        ),
                                                      ):
                                                      Container(
                                                        margin: const EdgeInsets.only(
                                                            top: 10.0),
                                                        child:Text(
                                                            diet2[index]['name'].toString().toUpperCase(),
                                                            style: TextStyle(
                                                                color: Color(constant.Color.crave_orange),
                                                                fontWeight: FontWeight.w700,
                                                                fontSize: 14.0.sp)
                                                        ),
                                                      );
                                                  },
                                                ),
                                              ),


                                            ],
                                          ),



                                        ),
                                      ),

                                      Container(
                                        padding: EdgeInsets.only(left:20,right:20,top:10),
                                        child:Divider(
                                            color:Colors.grey
                                        ),
                                      ),


                                      Container(
                                        width: double.maxFinite,
                                        padding: const EdgeInsets.only(
                                            left: 30.0,right:30.0,top:10,bottom:10),
                                        child:Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Budget",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                    fontSize: 12.0.sp)),


                                          ],
                                        ),
                                      ),

                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child:Container(
                                            padding : EdgeInsets.only(left:20,right:20),
                                            //height:100,
                                            width:100.0.w,
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(15.0),
                                              ),
                                              elevation: 5,
                                              child:
                                              Container(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(top:20),
                                                      child: Text("CRAVE CREDIT : 545, 280 USD",
                                                          textAlign: TextAlign.left,
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w600,
                                                              color: Colors.grey,
                                                              fontSize: 12.0.sp)),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(left:20,right:20,top:10),
                                                      child:Divider(
                                                          color:Colors.grey
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Text("1,200",
                                                            textAlign: TextAlign.left,
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.w600,
                                                                fontSize: 32.0.sp)),
                                                        Padding(
                                                          padding: EdgeInsets.only(bottom:10),
                                                          child:Text(" USD",
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                  color: Colors.grey,
                                                                  fontSize: 9.0.sp)),
                                                        ),

                                                      ],
                                                    ),

                                                    Container(
                                                      padding: EdgeInsets.only(left:20,right:20,top:5),
                                                      child:Divider(
                                                          color:Colors.grey
                                                      ),
                                                    ),

                                                    Padding(
                                                      padding: EdgeInsets.only(bottom:10),
                                                      child: Text("Rates",
                                                          textAlign: TextAlign.left,
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w600,
                                                              color: Colors.grey,
                                                              fontSize: 12.0.sp)),
                                                    ),

                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.only(left:20),
                                                          child:Text("1 CLICK :",
                                                              textAlign: TextAlign.right,
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight.w500,
                                                                  color: Color(constant.Color.crave_orange),
                                                                  fontSize: 10.0.sp)),
                                                        ),

                                                        Padding(
                                                          padding: EdgeInsets.only(right:20),
                                                          child: Text("1 USD",
                                                              textAlign: TextAlign.right,
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight.w500,
                                                                  color: Colors.black,
                                                                  fontSize: 10.0.sp)),
                                                        ),

                                                      ],
                                                    ),
                                                    SizedBox(height:5),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.only(left:20),
                                                          child:Text("1 CRAVE :",
                                                              textAlign: TextAlign.right,
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight.w500,
                                                                  color: Color(constant.Color.crave_orange),
                                                                  fontSize: 10.0.sp)),
                                                        ),

                                                        Padding(
                                                          padding: EdgeInsets.only(right:20),
                                                          child: Text("1.5 USD",
                                                              textAlign: TextAlign.right,
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight.w500,
                                                                  color: Colors.black,
                                                                  fontSize: 10.0.sp)),
                                                        ),

                                                      ],
                                                    ),
                                                    SizedBox(height:5),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.only(left:20),
                                                          child:Text("10K IMPRESSIONS :",
                                                              textAlign: TextAlign.right,
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight.w500,
                                                                  color: Color(constant.Color.crave_orange),
                                                                  fontSize: 10.0.sp)),
                                                        ),

                                                        Padding(
                                                          padding: EdgeInsets.only(right:20),
                                                          child: Text("1 USD",
                                                              textAlign: TextAlign.right,
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight.w500,
                                                                  color: Colors.black,
                                                                  fontSize: 10.0.sp)),
                                                        ),

                                                      ],
                                                    ),


                                                    Padding(
                                                      padding: const EdgeInsets.only(right:5,top:10,bottom:10),
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.only(top:10,bottom:10),
                                                            child:SizedBox(
                                                                width:40.w,
                                                                height:4.h,
                                                                child: ElevatedButton(
                                                                    child: Text(
                                                                        "TOP UP".toUpperCase(),
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.w700,
                                                                            fontSize: 14.0.sp)
                                                                    ),
                                                                    style: ButtonStyle(
                                                                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                                                        backgroundColor: MaterialStateProperty.all<Color>(const Color(constant.Color.crave_orange)),
                                                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                            RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(20.0),
                                                                                side: const BorderSide(color: Color(constant.Color.crave_orange))
                                                                            )
                                                                        )
                                                                    ),
                                                                    onPressed: () => null
                                                                )
                                                            ),
                                                          ),

                                                        ],
                                                      ),
                                                    ),

                                                  ],
                                                ),
                                              ),

                                            )
                                        ),

                                      ),

                                      Container(
                                        padding: EdgeInsets.only(left:20,right:20,top:15),
                                        child:Divider(
                                            color:Colors.grey
                                        ),
                                      ),

                                      Padding(
                                        padding: EdgeInsets.only(left:20,right:20),
                                        child:  Row(
                                          // mainAxisAlignment: MainAxisAlignment.start,
                                          // crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(bottom:10),
                                              child:Transform.scale(
                                                scale:1.3,
                                                child: Checkbox(
                                                  checkColor: Colors.white,
                                                  //fillColor: MaterialStateProperty.all(Color(0xFF2CBFC6)),
                                                  activeColor: Color(constant.Color.crave_blue),
                                                  value: isChecked4,
                                                  shape: CircleBorder(
                                                  ),
                                                  onChanged: (bool? value) {
                                                    setState(() {
                                                      isChecked4 = value!;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),


                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(right:10),
                                                  child: Text("I agree to the terms and conditions",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.w700,
                                                          color: Colors.black,
                                                          fontSize: 11.0.sp)),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(right:10,top:5),
                                                  child: Text("Read T&C",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                          color: Color(constant.Color.crave_blue),
                                                          fontSize: 10.0.sp)),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),


                                      Container(
                                          width:50.0.w,
                                          height:6.h,
                                          margin: const EdgeInsets.only(top:10.0,bottom:30.0,left:20, right:20),
                                          child: ElevatedButton(
                                              child: Text(
                                                  "Confirm".toUpperCase(),
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
                                              onPressed: () => null
                                          )
                                      ),


                                    ],
                                  ),
                                ),


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