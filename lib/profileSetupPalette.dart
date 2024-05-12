// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expandable/expandable.dart';

import 'homeBase.dart';
import 'constants.dart' as constant;

class ProfileSetupPalette extends StatefulWidget {
  final String image_path;
  const ProfileSetupPalette({Key? key,required this.image_path}) : super(key: key);

  @override
  ProfileSetupPaletteState createState() => ProfileSetupPaletteState();
}

class ProfileSetupPaletteState extends State<ProfileSetupPalette> {

  final displayNameCtrl = TextEditingController();
  double _height = 50.h;
  bool isMissingErrorMsg = false;
  bool isUsernameError = false;

  var cuisine1 = [
    {'name': 'Indian (North)', 'isSelected': false},
    {'name': 'Indian (South)', 'isSelected': false},
    {'name': 'Korean', 'isSelected': false},
    {'name': 'Italian', 'isSelected': false},
    {'name': 'French', 'isSelected': false},
    {'name': 'Japanese', 'isSelected': false},
    {'name': 'Continental', 'isSelected': false}];

  var cuisine2 = [
    {'name': 'Thai', 'isSelected': false},
    {'name': 'Vietnamese', 'isSelected': false},
    {'name': 'Mexican', 'isSelected': false},
    {'name': 'Middle-eastern', 'isSelected': false},
    {'name': 'Chinese', 'isSelected': false},
    {'name': 'Malay', 'isSelected': false}];


  var taste1 = [
    {'name': 'Sweet', 'isSelected': false},
    {'name': 'Sour', 'isSelected': false},
  ];

  var taste2 = [
    {'name': 'Savory', 'isSelected': false},
    {'name': 'Spicy', 'isSelected': false},
  ];


  var category1 = [
    {'name': 'DESSERT', 'isSelected': false},
    {'name': 'DRINK', 'isSelected': false}
  ];

  var category2 = [
    {'name': 'FOOD', 'isSelected': false},
    {'name': 'PASTRIES', 'isSelected': false},
  ];

  var type1 = [
    {'name': 'Halal', 'isSelected': false},
    {'name': 'Seafood', 'isSelected': false},
    {'name': 'Gluten-free', 'isSelected': false},
    {'name': 'Contains-nuts', 'isSelected': false}
  ];

  var type2 = [
    {'name': 'Alcoholic', 'isSelected': false},
    {'name': 'Coffee', 'isSelected': false},
    {'name': 'Vegetarian', 'isSelected': false},
  ];

  var ambiance1 = [
    {'name': 'CAFE', 'isSelected': false},
    {'name': 'FINE-DINING', 'isSelected': false},
    {'name': 'CASUAL', 'isSelected': false},
    {'name': 'PUBS-&-BARS', 'isSelected': false},
  ];

  var ambiance2 = [
    {'name': 'COFFEE-SHOP', 'isSelected': false},
    {'name': 'DESSERT-SHOP', 'isSelected': false},
    {'name': 'DRIVE-THRU', 'isSelected': false},
  ];

  List<String> selectedCuisine = [];
  List<String> selectedTaste = [];
  List<String> selectedCategory = [];
  List<String> selectedType = [];
  List<String> selectedAmbiance = [];

  void onExpand() {
    if (_height == 70.h) {
      setState(() {
        _height = 40.h;
      });
    } else {
      setState(() {
        _height = 70.h;
      });
    }
  }

