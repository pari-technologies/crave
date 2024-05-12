// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:a_crave/profileUser.dart';
import 'package:a_crave/reels.dart';
import 'package:a_crave/reelsDetails.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';

import 'package:sizer/sizer.dart';
import 'constants.dart' as constant;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'dataClass.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import "package:async/async.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';


class ChatDetailPage extends StatefulWidget {
  final PageController chatPageController;
  final String selectedChatroom;
  const ChatDetailPage({Key? key, required this.chatPageController, required this.selectedChatroom}) : super(key: key);

  @override
  ChatDetailPageState createState() => ChatDetailPageState();
}

class ChatDetailPageState extends State<ChatDetailPage> {

  final textController = TextEditingController();
  int currentTab = 0;
  List<ChatContent> returnedChatContent = [];
  String user_email = "";
  String recordFilePath = "";
  bool isPlayingMsg = false, isRecording = false, isSending = false;
  int i = 0;
  late File tmpFile;
  bool hasPermission = false;

  final ImagePicker _picker = ImagePicker();
  late CameraDescription firstCamera;
  late File imagePath = File('');
  late XFile? image;
  late XFile? photo;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => startLoad());
  }

  void startLoad() async {
    loadChatContent();
    hasPermission = await checkPermission();

    Future.delayed(const Duration(milliseconds: 500), () {

      _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut
      );

    });


  }

  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = storageDirectory.path + "/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: false);
    }
    return sdPath + "/${DateTime.now().millisecondsSinceEpoch}.mp3";
  }

  void startRecord() async {
    print("startttt");
    if (hasPermission) {
      Fluttertoast.showToast(
          msg: "Recording...",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );
      recordFilePath = await getFilePath();
      print("startttt permission OK");
      RecordMp3.instance.start(recordFilePath, (type) {
        setState(() {
          print("startttt rcorddd");
        });
      });
    } else {}
    setState(() {});
  }

  void stopRecord() async {
    print("stopppp ");
    bool s = RecordMp3.instance.stop();
    print(s);
    if (s) {
      Fluttertoast.showToast(
          msg: "Sending audio...",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );
      setState(() {
        isSending = true;
        print("audio file ");
        print(recordFilePath);
      });
      await uploadAudio();

      setState(() {
        isPlayingMsg = false;
      });
    }
  }

  Future<void> play() async {
    if (recordFilePath != null && File(recordFilePath).existsSync()) {
      AudioPlayer audioPlayer = AudioPlayer();
      await audioPlayer.play(
        recordFilePath,
        isLocal: true,
      );
    }
  }

  showAlertDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content:  Row(
        children: [
          const CircularProgressIndicator(),
          // Container(margin: const EdgeInsets.only(left: 5),child:const Text("Loading")),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

  Future<http.Response> loadChatContent() async {
    showAlertDialog(this.context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user_email = prefs.getString('user_email')!;
    });

    var url = Uri.parse(constant.Url.crave_url+'get_chat_content.php');
    // returnedEvent.clear();
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        "email":prefs.getString('user_email'),
        "chatroom_id":this.widget.selectedChatroom,
      },
    );

    if (response.statusCode == 200) {
      // print("get response body carlist");
      print(response.body);

      Map<String, dynamic> user = jsonDecode(response.body);

      if(user['chat_content'] != null){

        List<dynamic> body = user['chat_content'];

        List<ChatContent> chatcontent = body
            .map(
              (dynamic item) => ChatContent.fromJson(item),
        ).toList();

        setState(() {
          //isCarAvailable = true;
          print(chatcontent);
          returnedChatContent = chatcontent;
        });
        Navigator.of(this.context, rootNavigator: true).pop('dialog');
      }
      else{

      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
    return response;
  }

  Future<http.Response> sendChatText() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user_email = prefs.getString('user_email')!;
    });

    var url = Uri.parse(constant.Url.crave_url+'send_chat_text.php');
    // returnedEvent.clear();
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        "email":prefs.getString('user_email'),
        "chatroom_id":this.widget.selectedChatroom,
        "text":textController.text,
      },
    );

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
        loadChatContent();
        setState(() {
          textController.text = "";
        });
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
    return response;
  }

  Future uploadAudio() async{
// ignore: deprecated_member_use
    showAlertDialog(this.context);
    var stream= new http.ByteStream(DelegatingStream.typed(File(recordFilePath).openRead()));
    var length= await File(recordFilePath).length();
    var uri = Uri.parse(constant.Url.crave_url+'send_chat_audio.php');

    tmpFile = File(recordFilePath);
    String fileName = tmpFile.path.split('/').last;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var request = new http.MultipartRequest("POST", uri);

    var multipartFile = new http.MultipartFile("audio", stream, length, filename: basename(File(recordFilePath).path));

    request.files.add(multipartFile);
    request.fields['email'] = prefs.getString('user_email')!;
    request.fields['chatroom_id'] = this.widget.selectedChatroom;
    request.fields['filename'] = fileName;


    var respond = await request.send();
    if(respond.statusCode==200){
      Navigator.of(this.context, rootNavigator: true).pop('dialog');
      print("Audio Uploaded");
      loadChatContent();
    }else{
      Navigator.of(this.context, rootNavigator: true).pop('dialog');
      print("Upload Failed");
    }
  }

  void playAudio(String url) async {
    final player = AudioPlayer();
    await player.setUrl(url);
    player.play(url);
  }

  void getCameraImg() async {
    print("aksbdkasbd");
    photo = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      print("aksbdkasbd 222");
      imagePath = File(photo!.path);
      Future.delayed(const Duration(milliseconds: 1000), () {
        sendImageChat();
      });
    });
  }

  void getGalleryImg() async {
    image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imagePath = File(image!.path);
      Future.delayed(const Duration(milliseconds: 1000), () {
        sendImageChat();
      });

    });
  }

  Future sendImageChat() async{
// ignore: deprecated_member_use
    print("upladdd");
    showAlertDialog(this.context);
    var stream= new http.ByteStream(DelegatingStream.typed(imagePath.openRead()));
    var length= await imagePath.length();
    var uri = Uri.parse(constant.Url.crave_url+'send_chat_image.php');
    tmpFile = imagePath;
    String fileName = tmpFile.path.split('/').last;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var request = new http.MultipartRequest("POST", uri);

    var multipartFile = new http.MultipartFile("image", stream, length, filename: basename(imagePath.path));

    request.files.add(multipartFile);
    request.fields['email'] = prefs.getString('user_email')!;
    request.fields['chatroom_id'] = this.widget.selectedChatroom;
    request.fields['filename'] = fileName;

    var respond = await request.send();
    if(respond.statusCode==200){
      Navigator.of(this.context, rootNavigator: true).pop('dialog');
      print("Image Uploaded");
      loadChatContent();
    }else{
      Navigator.of(this.context, rootNavigator: true).pop('dialog');
      print("Upload Failed");
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
                          // resizeToAvoidBottomInset: false,
                          backgroundColor: Colors.white,
                          body:
                              SingleChildScrollView(
                                child:
                                Container(
                                  height:100.0.h,
                                  child:Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(20),
                                            bottomLeft: Radius.circular(20),
                                          ),
                                          border: Border.all(
                                            width: 2,
                                            color: Color(constant.Color.crave_grey),
                                            style: BorderStyle.solid,
                                          ),
                                        ),
                                        padding: const EdgeInsets.only(left:20,bottom:20,right:20,top:60),
                                        margin: EdgeInsets.only(bottom:20),
                                        child:Column(
                                          children: [
                                            Row(
                                              children: [
                                                returnedChatContent[0].p1_email != user_email?
                                                CircleAvatar(
                                                  radius: 22.0,
                                                  backgroundImage:
                                                  NetworkImage(constant.Url.profile_url+returnedChatContent[0].p1_profile_img),
                                                  backgroundColor: Colors.transparent,
                                                ):
                                                CircleAvatar(
                                                  radius: 22.0,
                                                  backgroundImage:
                                                  NetworkImage(constant.Url.profile_url+returnedChatContent[0].p2_profile_img),
                                                  backgroundColor: Colors.transparent,
                                                ),

                                                Container(
                                                  width:60.0.w,
                                                  padding:EdgeInsets.only(left:10),
                                                  child:
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      returnedChatContent[0].p1_email != user_email?
                                                      Text(returnedChatContent[0].p1_name,
                                                          style: TextStyle(
                                                              color: Color(constant.Color.crave_brown),
                                                              fontWeight: FontWeight.w700,
                                                              fontSize: 14.0.sp)):
                                                      Text(returnedChatContent[0].p2_name,
                                                          style: TextStyle(
                                                              color: Color(constant.Color.crave_brown),
                                                              fontWeight: FontWeight.w700,
                                                              fontSize: 14.0.sp)),

                                                    ],
                                                  ),

                                                ),
                                                Spacer(),
                                                Image.asset(
                                                  'images/menu_burger.png',
                                                  height: 2.0.h,
                                                ),
                                              ],

                                            ),

                                          ],
                                        ),
                                      ),
                                      Container(
                                        height:65.0.h,
                                        child:MediaQuery.removePadding(
                                          removeTop: true,
                                          context: context,
                                          child:ListView.builder(
                                            controller: _scrollController,
                                            shrinkWrap: true,
                                            itemCount: returnedChatContent.length,
                                            //physics: NeverScrollableScrollPhysics(),
                                            // crossAxisCount: 2,
                                            // // mainAxisSpacing: 10.0,
                                            // crossAxisSpacing: 10.0,
                                            // childAspectRatio: aspectRatio,
                                            itemBuilder: (context, index) {
                                              return

                                                returnedChatContent[index].sender_id != user_email?
                                                returnedChatContent[index].chat_type == "text"?
                                                Container(
                                                  //color:Colors.black,
                                                  padding: const EdgeInsets.only(
                                                      left: 20,
                                                      bottom: 10,
                                                      right: 20,
                                                      top: 10),
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .end,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets
                                                            .only(
                                                            bottom: 5, right: 5),
                                                        child:
                                                        returnedChatContent[0].p1_email != user_email?
                                                        CircleAvatar(
                                                          radius: 22.0,
                                                          backgroundImage:
                                                          NetworkImage(constant.Url.profile_url+returnedChatContent[0].p1_profile_img),
                                                          backgroundColor: Colors.transparent,
                                                        ):
                                                        CircleAvatar(
                                                          radius: 22.0,
                                                          backgroundImage:
                                                          NetworkImage(constant.Url.profile_url+returnedChatContent[0].p2_profile_img),
                                                          backgroundColor: Colors.transparent,
                                                        ),
                                                        // Image.asset(
                                                        //   'images/user1.png',
                                                        //   height: 3.5.h,
                                                        // ),
                                                      ),
                                                      Card(
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius
                                                              .only(
                                                              bottomRight: Radius
                                                                  .circular(10),
                                                              topLeft: Radius
                                                                  .circular(10)),
                                                        ),
                                                        child: Padding(
                                                          padding: EdgeInsets.all(
                                                              15),
                                                          child: Text(
                                                              returnedChatContent[index].chat_content,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 10.0
                                                                      .sp)),
                                                        ),

                                                      ),

                                                    ],

                                                  ),
                                                ):
                                                returnedChatContent[index].chat_type == "audio"?
                                                Container(
                                                  //color:Colors.black,
                                                  padding: const EdgeInsets.only(
                                                      left: 20,
                                                      bottom: 10,
                                                      right: 20,
                                                      top: 10),
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .end,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets
                                                            .only(
                                                            bottom: 5, right: 5),
                                                        child:
                                                        returnedChatContent[0].p1_email != user_email?
                                                        CircleAvatar(
                                                          radius: 22.0,
                                                          backgroundImage:
                                                          NetworkImage(constant.Url.profile_url+returnedChatContent[0].p1_profile_img),
                                                          backgroundColor: Colors.transparent,
                                                        ):
                                                        CircleAvatar(
                                                          radius: 22.0,
                                                          backgroundImage:
                                                          NetworkImage(constant.Url.profile_url+returnedChatContent[0].p2_profile_img),
                                                          backgroundColor: Colors.transparent,
                                                        ),
                                                        // Image.asset(
                                                        //   'images/user1.png',
                                                        //   height: 3.5.h,
                                                        // ),
                                                      ),
                                                      Card(
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius
                                                              .only(
                                                              bottomRight: Radius
                                                                  .circular(10),
                                                              topLeft: Radius
                                                                  .circular(10)),
                                                        ),
                                                        child: Padding(
                                                          padding: EdgeInsets.all(
                                                              15),
                                                          child: GestureDetector(
                                                            onTap:(){
                                                              playAudio(constant.Url.audio_url+returnedChatContent[index].chat_content);
                                                            },
                                                            child:Container(
                                                              height:18,
                                                              width:100,
                                                              child: Text('Play audio',
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.w700,
                                                                      color: Color(constant.Color.crave_brown),
                                                                      fontSize: 11.0.sp)),
                                                            ),
                                                          ),

                                                        ),

                                                      ),

                                                    ],

                                                  ),
                                                ):
                                                returnedChatContent[index].chat_type == "image"?
                                                Container(
                                                  //color:Colors.black,
                                                  padding: const EdgeInsets.only(
                                                      left: 20,
                                                      bottom: 10,
                                                      right: 20,
                                                      top: 10),
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .end,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets
                                                            .only(
                                                            bottom: 5, right: 5),
                                                        child:
                                                        returnedChatContent[0].p1_email != user_email?
                                                        CircleAvatar(
                                                          radius: 22.0,
                                                          backgroundImage:
                                                          NetworkImage(constant.Url.profile_url+returnedChatContent[0].p1_profile_img),
                                                          backgroundColor: Colors.transparent,
                                                        ):
                                                        CircleAvatar(
                                                          radius: 22.0,
                                                          backgroundImage:
                                                          NetworkImage(constant.Url.profile_url+returnedChatContent[0].p2_profile_img),
                                                          backgroundColor: Colors.transparent,
                                                        ),
                                                        // Image.asset(
                                                        //   'images/user1.png',
                                                        //   height: 3.5.h,
                                                        // ),
                                                      ),
                                                      Card(
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius
                                                              .only(
                                                              bottomRight: Radius
                                                                  .circular(10),
                                                              topLeft: Radius
                                                                  .circular(10)),
                                                        ),
                                                        child: Padding(
                                                          padding: EdgeInsets.all(
                                                              15),
                                                          child: Container(
                                                            height:100,
                                                            width:80,
                                                            child: Image.network(constant.Url.chat_image_url+returnedChatContent[index].chat_content, fit: BoxFit.cover),
                                                          ),
                                                        ),

                                                      ),

                                                    ],

                                                  ),
                                                ):
                                                Container(
                                                  //color:Colors.black,
                                                  padding: const EdgeInsets.only(
                                                      left: 20,
                                                      bottom: 10,
                                                      right: 20,
                                                      top: 10),
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .end,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets
                                                            .only(
                                                            bottom: 5, right: 5),
                                                        child:
                                                        returnedChatContent[0].p1_email != user_email?
                                                        CircleAvatar(
                                                          radius: 22.0,
                                                          backgroundImage:
                                                          NetworkImage(constant.Url.profile_url+returnedChatContent[0].p1_profile_img),
                                                          backgroundColor: Colors.transparent,
                                                        ):
                                                        CircleAvatar(
                                                          radius: 22.0,
                                                          backgroundImage:
                                                          NetworkImage(constant.Url.profile_url+returnedChatContent[0].p2_profile_img),
                                                          backgroundColor: Colors.transparent,
                                                        ),
                                                        // Image.asset(
                                                        //   'images/user1.png',
                                                        //   height: 3.5.h,
                                                        // ),
                                                      ),
                                                      Card(
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius
                                                              .only(
                                                              bottomRight: Radius
                                                                  .circular(10),
                                                              topLeft: Radius
                                                                  .circular(10)),
                                                        ),
                                                        child: Padding(
                                                          padding: EdgeInsets.all(
                                                              15),
                                                          child: Container(
                                                            height:100,
                                                            width:80,
                                                            child: Image.network(constant.Url.media_url+returnedChatContent[index].chat_content, fit: BoxFit.cover),
                                                          ),
                                                        ),

                                                      ),

                                                    ],

                                                  ),
                                                )

                                                    :
                                                returnedChatContent[index].chat_type == "text"?
                                                Container(
                                                  //color:Colors.black,
                                                  padding: const EdgeInsets.only(left:20,bottom:10,right:20),
                                                  child:Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Card(
                                                        color:Color(0xFFF2F2F2),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.only(
                                                              bottomLeft: Radius.circular(10),
                                                              topRight: Radius.circular(10)),
                                                        ),
                                                        child: Padding(
                                                          padding:EdgeInsets.all(15),
                                                          child:Text(returnedChatContent[index].chat_content,
                                                              style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontSize: 10.0.sp)),
                                                        ),

                                                      ),

                                                    ],

                                                  ),
                                                ):
                                                returnedChatContent[index].chat_type == "audio"?
                                                Container(
                                                  //color:Colors.black,
                                                  padding: const EdgeInsets.only(left:20,bottom:10,right:20),
                                                  child:Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Card(
                                                        color:Color(0xFFF2F2F2),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.only(
                                                              bottomLeft: Radius.circular(10),
                                                              topRight: Radius.circular(10)),
                                                        ),
                                                        child: Padding(
                                                          padding:EdgeInsets.all(15),
                                                          child:GestureDetector(
                                                            onTap:(){
                                                              playAudio(constant.Url.audio_url+returnedChatContent[index].chat_content);
                                                            },
                                                            child:Container(
                                                              height:18,
                                                              width:100,
                                                              child: Text('Play audio',
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.w700,
                                                                      color: Color(constant.Color.crave_brown),
                                                                      fontSize: 11.0.sp)),
                                                            ),
                                                          ),
                                                        ),

                                                      ),

                                                    ],

                                                  ),
                                                ):
                                                returnedChatContent[index].chat_type == "image"?
                                                Container(
                                                  //color:Colors.black,
                                                  padding: const EdgeInsets.only(left:20,bottom:10,right:20),
                                                  child:Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Card(
                                                        color:Color(0xFFF2F2F2),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.only(
                                                              bottomLeft: Radius.circular(10),
                                                              topRight: Radius.circular(10)),
                                                        ),
                                                        child: Padding(
                                                          padding:EdgeInsets.all(15),
                                                          child:Container(
                                                            height:100,
                                                            width:80,
                                                            child: Image.network(constant.Url.chat_image_url+returnedChatContent[index].chat_content, fit: BoxFit.cover),
                                                          ),
                                                        ),

                                                      ),

                                                    ],

                                                  ),
                                                ):
                                                Container(
                                                  //color:Colors.black,
                                                  padding: const EdgeInsets.only(left:20,bottom:10,right:20),
                                                  child:Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Card(
                                                        color:Color(0xFFF2F2F2),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.only(
                                                              bottomLeft: Radius.circular(10),
                                                              topRight: Radius.circular(10)),
                                                        ),
                                                        child: Padding(
                                                          padding:EdgeInsets.all(15),
                                                          child:Container(
                                                            height:100,
                                                            width:80,
                                                            child: Image.network(constant.Url.media_url+returnedChatContent[index].chat_content, fit: BoxFit.cover),
                                                          ),
                                                        ),

                                                      ),

                                                    ],

                                                  ),
                                                );
                                              // Container(
                                              //   //color:Colors.black,
                                              //   padding: const EdgeInsets.only(left:20,bottom:10,right:20),
                                              //   child:Row(
                                              //     mainAxisAlignment: MainAxisAlignment.end,
                                              //     crossAxisAlignment: CrossAxisAlignment.end,
                                              //     children: [
                                              //       Card(
                                              //         color:Color(0xFFF2F2F2),
                                              //         shape: RoundedRectangleBorder(
                                              //           borderRadius: BorderRadius.only(
                                              //               bottomLeft: Radius.circular(10),
                                              //               topRight: Radius.circular(10)),
                                              //         ),
                                              //         child: Padding(
                                              //           padding:EdgeInsets.all(15),
                                              //           child:Text('Nopeee',
                                              //               style: TextStyle(
                                              //                   color: Colors.black,
                                              //                   fontSize: 10.0.sp)),
                                              //         ),
                                              //
                                              //       ),
                                              //
                                              //     ],
                                              //
                                              //   ),
                                              // ),

                                              // Container(
                                              //   //color:Colors.black,
                                              //   padding: const EdgeInsets.only(left:20,bottom:10,right:20),
                                              //   child:Row(
                                              //     mainAxisAlignment: MainAxisAlignment.end,
                                              //     crossAxisAlignment: CrossAxisAlignment.end,
                                              //     children: [
                                              //       Card(
                                              //         color:Color(0xFFF2F2F2),
                                              //         shape: RoundedRectangleBorder(
                                              //           borderRadius: BorderRadius.only(
                                              //               bottomLeft: Radius.circular(10),
                                              //               topRight: Radius.circular(10)),
                                              //         ),
                                              //         child: Padding(
                                              //           padding:EdgeInsets.all(15),
                                              //           child:Text('Not now anyways',
                                              //               style: TextStyle(
                                              //                   color: Colors.black,
                                              //                   fontSize: 10.0.sp)),
                                              //         ),
                                              //
                                              //       ),
                                              //
                                              //     ],
                                              //
                                              //   ),
                                              // ),

                                              // Padding(
                                              //   padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                                              //   child:IntrinsicHeight(
                                              //     child: Row(
                                              //       mainAxisAlignment: MainAxisAlignment.end,
                                              //       children: [
                                              //         Text("SEEN",
                                              //             style: TextStyle(
                                              //                 color: currentTab==0?Colors.black:Color(0xFFDEDDDD),
                                              //                 fontSize: 8.0.sp)),
                                              //         SizedBox(
                                              //           width:1.0.w,
                                              //         ),
                                              //         Container(
                                              //           //padding: const EdgeInsets.only(top:15,bottom:15),
                                              //           child:VerticalDivider(
                                              //               color:Colors.grey
                                              //           ),
                                              //         ),
                                              //         SizedBox(
                                              //           width:1.0.w,
                                              //         ),
                                              //         Text("11:45 AM",
                                              //             style: TextStyle(
                                              //                 color: Color(0xFFDEDDDD),
                                              //                 fontSize: 8.0.sp)),
                                              //
                                              //
                                              //
                                              //       ],
                                              //     ),
                                              //   ),
                                              // ),

                                            },
                                          ),
                                        ),
                                      ),

                                      Spacer(),

                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child:Container(
                                          //width:250,
                                          height:50,
                                          margin: const EdgeInsets.only(bottom: 10.0,top:10),
                                          padding: const EdgeInsets.only(left: 30.0, right: 30.0,bottom:10),
                                          child:TextField(
                                            autofocus: false,
                                            controller: textController,
                                            cursorColor: Colors.black,
                                            keyboardType: TextInputType.text,
                                            textInputAction: TextInputAction.go,
                                            textCapitalization: TextCapitalization.sentences,
                                            decoration: InputDecoration(
                                                counterText: '',
                                                filled: true,
                                                // Color(0xFFD6D6D6)
                                                fillColor: Color(0xFFF2F2F2),
                                                // fillColor: Colors.black,
                                                contentPadding:EdgeInsets.symmetric(horizontal: 15,vertical:10),
                                                labelStyle: TextStyle(
                                                    fontSize: 14,
                                                    color:Colors.black
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color:Color(0xFFF2F2F2) ),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(20.0),
                                                  borderSide: BorderSide(color:Color(0xFFF2F2F2) ),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color:Color(0xFFF2F2F2), ),
                                                ),
                                                prefixIcon:
                                                GestureDetector(
                                                  onTap:(){
                                                    getCameraImg();
                                                  },
                                                  child:Icon(
                                                    Icons.photo_camera,
                                                    color: Colors.black,
                                                    size: 25.0,
                                                  ),
                                                ),


                                                suffixIcon:
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
                                                  mainAxisSize: MainAxisSize.min, // added line
                                                  children: <Widget>[
                                                    GestureDetector(
                                                      onLongPress: () {
                                                        startRecord();
                                                        setState(() {
                                                          isRecording = true;
                                                        });
                                                      },
                                                      onLongPressEnd: (details) {
                                                        stopRecord();
                                                        setState(() {
                                                          isRecording = false;
                                                        });
                                                      },
                                                      child:Container(
                                                        color:Colors.transparent,
                                                        padding: const EdgeInsets.only(bottom:5,top:5,left:10,right:10),
                                                        child:Image.asset(
                                                          'images/icon_chat_mic.png',
                                                          height: 2.3.h,
                                                        ),
                                                      ),
                                                    ),

                                                    SizedBox(width:5),
                                                    GestureDetector(
                                                      onTap:(){
                                                        getGalleryImg();
                                                      },
                                                      child:Container(
                                                        color:Colors.transparent,
                                                        padding: const EdgeInsets.only(bottom:5,top:5,left:10,right:10),
                                                        child:Image.asset(
                                                          'images/icon_chat_img.png',
                                                          height: 2.3.h,
                                                        ),
                                                      ),
                                                    ),

                                                    SizedBox(width:5),
                                                    GestureDetector(
                                                      onTap:(){
                                                        sendChatText();
                                                      },
                                                      child:Container(
                                                        color:Colors.transparent,
                                                        padding: const EdgeInsets.only(bottom:5,top:5,left:10,right:10),
                                                        child:Image.asset(
                                                          'images/icon_chat_send.png',
                                                          height: 2.3.h,
                                                        ),
                                                      ),
                                                    ),

                                                    SizedBox(width:5),
                                                  ],
                                                ),
                                                // Icon(
                                                //   Icons.search,
                                                //   color: Colors.grey,
                                                //   size: 20.0,
                                                // ),
                                                hintText: "Type a message"),
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


