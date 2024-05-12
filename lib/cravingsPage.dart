// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:a_crave/chatDetailPage.dart';
import 'package:a_crave/profileUser.dart';
import 'package:a_crave/reels.dart';
import 'package:a_crave/reelsDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart' as constant;
import 'dart:math' as math;
import 'package:circle_list/circle_list.dart';
import 'camera_screen.dart';
import 'chatPage.dart';
import 'circle_wheel_scroll/circle_wheel_scroll_view.dart';
import 'cravingsFollowing.dart';
import 'dataClass.dart';
import 'homeBase.dart';
import 'homepage.dart';
import 'notificationsPage.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui' as ui;
import 'custom_marker/lib/marker_icon.dart';
import 'profileBusiness.dart';

class CravingsPage extends StatefulWidget {
  const CravingsPage({Key? key}) : super(key: key);

  @override
  CravingsPageState createState() => CravingsPageState();
}

class CravingsPageState extends State<CravingsPage> {

  final topCraveSearchController = TextEditingController();
  final discoverSearchController = TextEditingController();
  final followingSearchController = TextEditingController();
  // final GlobalKey genKey = GlobalKey();

  late BitmapDescriptor icon;
  bool isMapVisible = true;
  int currentTab = 1;
  double currentlat = 3.1390;
  double currentlng = 101.6869;

  bool isShowCravings1 = false;
  bool isShowCravings2 = false;
  bool isShowCravings3 = false;

  List<bool> isShowCravings = [];

  List<Media> returnedMedia = [];
  List<Media> topCraveMedia = [];
  List<Media> discoverMedia = [];

  List returnedFollowingList = [];
  List followingMedia = [];

  String imgurl = "";

  // Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
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

  late GoogleMapController _controller;

