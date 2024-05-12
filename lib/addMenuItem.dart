// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'dart:io';
import 'constants.dart' as constant;

import 'package:sizer/sizer.dart';

class AddMenuItem extends StatefulWidget {
  const AddMenuItem({Key? key}) : super(key: key);

  @override
  AddMenuItemState createState() => AddMenuItemState();
}

class AddMenuItemState extends State<AddMenuItem> {

  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final itemNameCtrl = TextEditingController();
  final itemDescCtrl = TextEditingController();

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
                                        child:Text("Add a Menu Item",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black,
                                                fontSize: 14.0.sp)),
                                      ),
                                      Container(
                                        width: double.maxFinite,
                                        padding: const EdgeInsets.only(
                                            top: 30.0,bottom:15.0),
                                        child:Text("ADD FROM",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black,
                                                fontSize: 12.0.sp)),
                                      ),

                                      IntrinsicHeight(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Image.asset('images/add_menu_from_menu.png',height:8.0.h),
                                            Container(
                                              padding: EdgeInsets.only(left:10,right:10),
                                              child:VerticalDivider(
                                                color:Colors.grey
                                              ),
                                            ),
                                            Image.asset('images/add_menu_from_camera.png',height:8.0.h),
                                            Container(
                                              padding: EdgeInsets.only(left:10,right:10),
                                              child:VerticalDivider(
                                                  color:Colors.grey
                                              ),
                                            ),
                                            Image.asset('images/add_menu_from_gallery.png',height:8.0.h),
                                          ],
                                        ),
                                      ),

                                      Container(
                                        padding: EdgeInsets.only(left: 30.0, right: 30.0, top:10.0.h),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Item Name",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    color: Color(constant.Color.crave_orange),
                                                    fontSize: 11.0.sp)),
                                            Container(
                                              //width:250,
                                              height:30,
                                              margin: const EdgeInsets.only(bottom: 10.0,top:5),
                                              child:TextField(
                                                autofocus: false,
                                                controller: itemNameCtrl,
                                                cursorColor: Colors.black,
                                                keyboardType: TextInputType.text,
                                                textInputAction: TextInputAction.go,
                                                textCapitalization: TextCapitalization.sentences,
                                                  style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.black
                                                  ),
                                                decoration: const InputDecoration(
                                                    counterText: '',
                                                    filled: true,
                                                    // Color(0xFFD6D6D6)
                                                    fillColor: Color(0xFFF2F2F2),
                                                    contentPadding:EdgeInsets.symmetric(horizontal: 15),
                                                    labelStyle: TextStyle(
                                                        fontSize: 12,
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
                                                    hintText: "Item Name"),
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
                                            Text("Item Description",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    color: Color(constant.Color.crave_orange),
                                                    fontSize: 11.0.sp)),
                                            Container(
                                              //width:250,
                                              //height:50,
                                              margin: const EdgeInsets.only(bottom: 20.0,top:5),
                                              child:TextField(
                                                autofocus: false,
                                                minLines: 5,
                                                maxLines: null,
                                                controller: itemDescCtrl,
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
                                                    hintText: "--"),
                                              ),
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
                                                Text("CHOOSE 1 OR MORE",
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.black,
                                                        fontSize: 9.5.sp)),

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
                                                Text("CHOOSE 1 OR MORE",
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.black,
                                                        fontSize: 9.5.sp)),
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
                                                Text("CHOOSE 1 OR MORE",
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.black,
                                                        fontSize: 9.5.sp)),
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
                                          width:double.infinity,
                                          height:4.h,
                                          margin: const EdgeInsets.only(top:30.0,bottom:10.0,left:20, right:20),
                                          child: ElevatedButton(
                                              child: Text(
                                                  "Preview".toUpperCase(),
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 14.0.sp)
                                              ),
                                              style: ButtonStyle(
                                                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                                  backgroundColor: MaterialStateProperty.all<Color>(const Color(constant.Color.crave_blue),),
                                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(5.0),
                                                          side: const BorderSide(color: Color(constant.Color.crave_blue))
                                                      )
                                                  )
                                              ),
                                              onPressed: () => null
                                          )
                                      ),
                                      Container(
                                          width:double.infinity,
                                          height:8.h,
                                          margin: const EdgeInsets.only(top:5.0,bottom:30.0,left:20, right:20),
                                          child: ElevatedButton(
                                              child: Text(
                                                  "Confirm".toUpperCase(),
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 14.0.sp)
                                              ),
                                              style: ButtonStyle(
                                                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                                  backgroundColor: MaterialStateProperty.all<Color>(const Color(constant.Color.crave_orange)),
                                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(5.0),
                                                          side: const BorderSide(color: Color(constant.Color.crave_orange))
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