  void goToHomepage() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => PageViewDemo()));
    // setState(() {
    //   Navigator.of(context).pushReplacementNamed("/homepage");
    // });
  }

  Future<http.Response> registerUserPalette() async {

    setState(() {
      isUsernameError = false;
      isMissingErrorMsg = false;
    });

    if(displayNameCtrl.text.isEmpty || selectedCuisine.length < 3 || selectedTaste.length == 0 || selectedCategory.length == 0 || selectedType.length == 0){
      setState(() {
        isMissingErrorMsg = true;
        if(displayNameCtrl.text.isEmpty){
          isUsernameError = true;
        }
      });
    }

    else{
      showAlertDialog(context);
      var url = Uri.parse(constant.Url.crave_url+'register_palette.php');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? user_email =prefs.getString('user_email');
      final http.Response response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        },
        body: {
          "email":user_email,
          "displayName":displayNameCtrl.text,
          "selected_cuisine":json.encode(selectedCuisine),
          "selected_taste":json.encode(selectedTaste),
          "selected_category":json.encode(selectedCategory),
          "selected_type":json.encode(selectedType),
          "selected_ambiance":json.encode(selectedAmbiance),
        },
      );


      if (response.statusCode == 200) {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        // If the server did return a 201 CREATED response,
        // then parse the JSON.
        //return Album.fromJson(json.decode(response.body));
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

  showAlertDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content:  Row(
        children: [
          const CircularProgressIndicator(),
          Container(margin: const EdgeInsets.only(left: 5),child:const Text("Loading")),
        ],),
    );
    showDialog(barrierDismissible: true,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
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
                                        padding: EdgeInsets.only(top: 30.0,bottom:20),
                                        child:
                                        CircleAvatar(
                                          radius: 90.0,
                                          backgroundImage:
                                          this.widget.image_path == ""?
                                          Image.asset('images/profile_img.png').image:
                                          Image.file(File(this.widget.image_path)).image,
                                          backgroundColor: Colors.transparent,
                                        ),
                                        //Image.asset('images/profile_img.png',height:18.0.h),

                                        // CircleAvatar(
                                        //   backgroundColor: Color(0xffF7F7F7),
                                        //   radius: 100.0,
                                        //   child: ClipRRect(
                                        //     child: Image.asset("images/user.png"),
                                        //     borderRadius: BorderRadius.circular(100.0),
                                        //   ),
                                        //
                                        // )

                                        // CircleAvatar(
                                        //   backgroundColor: Color(0xffF7F7F7),
                                        //   radius: 80,
                                        //   child: Icon(
                                        //     Icons.person,
                                        //     size: 150,
                                        //     color: Color(0xffFF6839),
                                        //   ),
                                        // ),
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                                            child: Text("Display Name",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(constant.Color.crave_brown),
                                                    fontSize: 12.0.sp)),
                                          ),

                                          Row(
                                            children: [
                                              Container(
                                                width:90.0.w,
                                                height:50,
                                                margin: const EdgeInsets.only(bottom: 10.0),
                                                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                                                child:TextField(
                                                  autofocus: false,
                                                  controller: displayNameCtrl,
                                                  cursorColor: Colors.black,
                                                  keyboardType: TextInputType.text,
                                                  textInputAction: TextInputAction.go,
                                                  textCapitalization: TextCapitalization.sentences,
                                                  decoration: const InputDecoration(
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
                                                        borderSide: BorderSide(color:Color(0xFFF2F2F2) ),
                                                      ),
                                                      border: UnderlineInputBorder(
                                                        borderSide: BorderSide(color:Color(0xFFF2F2F2) ),
                                                      ),
                                                      focusedBorder: UnderlineInputBorder(
                                                        borderSide: BorderSide(color:Color(0xFFF2F2F2), ),
                                                      ),
                                                      hintText: "Display Name"),
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
                                        width: double.maxFinite,
                                        padding: const EdgeInsets.only(
                                            left: 30.0,top:10),
                                        child:Text("What do you like to eat?",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Color(constant.Color.crave_brown),
                                                fontSize: 15.0.sp)),
                                      ),

                                      //Cuisine
                                      Container(
                                        width: double.maxFinite,
                                        padding: const EdgeInsets.only(
                                            left: 30.0,right:30.0,top:30,bottom:15),
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

                                      Stack(
                                        children: [
                                          Wrap(
                                            children: [
                                              Container(
                                                //height:_height,
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
                                                                          selectedCuisine.removeWhere((str){
                                                                            return str == cuisine1[index]['name'].toString();
                                                                          });
                                                                        }
                                                                        else{
                                                                          cuisine1[index]['isSelected'] = true;
                                                                          selectedCuisine.add(cuisine1[index]['name'].toString());
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
                                                      IntrinsicHeight(
                                                        child:Container(
                                                          padding: const EdgeInsets.only(
                                                              top: 10.0,bottom:10,right:5),
                                                          child: VerticalDivider(
                                                            color: Color(0xFFE0E0E0),thickness: 1,),height:28.0.h),
                                                      ),

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
                                                                          selectedCuisine.removeWhere((str){
                                                                            return str == cuisine2[index]['name'].toString();
                                                                          });
                                                                        }
                                                                        else{
                                                                          cuisine2[index]['isSelected'] = true;
                                                                          selectedCuisine.add(cuisine2[index]['name'].toString());
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
                                            ],
                                          ),

                                          // GestureDetector(
                                          //   onTap:onExpand,
                                          //   child: Container(
                                          //     height:25,
                                          //     margin: EdgeInsets.only(
                                          //         left: 25.0,right:25.0,top:_height-1.0.h),
                                          //     decoration: BoxDecoration(
                                          //       color: Color(0xFFEAEAEA),
                                          //       borderRadius: BorderRadius.only(
                                          //         bottomRight: Radius.circular(10),
                                          //         bottomLeft: Radius.circular(10),
                                          //       ),
                                          //
                                          //     ),
                                          //     child:Center(
                                          //       child:Icon(
                                          //         _height==70.0.h?Icons.keyboard_arrow_up:Icons.keyboard_arrow_down,
                                          //         color: Colors.grey,
                                          //         size: 25.0,
                                          //       ),
                                          //     ),
                                          //
                                          //   ),
                                          // ),

                                        ],
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
                                                                  selectedTaste.removeWhere((str){
                                                                    return str == taste1[index]['name'].toString();
                                                                  });
                                                                }
                                                                else{
                                                                  taste1[index]['isSelected'] = true;
                                                                  selectedTaste.add(taste1[index]['name'].toString());
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
                                                    top: 5.0,bottom:10,right:10),
                                                child: VerticalDivider(
                                                  color: Color(0xFFE0E0E0),thickness: 1,),
                                                height:9.0.h,),

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
                                                                  selectedTaste.removeWhere((str){
                                                                    return str == taste2[index]['name'].toString();
                                                                  });
                                                                }
                                                                else{
                                                                  taste2[index]['isSelected'] = true;
                                                                  selectedTaste.add(taste2[index]['name'].toString());
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

                                      //Category
                                      Container(
                                        width: double.maxFinite,
                                        padding: const EdgeInsets.only(
                                            left: 30.0,right:30.0,top:30,bottom:10),
                                        child:Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Category",
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
                                                  itemCount: category1.length,
                                                  itemBuilder: (BuildContext ctx, index) {
                                                    return
                                                      category1[index]['name'].toString().length != 1?
                                                      Container(
                                                          decoration: BoxDecoration(
                                                            color: category1[index]['isSelected'] == true
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
                                                                if(category1[index]['isSelected'] == true){
                                                                  category1[index]['isSelected'] = false;
                                                                  selectedCategory.removeWhere((str){
                                                                    return str == category1[index]['name'].toString();
                                                                  });
                                                                }
                                                                else{
                                                                  category1[index]['isSelected'] = true;
                                                                  selectedCategory.add(category1[index]['name'].toString());
                                                                }

                                                              });
                                                            },
                                                            title:
                                                            Text(
                                                                category1[index]['name'].toString(),
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.w600,
                                                                  color: category1[index]['isSelected'] == true
                                                                      ? Colors.white
                                                                      : Colors.black,)
                                                            ),

                                                          )):
                                                      index==0?
                                                      Container(
                                                        child:Text(
                                                            category1[index]['name'].toString(),
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
                                                            category1[index]['name'].toString(),
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
                                                    top: 5.0,bottom:10,right:10),
                                                child: VerticalDivider(
                                                  color: Color(0xFFE0E0E0),thickness: 1,),
                                                height: 9.0.h,),

                                              Expanded(
                                                child:  ListView.builder(
                                                  padding:  EdgeInsets.only(right:10.0),
                                                  shrinkWrap: true,
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  itemCount: category2.length,
                                                  itemBuilder: (BuildContext ctx, index) {
                                                    return
                                                      category2[index]['name'].toString().length != 1?
                                                      Container(
                                                          decoration: BoxDecoration(
                                                            color: category2[index]['isSelected'] == true
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
                                                                if(category2[index]['isSelected'] == true){
                                                                  category2[index]['isSelected'] = false;
                                                                  selectedCategory.removeWhere((str){
                                                                    return str == category2[index]['name'].toString();
                                                                  });
                                                                }
                                                                else{
                                                                  category2[index]['isSelected'] = true;
                                                                  selectedCategory.add(category2[index]['name'].toString());
                                                                }

                                                              });
                                                            },
                                                            title:
                                                            Text(
                                                                category2[index]['name'].toString().toUpperCase(),
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.w600,
                                                                  color: category2[index]['isSelected'] == true
                                                                      ? Colors.white
                                                                      : Colors.black,)
                                                            ),

                                                          )):
                                                      index==0?
                                                      Container(
                                                        child:Text(
                                                            category2[index]['name'].toString().toUpperCase(),
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
                                                            category2[index]['name'].toString().toUpperCase(),
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

                                      //Type
                                      Container(
                                        width: double.maxFinite,
                                        padding: const EdgeInsets.only(
                                            left: 30.0,right:30.0,top:30,bottom:10),
                                        child:Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Type",
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
                                                  itemCount: type1.length,
                                                  itemBuilder: (BuildContext ctx, index) {
                                                    return
                                                      type1[index]['name'].toString().length != 1?
                                                      Container(
                                                          decoration: BoxDecoration(
                                                            color: type1[index]['isSelected'] == true
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
                                                                if(type1[index]['isSelected'] == true){
                                                                  type1[index]['isSelected'] = false;
                                                                  selectedType.removeWhere((str){
                                                                    return str == type1[index]['name'].toString();
                                                                  });
                                                                }
                                                                else{
                                                                  type1[index]['isSelected'] = true;
                                                                  selectedType.add(type1[index]['name'].toString());
                                                                }

                                                              });
                                                            },
                                                            title:
                                                            Text(
                                                                type1[index]['name'].toString().toUpperCase(),
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.w600,
                                                                  color: type1[index]['isSelected'] == true
                                                                      ? Colors.white
                                                                      : Colors.black,)
                                                            ),

                                                          )):
                                                      index==0?
                                                      Container(
                                                        child:Text(
                                                            type1[index]['name'].toString().toUpperCase(),
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
                                                            type1[index]['name'].toString().toUpperCase(),
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
                                                  itemCount: type2.length,
                                                  itemBuilder: (BuildContext ctx, index) {
                                                    return
                                                      type2[index]['name'].toString().length != 1?
                                                      Container(
                                                          decoration: BoxDecoration(
                                                            color: type2[index]['isSelected'] == true
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
                                                                if(type2[index]['isSelected'] == true){
                                                                  type2[index]['isSelected'] = false;
                                                                  selectedType.removeWhere((str){
                                                                    return str == type2[index]['name'].toString();
                                                                  });
                                                                }
                                                                else{
                                                                  type2[index]['isSelected'] = true;
                                                                  selectedType.add(type2[index]['name'].toString());
                                                                }

                                                              });
                                                            },
                                                            title:
                                                            Text(
                                                                type2[index]['name'].toString().toUpperCase(),
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.w600,
                                                                  color: type2[index]['isSelected'] == true
                                                                      ? Colors.white
                                                                      : Colors.black,)
                                                            ),

                                                          )):
                                                      index==0?
                                                      Container(
                                                        child:Text(
                                                            type2[index]['name'].toString().toUpperCase(),
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
                                                            type2[index]['name'].toString().toUpperCase(),
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

                                      //Ambiance
                                      Container(
                                        width: double.maxFinite,
                                        padding: const EdgeInsets.only(
                                            left: 30.0,right:30.0,top:30,bottom:10),
                                        child:Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Ambiance",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(constant.Color.crave_orange),
                                                    fontSize: 11.0.sp)),
                                            Row(
                                              children: [
                                                Text("(Optional)",
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
                                                  itemCount: ambiance1.length,
                                                  itemBuilder: (BuildContext ctx, index) {
                                                    return
                                                      ambiance1[index]['name'].toString().length != 1?
                                                      Container(
                                                          decoration: BoxDecoration(
                                                            color: ambiance1[index]['isSelected'] == true
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
                                                                if(ambiance1[index]['isSelected'] == true){
                                                                  ambiance1[index]['isSelected'] = false;
                                                                  selectedAmbiance.removeWhere((str){
                                                                    return str == ambiance1[index]['name'].toString();
                                                                  });
                                                                }
                                                                else{
                                                                  ambiance1[index]['isSelected'] = true;
                                                                  selectedAmbiance.add(ambiance1[index]['name'].toString());
                                                                }

                                                              });
                                                            },
                                                            title:
                                                            Text(
                                                                ambiance1[index]['name'].toString(),
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.w600,
                                                                  color: ambiance1[index]['isSelected'] == true
                                                                      ? Colors.white
                                                                      : Colors.black,)
                                                            ),

                                                          )):
                                                      index==0?
                                                      Container(
                                                        child:Text(
                                                            ambiance1[index]['name'].toString(),
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
                                                            ambiance1[index]['name'].toString(),
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
                                                  itemCount: ambiance2.length,
                                                  itemBuilder: (BuildContext ctx, index) {
                                                    return
                                                      ambiance2[index]['name'].toString().length != 1?
                                                      Container(
                                                          decoration: BoxDecoration(
                                                            color: ambiance2[index]['isSelected'] == true
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
                                                                if(ambiance2[index]['isSelected'] == true){
                                                                  ambiance2[index]['isSelected'] = false;
                                                                  selectedAmbiance.removeWhere((str){
                                                                    return str == ambiance2[index]['name'].toString();
                                                                  });
                                                                }
                                                                else{
                                                                  ambiance2[index]['isSelected'] = true;
                                                                  selectedAmbiance.add(ambiance2[index]['name'].toString());
                                                                }

                                                              });
                                                            },
                                                            title:
                                                            Text(
                                                                ambiance2[index]['name'].toString().toUpperCase(),
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.w600,
                                                                  color: ambiance2[index]['isSelected'] == true
                                                                      ? Colors.white
                                                                      : Colors.black,)
                                                            ),

                                                          )):
                                                      index==0?
                                                      Container(
                                                        child:Text(
                                                            ambiance2[index]['name'].toString().toUpperCase(),
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
                                                            ambiance2[index]['name'].toString().toUpperCase(),
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

                                      isMissingErrorMsg?
                                          Container(
                                            width:100.0.w,
                                            child: Column(
                                              children: [
                                                Row(mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets.only(left: 0.0,bottom:0, top:30),
                                                      child:Text("Oh no! You haven't selected ",
                                                          textAlign: TextAlign.left,
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w500,
                                                              color: Color(constant.Color.crave_brown),
                                                              fontSize: 11.0.sp)),
                                                    ),
                                                    Container(
                                                      padding: const EdgeInsets.only(bottom:0, top:30),
                                                      child:Text("enough ",
                                                          textAlign: TextAlign.left,
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w500,
                                                              color: Color(constant.Color.crave_orange),
                                                              fontSize: 11.0.sp)),
                                                    ),
                                                    Container(
                                                      padding: const EdgeInsets.only(bottom:0, top:30),
                                                      child:Text("items :(",
                                                          textAlign: TextAlign.left,
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w500,
                                                              color: Color(constant.Color.crave_brown),
                                                              fontSize: 11.0.sp)),
                                                    ),
                                                  ],
                                                ),

                                              ],
                                            )
                                          )
                                        :
                                      Container(height:30),

                                      Container(
                                          width:45.w,
                                          height:6.h,
                                          margin: const EdgeInsets.only(top:30.0,bottom:30.0),
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
                                                          borderRadius: BorderRadius.circular(5.0),
                                                          side: const BorderSide(color: Color(constant.Color.crave_blue))
                                                      )
                                                  )
                                              ),
                                              onPressed: () => registerUserPalette()
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