  static CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(3.1390,101.6869),
    zoom: 12,
  );

  static final CameraPosition _kGooglePlexPopup = CameraPosition(
    target: LatLng(3.1390,101.6869),
    zoom: 12,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(3.1390,101.6869),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  List<Marker> _markersB = <Marker>[];
  List<Marker> _markers = <Marker>[];

  // getIcons() async {
  //   BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
  //       'images/comment_icon.png')
  //       .then((d) async {
  //         print("this is iconnn");
  //     this.icon = d;
  //   });
  //
  //
  //   // BitmapDescriptor.fromAssetImage(
  //   //     ImageConfiguration(size: Size(10, 10)), 'images/comment_icon.png')
  //   //     .then((onValue) {
  //   //   this.icon = onValue;
  //   //   loadMarkers();
  //   // });
  //
  //   // var icon = await BitmapDescriptor.fromAssetImage(
  //   //     ImageConfiguration(size: Size(2, 2)),
  //   //     "images/comment_icon.png");
  //   // setState(() {
  //   //   this.icon = icon;
  //   //   loadMarkers();
  //   // });
  // }

  Future<void> _onMapCreated(GoogleMapController _cntlr) async {
    Position position = await _determinePosition();
    _cntlr.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(currentlat, currentlng),zoom: 12),
        ),
      );

  }

  Future<void> loadMarkers() async {
    // Position position = await _determinePosition();
    _markers.add(
        Marker(
            markerId: MarkerId('0'),
            position: LatLng(currentlat,currentlng),
            // icon:  icon,
        )
    );

    _markersB.add(
        Marker(
          markerId: MarkerId('0'),
          position: LatLng(currentlat,currentlng),
          // icon:  icon,
        )
    );
  }

  Future<void> loadMarkersPlaces(double lat, double lng,String url,String id) async {

    _markers.add(
        // Marker(
        //   markerId: MarkerId(id),
        //   position: LatLng(lat,lng),
        //   icon: BitmapDescriptor.fromBytes(bytes)
        //   // icon:  icon,
        // )
        Marker(
            markerId: MarkerId(id),
            position: LatLng(lat,lng),
          icon: await MarkerIcon.downloadResizePictureCircle(
              url,
            size: 180,
            addBorder: false,

          ),
    )
          // icon:  icon,

    );

    _markersB.add(
      // Marker(
      //   markerId: MarkerId(id),
      //   position: LatLng(lat,lng),
      //   icon: BitmapDescriptor.fromBytes(bytes)
      //   // icon:  icon,
      // )
        Marker(
          markerId: MarkerId(id),
          position: LatLng(lat,lng),
          icon: await MarkerIcon.downloadResizePictureCircle(
              url,
              size: 180,
              addBorder: false,

          ),
        )
      // icon:  icon,

    );

    // _markersB.add(
    //     Marker(
    //       markerId: MarkerId(id),
    //       position: LatLng(lat,lng),
    //       icon: BitmapDescriptor.fromBytes(bytes)
    //       // icon:  icon,
    //     )
    // );

  }

  void getLocation() async{
    Position position = await _determinePosition();
    setState(() {
      currentlat = position.latitude;
      currentlng = position.longitude;
      print("curentl attaa");
      print(currentlat);
      print(currentlng);
    });
  }

  Future<List<Media>> loadMedia() async {
    //getLocation();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentlat = prefs.getDouble('lat')!;
    currentlng =  prefs.getDouble('lng')!;

    if(currentlat == 3.1390 && currentlng == 101.6869){
      getLocation();
    }

    var url = Uri.parse(constant.Url.crave_url+'get_top_crave.php');
    returnedMedia.clear();
    topCraveMedia.clear();
    _markers.clear();
    _markersB.clear();
    // loadMarkers();
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        "email":prefs.getString('user_email'),
      },
    );

    if (response.statusCode == 200) {
      // print("get response body carlist");
      print(response.body);

      Map<String, dynamic> user = jsonDecode(response.body);

      if(user['media'] != null){

        List<dynamic> body = user['media'];

        List<Media> media = body
            .map(
              (dynamic item) => Media.fromJson(item),
        ).toList();

        List<Media> dummymedia = body
            .map(
              (dynamic item) => Media.fromJson(item),
        ).toList();

        setState(() {
          //isCarAvailable = true;
          // returnedMedia = media;
          // topCraveMedia = dummymedia;

          for(int i =0;i<media.length;i++){
           if(calculateDistance(media[i].media_latlng)<=10.0 && media[i].post_craving != "0"){
             print(media[i].user_display_name);
             returnedMedia.add(media[i]);
             topCraveMedia.add(dummymedia[i]);
           }

          }

          // loadMarkers();
          for(int i =0;i<media.length;i++){
            if(calculateDistance(media[i].media_latlng)<=10.0){
              loadMarkerMedia(media[i],(i+1).toString());
            }

          }
        });

        //suggestions = location;
        // print("--avaialbel carr---");
        // print(returnedMedia);

        topCraveMedia.sort((a, b) => int.parse(b.post_craving).compareTo(int.parse(a.post_craving)));

        returnedMedia.sort((a, b) => int.parse(b.post_craving).compareTo(int.parse(a.post_craving)));

        return returnedMedia;
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

  Future<List<Media>> loadMediaSearch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var url = Uri.parse(constant.Url.crave_url+'get_top_crave.php');
    returnedMedia.clear();
    topCraveMedia.clear();

    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        "email":prefs.getString('user_email'),
      },
    );

    if (response.statusCode == 200) {
      // print("get response body carlist");
      print(response.body);

      Map<String, dynamic> user = jsonDecode(response.body);

      if(user['media'] != null){

        List<dynamic> body = user['media'];

        List<Media> media = body
            .map(
              (dynamic item) => Media.fromJson(item),
        ).toList();

        setState(() {
          //isCarAvailable = true;
          returnedMedia = media;
          topCraveMedia = media;

          topCraveMedia.sort((a, b) => int.parse(a.post_craving).compareTo(int.parse(b.post_craving)));

          returnedMedia.sort((a, b) => int.parse(a.post_craving).compareTo(int.parse(b.post_craving)));
        });

        //suggestions = location;
        // print("--avaialbel carr---");
        // print(returnedMedia);
        return returnedMedia;
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

  Future<List<Media>> loadMediaDiscover() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    currentlat = prefs.getDouble('lat')!;
    currentlng =  prefs.getDouble('lng')!;

    if(currentlat == 3.1390 && currentlng == 101.6869){
      getLocation();
    }

    var url = Uri.parse(constant.Url.crave_url+'get_discover_crave.php');
    returnedMedia.clear();
    discoverMedia.clear();
    _markers.clear();
    _markersB.clear();
    // loadMarkers();
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        "email":prefs.getString('user_email'),
      },
    );

    if (response.statusCode == 200) {
      // print("get response body carlist");
      print(response.body);

      Map<String, dynamic> user = jsonDecode(response.body);

      if(user['media'] != null){

        List<dynamic> body = user['media'];

        List<Media> media = body
            .map(
              (dynamic item) => Media.fromJson(item),
        ).toList();

        List<Media> dummymedia = body
            .map(
              (dynamic item) => Media.fromJson(item),
        ).toList();

        setState(() {
          //isCarAvailable = true;
          returnedMedia = media;
          discoverMedia = dummymedia;

          // loadMarkers();
          for(int i =0;i<media.length;i++){
            loadMarkerMedia(media[i],(i+1).toString());
          }
        });

        //suggestions = location;
        // print("--avaialbel carr---");
        // print(returnedMedia);
        return returnedMedia;
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

  Future<List<Media>> loadMediaDiscoverSearch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var url = Uri.parse(constant.Url.crave_url+'get_discover_crave.php');
    returnedMedia.clear();
    discoverMedia.clear();
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        "email":prefs.getString('user_email'),
      },
    );

    if (response.statusCode == 200) {
      // print("get response body carlist");
      print(response.body);

      Map<String, dynamic> user = jsonDecode(response.body);

      if(user['media'] != null){

        List<dynamic> body = user['media'];

        List<Media> media = body
            .map(
              (dynamic item) => Media.fromJson(item),
        ).toList();

        setState(() {
          //isCarAvailable = true;
          returnedMedia = media;
          discoverMedia = media;
        });

        //suggestions = location;
        // print("--avaialbel carr---");
        // print(returnedMedia);
        return returnedMedia;
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

  Future<void> loadMediaFollowing() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(currentlat == 3.1390 && currentlng == 101.6869){
      getLocation();
    }

    var url = Uri.parse(constant.Url.crave_url+'get_following_crave.php');

    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        "email":prefs.getString('user_email'),
      },
    );

    if (response.statusCode == 200) {
      // print("get response body carlist");
      print(response.body);

      Map<String, dynamic> user = jsonDecode(response.body);

      if(user['following_crave'] != null){

        final followingCrave = followingCraveFromJson(response.body);
        final dummyFollowingCrave = followingCraveFromJson(response.body);

        setState(() {
          //isCarAvailable = true;
          returnedFollowingList = followingCrave.followingCrave;
          followingMedia = dummyFollowingCrave.followingCrave;

          print("asbdakhsbdk");
          print(returnedFollowingList.length);

          for(int i=0;i<followingCrave.followingCrave.length;i++){
            isShowCravings.add(false);
          }
        });

        //suggestions = location;
        // print("--avaialbel carr---");
        // print(returnedMedia);
        // return returnedFollowingList;
      }
      else{
        setState(() {
          // isCarAvailable = false;
          //carList.;
        });

        // return [];
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }

  }

  Future<void> loadMarkerMedia(Media media,String id) async {
    //setState(() {
      String imgurl = constant.Url.thumbnail_url+media.media_name;
    //});

    Uint8List bytes = (await NetworkAssetBundle(Uri.parse(imgurl))
        .load(imgurl))
        .buffer
        .asUint8List();

    // Uint8List bytes = _capturePng() as Uint8List;

    final splitNames= media.media_latlng.split(',');
    // _capturePng(double.parse(splitNames[0]),double.parse(splitNames[1]),id);
    loadMarkersPlaces(double.parse(splitNames[0]),double.parse(splitNames[1]),imgurl,id);
  }

  String getDistance(latlng){
    String distance = "0";
    final new_dis = latlng.split(',');

    double distanceInMeters = Geolocator.distanceBetween(currentlat, currentlng, double.parse(new_dis[0]), double.parse(new_dis[1]));

    distance = (distanceInMeters/1000).toStringAsFixed(2).toString();
    return distance+" km";

  }

  double calculateDistance(latlng){
    double distance = 0.0;
    final new_dis = latlng.split(',');

    double distanceInMeters = Geolocator.distanceBetween(currentlat, currentlng, double.parse(new_dis[0]), double.parse(new_dis[1]));

    distance = distanceInMeters/1000;
    return distance;

  }

  void launchWaze(latlng) async {
    final new_dis = latlng.split(',');
    var url = 'waze://?ll=${new_dis[0]},${new_dis[1]}';
    var fallbackUrl =
        'https://waze.com/ul?ll=${new_dis[0]},${new_dis[1]}&navigate=yes';
    try {
      bool launched =
      await launch(url, forceSafariVC: false, forceWebView: false);
      if (!launched) {
        await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
      }
    } catch (e) {
      await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
    }
  }

  void launchGoogleMaps(latlng) async {
    final new_dis = latlng.split(',');
    var url = 'google.navigation:q=${new_dis[0]},${new_dis[1]}';
    var fallbackUrl =
        'https://www.google.com/maps/search/?api=1&query=${new_dis[0]},${new_dis[1]}';
    try {
      bool launched =
      await launch(url, forceSafariVC: false, forceWebView: false);
      if (!launched) {
        await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
      }
    } catch (e) {
      await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
    }
  }

  void showTravel(latlng){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius:
                BorderRadius.circular(20.0),
                ),
              child: Container(
                padding: EdgeInsets.only(left:20.0,right:20.0),
                margin : EdgeInsets.only(left:20.0,right:20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('How would you like to get there?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                           fontSize: 20,
                        fontWeight:FontWeight.w600
                      ),
                    ),
                    SizedBox(height:20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap:(){
                            launchGoogleMaps(latlng);
                          },
                          child:ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Image.asset('images/gmaps_icon.png',height: 60.0),
                          ),
                        ),

                        SizedBox(width:20),
                        GestureDetector(
                          onTap:(){
                            launchWaze(latlng);
                          },
                          child:ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Image.asset('images/waze_icon.png',height: 60.0),
                          ),
                        ),


                      ],
                    ),
                    SizedBox(height:20),
                    GestureDetector(
                      onTap:(){
                        Navigator.pop(context);
                      },
                      child:SizedBox(
                          width: 320.0,
                          child: Text('Nevermind',
                              textAlign: TextAlign.center,
                              style:TextStyle(
                                color:Colors.white,
                                fontSize: 18,
                                decoration: TextDecoration.underline,
                              ))
                      )
                    ),

                  ],
                ),
              ),
            ),
          );
        });
  }


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) =>  loadMedia());
  }


  void goToComments() {
    setState(() {
      Navigator.of(context).pushNamed("/feedDetails");
    });
  }

  void goToCravingsPage(pageNo){
    if(pageNo == "1"){
      setState(() {
        currentTab = 1;
        loadMedia();
      });
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => CravingsPage()));
    }
    else if(pageNo == "2"){
      setState(() {
        currentTab = 2;
        loadMediaDiscover();
      });
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => CravingsPage()));
    }
    else if(pageNo == "3"){
      setState(() {
        currentTab = 3;
        loadMediaFollowing();
      });
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => CravingsFollowing()));
    }

  }

  void onShowCravings(index){
    setState(() {
      isShowCravings[index] = !isShowCravings[index];
    });
  }

  void filterSearchTopCraves(String query) {
    print(query);
    print(topCraveMedia.length);
    List<Media> dummySearchList = [];
    dummySearchList.addAll(topCraveMedia);
    if(query.isNotEmpty) {
      List<Media> dummyListData = [];
      dummySearchList.forEach((item) {
        if(item.user_display_name.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        returnedMedia.clear();
        returnedMedia.addAll(dummyListData);
      });
      // return;
    } else {
      setState(() {
        returnedMedia.clear();
        returnedMedia.addAll(topCraveMedia);
      });
    }
  }

  void filterSearchDiscover(String query) {
    print(query);
    print(discoverMedia.length);
    List<Media> dummySearchList = [];
    dummySearchList.addAll(discoverMedia);
    if(query.isNotEmpty) {
      List<Media> dummyListData = [];
      dummySearchList.forEach((item) {
        if(item.user_display_name.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        returnedMedia.clear();
        returnedMedia.addAll(dummyListData);
      });
      // return;
    } else {
      setState(() {
        returnedMedia.clear();
        returnedMedia.addAll(discoverMedia);
        // loadMediaDiscoverSearch();
      });
    }
  }

  void filterSearchFollowing(String query) {
    print(query);
    print(followingMedia.length);
    List dummySearchList = [];
    dummySearchList.addAll(followingMedia);
    if(query.isNotEmpty) {
      List dummyListData = [];
      dummySearchList.forEach((item) {
        item.FollowMedia.forEach((itemF) {
          if(itemF.cDisplayName.contains(query)) {
            dummyListData.add(item);
          }
        });
        // if(item.cDisplayName.contains(query)) {
        //   dummyListData.add(item);
        // }
      });
      setState(() {
        followingMedia.clear();
        followingMedia.addAll(dummyListData);
      });
      // return;
    } else {
      setState(() {
        followingMedia.clear();
        followingMedia.addAll(followingMedia);
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
                        home: GestureDetector(
                          onHorizontalDragUpdate: (details) {
                            // Note: Sensitivity is integer used when you don't want to mess up vertical drag
                            int sensitivity = 10;
                            if (details.delta.dx > sensitivity) {
                              // Right Swipe
                              print("is wheel shown");
                              print(details.delta.dx);
                              if(PageViewDemo.of(context)!.isShowWheel){
                                PageViewDemo.of(context)!.hideWheel();
                              }
                              print("swipe right");
                            } else if(details.delta.dx < -sensitivity){
                              //Left Swipe
                              if(!PageViewDemo.of(context)!.isShowWheel){
                                PageViewDemo.of(context)!.showWheel();
                              }
                              print("swipe left");
                            }
                          },
                          child: Scaffold(
                            // appBar: AppBar(
                            //   backgroundColor: Colors.white,
                            //   automaticallyImplyLeading: false,
                            //   actions: <Widget>[Container()],
                            //   title: Image.asset('images/crave_logo_word.png',height: 40,),
                            //   centerTitle: true,
                            // ),
                            backgroundColor: Colors.white,
                            body:
                            Stack(
                              children: <Widget>[

                                // RepaintBoundary(
                                //   key: genKey,
                                //   child: ClipRRect(
                                //     borderRadius: BorderRadius.circular(15.0),
                                //     child: Image.network(
                                //       imgurl,
                                //       height: 50,
                                //       width: 80,
                                //       fit: BoxFit.cover,
                                //     ),
                                //   ),
                                // ),
                                Column(
                                  children: [
                                    SafeArea(
                                        bottom: false,
                                      child:Container(
                                          padding: const EdgeInsets.only(
                                              top: 50.0,bottom:20,left:20),
                                          width:MediaQuery.of(context).size.width,
                                          child:Text("CRAVES",
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  color: Color(constant.Color.crave_brown),
                                                  fontSize: 16.0.sp))
                                      ),
                                    ),

                                    // isMapVisible?
                                    Padding(
                                      padding: const EdgeInsets.only(left: 30.0, right: 30.0,bottom:15),
                                      child:IntrinsicHeight(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            GestureDetector(
                                              onTap:(){
                                                goToCravingsPage("1");
                                              },
                                              child:Text("TOP CRAVES",
                                                  style: TextStyle(
                                                      color: currentTab==1?Colors.black:Color(0xFFDEDDDD),
                                                      fontSize: 11.0.sp)),
                                            ),
                                            SizedBox(
                                              width:2.0.w,
                                            ),
                                            Container(
                                              //padding: const EdgeInsets.only(top:15,bottom:15),
                                              child:VerticalDivider(
                                                  color:Colors.grey
                                              ),
                                            ),
                                            SizedBox(
                                              width:2.0.w,
                                            ),
                                            GestureDetector(
                                              onTap:(){
                                                goToCravingsPage("2");
                                              },
                                              child:Text("DISCOVER",
                                                  style: TextStyle(
                                                      color: currentTab==2?Colors.black:Color(0xFFDEDDDD),
                                                      fontSize: 11.0.sp)),
                                            ),
                                            SizedBox(
                                              width:2.0.w,
                                            ),
                                            Container(
                                              // padding: const EdgeInsets.only(top:15,bottom:15),
                                              child:VerticalDivider(
                                                  color:Colors.grey
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap:(){
                                                goToCravingsPage("3");
                                              },
                                              child:Text("FOLLOWING",
                                                  style: TextStyle(
                                                      color: currentTab==3?Colors.black:Color(0xFFDEDDDD),
                                                      fontSize: 11.0.sp)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // :
                                    // Card(
                                    //     margin:EdgeInsets.zero,
                                    //   shape: RoundedRectangleBorder(
                                    //     borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                    //   ),
                                    //   child:Padding(
                                    //           padding: const EdgeInsets.only(left: 30.0, right: 30.0,bottom:15),
                                    //           child:IntrinsicHeight(
                                    //             child: Row(
                                    //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    //               children: [
                                    //                 GestureDetector(
                                    //                   onTap:(){
                                    //                     goToCravingsPage("1");
                                    //                   },
                                    //                   child:Text("TOP CRAVES",
                                    //                       style: TextStyle(
                                    //                           color: currentTab==1?Colors.black:Color(0xFFDEDDDD),
                                    //                           fontSize: 11.0.sp)),
                                    //                 ),
                                    //                 SizedBox(
                                    //                   width:2.0.w,
                                    //                 ),
                                    //                 Container(
                                    //                   //padding: const EdgeInsets.only(top:15,bottom:15),
                                    //                   child:VerticalDivider(
                                    //                       color:Colors.grey
                                    //                   ),
                                    //                 ),
                                    //                 SizedBox(
                                    //                   width:2.0.w,
                                    //                 ),
                                    //                 GestureDetector(
                                    //                   onTap:(){
                                    //                     goToCravingsPage("2");
                                    //                   },
                                    //                   child:Text("DISCOVER",
                                    //                       style: TextStyle(
                                    //                           color: currentTab==2?Colors.black:Color(0xFFDEDDDD),
                                    //                           fontSize: 11.0.sp)),
                                    //                 ),
                                    //                 SizedBox(
                                    //                   width:2.0.w,
                                    //                 ),
                                    //                 Container(
                                    //                   // padding: const EdgeInsets.only(top:15,bottom:15),
                                    //                   child:VerticalDivider(
                                    //                       color:Colors.grey
                                    //                   ),
                                    //                 ),
                                    //                 GestureDetector(
                                    //                   onTap:(){
                                    //                     goToCravingsPage("3");
                                    //                   },
                                    //                   child:Text("FOLLOWING",
                                    //                       style: TextStyle(
                                    //                           color: currentTab==3?Colors.black:Color(0xFFDEDDDD),
                                    //                           fontSize: 11.0.sp)),
                                    //                 ),
                                    //               ],
                                    //             ),
                                    //           ),
                                    //         ),
                                    // ),
                                    

                                    currentTab==1?
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child:Column(
                                          children: [
                                            VisibilityDetector(
                                              key: Key('gmapsKey'),
                                              onVisibilityChanged: (visibilityInfo) {
                                                var visiblePercentage = visibilityInfo.visibleFraction * 100;
                                                if(visiblePercentage==0.0){
                                                  setState(() {
                                                    isMapVisible = false;
                                                  });
                                                }
                                                else if(visiblePercentage > 10.0){
                                                  setState(() {
                                                    isMapVisible = true;
                                                  });
                                                }
                                                debugPrint(
                                                    'Widget ${visibilityInfo.key} is ${visiblePercentage}% visible');
                                              },
                                              child:Card(
                                                  margin:EdgeInsets.zero,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                                ),
                                                child:Container(
                                                  height:50.0.h,
                                                  // decoration: BoxDecoration(
                                                  //   borderRadius: BorderRadius.only(
                                                  //     bottomRight: Radius.circular(20),
                                                  //     bottomLeft: Radius.circular(20),
                                                  //   ),
                                                  //   border: Border.all(
                                                  //     width: 2,
                                                  //     color: Color(constant.Color.crave_grey),
                                                  //     style: BorderStyle.solid,
                                                  //   ),
                                                  // ),
                                                  padding: const EdgeInsets.only(left:15,right:15,bottom:20),
                                                  child:GoogleMap(
                                                    mapType: MapType.normal,
                                                    zoomControlsEnabled: true,
                                                    myLocationButtonEnabled: false,
                                                    markers: Set<Marker>.of(_markersB),
                                                    initialCameraPosition: _kGooglePlex,
                                                    onMapCreated: (GoogleMapController controller) {
                                                      _onMapCreated(controller);
                                                    },
                                                  ),

                                                ),
                                              ),

                                            ),

                                            Container(
                                              //width:250,
                                              height:40,
                                              margin: const EdgeInsets.only(bottom: 20.0,top:20),
                                              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                              child:TextField(
                                                autofocus: false,
                                                controller: topCraveSearchController,
                                                cursorColor: Colors.black,
                                                keyboardType: TextInputType.text,
                                                textInputAction: TextInputAction.go,
                                                textCapitalization: TextCapitalization.sentences,
                                                onChanged:(value){
                                                  filterSearchTopCraves(value);
                                                },
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
                                                      size: 20.0,
                                                    ),
                                                    hintText: "Search"),
                                              ),
                                            ),

                                            Container(
                                              child:MediaQuery.removePadding(
                                                removeTop: true,
                                                context: context,
                                                child:
                                                ListView.builder(
                                                  // the number of items in the list
                                                    itemCount: returnedMedia.length,
                                                    shrinkWrap: true,
                                                    physics: NeverScrollableScrollPhysics(),
                                                    // display each item of the product list
                                                    itemBuilder: (context, index) {
                                                      return
                                                        Column(
                                                          children: [
                                                            GestureDetector(
                                                              onTap:(){
                                                                // showTravelTo(returnedMedia[index].media_latlng);
                                                                showTravel(returnedMedia[index].media_latlng);
                                                              },
                                                              child:Container(
                                                                color:Colors.transparent,
                                                                padding: const EdgeInsets.only(left:20,bottom:10,right:20),
                                                                child:Column(
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        ClipRRect(
                                                                          borderRadius: BorderRadius.circular(10.0),
                                                                          child: Image.network(
                                                                            constant.Url.media_url+returnedMedia[index].media_name,
                                                                            height: 6.0.h,
                                                                            width:13.0.w,
                                                                            fit: BoxFit.cover,
                                                                          ),
                                                                        ),


                                                                        // Image.asset(
                                                                        //   'images/food1.png',
                                                                        //   height: 5.5.h,
                                                                        // ),

                                                                        Container(
                                                                          width:50.0.w,
                                                                          padding:EdgeInsets.only(left:10),
                                                                          child:
                                                                          Column(
                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(returnedMedia[index].user_display_name,
                                                                                  style: TextStyle(
                                                                                      color: Color(constant.Color.crave_brown),
                                                                                      fontWeight: FontWeight.w600,
                                                                                      fontSize: 12.0.sp)),
                                                                              SizedBox(height:0.5.h),
                                                                              Text(returnedMedia[index].media_desc,
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
                                                                                  child:Text(returnedMedia[index].post_craving,
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
                                                                                  child:Text(getDistance(returnedMedia[index].media_latlng),
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
                                                              padding: const EdgeInsets.only(left:5,right:5,top:0,bottom:5),
                                                              child:Divider(
                                                                color: Colors.grey,
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                    }),

                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ):
                                    currentTab==2?
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child:Column(
                                          children: [
                                            VisibilityDetector(
                                              key: Key('gmapsKey'),
                                              onVisibilityChanged: (visibilityInfo) {
                                                var visiblePercentage = visibilityInfo.visibleFraction * 100;
                                                if(visiblePercentage==0.0){
                                                  setState(() {
                                                    isMapVisible = false;
                                                  });
                                                }
                                                else if(visiblePercentage > 10.0){
                                                  setState(() {
                                                    isMapVisible = true;
                                                  });
                                                }
                                                debugPrint(
                                                    'Widget ${visibilityInfo.key} is ${visiblePercentage}% visible');
                                              },
                                              child:Card(
                                                margin:EdgeInsets.zero,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                                ),
                                                child:Container(
                                                  height:50.0.h,
                                                  // decoration: BoxDecoration(
                                                  //   borderRadius: BorderRadius.only(
                                                  //     bottomRight: Radius.circular(20),
                                                  //     bottomLeft: Radius.circular(20),
                                                  //   ),
                                                  //   border: Border.all(
                                                  //     width: 2,
                                                  //     color: Color(constant.Color.crave_grey),
                                                  //     style: BorderStyle.solid,
                                                  //   ),
                                                  // ),
                                                  padding: const EdgeInsets.only(left:15,right:15,bottom:20),
                                                  child:GoogleMap(
                                                    mapType: MapType.normal,
                                                    zoomControlsEnabled: true,
                                                    myLocationButtonEnabled: false,
                                                    markers: Set<Marker>.of(_markersB),
                                                    initialCameraPosition: _kGooglePlex,
                                                    onMapCreated: (GoogleMapController controller) {
                                                      _onMapCreated(controller);
                                                    },
                                                  ),

                                                ),
                                              ),

                                            ),

                                            Container(
                                              //width:250,
                                              height:40,
                                              margin: const EdgeInsets.only(bottom: 20.0,top:20),
                                              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                              child:TextField(
                                                autofocus: false,
                                                controller: discoverSearchController,
                                                cursorColor: Colors.black,
                                                keyboardType: TextInputType.text,
                                                textInputAction: TextInputAction.go,
                                                textCapitalization: TextCapitalization.sentences,
                                                onChanged:(value){
                                                  filterSearchDiscover(value);
                                                },
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
                                                      size: 20.0,
                                                    ),
                                                    hintText: "Search"),
                                              ),
                                            ),

                                            Container(
                                              child:MediaQuery.removePadding(
                                                removeTop: true,
                                                context: context,
                                                child:
                                                ListView.builder(
                                                  // the number of items in the list
                                                    itemCount: returnedMedia.length,
                                                    shrinkWrap: true,
                                                    physics: NeverScrollableScrollPhysics(),
                                                    // display each item of the product list
                                                    itemBuilder: (context, index) {
                                                      return
                                                        Column(
                                                          children: [
                                                            GestureDetector(
                                                              onTap:(){
                                                                // showTravelTo(returnedMedia[index].media_latlng);
                                                                showTravel(returnedMedia[index].media_latlng);
                                                              },
                                                              child:Container(
                                                                //color:Colors.black,
                                                                padding: const EdgeInsets.only(left:20,bottom:10,right:20),
                                                                child:Column(
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        ClipRRect(
                                                                          borderRadius: BorderRadius.circular(8.0),
                                                                          child: Image.network(
                                                                            constant.Url.media_url+returnedMedia[index].media_name,
                                                                            height: 6.0.h,
                                                                            width:13.0.w,
                                                                            fit: BoxFit.cover,
                                                                          ),
                                                                        ),


                                                                        // Image.asset(
                                                                        //   'images/food1.png',
                                                                        //   height: 5.5.h,
                                                                        // ),

                                                                        Container(
                                                                          width:50.0.w,
                                                                          padding:EdgeInsets.only(left:10),
                                                                          child:
                                                                          Column(
                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(returnedMedia[index].user_display_name,
                                                                                  style: TextStyle(
                                                                                      color: Color(constant.Color.crave_brown),
                                                                                      fontWeight: FontWeight.w600,
                                                                                      fontSize: 12.0.sp)),
                                                                              SizedBox(height:0.5.h),
                                                                              Text(returnedMedia[index].media_desc,
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
                                                                                  child:Text(returnedMedia[index].post_craving,
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
                                                                                  child:Text(getDistance(returnedMedia[index].media_latlng),
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
                                                              padding: const EdgeInsets.only(left:5,right:5,top:0,bottom:5),
                                                              child:Divider(
                                                                color: Colors.grey,
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                    }),

                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ):

                                    Expanded(
                                      child: SingleChildScrollView(
                                        child:Column(
                                          children: [
                                            Container(
                                              //width:250,
                                              height:40,
                                              margin: const EdgeInsets.only(bottom: 20.0,top:15),
                                              padding: const EdgeInsets.only(left:20.0, right: 20.0),
                                              child:TextField(
                                                autofocus: false,
                                                controller: followingSearchController,
                                                cursorColor: Colors.black,
                                                keyboardType: TextInputType.text,
                                                textInputAction: TextInputAction.go,
                                                textCapitalization: TextCapitalization.sentences,
                                                onChanged:(value){
                                                  filterSearchFollowing(value);
                                                },
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
                                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                                      borderSide: BorderSide(color:Color(0xFFF2F2F2) ),
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                                      borderSide: BorderSide(color:Color(0xFFF2F2F2) ),
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                                      borderSide: BorderSide(color:Color(0xFFF2F2F2), ),
                                                    ),
                                                    suffixIcon: Icon(
                                                      Icons.search,
                                                      color: Colors.grey,
                                                      size: 20.0,
                                                    ),
                                                    hintText: "Search"),
                                              ),
                                            ),
                                            Container(
                                              child:MediaQuery.removePadding(
                                                removeTop: true,
                                                context: context,
                                                child:
                                                ListView.builder(
                                                  // the number of items in the list
                                                    itemCount: returnedFollowingList.length,
                                                    shrinkWrap: true,
                                                    physics: NeverScrollableScrollPhysics(),
                                                    // display each item of the product list
                                                    itemBuilder: (context, index) {
                                                      return
                                                        Column(
                                                          children: [
                                                            GestureDetector(
                                                              onTap:(){
                                                                onShowCravings(index);
                                                              },
                                                              child:Container(
                                                                color:Colors.transparent,
                                                                padding: const EdgeInsets.only(left:20,bottom:0,right:20),
                                                                child:Column(
                                                                  children: [
                                                                    Row(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Image.network(
                                                                          constant.Url.profile_url+returnedFollowingList[index].cProfileImg,
                                                                          height: 6.0.h,
                                                                          fit: BoxFit.fitHeight,
                                                                        ),
                                                                        // Image.asset(
                                                                        //   'images/user_square1.png',
                                                                        //   height: 6.0.h,
                                                                        // ),
                                                                        Container(
                                                                          width:50.0.w,
                                                                          padding:EdgeInsets.only(left:10),
                                                                          child:
                                                                          Column(
                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              SizedBox(height:1.0.h),
                                                                              Text(returnedFollowingList[index].cDisplayName,
                                                                                  style: TextStyle(
                                                                                      color: Colors.black,
                                                                                      fontWeight: FontWeight.w700,
                                                                                      fontSize: 12.0.sp)),
                                                                              SizedBox(height:0.5.h),
                                                                              Text(returnedFollowingList[index].followMedia[0].cMediaDesc,
                                                                                  maxLines: 1,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  style: TextStyle(
                                                                                      color: Colors.black,
                                                                                      fontSize: 10.0.sp)),

                                                                            ],
                                                                          ),

                                                                        ),
                                                                        Spacer(),
                                                                        Column(
                                                                          children: [
                                                                            SizedBox(height:1.0.h),
                                                                            Text('0',
                                                                                style: TextStyle(
                                                                                    color:Colors.black,
                                                                                    fontWeight: FontWeight.w700,
                                                                                    fontSize: 10.0.sp)),
                                                                          ],
                                                                        ),

                                                                        SizedBox(
                                                                            width:2.0.w
                                                                        ),
                                                                        Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                                          children: [
                                                                            SizedBox(height:1.0.h),
                                                                            Image.asset(
                                                                              'images/crave_logo.jpg',
                                                                              height: 2.0.h,
                                                                            ),
                                                                            isShowCravings[index]?
                                                                            SizedBox(
                                                                                width:20,
                                                                                child:Icon(Icons.keyboard_arrow_up)
                                                                            )
                                                                                :
                                                                            SizedBox(
                                                                                width:20,
                                                                                child:Icon(Icons.keyboard_arrow_down)
                                                                            )
                                                                            // Icon(Icons.keyboard_arrow_down,)

                                                                          ],
                                                                        ),
                                                                      ],

                                                                    ),

                                                                  ],
                                                                ),
                                                              ),
                                                            ),

                                                            Visibility(
                                                              visible:isShowCravings[index],
                                                              child:
                                                              Container(
                                                                //color:Colors.black,
                                                                height:15.0.h,
                                                                padding: const EdgeInsets.only(left:40,bottom:00,right:20,top:10),
                                                                child:
                                                                ListView.builder(
                                                                    itemCount: returnedFollowingList[index].followMedia.length,
                                                                    shrinkWrap: true,
                                                                itemBuilder: (context, indexF) {
                                                                  return Column(
                                                                  children: [
                                                                    Row(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Image.network(
                                                                          constant.Url.media_url+returnedFollowingList[index].followMedia[indexF].cMediaName,
                                                                          height: 4.0.h,
                                                                          width:5.0.h,
                                                                          fit: BoxFit.cover,
                                                                        ),
                                                                        Container(
                                                                          width:50.0.w,
                                                                          padding:EdgeInsets.only(left:10),
                                                                          child:
                                                                          Column(
                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              SizedBox(height:0.5.h),
                                                                              Text(returnedFollowingList[index].followMedia[indexF].cDisplayName,
                                                                                  style: TextStyle(
                                                                                      color: Colors.black,
                                                                                      fontWeight: FontWeight.w700,
                                                                                      fontSize: 8.0.sp)),
                                                                              SizedBox(height:0.5.h),
                                                                              Text(returnedFollowingList[index].followMedia[indexF].cMediaDesc,
                                                                                  maxLines: 1,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  style: TextStyle(
                                                                                      color: Colors.black,
                                                                                      fontSize: 7.0.sp)),

                                                                            ],
                                                                          ),

                                                                        ),
                                                                        Spacer(),
                                                                        Column(
                                                                          children: [
                                                                            SizedBox(height:1.0.h),
                                                                            Row(
                                                                                children:[
                                                                                  Text(returnedFollowingList[index].followMedia[indexF].postCraving,
                                                                                      style: TextStyle(
                                                                                          color:Colors.black,
                                                                                          fontWeight: FontWeight.w600,
                                                                                          fontSize: 9.0.sp)),
                                                                                  SizedBox(
                                                                                      width:1.0.w
                                                                                  ),
                                                                                  Image.asset(
                                                                                    'images/crave_logo.jpg',
                                                                                    height:1.5.h,
                                                                                  ),
                                                                                ]
                                                                            ),

                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                            width:3.0.w
                                                                        ),
                                                                        Column(
                                                                          children: [
                                                                            SizedBox(height:1.0.h),
                                                                            Row(
                                                                                children:[
                                                                                  Text(getDistance(returnedFollowingList[index].followMedia[indexF].cMediaLatlng),
                                                                                      style: TextStyle(
                                                                                          color:Colors.black,
                                                                                          fontWeight: FontWeight.w600,
                                                                                          fontSize: 9.0.sp)),
                                                                                  SizedBox(
                                                                                      width:1.0.w
                                                                                  ),
                                                                                  Image.asset(
                                                                                    'images/icon_location_camera.png',
                                                                                    color:Colors.grey,
                                                                                    height:1.5.h,
                                                                                  ),
                                                                                ]
                                                                            ),

                                                                          ],
                                                                        ),
                                                                      ],

                                                                    ),
                                                                    SizedBox(height:1.0.h),

                                                                  ],
                                                                );
                                                              })
                                                              ),
                                                                      ),


                                                            Container(
                                                              padding: const EdgeInsets.only(left:5,right:5,top:0,bottom:5),
                                                              child:Divider(
                                                                color: Colors.grey,
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                    }),

                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),

                                  ],
                                ),

                                // isMapVisible?
                                Container(height:0, width:0)
                                    // :
                                // Align(
                                //   alignment: Alignment.bottomLeft,
                                //   child:Container(
                                //     margin: const EdgeInsets.only(left:15,bottom:20),
                                //     height:28.0.h,
                                //     width:33.0.w,
                                //     child:Card(
                                //       shape: RoundedRectangleBorder(
                                //         borderRadius: BorderRadius.circular(5.0),
                                //       ),
                                //       elevation:10,
                                //       child:ClipRRect(
                                //         borderRadius: BorderRadius.only(
                                //           topLeft: Radius.circular(5),
                                //           topRight: Radius.circular(5),
                                //           bottomRight: Radius.circular(5),
                                //           bottomLeft: Radius.circular(5),
                                //         ),
                                //         child:GoogleMap(
                                //           mapType: MapType.normal,
                                //           markers: Set<Marker>.of(_markers),
                                //           myLocationButtonEnabled: false,
                                //           initialCameraPosition: _kGooglePlexPopup,
                                //           onMapCreated: (GoogleMapController controller) {
                                //             _onMapCreated(controller);
                                //           },
                                //         ),
                                //       ),
                                //
                                //     ),
                                //   ),
                                //
                                // ),

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



