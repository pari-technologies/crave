// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';
import 'constants.dart' as constant;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'dataClass.dart';

class ProfileManageCraveList extends StatefulWidget {
  final PageController profilePageController;
  final List<CraveContent> crave_content;
  final String craveListName;
  final String craveListId;
  final Function() loadCraveList;
  const ProfileManageCraveList({Key? key, required this.profilePageController,required this.crave_content, required this.craveListName, required this.craveListId,required this.loadCraveList}) : super(key: key);

  @override
  ProfileManageCraveListState createState() => ProfileManageCraveListState();
}

class ProfileManageCraveListState extends State<ProfileManageCraveList> {

  final textController = TextEditingController();
  final addCraveListCtrl = TextEditingController();
  int currentTab = 0;
  String currentListName = "";
  double currentlat = 0.00;
  double currentlng = 0.00;
  List<CraveContent> currentListContent = [];
  List<CraveContent> dummyListContent = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => startLoad());
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void startLoad() async{
    Position position = await _determinePosition();

    setState(() {
      currentlat = position.latitude;
      currentlng = position.longitude;

      currentListName = this.widget.craveListName;
      addCraveListCtrl.text = this.widget.craveListName;

      loadCraveContent(this.widget.craveListId);
    });
  }

  Future<List<CraveContent>> loadCraveContent(String crave_list_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var url = Uri.parse(constant.Url.crave_url+'get_crave_content.php');
    // returnedEvent.clear();
    print(crave_list_id);
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        "email":"",
        "crave_list_id":crave_list_id
      },
    );

    if (response.statusCode == 200) {

      Map<String, dynamic> crave_list = jsonDecode(response.body);


      if(crave_list['crave_content'] != null){

        List<dynamic> body = crave_list['crave_content'];
        print("loadCraveContentsadsa");
        print(body);
        List<CraveContent> c_list = body
            .map(
              (dynamic item) => CraveContent.fromJson(item),
        ).toList();

        List<CraveContent> d_list = body
            .map(
              (dynamic item) => CraveContent.fromJson(item),
        ).toList();

        setState(() {
          //isCarAvailable = true;
          print("get response body carlist");
          print(response.body);
          print(c_list.toString());
          currentListContent = c_list;

          dummyListContent = d_list;
        });


        //suggestions = location;
        // print("--avaialbel carr---");
        print(currentListContent);
        return currentListContent;
      }
      else{
        setState(() {
          // isCarAvailable = false;
          //carList.;
        });

        return [];
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }

  }

  void doNothing() {}

  void onTabChange(pageNo){
    setState(() {
      currentTab = pageNo;
    });

  }

  void onShowAddCraveList(){
    showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (context) {
          return  StatefulBuilder(builder: (BuildContext context, StateSetter mystate) {
            return
              Container(
                //height:MediaQuery.of(context).size.height,
                // padding:
                padding: MediaQuery.of(context).viewInsets,
                //height:30.0.h,
                child:
                Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(bottom:15,top:30),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                            ),
                            border: Border.all(
                              width: 2,
                              color: Color(constant.Color.crave_grey),
                              style: BorderStyle.solid,
                            ),
                          ),
                          child:Column(
                            children: [
                              SafeArea(
                                bottom:false,
                                child:
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(left: 20.0,top:50),
                                      child: GestureDetector(
                                          onTap:(){
                                            Navigator.pop(context);
                                          },
                                          child:
                                          Icon(Icons.arrow_back_ios,size: 20,color:Colors.grey)
                                      ),
                                    ),
                                    Container(
                                        padding: const EdgeInsets.only(
                                            top: 50.0,bottom:0,left:10),
                                        //width:MediaQuery.of(context).size.width,
                                        child:Text("Add a List",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: Color(constant.Color.crave_brown),
                                                fontSize: 16.0.sp))
                                    ),


                                  ],
                                ),

                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                    //location name
                    SizedBox(height:2.0.h),
                    Row(
                      children: [
                        Container(
                          width:90.0.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                                child: Text("List Name",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Color(constant.Color.crave_brown),
                                        fontSize: 12.0.sp)),
                              ),

                              Container(
                                //width:250,
                                height:45,
                                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                                child:TextField(
                                  autofocus: false,
                                  controller: addCraveListCtrl,
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
                                      ),
                                      hintText: "List name"),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                            width:10,
                            height:10,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(constant.Color.crave_orange)),)
                      ],
                    ),

                    SizedBox(height:5.0.h),
                    SizedBox(
                        width:60.w,
                        height:6.h,
                        child: ElevatedButton(
                            child: Text(
                                "Confirm".toUpperCase(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16.0.sp)
                            ),
                            style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                backgroundColor: MaterialStateProperty.all<Color>(const Color(constant.Color.crave_orange)),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                        side: const BorderSide(color: Color(constant.Color.crave_orange))
                                    )
                                )
                            ),
                            onPressed: () =>  updateList()
                        )
                    ),

                  ],
                ),


              );


          });
        });
  }

  void goToDetails() {
    // this.widget.profilePageController.nextPage(duration: Duration(milliseconds: 100), curve: Curves.easeIn);
    // PageViewDemo.of(context)!.hideWheel();
  }

  Future<http.Response> updateList() async {
    var url = Uri.parse(constant.Url.crave_url+'edit_crave_list.php');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        "email":prefs.getString('user_email'),
        "list_name":addCraveListCtrl.text,
        "list_id":this.widget.craveListId,
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
      }
      else{
        setState(() {
          currentListName = addCraveListCtrl.text;
        });
        Navigator.pop(context);
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

  void removeCraveContent(crave_content_id,index) async {
    var url = Uri.parse(constant.Url.crave_url+'remove_crave_content.php');
    print(crave_content_id);
    print(index);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        "content_id":crave_content_id
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
      }
      else{
        setState(() {
          currentListContent.removeAt(index);
        });
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
   // return response;
  }

  String getDistance(latlng){
    String distance = "0";
    final new_dis = latlng.split(',');

    double distanceInMeters = Geolocator.distanceBetween(currentlat, currentlng, double.parse(new_dis[0]), double.parse(new_dis[1]));

    distance = (distanceInMeters/1000).toStringAsFixed(2).toString();
    return distance+" km";

  }

  void filterSearchContent(String query) {
    print(query);
    List<CraveContent> dummySearchList = [];
    dummySearchList.addAll(dummyListContent);
    if(query.isNotEmpty) {
      List<CraveContent> dummyListData = [];
      dummySearchList.forEach((item) {
        if(item.user_display_name.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        currentListContent.clear();
        currentListContent.addAll(dummyListData);
      });
      // return;
    } else {
      setState(() {
        currentListContent.clear();
        currentListContent.addAll(dummyListContent);
        // loadMediaDiscoverSearch();
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    var maxWidth = 500.0;
    var width = MediaQuery.of(context).size.width;
    var columns = (width ~/ maxWidth) + 1;
    var columnWidth = width / columns;
    var aspectRatio = columnWidth / 390;

    final screenSize = MediaQuery.of(context).size;

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
                          Stack(
                            children: <Widget>[
                              Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(bottom:15,top:25),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(15),
                                        bottomLeft: Radius.circular(15),
                                      ),
                                      border: Border.all(
                                        width: 2,
                                        color: Color(constant.Color.crave_grey),
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    child:Column(
                                      children: [
                                        SafeArea(
                                          bottom:false,
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(left:20),
                                                child:GestureDetector(
                                                    onTap:(){
                                                      // Navigator.pop(context);
                                                      // this.widget.homepageController.jumpToPage(0);
                                                      this.widget.profilePageController.previousPage(duration: new Duration(milliseconds: 100), curve: Curves.easeOut);
                                                    },
                                                    child:
                                                    Icon(Icons.arrow_back_ios,size: 20,color: Colors.grey,)
                                                ),
                                              ),

                                              Container(
                                                  padding: const EdgeInsets.only(
                                                      top: 10.0,bottom:10,left:10),
                                                  // width:MediaQuery.of(context).size.width,
                                                  child:Text(currentListName,
                                                      textAlign: TextAlign.start,
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.w700,
                                                          color: Color(constant.Color.crave_brown),
                                                          fontSize: 17.0.sp))
                                              ),
                                              Spacer(),
                                              GestureDetector(
                                                onTap:onShowAddCraveList,
                                                child:Container(
                                                    padding: const EdgeInsets.only(
                                                        top: 10.0,bottom:10,right:30),
                                                    //width:MediaQuery.of(context).size.width,
                                                    child:Image.asset(
                                                      'images/edit_cravelist_name.png',
                                                      height: 25,
                                                    )
                                                ),
                                              ),

                                            ],
                                          ),

                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 30.0, right: 30.0,top:10),
                                          child:IntrinsicHeight(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                GestureDetector(
                                                  onTap:(){
                                                    onTabChange(0);
                                                  },
                                                  child:Text("MANAGE LIST",
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.w600,
                                                          color: currentTab==0?Colors.black:Color(0xFFDEDDDD),
                                                          fontSize: 10.0.sp)),
                                                ),
                                                SizedBox(
                                                  width:5.0.w,
                                                ),
                                                Container(
                                                  //padding: const EdgeInsets.only(top:15,bottom:15),
                                                  child:VerticalDivider(
                                                      color:Colors.grey
                                                  ),
                                                ),
                                                SizedBox(
                                                  width:5.0.w,
                                                ),
                                                GestureDetector(
                                                  onTap:(){
                                                    onTabChange(1);
                                                  },
                                                  child:Text("ADD CRAVE",
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.w600,
                                                          color: currentTab==1?Colors.black:Color(0xFFDEDDDD),
                                                          fontSize: 10.0.sp)),
                                                ),
                                                SizedBox(
                                                  width:2.0.w,
                                                ),


                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    //width:250,
                                    height:37,
                                    margin: const EdgeInsets.only(bottom: 20.0,top:15),
                                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                    child:TextField(
                                      autofocus: false,
                                      controller: textController,
                                      cursorColor: Colors.black,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.go,
                                      textCapitalization: TextCapitalization.sentences,
                                      onChanged:(value){
                                        filterSearchContent(value);
                                      },
                                      decoration: InputDecoration(
                                          counterText: '',
                                          filled: true,
                                          // Color(0xFFD6D6D6)
                                          fillColor: Color(0xFFF2F2F2),
                                          contentPadding:EdgeInsets.symmetric(horizontal: 15,vertical:10),
                                          labelStyle: TextStyle(
                                              fontSize: 14,
                                              color:Colors.black
                                          ),
                                          hintStyle: TextStyle(
                                            fontSize: 15,
                                              color:Colors.grey.shade400,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                            borderSide: BorderSide(color:Color(0xFFF2F2F2) ),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                            borderSide: BorderSide(color:Color(0xFFF2F2F2) ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                            borderSide: BorderSide(color:Color(0xFFF2F2F2), ),
                                          ),
                                          suffixIcon: Icon(
                                            Icons.search,
                                            color: Colors.grey,
                                            size: 25.0,
                                          ),
                                          hintText: "Search"),
                                    ),
                                  ),

                                  Expanded(
                                    child:MediaQuery.removePadding(
                                      removeTop: true,
                                      context: context,
                                      child:
                                      ListView.builder(
                                        // the number of items in the list
                                          itemCount: currentListContent.length,
                                          shrinkWrap: true,
                                          // display each item of the product list
                                          itemBuilder: (context, index) {
                                            return
                                            Column(
                                              children: [
                                                Slidable(
                                                  // Specify a key if the Slidable is dismissible.
                                                  key: ValueKey(index),
                                                  // The end action pane is the one at the right or the bottom side.
                                                  endActionPane: ActionPane(
                                                    extentRatio: 0.25,
                                                    motion: ScrollMotion(),
                                                    children: [
                                                      SlidableAction(
                                                        onPressed: (BuildContext context){
                                                          removeCraveContent(currentListContent[index].content_id, index);
                                                        },
                                                        backgroundColor: Color(constant.Color.crave_orange),
                                                        foregroundColor: Colors.white,
                                                        // icon: Icons.save,
                                                        label: 'Delete',
                                                      ),
                                                    ],
                                                  ),

                                                  // The child of the Slidable is what the user sees when the
                                                  // component is not dragged.
                                                  child: Container(
                                                    height:60,
                                                    padding: const EdgeInsets.only(left:20,top:0,bottom:0,right:20),
                                                    child:Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Image.network(
                                                              constant.Url.media_url+currentListContent[index].content_name,
                                                              height: 55,
                                                            ),

                                                            Container(
                                                              width:50.0.w,
                                                              padding:EdgeInsets.only(left:10),
                                                              child:
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(currentListContent[index].user_display_name,
                                                                      style: TextStyle(
                                                                          color: Color(constant.Color.crave_brown),
                                                                          fontWeight: FontWeight.w600,
                                                                          fontSize: 12.0.sp)),
                                                                  SizedBox(height:0.5.h),
                                                                  Text(currentListContent[index].content_desc,
                                                                      maxLines: 1,
                                                                      overflow: TextOverflow.ellipsis,
                                                                      style: TextStyle(
                                                                          color: Colors.black,
                                                                          fontSize: 8.0.sp)),

                                                                ],
                                                              ),

                                                            ),
                                                            Spacer(),
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                              mainAxisSize: MainAxisSize.max,
                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                                  children: [
                                                                    Padding(
                                                                      padding: EdgeInsets.only(left:0,right:10),
                                                                      child:Text(currentListContent[index].post_craving,
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w600,
                                                                              color: Color(constant.Color.crave_brown),
                                                                              fontSize: 11.0.sp)),
                                                                    ),
                                                                    Image.asset(
                                                                      'images/icon_crave.png',
                                                                      height: 2.0.h,
                                                                    ),

                                                                  ],
                                                                ),
                                                                SizedBox(height:5),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                                  children: [
                                                                    Padding(
                                                                      padding: EdgeInsets.only(left:0,right:10),
                                                                      child:Text(getDistance(currentListContent[index].content_latlng),
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w600,
                                                                              color: Color(constant.Color.crave_brown),
                                                                              fontSize: 11.0.sp)),
                                                                    ),
                                                                    Image.asset(
                                                                        'images/icon_location_camera.png',
                                                                        height: 2.2.h,
                                                                        colorBlendMode: BlendMode.modulate,
                                                                        color:Colors.black.withOpacity(0.5)
                                                                    ),

                                                                  ],
                                                                ),
                                                              ],
                                                            ),

                                                          ],

                                                        ),

                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.only(left:20,right:20,top:0,bottom:5),
                                                  child:Divider(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            );

                                          }),
                                      // ListView(
                                      //   shrinkWrap: true,
                                      //   //physics: NeverScrollableScrollPhysics(),
                                      //   // crossAxisCount: 2,
                                      //   // // mainAxisSpacing: 10.0,
                                      //   // crossAxisSpacing: 10.0,
                                      //   // childAspectRatio: aspectRatio,
                                      //   children: <Widget>[
                                      //     Slidable(
                                      //       // Specify a key if the Slidable is dismissible.
                                      //       key: const ValueKey(0),
                                      //       // The end action pane is the one at the right or the bottom side.
                                      //       endActionPane: ActionPane(
                                      //         extentRatio: 0.25,
                                      //         motion: ScrollMotion(),
                                      //         children: [
                                      //           SlidableAction(
                                      //             onPressed: doNothing,
                                      //             backgroundColor: Color(constant.Color.crave_orange),
                                      //             foregroundColor: Colors.white,
                                      //             // icon: Icons.save,
                                      //             label: 'Delete',
                                      //           ),
                                      //         ],
                                      //       ),
                                      //
                                      //       // The child of the Slidable is what the user sees when the
                                      //       // component is not dragged.
                                      //       child: Container(
                                      //         height:60,
                                      //         padding: const EdgeInsets.only(left:20,top:0,bottom:0,right:20),
                                      //         child:Column(
                                      //           children: [
                                      //             Row(
                                      //               children: [
                                      //                 Image.asset(
                                      //                   'images/food1.png',
                                      //                   height: 55,
                                      //                 ),
                                      //
                                      //                 Container(
                                      //                   width:50.0.w,
                                      //                   padding:EdgeInsets.only(left:10),
                                      //                   child:
                                      //                   Column(
                                      //                     mainAxisAlignment: MainAxisAlignment.start,
                                      //                     crossAxisAlignment: CrossAxisAlignment.start,
                                      //                     children: [
                                      //                       Text('Kar Heng',
                                      //                           style: TextStyle(
                                      //                               color: Color(constant.Color.crave_brown),
                                      //                               fontWeight: FontWeight.w600,
                                      //                               fontSize: 12.0.sp)),
                                      //                       SizedBox(height:0.5.h),
                                      //                       Text('Lorem ipsum dolor sit amet, consectetur adipiscing . . . ',
                                      //                           maxLines: 1,
                                      //                           overflow: TextOverflow.ellipsis,
                                      //                           style: TextStyle(
                                      //                               color: Colors.black,
                                      //                               fontSize: 8.0.sp)),
                                      //
                                      //                     ],
                                      //                   ),
                                      //
                                      //                 ),
                                      //                 Spacer(),
                                      //                 Column(
                                      //                   crossAxisAlignment: CrossAxisAlignment.end,
                                      //                   mainAxisSize: MainAxisSize.max,
                                      //                   mainAxisAlignment: MainAxisAlignment.end,
                                      //                   children: [
                                      //                     Row(
                                      //                       mainAxisAlignment: MainAxisAlignment.end,
                                      //                       children: [
                                      //                         Padding(
                                      //                           padding: EdgeInsets.only(left:0,right:10),
                                      //                           child:Text('19',
                                      //                               style: TextStyle(
                                      //                                   fontWeight: FontWeight.w600,
                                      //                                   color: Color(constant.Color.crave_brown),
                                      //                                   fontSize: 11.0.sp)),
                                      //                         ),
                                      //                         Image.asset(
                                      //                           'images/icon_crave.png',
                                      //                           height: 2.0.h,
                                      //                         ),
                                      //
                                      //                       ],
                                      //                     ),
                                      //                     SizedBox(height:5),
                                      //                     Row(
                                      //                       mainAxisAlignment: MainAxisAlignment.end,
                                      //                       children: [
                                      //                         Padding(
                                      //                           padding: EdgeInsets.only(left:0,right:10),
                                      //                           child:Text('9 km',
                                      //                               style: TextStyle(
                                      //                                   fontWeight: FontWeight.w600,
                                      //                                   color: Color(constant.Color.crave_brown),
                                      //                                   fontSize: 11.0.sp)),
                                      //                         ),
                                      //                         Image.asset(
                                      //                             'images/icon_location_camera.png',
                                      //                             height: 2.2.h,
                                      //                             colorBlendMode: BlendMode.modulate,
                                      //                             color:Colors.black.withOpacity(0.5)
                                      //                         ),
                                      //
                                      //                       ],
                                      //                     ),
                                      //                   ],
                                      //                 ),
                                      //
                                      //               ],
                                      //
                                      //             ),
                                      //
                                      //           ],
                                      //         ),
                                      //       ),
                                      //     ),
                                      //     Container(
                                      //       padding: const EdgeInsets.only(left:20,right:20,top:0,bottom:5),
                                      //       child:Divider(
                                      //         color: Colors.grey,
                                      //       ),
                                      //     ),
                                      //     Slidable(
                                      //       // Specify a key if the Slidable is dismissible.
                                      //       key: const ValueKey(1),
                                      //       // The end action pane is the one at the right or the bottom side.
                                      //       endActionPane: ActionPane(
                                      //         extentRatio: 0.25,
                                      //         motion: ScrollMotion(),
                                      //         children: [
                                      //           SlidableAction(
                                      //             onPressed: doNothing,
                                      //             backgroundColor: Color(constant.Color.crave_orange),
                                      //             foregroundColor: Colors.white,
                                      //             // icon: Icons.save,
                                      //             label: 'Delete',
                                      //           ),
                                      //         ],
                                      //       ),
                                      //
                                      //       // The child of the Slidable is what the user sees when the
                                      //       // component is not dragged.
                                      //       child: Container(
                                      //         height:60,
                                      //         padding: const EdgeInsets.only(left:20,top:0,bottom:0,right:20),
                                      //         child:Column(
                                      //           children: [
                                      //             Row(
                                      //               children: [
                                      //                 Image.asset(
                                      //                   'images/food1.png',
                                      //                   height: 55,
                                      //                 ),
                                      //
                                      //                 Container(
                                      //                   width:50.0.w,
                                      //                   padding:EdgeInsets.only(left:10),
                                      //                   child:
                                      //                   Column(
                                      //                     mainAxisAlignment: MainAxisAlignment.start,
                                      //                     crossAxisAlignment: CrossAxisAlignment.start,
                                      //                     children: [
                                      //                       Text('Kar Heng',
                                      //                           style: TextStyle(
                                      //                               color: Color(constant.Color.crave_brown),
                                      //                               fontWeight: FontWeight.w600,
                                      //                               fontSize: 12.0.sp)),
                                      //                       SizedBox(height:0.5.h),
                                      //                       Text('Lorem ipsum dolor sit amet, consectetur adipiscing . . . ',
                                      //                           maxLines: 1,
                                      //                           overflow: TextOverflow.ellipsis,
                                      //                           style: TextStyle(
                                      //                               color: Colors.black,
                                      //                               fontSize: 8.0.sp)),
                                      //
                                      //                     ],
                                      //                   ),
                                      //
                                      //                 ),
                                      //                 Spacer(),
                                      //                 Column(
                                      //                   crossAxisAlignment: CrossAxisAlignment.end,
                                      //                   mainAxisSize: MainAxisSize.max,
                                      //                   mainAxisAlignment: MainAxisAlignment.end,
                                      //                   children: [
                                      //                     Row(
                                      //                       mainAxisAlignment: MainAxisAlignment.end,
                                      //                       children: [
                                      //                         Padding(
                                      //                           padding: EdgeInsets.only(left:0,right:10),
                                      //                           child:Text('19',
                                      //                               style: TextStyle(
                                      //                                   fontWeight: FontWeight.w600,
                                      //                                   color: Color(constant.Color.crave_brown),
                                      //                                   fontSize: 11.0.sp)),
                                      //                         ),
                                      //                         Image.asset(
                                      //                           'images/icon_crave.png',
                                      //                           height: 2.0.h,
                                      //                         ),
                                      //
                                      //                       ],
                                      //                     ),
                                      //                     SizedBox(height:5),
                                      //                     Row(
                                      //                       mainAxisAlignment: MainAxisAlignment.end,
                                      //                       children: [
                                      //                         Padding(
                                      //                           padding: EdgeInsets.only(left:0,right:10),
                                      //                           child:Text('9 km',
                                      //                               style: TextStyle(
                                      //                                   fontWeight: FontWeight.w600,
                                      //                                   color: Color(constant.Color.crave_brown),
                                      //                                   fontSize: 11.0.sp)),
                                      //                         ),
                                      //                         Image.asset(
                                      //                             'images/icon_location_camera.png',
                                      //                             height: 2.2.h,
                                      //                             colorBlendMode: BlendMode.modulate,
                                      //                             color:Colors.black.withOpacity(0.5)
                                      //                         ),
                                      //
                                      //                       ],
                                      //                     ),
                                      //                   ],
                                      //                 ),
                                      //
                                      //               ],
                                      //
                                      //             ),
                                      //
                                      //           ],
                                      //         ),
                                      //       ),
                                      //     ),
                                      //     Container(
                                      //       padding: const EdgeInsets.only(left:20,right:20,top:0,bottom:5),
                                      //       child:Divider(
                                      //         color: Colors.grey,
                                      //       ),
                                      //     ),
                                      //     Slidable(
                                      //       // Specify a key if the Slidable is dismissible.
                                      //       key: const ValueKey(2),
                                      //       // The end action pane is the one at the right or the bottom side.
                                      //       endActionPane: ActionPane(
                                      //         extentRatio: 0.25,
                                      //         motion: ScrollMotion(),
                                      //         children: [
                                      //           SlidableAction(
                                      //             onPressed: doNothing,
                                      //             backgroundColor: Color(constant.Color.crave_orange),
                                      //             foregroundColor: Colors.white,
                                      //             // icon: Icons.save,
                                      //             label: 'Delete',
                                      //           ),
                                      //         ],
                                      //       ),
                                      //
                                      //       // The child of the Slidable is what the user sees when the
                                      //       // component is not dragged.
                                      //       child: Container(
                                      //         height:60,
                                      //         padding: const EdgeInsets.only(left:20,top:0,bottom:0,right:20),
                                      //         child:Column(
                                      //           children: [
                                      //             Row(
                                      //               children: [
                                      //                 Image.asset(
                                      //                   'images/food1.png',
                                      //                   height: 55,
                                      //                 ),
                                      //
                                      //                 Container(
                                      //                   width:50.0.w,
                                      //                   padding:EdgeInsets.only(left:10),
                                      //                   child:
                                      //                   Column(
                                      //                     mainAxisAlignment: MainAxisAlignment.start,
                                      //                     crossAxisAlignment: CrossAxisAlignment.start,
                                      //                     children: [
                                      //                       Text('Kar Heng',
                                      //                           style: TextStyle(
                                      //                               color: Color(constant.Color.crave_brown),
                                      //                               fontWeight: FontWeight.w600,
                                      //                               fontSize: 12.0.sp)),
                                      //                       SizedBox(height:0.5.h),
                                      //                       Text('Lorem ipsum dolor sit amet, consectetur adipiscing . . . ',
                                      //                           maxLines: 1,
                                      //                           overflow: TextOverflow.ellipsis,
                                      //                           style: TextStyle(
                                      //                               color: Colors.black,
                                      //                               fontSize: 8.0.sp)),
                                      //
                                      //                     ],
                                      //                   ),
                                      //
                                      //                 ),
                                      //                 Spacer(),
                                      //                 Column(
                                      //                   crossAxisAlignment: CrossAxisAlignment.end,
                                      //                   mainAxisSize: MainAxisSize.max,
                                      //                   mainAxisAlignment: MainAxisAlignment.end,
                                      //                   children: [
                                      //                     Row(
                                      //                       mainAxisAlignment: MainAxisAlignment.end,
                                      //                       children: [
                                      //                         Padding(
                                      //                           padding: EdgeInsets.only(left:0,right:10),
                                      //                           child:Text('19',
                                      //                               style: TextStyle(
                                      //                                   fontWeight: FontWeight.w600,
                                      //                                   color: Color(constant.Color.crave_brown),
                                      //                                   fontSize: 11.0.sp)),
                                      //                         ),
                                      //                         Image.asset(
                                      //                           'images/icon_crave.png',
                                      //                           height: 2.0.h,
                                      //                         ),
                                      //
                                      //                       ],
                                      //                     ),
                                      //                     SizedBox(height:5),
                                      //                     Row(
                                      //                       mainAxisAlignment: MainAxisAlignment.end,
                                      //                       children: [
                                      //                         Padding(
                                      //                           padding: EdgeInsets.only(left:0,right:10),
                                      //                           child:Text('9 km',
                                      //                               style: TextStyle(
                                      //                                   fontWeight: FontWeight.w600,
                                      //                                   color: Color(constant.Color.crave_brown),
                                      //                                   fontSize: 11.0.sp)),
                                      //                         ),
                                      //                         Image.asset(
                                      //                             'images/icon_location_camera.png',
                                      //                             height: 2.2.h,
                                      //                             colorBlendMode: BlendMode.modulate,
                                      //                             color:Colors.black.withOpacity(0.5)
                                      //                         ),
                                      //
                                      //                       ],
                                      //                     ),
                                      //                   ],
                                      //                 ),
                                      //
                                      //               ],
                                      //
                                      //             ),
                                      //
                                      //           ],
                                      //         ),
                                      //       ),
                                      //     ),
                                      //     Container(
                                      //       padding: const EdgeInsets.only(left:20,right:20,top:0,bottom:5),
                                      //       child:Divider(
                                      //         color: Colors.grey,
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ),
                                    ),
                                  )


                                ],
                              ),

                              // Builder(builder: (context) {
                              //   return  GestureDetector(
                              //     onTap:(){
                              //       // Scaffold.of(context).openEndDrawer();
                              //       setState(() {
                              //         PageViewDemo.of(context)!.showWheel();
                              //       });
                              //     },
                              //     child:Padding(
                              //       padding: const EdgeInsets.only(top:100),
                              //       child: Align(
                              //         alignment: Alignment.centerRight,
                              //         child:Container(
                              //           // height:MediaQuery.of(context).size.height ,
                              //           width: 5.0.w,
                              //           decoration: BoxDecoration(
                              //             // color:Colors.black,
                              //             image: DecorationImage(
                              //               image: AssetImage("images/sidewheel.png"),
                              //               //fit: BoxFit.cover,
                              //             ),
                              //           ),
                              //         ),
                              //       ),
                              //     ),
                              //   );
                              // }),
                            ],
                          ),

                          // endDrawer:
                          //     MyNavWheel(),
                          // Padding(
                          //   padding: const EdgeInsets.only(top:100),
                          //   child:
                          //   Transform.scale(
                          //     scale:
                          //     (MediaQuery.of(context).size.height / 600),
                          //     child:CircleList(
                          //
                          //       // showInitialAnimation: true,
                          //       rotateMode:RotateMode.allRotate,
                          //       innerCircleColor:Color(0xFF2CBFC6),
                          //       outerCircleColor:Color(0xFF2CBFC6),
                          //       origin: Offset(50.0.w, 0),
                          //       children: [
                          //         Container(),
                          //         Container(),
                          //         Container(),
                          //         Container(),
                          //         Container(),
                          //         Container(),
                          //
                          //         Image(image: AssetImage('images/menu_settings.png'),height:30),
                          //         GestureDetector(
                          //           onTap:(){
                          //             Navigator.push(
                          //                 context,
                          //                 MaterialPageRoute(
                          //                     builder: (context) => CameraScreen()));
                          //           },
                          //           child: Image(image: AssetImage('images/menu_camera.png'),height:30),
                          //         ),
                          //
                          //         GestureDetector(
                          //           onTap:(){
                          //             Navigator.pushReplacement(
                          //                 context,
                          //                 MaterialPageRoute(
                          //                     builder: (context) => Homepage()));
                          //           },
                          //           child: Image(image: AssetImage('images/menu_home.png'),height:35),
                          //         ),
                          //         GestureDetector(
                          //           onTap:(){
                          //             Navigator.push(
                          //                 context,
                          //                 MaterialPageRoute(
                          //                     builder: (context) => CravingsPage()));
                          //           },
                          //           child: Image(image: AssetImage('images/menu_cravings.png'),height:30),
                          //         ),
                          //
                          //         GestureDetector(
                          //           onTap:(){
                          //             Navigator.push(
                          //                 context,
                          //                 MaterialPageRoute(
                          //                     builder: (context) => ReelsDetails()));
                          //           },
                          //           child:Image(image: AssetImage('images/menu_reels.png'),height:35),
                          //         ),
                          //
                          //         GestureDetector(
                          //           onTap:(){
                          //             Navigator.push(
                          //                 context,
                          //                 MaterialPageRoute(
                          //                     builder: (context) => ProfileUser()));
                          //           },
                          //           child:Image(image: AssetImage('images/menu_me.png'),height:35),
                          //         ),
                          //
                          //         GestureDetector(
                          //           onTap:(){
                          //             Navigator.pushReplacement(
                          //                 context,
                          //                 MaterialPageRoute(
                          //                     builder: (context) => ChatPage()));
                          //           },
                          //           child: Image(image: AssetImage('images/menu_chat.png'),height:30),
                          //         ),
                          //
                          //         GestureDetector(
                          //           onTap:(){
                          //             Navigator.pushReplacement(
                          //                 context,
                          //                 MaterialPageRoute(
                          //                     builder: (context) => NotificationsPage()));
                          //           },
                          //           child: Image(image: AssetImage('images/menu_bell.png'),height:40),
                          //         ),
                          //
                          //         Container(),
                          //         Container(),
                          //         Container(),
                          //         Container(),
                          //
                          //       ],
                          //     ),
                          //   ),
                          //
                          //
                          //   // Transform(
                          //   //   alignment: Alignment.center,
                          //   //   transform: Matrix4.rotationY(math.pi),
                          //   //   child:  CircleListScrollView(
                          //   //     // controller: _scrollController,
                          //   //     // controller: _controllerFixed,
                          //   //     physics: CircleFixedExtentScrollPhysics(),
                          //   //     axis: Axis.vertical,
                          //   //     itemExtent: 65,
                          //   //     // children: List.generate(20, _buildItem),
                          //   //     children: [
                          //   //       Transform(
                          //   //         alignment: Alignment.center,
                          //   //         transform: Matrix4.rotationY(math.pi),
                          //   //         child:
                          //   //         TextButton(
                          //   //           onPressed: () {
                          //   //             Navigator.pushReplacement(
                          //   //                 context,
                          //   //                 MaterialPageRoute(
                          //   //                     builder: (context) => NotificationsPage()));
                          //   //           },
                          //   //
                          //   //           child: Text("TEXT BUTTON",style: TextStyle(
                          //   //               fontWeight: FontWeight.w700,
                          //   //               color: Colors.white,
                          //   //               fontSize: 10.0.sp)),
                          //   //         ),
                          //   //
                          //   //       ),
                          //   //
                          //   //       Transform(
                          //   //         alignment: Alignment.center,
                          //   //         transform: Matrix4.rotationY(math.pi),
                          //   //         child:
                          //   //         GestureDetector(
                          //   //           onTap:(){
                          //   //             Navigator.pushReplacement(
                          //   //                               context,
                          //   //                               MaterialPageRoute(
                          //   //                                   builder: (context) => NotificationsPage()));
                          //   //           },
                          //   //           child: Center(
                          //   //             child: Container(
                          //   //                 padding: EdgeInsets.all(5),
                          //   //                 child: Image(image: AssetImage('images/menu_chat.png'),height:40)
                          //   //             ),
                          //   //           ),
                          //   //         ),
                          //   //
                          //   //       ),
                          //   //       Transform(
                          //   //         alignment: Alignment.center,
                          //   //         transform: Matrix4.rotationY(math.pi),
                          //   //         child:  Center(
                          //   //           child: Container(
                          //   //               padding: EdgeInsets.all(5),
                          //   //               child: Image(image: AssetImage('images/menu_chat.png'),height:40)
                          //   //           ),
                          //   //         ),
                          //   //       ),
                          //   //       Transform(
                          //   //         alignment: Alignment.center,
                          //   //         transform: Matrix4.rotationY(math.pi),
                          //   //         child:  Center(
                          //   //           child: Container(
                          //   //               padding: EdgeInsets.all(5),
                          //   //               child: Image(image: AssetImage('images/menu_switch_account.png'),height:80)
                          //   //           ),
                          //   //         ),
                          //   //       ),
                          //   //       Transform(
                          //   //         alignment: Alignment.center,
                          //   //         transform: Matrix4.rotationY(math.pi),
                          //   //         child:  Center(
                          //   //           child: Container(
                          //   //               padding: EdgeInsets.all(5),
                          //   //               child: Image(image: AssetImage('images/menu_me.png'),height:50)
                          //   //           ),
                          //   //         ),
                          //   //       ),
                          //   //       Transform(
                          //   //         alignment: Alignment.center,
                          //   //         transform: Matrix4.rotationY(math.pi),
                          //   //         child:
                          //   //         Center(
                          //   //           child: Container(
                          //   //               padding: EdgeInsets.all(5),
                          //   //               child: Image(image: AssetImage('images/menu_reels.png'),height:50)
                          //   //           ),
                          //   //         ),
                          //   //
                          //   //       ),
                          //   //
                          //   //       Transform(
                          //   //         alignment: Alignment.center,
                          //   //         transform: Matrix4.rotationY(math.pi),
                          //   //         child:  Center(
                          //   //           child: Container(
                          //   //               padding: EdgeInsets.all(5),
                          //   //               child: Image(image: AssetImage('images/menu_cravings.png'),height:50)
                          //   //           ),
                          //   //         ),
                          //   //       ),
                          //   //       Transform(
                          //   //         alignment: Alignment.center,
                          //   //         transform: Matrix4.rotationY(math.pi),
                          //   //         child:  Center(
                          //   //           child: Container(
                          //   //               padding: EdgeInsets.all(5),
                          //   //               child: Image(image: AssetImage('images/menu_home.png'),height:50)
                          //   //           ),
                          //   //         ),
                          //   //       ),
                          //   //       Transform(
                          //   //         alignment: Alignment.center,
                          //   //         transform: Matrix4.rotationY(math.pi),
                          //   //         child:  Center(
                          //   //           child: Container(
                          //   //               padding: EdgeInsets.all(5),
                          //   //               child: Image(image: AssetImage('images/menu_camera.png'),height:40)
                          //   //           ),
                          //   //         ),
                          //   //       ),
                          //   //       Transform(
                          //   //         alignment: Alignment.center,
                          //   //         transform: Matrix4.rotationY(math.pi),
                          //   //         child:  Center(
                          //   //           child: Container(
                          //   //               padding: EdgeInsets.all(5),
                          //   //               child: Image(image: AssetImage('images/menu_run_ads.png'),height:40)
                          //   //           ),
                          //   //         ),
                          //   //       ),
                          //   //       Transform(
                          //   //         alignment: Alignment.center,
                          //   //         transform: Matrix4.rotationY(math.pi),
                          //   //         child:  Center(
                          //   //           child: Container(
                          //   //               padding: EdgeInsets.all(5),
                          //   //               child: Image(image: AssetImage('images/menu_settings.png'),height:50)
                          //   //           ),
                          //   //         ),
                          //   //       ),
                          //   //     ],
                          //   //     radius: MediaQuery.of(context).size.width * 0.6,
                          //   //     onSelectedItemChanged: (index){
                          //   //       onChangedMenu(index);
                          //   //       print('Current index: $index');
                          //   //     },
                          //   //
                          //   //   ),
                          //   //
                          //   // ),
                          // ),
                          // drawerScrimColor: Colors.transparent,
                          // drawerEdgeDragWidth: MediaQuery.of(context).size.width,
                        ),
                      );
                    });
              }
          );
        }
    );

  }
}


