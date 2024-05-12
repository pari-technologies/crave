import 'dart:developer';
import 'dart:io';
import 'dart:math';

import 'homeBase.dart';
import 'tensorflow-service.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'preview_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'dart:io' show Platform;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import 'main.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  CameraController? controller;
  VideoPlayerController? videoController;
  final ImagePicker _picker = ImagePicker();
  TensorflowService _tensorflowService = TensorflowService();
  String? food1 = "";
  String? food2 = "";
  String? food3 = "";

  bool isDevice = false;
  int currentTab = 0;

  File? _imageFile;
  File? _videoFile;
  late XFile? image;

  // Initial values
  bool _isCameraInitialized = false;
  bool _isCameraPermissionGranted = false;
  // bool _isCameraInitialized = true; //temporary
  // bool _isCameraPermissionGranted = true; //temporary
  bool _isRearCameraSelected = true;
  bool _isVideoCameraSelected = false;
  bool _isRecordingInProgress = false;
  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;

  // Current values
  double _currentZoomLevel = 1.0;
  double _currentExposureOffset = 0.0;
  FlashMode? _currentFlashMode;
  double currentLat = 0.0;
  double currentLng = 0.0;
  // late List<Address> current_address;
  String showAddress = "";
  String postType = "story";

  List<File> allFileList = [];
  List<String> indian_s = [];
  List<String> indian_n = [];
  List<String> korean = ['Bibimbap','Hot and sour soup','Seaweed salad'];
  List<String> italian = ['Beef carpaccio','Beef tartare','Cannoli','Carrot cake','Ceviche','Deviled eggs',
    'Filet mignon','Greek salad','Lobster bisque','Lobster roll sandwich','Panna cotta','Ravioli','Risotto','Spaghetti bolognese',
  'Spaghetti carbonara'];
  List<String> french = ['Beet salad','Beignets','Bruschetta','Caesar salad',
    'Cheese plate','Chocolate mousse','Clam chowder','Creme brulee','Croque madame','Eggs benedict','Escargots','Foie gras',
    'French onion soup','French toast','Macarons','Oysters','Poutine','Scallops','Tuna tartare'];
  List<String> japanese = ['Edamame','Gyoza','Miso soup','Ramen','Sashimi','Shrimp and grits','Sushi','Takoyaki'];
  List<String> continental = ['Apple pie','Baby back ribs','Bread pudding','Caprese salad',
    'Cheesecake','Chocolate cake','Club sandwich','Crab cakes','Cup cakes','Donuts','Fish and chips','French fries','Gnocchi','Grilled cheese sandwich'
  ,'Grilled salmon','Hamburger','Hot dog','Ice cream','Lasagna','Macaroni and cheese','Omelette','Onion rings','Pancakes',
  'Pizza','Pork chop','Prime rib','Red velvet cake','Steak','Strawberry shortcake','Tiramisu','Waffles'];
  List<String> thai = ['Fried calamari','Mussels','Pad thai'];
  List<String> viet = ['Pho'];
  List<String> mexican = ['Breakfast burrito','Chicken quesadilla','Chicken wings','Churros','Garlic bread','Guacamole',
  'Huevos rancheros','Nachos','Paella','Pulled pork sandwich','Tacos'];
  List<String> middle_east = ['Baklava','Falafel','Frozen yogurt','Hummus'];
  List<String> chinese = ['Dumplings','Peking duck','Samosa','Spring rolls'];
  List<String> malay = ['Chicken curry','Fried rice','Nasi Lemak','Roti Canai','Satay'];

  List<String> food_category = ['DESSERT','DRINK','FOOD','PASTRIES'];
  List<String> food_cuisine = ['Indian (North)','Indian (South)','Korean','Italian','French','Japanese','Continental','Thai','Vietnamese','Mexican','Middle-eastern','Chinese','Malay'];
  List<String> food_taste = ['Sweet','Sour','Savory','Spicy'];

  final resolutionPresets = ResolutionPreset.values;

  ResolutionPreset currentResolutionPreset = ResolutionPreset.high;

  getPermissionStatus() async {
    await Permission.camera.request();
    var status = await Permission.camera.status;

    setState(() {
      _isCameraPermissionGranted = true;
    });

    onNewCameraSelected(cameras[0]);
    refreshAlreadyCapturedImages();

    // if (status.isGranted) {
    //   log('Camera Permission: GRANTED');
    //   setState(() {
    //     _isCameraPermissionGranted = true;
    //   });
    //   // Set and initialize the new camera
    //   onNewCameraSelected(cameras[0]);
    //   refreshAlreadyCapturedImages();
    // } else {
    //   log('Camera Permission: DENIED');
    // }
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

  void getCurrentLocation() async{
    await _tensorflowService.loadModel();

    Position position = await _determinePosition();
    // From coordinates
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    setState(() {
      showAddress = placemarks.first.street!+","+placemarks.first.locality!+","+placemarks.first.postalCode!+","+placemarks.first.administrativeArea!+","+placemarks.first.country!;
    });

  }

  refreshAlreadyCapturedImages() async {
    final directory = await getApplicationDocumentsDirectory();
    List<FileSystemEntity> fileList = await directory.list().toList();
    allFileList.clear();
    List<Map<int, dynamic>> fileNames = [];

    fileList.forEach((file) {
      if (file.path.contains('.jpg') || file.path.contains('.mp4')) {
        allFileList.add(File(file.path));

        String name = file.path.split('/').last.split('.').first;
        fileNames.add({0: int.parse(name), 1: file.path.split('/').last});
      }
    });

    if (fileNames.isNotEmpty) {
      final recentFile =
      fileNames.reduce((curr, next) => curr[0] > next[0] ? curr : next);
      String recentFileName = recentFile[1];
      if (recentFileName.contains('.mp4')) {
        _videoFile = File('${directory.path}/$recentFileName');
        _imageFile = null;
        _startVideoPlayer();
      } else {
        _imageFile = File('${directory.path}/$recentFileName');
        _videoFile = null;
      }

      setState(() {});
    }


  }

  void getGalleryImg() async {
    image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = File(image!.path);
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>
                PreviewScreen(
                    imageFile: _imageFile!,
                    fileList: allFileList,
                    address:showAddress,
                    postType:postType,
                    food1:food1!,
                    food2:food2!,
                    food3:food3!
                ),
          ),
        );
      });

    });
  }

  Future<XFile?> takePicture() async {
    final CameraController? cameraController = controller;

    if (cameraController!.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      print('Error occured while taking picture: $e');
      return null;
    }
  }

  Future<void> _startVideoPlayer() async {
    if (_videoFile != null) {
      videoController = VideoPlayerController.file(_videoFile!);
      await videoController!.initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized,
        // even before the play button has been pressed.
        setState(() {});
      });
      await videoController!.setLooping(true);
      await videoController!.play();
    }
  }

  Future<void> startVideoRecording() async {
    final CameraController? cameraController = controller;

    if (controller!.value.isRecordingVideo) {
      // A recording has already started, do nothing.
      return;
    }

    try {
      await cameraController!.startVideoRecording();
      setState(() {
        _isRecordingInProgress = true;
        print(_isRecordingInProgress);
      });
    } on CameraException catch (e) {
      print('Error starting to record video: $e');
    }
  }

  Future<XFile?> stopVideoRecording() async {
    if (!controller!.value.isRecordingVideo) {
      // Recording is already is stopped state
      return null;
    }

    try {
      XFile file = await controller!.stopVideoRecording();
      setState(() {
        _isRecordingInProgress = false;
      });
      return file;
    } on CameraException catch (e) {
      print('Error stopping video recording: $e');
      return null;
    }
  }

  Future<void> pauseVideoRecording() async {
    if (!controller!.value.isRecordingVideo) {
      // Video recording is not in progress
      return;
    }

    try {
      await controller!.pauseVideoRecording();
    } on CameraException catch (e) {
      print('Error pausing video recording: $e');
    }
  }

  Future<void> resumeVideoRecording() async {
    if (!controller!.value.isRecordingVideo) {
      // No video recording was in progress
      return;
    }

    try {
      await controller!.resumeVideoRecording();
    } on CameraException catch (e) {
      print('Error resuming video recording: $e');
    }
  }

  void resetCameraValues() async {
    _currentZoomLevel = 1.0;
    _currentExposureOffset = 0.0;
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraController = controller;

    bool available = true;

    final CameraController cameraController = CameraController(
      cameraDescription,
      currentResolutionPreset,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    await previousCameraController?.dispose();

    resetCameraValues();

    if (mounted) {
      setState(() {
        controller = cameraController;
      });
    }

    // Update UI if controller updated
    cameraController.addListener(() {
      if (mounted) setState(() {});
    });

    try {
      await cameraController.initialize();
      cameraController.startImageStream((img) async {
        if (available) {
          available = false;
          String? results = await _tensorflowService.runModel(img);    // Tflite.runModelOnFrame(...) code
          await Future.delayed(Duration(seconds: 2));
          available = true;
          setState(() {
            if(results!.isNotEmpty){
              foodCategory(results);
            }

          });
        }
      });
      await Future.wait([
        cameraController
            .getMinExposureOffset()
            .then((value) => _minAvailableExposureOffset = value),
        cameraController
            .getMaxExposureOffset()
            .then((value) => _maxAvailableExposureOffset = value),
        cameraController
            .getMaxZoomLevel()
            .then((value) => _maxAvailableZoom = value),
        cameraController
            .getMinZoomLevel()
            .then((value) => _minAvailableZoom = value),
        cameraController
            .setZoomLevel(_minAvailableZoom),
      ]);

      _currentFlashMode = controller!.value.flashMode;
    } on CameraException catch (e) {
      print('Error initializing camera: $e');
    }

    if (mounted) {
      setState(() {
        _isCameraInitialized = controller!.value.isInitialized;
      });
    }
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (controller == null) {
      return;
    }

    final offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    controller!.setExposurePoint(offset);
    controller!.setFocusPoint(offset);
  }

  void isRealDevice() async {
    bool isAndroidDevice = false;
    bool isIosDevice = false;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      isAndroidDevice = androidInfo.isPhysicalDevice!;
      print('isAndroidDevice -  ${isAndroidDevice}');
      if(isAndroidDevice){
        setState(() {
          isDevice = true;
        });
      }

    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      isIosDevice = iosInfo.isPhysicalDevice;
      print('isIosDevice -  ${isIosDevice}');
      if(isIosDevice){
        setState(() {
          isDevice = true;
        });
      }
    }

  }

  void toastNoImageCaptured(){
    Fluttertoast.showToast(
        msg: "Please capture an image first to view",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  void foodCategory(String food_name){
    // generates a new Random object
    final _random = new Random();
    if(korean.contains(food_name)){
      setState(() {
        food1 = "Korean";

      });
    }
    else if(italian.contains(food_name)) {
      setState(() {
        food1 = "Italian";

      });
    }
    else if(french.contains(food_name)) {
      setState(() {
        food1 = "French";
      });
    }
    else if(japanese.contains(food_name)) {
      setState(() {
        food1 = "Japanese";
      });
    }
    else if(continental.contains(food_name)) {
      setState(() {
        food1 = "Continental";
      });
    }
    else if(thai.contains(food_name)) {
      setState(() {
        food1 = "Thai";
      });
    }
    else if(viet.contains(food_name)) {
      setState(() {
        food1 = "Vietnamese";
      });
    }
    else if(mexican.contains(food_name)) {
      setState(() {
        food1 = "Mexican";
      });
    }
    else if(middle_east.contains(food_name)) {
      setState(() {
        food1 = "Middle-eastern";
      });
    }
    else if(chinese.contains(food_name)) {
      setState(() {
        food1 = "Chinese";
      });
    }
    else if(malay.contains(food_name)) {
      setState(() {
        food1 = "Malay";
      });
    }
    else{
      setState(() {
        // food1 = "Malay";
        food1 = food_cuisine[_random.nextInt(food_cuisine.length)];
      });
    }

    if(food1!.isNotEmpty){
      setState(() {
        food2 = food_category[_random.nextInt(food_category.length)];
        food3 = food_taste[_random.nextInt(food_taste.length)];
      });
    }


  }

  @override
  void initState() {
    // Hide the status bar in Android
    // isRealDevice();
    SystemChrome.setEnabledSystemUIOverlays([]);
    getPermissionStatus();
    WidgetsBinding.instance!.addPostFrameCallback((_) => getCurrentLocation());
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(cameraController.description);
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    videoController?.dispose();
    super.dispose();
  }


  void onTabChange(int newTab) {
    setState(() {
      currentTab = newTab;
      if(newTab == 0){
        postType = "story";
      }
      else if(newTab == 1){
        postType = "feed";
      }
      else if(newTab == 2){
        postType = "clips";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isCameraPermissionGranted
          ? _isCameraInitialized
          ?
          Stack(
        children: [
          // isDevice?
          Transform.scale(
            scale: 1 / (controller!.value.aspectRatio * size.aspectRatio),
            alignment: Alignment.topCenter,
            child: CameraPreview(
              controller!,
              child: LayoutBuilder(builder:
                  (BuildContext context,
                  BoxConstraints constraints) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapDown: (details) =>
                      onViewFinderTap(details, constraints),
                );
              }),
            ),
          )
          ,
          //     :
          // Container(
          //   color:Colors.green,
          // ),


          // TODO: Uncomment to preview the overlay
          // Center(
          //   child: Image.asset(
          //     'assets/camera_aim.png',
          //     color: Colors.greenAccent,
          //     width: 150,
          //     height: 150,
          //   ),
          // ),
          Align(
            alignment:Alignment.topCenter,
            child:  Container(
              color:Color.fromRGBO(0, 0, 0, 0.3),
              padding: const EdgeInsets.only(
                  top: 10.0,bottom:15),
              child:SafeArea(
                  bottom: false,
                  child:IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(width:size.width*0.05),
                        GestureDetector(
                            onTap:(){
                              Navigator.pop(this.context);
                              PageViewDemo.of(this.context)!.appearWheel();
                            },
                            child:
                                Container(
                                  // height:30,
                                  width:30,
                                  color:Colors.transparent,
                                  child: Icon(Icons.arrow_back_ios,size: 20,color:Colors.white)
                                ),

                        ),
                        SizedBox(width:size.width*0.05),
                        GestureDetector(
                          onTap:(){
                            onTabChange(0);
                          },
                          child:Text("STORIES",
                              style: TextStyle(
                                  color: currentTab==0?Colors.white:Color(0xFFDEDDDD),
                                  fontWeight: currentTab==0?FontWeight.w600:FontWeight.w500,
                                  fontSize: 15.0)),
                        ),
                        SizedBox(width:size.width*0.03),
                        Container(
                          //padding: const EdgeInsets.only(top:15,bottom:15),
                          child:VerticalDivider(color: Colors.white,),
                        ),
                        SizedBox(width:size.width*0.07),
                        GestureDetector(
                          onTap:(){
                            onTabChange(1);
                          },
                          child:Text("POST",
                              style: TextStyle(
                                  color: currentTab==1?Colors.white:Color(0xFFDEDDDD),
                                  fontWeight: currentTab==1?FontWeight.w600:FontWeight.w500,
                                  fontSize: 15.0)),
                        ),
                        SizedBox(width:size.width*0.07),
                        Container(
                          // padding: const EdgeInsets.only(top:15,bottom:15),
                          child:VerticalDivider(color: Colors.white,),
                        ),
                        SizedBox(width:size.width*0.05),
                        GestureDetector(
                          onTap:(){
                            onTabChange(2);
                          },
                          child:Text("CLIPS",
                              style: TextStyle(
                                  color: currentTab==2?Colors.white:Color(0xFFDEDDDD),
                                  fontWeight: currentTab==2?FontWeight.w600:FontWeight.w500,
                                  fontSize: 15.0)),
                        ),
                        SizedBox(width:30),
                        // Row(
                        //   crossAxisAlignment: CrossAxisAlignment.stretch,
                        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //   children: [
                        //
                        //   ],
                        // ),

                      ],
                    ),
                  )
              ),

            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Spacer(),
              // SizedBox(height:MediaQuery.of(context).size.height - 300),
              Container(
                // color:Color.fromRGBO(0, 0, 0, 0.3),
                padding: const EdgeInsets.only(top: 20.0),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left:15.0),
                      child: Image.asset('images/icon_location_camera.png',height: 25.0),
                    ),
                    Container(
                      width:MediaQuery.of(context).size.width * 0.87,
                      margin:const EdgeInsets.only(right:10.0),
                      padding:const EdgeInsets.only(top: 10.0,left:15.0,right:15.0,bottom:10.0),
                      decoration: BoxDecoration(
                          color:Color.fromRGBO(220,220, 220, 0.4),
                          borderRadius: BorderRadius.all(Radius.circular(30))
                      ),
                      child:Text(showAddress,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13.0)),
                    ),


                  ],
                ),
              ),
              Container(
                // color:Color.fromRGBO(0, 0, 0, 0.3),
                margin: const EdgeInsets.only(bottom: 20.0),
                padding: const EdgeInsets.only(top: 20.0,right:10),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(width:25),
                    Expanded(
                      child: Container(
                        padding:const EdgeInsets.only(top: 5.0,bottom:5.0),
                        decoration: BoxDecoration(
                            color:Color.fromRGBO(0, 0, 0, 0.3),
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        child:Text(food1!.toUpperCase(),textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0)),
                      ),
                    ),
                    SizedBox(width:8),
                    Expanded(
                      child:Container(
                        padding:const EdgeInsets.only(top: 5.0,bottom:5.0),
                        decoration: BoxDecoration(
                            color:Color.fromRGBO(0, 0, 0, 0.3),
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        child:Text(food2!.toUpperCase(),textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0)),
                      ),
                    ),
                    SizedBox(width:8),
                    Expanded(
                      child: Container(
                        padding:const EdgeInsets.only(top: 5.0,bottom:5.0),
                        decoration: BoxDecoration(
                            color:Color.fromRGBO(0, 0, 0, 0.3),
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        child:Text(food3!.toUpperCase(),textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0)),
                      ),
                    ),
                    SizedBox(width:8),

                  ],
                ),
              ),
              Row(
                mainAxisAlignment:MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap:
                    // _imageFile != null ||
                    //     _videoFile != null
                    //     ?
                    //     () {
                    //
                    //
                    // }
                    // // ,
                    // : toastNoImageCaptured

                    getGalleryImg
                    ,
                    child: Container(
                      // width: 60,
                      // height: 60,
                      margin: const EdgeInsets.only(right:30),
                      // decoration: BoxDecoration(
                      //   color: Colors.black,
                      //   borderRadius:
                      //   BorderRadius.circular(10.0),
                      //   border: Border.all(
                      //     color: Colors.white,
                      //     width: 2,
                      //   ),
                      //   image: _imageFile != null
                      //       ? DecorationImage(
                      //     image:
                      //     FileImage(_imageFile!),
                      //     fit: BoxFit.cover,
                      //   )
                      //       : null,
                      // ),
                      child: Image.asset('images/icon_select_img.png',height:45),

                      // videoController != null &&
                      //     videoController!
                      //         .value.isInitialized
                      //     ? ClipRRect(
                      //   borderRadius:
                      //   BorderRadius.circular(
                      //       8.0),
                      //       child: AspectRatio(
                      //         aspectRatio:
                      //         videoController!
                      //             .value.aspectRatio,
                      //         child: VideoPlayer(
                      //             videoController!),
                      //       ),
                      // )
                      //     : Container(),
                    ),
                  ),
                  InkWell(
                    onTap: _isVideoCameraSelected
                        ? () async {
                      if (_isRecordingInProgress) {
                        XFile? rawVideo =
                        await stopVideoRecording();
                        File videoFile =
                        File(rawVideo!.path);

                        int currentUnix = DateTime
                            .now()
                            .millisecondsSinceEpoch;

                        final directory =
                        await getApplicationDocumentsDirectory();

                        String fileFormat = videoFile
                            .path
                            .split('.')
                            .last;

                        _videoFile =
                        await videoFile.copy(
                          '${directory.path}/$currentUnix.$fileFormat',
                        );

                        _startVideoPlayer();
                      } else {
                        await startVideoRecording();
                      }
                    }
                        : () async {
                      XFile? rawImage =
                      await takePicture();
                      File imageFile =
                      File(rawImage!.path);

                      int currentUnix = DateTime.now()
                          .millisecondsSinceEpoch;

                      final directory =
                      await getApplicationDocumentsDirectory();

                      String fileFormat = imageFile
                          .path
                          .split('.')
                          .last;

                      print(fileFormat);

                      await imageFile.copy(
                        '${directory.path}/$currentUnix.$fileFormat',
                      );

                      refreshAlreadyCapturedImages();
                      print(food1);
                      print(food2);
                      print(food3);
                      await Future.delayed(Duration(milliseconds: 300));
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) =>
                              PreviewScreen(
                                imageFile: _imageFile!,
                                fileList: allFileList,
                                address:showAddress,
                                postType:postType,
                                  food1:food1!,
                                  food2:food2!,
                                  food3:food3!
                              ),
                        ),
                      );
                    },
                    child: Image.asset('images/icon_capture_img.png',height: 70.0),
                    // Stack(
                    //   alignment: Alignment.center,
                    //   children: [
                    //     Icon(
                    //       Icons.circle,
                    //       color: _isVideoCameraSelected
                    //           ? Colors.white
                    //           : Colors.white38,
                    //       size: 80,
                    //     ),
                    //     Icon(
                    //       Icons.circle,
                    //       color: _isVideoCameraSelected
                    //           ? Colors.red
                    //           : Colors.white,
                    //       size: 65,
                    //     ),
                    //     _isVideoCameraSelected &&
                    //         _isRecordingInProgress
                    //         ? Icon(
                    //       Icons.stop_rounded,
                    //       color: Colors.white,
                    //       size: 32,
                    //     )
                    //         : Container(),
                    //   ],
                    // ),
                  ),
                  InkWell(
                    onTap: _isRecordingInProgress
                        ? () async {
                      if (controller!
                          .value.isRecordingPaused) {
                        await resumeVideoRecording();
                      } else {
                        await pauseVideoRecording();
                      }
                    }
                        : () {
                      setState(() {
                        _isCameraInitialized = false;
                      });
                      onNewCameraSelected(cameras[
                      _isRearCameraSelected
                          ? 1
                          : 0]);
                      setState(() {
                        _isRearCameraSelected =
                        !_isRearCameraSelected;
                      });
                    },
                    child:Container(
                      margin: const EdgeInsets.only(left:30),
                      child:Image.asset('images/icon_flip_camera.png',height: 40.0),
                    ),

                    // Stack(
                    //   alignment: Alignment.center,
                    //   children: [
                    //     Icon(
                    //       Icons.circle,
                    //       color: Colors.black38,
                    //       size: 60,
                    //     ),
                    //     _isRecordingInProgress
                    //         ? controller!
                    //         .value.isRecordingPaused
                    //         ? Icon(
                    //       Icons.play_arrow,
                    //       color: Colors.white,
                    //       size: 30,
                    //     )
                    //         : Icon(
                    //       Icons.pause,
                    //       color: Colors.white,
                    //       size: 30,
                    //     )
                    //         : Icon(
                    //       _isRearCameraSelected
                    //           ? Icons.camera_front
                    //           : Icons.camera_rear,
                    //       color: Colors.white,
                    //       size: 30,
                    //     ),
                    //   ],
                    // ),
                  ),
                ],
              ),
              SizedBox(height:40),
            ],
          ),
        ],
      )
          : Center(
            child: Text(
              '',
              style: TextStyle(color: Colors.white),
            ),
          )
          : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(),
              Text(
                'Permission denied',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  getPermissionStatus();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Give permission',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ],
      ),
    );
  }
}
