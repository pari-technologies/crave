// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'profileSetupPalette.dart';
import "package:async/async.dart";
import 'package:path/path.dart';
import 'package:a_crave/takeProfilePicture.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:sizer/sizer.dart';
import 'constants.dart' as constant;
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';


class ProfileSetupPicture extends StatefulWidget {
  const ProfileSetupPicture({Key? key}) : super(key: key);

  @override
  ProfileSetupPictureState createState() => ProfileSetupPictureState();
}

class ProfileSetupPictureState extends State<ProfileSetupPicture> {
  final ImagePicker _picker = ImagePicker();
  late CameraDescription firstCamera;
  late File imagePath = File('');
  late File tmpFile;
  late XFile? image;
  late XFile? photo;

  void goToSetupPalette(String pathname) async {

    // imagePath = image.path;

    Navigator.pushReplacement(
      this.context,
      MaterialPageRoute(builder: (context) => ProfileSetupPalette(image_path: pathname)),
    );
    // setState(() {
    //   Navigator.of(this.context).pushNamed("/profileSetupPalette");
    // });
  }

  void getCameraImg() async {
    print("aksbdkasbd");
    photo = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      print("aksbdkasbd 222");
      imagePath = File(photo!.path);
      Future.delayed(const Duration(milliseconds: 1000), () {
        sendProfileImg();
      });
    });
  }

  void getGalleryImg() async {
    image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imagePath = File(image!.path);
      Future.delayed(const Duration(milliseconds: 1000), () {
        sendProfileImg();
      });

    });
  }


  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => loadProfile());

  }

  Future<void> loadProfile() async {
    // Ensure that plugin services are initialized so that `availableCameras()`
    // can be called before `runApp()`
    WidgetsFlutterBinding.ensureInitialized();

    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

    // Get a specific camera from the list of available cameras.
    firstCamera = cameras.first;
  }

  // A method that launches the SelectionScreen and awaits the result from
  // Navigator.pop.
  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TakeProfilePicture(camera: firstCamera)),
    );

    // When a BuildContext is used from a StatefulWidget, the mounted property
    // must be checked after an asynchronous gap.
    if (!mounted) return;

    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.
    // ScaffoldMessenger.of(context)
    //   ..removeCurrentSnackBar()
    //   ..showSnackBar(SnackBar(content: Text('$result')));
    setState(() {
      imagePath = result;
    });
    print(result);
  }

  Future sendProfileImg() async{
// ignore: deprecated_member_use
  print("upladdd");
    showAlertDialog(this.context);
    var stream= new http.ByteStream(DelegatingStream.typed(imagePath.openRead()));
    var length= await imagePath.length();
    var uri = Uri.parse(constant.Url.crave_url+'register_user_img.php');
    tmpFile = imagePath;
    String fileName = tmpFile.path.split('/').last;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var request = new http.MultipartRequest("POST", uri);

    var multipartFile = new http.MultipartFile("image", stream, length, filename: basename(imagePath.path));

    request.files.add(multipartFile);
    request.fields['email'] = prefs.getString('user_email')!;
    request.fields['filename'] = fileName;

    var respond = await request.send();
    if(respond.statusCode==200){
      Navigator.of(this.context, rootNavigator: true).pop('dialog');
      print("Image Uploaded");
      goToSetupPalette(tmpFile.path);
    }else{
      Navigator.of(this.context, rootNavigator: true).pop('dialog');
      print("Upload Failed");
    }
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
                                        child:Text("Profile Picture",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: Color(constant.Color.crave_brown),
                                                fontSize: 24.0.sp)),
                                      ),
                                      Container(
                                        width: double.maxFinite,
                                        padding: const EdgeInsets.only(
                                            left: 35.0,bottom:50),
                                        child:Text("You can always change this later.",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Color(constant.Color.crave_brown),
                                                fontSize: 10.0.sp)),
                                      ),
                                      Container(
                                        child:
                                        // Image.asset('images/profile_img.png',height:25.0.h)
                                        CircleAvatar(
                                          radius: 90.0,
                                          backgroundImage:
                                          imagePath.path == ""?
                                          Image.asset('images/profile_img.png').image:
                                          Image.file(File(imagePath.path)).image,
                                          backgroundColor: Colors.transparent,
                                        ),

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
                                      Container(
                                          width:50.w,
                                          height:6.h,
                                          margin: const EdgeInsets.only(top:30.0,bottom:15.0),
                                          child: ElevatedButton(
                                              child: Text(
                                                  "Upload".toUpperCase(),
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 14.0.sp)
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
                                              onPressed: () => getGalleryImg()
                                          )
                                      ),
                                      SizedBox(
                                          width:50.w,
                                          height:6.h,
                                          child: ElevatedButton(
                                              child: Text(
                                                  "Take a Photo".toUpperCase(),
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 14.0.sp)
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
                                              onPressed: () => getCameraImg()
                                          )
                                      ),
                                      GestureDetector(
                                        onTap: (){
                                          goToSetupPalette('');
                                        },
                                        child:Container(
                                          decoration: BoxDecoration(
                                              border:Border(
                                                  bottom: BorderSide(
                                                    color:Color(constant.Color.crave_brown),
                                                  )
                                              )
                                          ),
                                          padding: const EdgeInsets.only(bottom:1,top:50),
                                          child:Text("SKIP",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                  fontSize: 12.0.sp)),
                                        ),
                                      ),

                                      SizedBox(
                                        height:15.0.h
                                      ),

                                    ],
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