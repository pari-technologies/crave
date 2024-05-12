import 'dart:convert';
import 'dart:developer';
import "package:async/async.dart";
import 'package:path/path.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'camera_screen.dart';
import 'captures_screen.dart';
import 'constants.dart' as constant;
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'filter_wheel.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_place/google_place.dart';
import 'package:audioplayers/audioplayers.dart';
import 'music_wheel.dart';
import 'package:text_editor/text_editor.dart';

class PreviewScreen extends StatefulWidget {
  final File imageFile;
  final List<File> fileList;
  final String address;
  final String postType;
  final String food1;
  final String food2;
  final String food3;
  const PreviewScreen({
    required this.imageFile,
    required this.fileList,
    required this.address,
    required this.postType,
    required this.food1,
    required this.food2,
    required this.food3
  });

// const PreviewScreen();

  @override
  PreviewScreenState createState() => PreviewScreenState();
}

class PreviewScreenState extends State<PreviewScreen> {

  final paletteCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  final addLocationCtrl = TextEditingController();
  final addAddressCtrl = TextEditingController();
  final addPostcodeCtrl = TextEditingController();
  final addCityCtrl = TextEditingController();
  final addStateCtrl = TextEditingController();
  var googlePlace = GooglePlace("AIzaSyAmIgkAfv3eTAqVZEMT8KDfuvbcn16suWY");
  final captionCtrl = TextEditingController();
  final player = AudioPlayer();
  bool isMusic = false;
  bool isFilter = false;
  bool isText = false;
  late String base64Image;
  late File tmpFile;
  List<String> selectedTags = [];
  String tags1 = "";
  String tags2 = "";
  String tags3 = "";

  String currentMusic = "";
  String currentFilter = "";

  double currentlat = 3.1390;
  double currentlng = 101.6869;

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

  static const NO_FILTER = [
    1.0,0.0,0.0,0.0,0.0,
    0.0,1.0,0.0,0.0,0.0,
    0.0,0.0,1.0,0.0,0.0,
    0.0,0.0,0.0,1.0,0.0];

  static const SEPIA_MATRIX = [0.39, 0.769, 0.189, 0.0,
    0.0, 0.349, 0.686, 0.168,
    0.0, 0.0, 0.272, 0.534, 0.131,
    0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0];

  static const GREYSCALE_MATRIX = [0.2126, 0.7152, 0.0722, 0.0, 0.0,
    0.2126, 0.7152, 0.0722, 0.0, 0.0,
    0.2126, 0.7152, 0.0722, 0.0, 0.0,
    0.0, 0.0, 0.0, 1.0, 0.0];

  static const VINTAGE_MATRIX = [0.9, 0.5, 0.1, 0.0, 0.0,
    0.3, 0.8, 0.1, 0.0, 0.0,
    0.2, 0.3, 0.5, 0.0, 0.0,
    0.0, 0.0, 0.0, 1.0, 0.0];

  static const FILTER_1 = [1.0, 0.0, 0.2, 0.0, 0.0,
    0.0, 1.0, 0.0, 0.0, 0.0,
    0.0, 0.0, 1.0, 0.0, 0.0,
    0.0, 0.0, 0.0, 1.0, 0.0];

  static const FILTER_2 = [0.4, 0.4, -0.3, 0.0, 0.0,
    0.0, 1.0, 0.0, 0.0, 0.0,
    0.0, 0.0, 1.2, 0.0, 0.0,
    -1.2, 0.6, 0.7, 1.0, 0.0];

  static const FILTER_3 = [0.8, 0.5, 0.0, 0.0, 0.0,
    0.0, 1.1,0.0, 0.0, 0.0,
    0.0, 0.2, 1.1 , 0.0, 0.0,
    0.0, 0.0, 0.0, 1.0, 0.0];

  static const FILTER_4 = [1.1, 0.0, 0.0, 0.0, 0.0,
    0.2, 1.0,-0.4, 0.0, 0.0,
    -0.1, 0.0, 1.0 , 0.0, 0.0,
    0.0, 0.0, 0.0, 1.0, 0.0];

  static const FILTER_5 = [1.2, 0.1, 0.5, 0.0, 0.0,
    0.1, 1.0,0.05, 0.0, 0.0,
    0.0, 0.1, 1.0 , 0.0, 0.0,
    0.0, 0.0, 0.0, 1.0, 0.0];

  // final _filters = [
  //   Colors.white,
  //   ...List.generate(
  //     Colors.primaries.length,
  //         (index) => Colors.primaries[(index * 4) % Colors.primaries.length],
  //   )
  // ];

  final _filters = [
    NO_FILTER,SEPIA_MATRIX,GREYSCALE_MATRIX,VINTAGE_MATRIX,FILTER_1,FILTER_2,FILTER_3,FILTER_4,FILTER_5
  ];

  final _musics = [
    'music0','music1','music2','music3','music4','music5'
  ];

  final _filterColor = ValueNotifier<List<double>>(NO_FILTER);

  final fonts = [
    'OpenSans',
    'Billabong',
    'GrandHotel',
    'Oswald',
    'Quicksand',
    'BeautifulPeople',
    'BeautyMountains',
    'BiteChocolate',
    'BlackberryJam',
    'BunchBlossoms',
    'CinderelaRegular',
    'Countryside',
    'Halimun',
    'LemonJelly',
    'QuiteMagicalRegular',
    'Tomatoes',
    'TropicalAsianDemoRegular',
    'VeganStyle',
  ];
  TextStyle _textStyle = TextStyle(
    fontSize: 50,
    color: Colors.white,
    fontFamily: 'Billabong',
  );
  String _text = '';
  TextAlign _textAlign = TextAlign.center;

  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => loadData());
  }

  @override
  void dispose() {
    player.stop();
    player.dispose();
    super.dispose();
  }

  void _tapHandler(text, textStyle, textAlign) {
    showGeneralDialog(
      context: this.context,
      barrierDismissible: false,
      transitionDuration: Duration(
        milliseconds: 400,
      ), // how long it takes to popup dialog after button click
      pageBuilder: (_, __, ___) {
        // your widget implementation
        return Container(
          color:Color.fromRGBO(0, 0, 0, 0.4),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              // top: false,
              child: Container(
                padding: EdgeInsets.only(top: 5.0,right:15),
                child: TextEditor(
                  fonts: fonts,
                  text: text,
                  textStyle: textStyle,
                  textAlingment: textAlign,
                  minFontSize: 10,
                  decoration: EditorDecoration(
                    doneButton: Container(
                      //color:Color.fromRGBO(0, 0, 0, 0.3),
                      child: Text("DONE",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontSize: 18.0)),
                    ),




                  ),
                  onEditCompleted: (style, align, text) {
                    setState(() {
                      _text = text;
                      _textStyle = style;
                      _textAlign = align;
                    });
                    Navigator.pop(this.context);
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
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

  void loadData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    currentlat = prefs.getDouble('lat')!;
    currentlng =  prefs.getDouble('lng')!;

    getListOfNearbyLocations();
    setState(() {
      print("on preview screen");
      print(this.widget.food1);
      print(this.widget.food2);
      print(this.widget.food3);
      if(this.widget.food1 != ""){
        selectedTags.add(this.widget.food1);
      }

      if(this.widget.food2 != ""){
        selectedTags.add(this.widget.food2);
      }

      if(this.widget.food3 != ""){
        selectedTags.add(this.widget.food3);
      }

      print(selectedTags.toString());

      if(selectedTags.length==0){
        tags1 = "";
        tags2 = "";
        tags3 = "";
      }

      else if(selectedTags.length==1){
        tags1 = selectedTags[0];
        tags2 = "";
        tags3 = "";
      }

      else if(selectedTags.length==2){
        tags1 = selectedTags[0];
        tags2 = selectedTags[1];
        tags3 = "";
      }

      else if(selectedTags.length==3){
        tags1 = selectedTags[0];
        tags2 = selectedTags[1];
        tags3 = selectedTags[2];
      }

      for(int i=0;i<cuisine1.length;i++){
        if(cuisine1[i]['name'] == this.widget.food1){
          cuisine1[i]['isSelected'] = true;
        }
      }

      for(int i=0;i<cuisine2.length;i++){
        if(cuisine2[i]['name'] == this.widget.food1){
          cuisine2[i]['isSelected'] = true;
        }
      }

      for(int i=0;i<category1.length;i++){
        if(category1[i]['name'] == this.widget.food2){
          category1[i]['isSelected'] = true;
        }
      }

      for(int i=0;i<category2.length;i++){
        if(category2[i]['name'] == this.widget.food2){
          category2[i]['isSelected'] = true;
        }
      }

      for(int i=0;i<taste1.length;i++){
        if(taste1[i]['name'] == this.widget.food3){
          taste1[i]['isSelected'] = true;
        }
      }

      for(int i=0;i<taste2.length;i++){
        if(taste2[i]['name'] == this.widget.food3){
          taste2[i]['isSelected'] = true;
        }
      }

    });

  }

  void getListOfNearbyLocations() async{
    Position position = await _determinePosition();
    var result = await googlePlace.search.getNearBySearch(
        Location(lat: position.latitude, lng: position.longitude), 15000,
        type: "restaurant");

    // print(result);
    // print(result!.debugLog!.line);
    // print(result.results.toString());
  }

  void updateSelectedTags(String tags){
    print(tags);
    setState(() {
      if(selectedTags.contains(tags)){
        selectedTags.remove(tags);
      }
      else{
        if(selectedTags.length < 3){
          selectedTags.add(tags);
        }

      }

      if(selectedTags.length==0){
        tags1 = "";
        tags2 = "";
        tags3 = "";
      }

      else if(selectedTags.length==1){
        tags1 = selectedTags[0];
        tags2 = "";
        tags3 = "";
      }

      else if(selectedTags.length==2){
        tags1 = selectedTags[0];
        tags2 = selectedTags[1];
        tags3 = "";
      }

      else if(selectedTags.length==3){
        tags1 = selectedTags[0];
        tags2 = selectedTags[1];
        tags3 = selectedTags[2];
      }

      // if(selectedTags[0].isNotEmpty){
      //   tags1 = selectedTags[0];
      // }
      // else{
      //   tags1 = "";
      // }
      //
      // if(selectedTags[1].isNotEmpty){
      //   tags2 = selectedTags[1];
      // }
      // else{
      //   tags2 = "";
      // }
      //
      // if(selectedTags[2].isNotEmpty){
      //   tags3 = selectedTags[2];
      // }
      // else{
      //   tags3 = "";
      // }

    });

    print(selectedTags.toString());

  }

  showAlertDialog(BuildContext context, String loadingText){
    AlertDialog alert=AlertDialog(
      content:  Row(
        children: [
          const CircularProgressIndicator(),
          Container(margin: const EdgeInsets.only(left: 5),child:Text(loadingText)),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

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

  Future sendMedia() async{
// ignore: deprecated_member_use
  String loading_text = "";
  if(this.widget.postType == "story"){
    setState(() {
      loading_text = "Posting to Stories...";
    });
  }
  else if(this.widget.postType == "feed"){
    setState(() {
      loading_text = "Posting to Feed...";
    });
  }
  else if(this.widget.postType == "clips"){
    setState(() {
      loading_text = "Posting to Clips...";
    });
  }
    showAlertDialog(this.context,loading_text);
    var stream= new http.ByteStream(DelegatingStream.typed(this.widget.imageFile.openRead()));
    var length= await this.widget.imageFile.length();
    var uri = Uri.parse(constant.Url.crave_url+'send_media.php');
    var latlng = currentlat.toString()+","+currentlng.toString();
    tmpFile = this.widget.imageFile;
    String fileName = tmpFile.path.split('/').last;
    String food1 = "",food2 = "",food3 = "";
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var request = new http.MultipartRequest("POST", uri);

    var multipartFile = new http.MultipartFile("image", stream, length, filename: basename(this.widget.imageFile.path));

    if(selectedTags.length == 0){
      food1 = "";
      food2 = "";
      food3 = "";
    }
    else if(selectedTags.length == 1){
      food1 = selectedTags[0];
      food2 = "";
      food3 = "";
    }
    else if(selectedTags.length == 2){
      food1 = selectedTags[0];
      food2 = selectedTags[1];
      food3 = "";
    }
    else if(selectedTags.length == 3){
      food1 = selectedTags[0];
      food2 = selectedTags[1];
      food3 = selectedTags[2];
    }
    request.files.add(multipartFile);
    request.fields['email'] = prefs.getString('user_email')!;
    request.fields['latlng'] = latlng;
    request.fields['location'] = this.widget.address;
    request.fields['postType'] = this.widget.postType;
    request.fields['img_desc'] = captionCtrl.text;
    request.fields['filename'] = fileName;
    request.fields['filter'] = currentFilter;
    request.fields['music'] = currentMusic;
    request.fields['tags1'] = food1;
    request.fields['tags2'] = food2;
    request.fields['tags3'] = food3;
    request.fields['textfilter'] = _text;
    request.fields['textstyle'] = _textStyle.toString();
    request.fields['textColor'] = _textStyle.color.toString();
    request.fields['textBgColor'] = _textStyle.backgroundColor!=null?_textStyle.backgroundColor.toString():Color(0x00000000).toString();
    request.fields['textFamily'] = _textStyle.fontFamily.toString();
    request.fields['textSize'] = _textStyle.fontSize.toString();
    request.fields['textalign'] = _textAlign.toString();


    var respond = await request.send();
    if(respond.statusCode==200){
      Navigator.of(this.context, rootNavigator: true).pop('dialog');
      var response = await http.Response.fromStream(respond);
      final result = jsonDecode(response.body) as Map<String, dynamic>;
      print(result);
      print("Image Uploaded");
      player.stop();
      player.dispose();
      Navigator.pop(this.context);
    }else{
      Navigator.of(this.context, rootNavigator: true).pop('dialog');
      print("Upload Failed");
    }
  }

  void onShowFoodPalette(){
    showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: true,
        backgroundColor: Color.fromRGBO(0, 0, 0, 0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: this.context,
        builder: (context) {
          return  StatefulBuilder(builder: (BuildContext context, StateSetter mystate) {
            return Container(
              height:MediaQuery.of(context).size.height -100,
              // padding:
              padding: MediaQuery.of(context).viewInsets,
              //height:30.0.h,
              child:
              SingleChildScrollView(
                child:Stack(
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 20.0,top:15),
                              child: GestureDetector(
                                  onTap:(){
                                    player.stop();
                                    player.dispose();
                                    Navigator.pop(context);
                                  },
                                  child:
                                  Icon(Icons.arrow_back_ios,size: 20,color:Colors.white)
                              ),
                            ),

                            Expanded(
                              child:Container(
                                //width:250,
                                height:55,
                                margin: const EdgeInsets.only(bottom: 10.0),
                                padding: const EdgeInsets.only(left: 10.0, right: 30.0,top:25),
                                child:TextField(
                                  autofocus: false,
                                  controller: paletteCtrl,
                                  cursorColor: Colors.black,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.go,
                                  textCapitalization: TextCapitalization.sentences,
                                  decoration:  InputDecoration(

                                      counterText: '',
                                      filled: true,
                                      // Color(0xFFD6D6D6)
                                      fillColor: Color(0xFFF2F2F2),
                                      contentPadding:EdgeInsets.symmetric(horizontal: 15,vertical:0),
                                      labelStyle: TextStyle(
                                          fontSize: 14,
                                          color:Colors.black
                                      ),

                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                        borderSide: BorderSide(color:Color(0xFFF2F2F2) ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                        borderSide: BorderSide(color:Color(0xFFF2F2F2) ,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                        borderSide: BorderSide(color:Color(0xFFF2F2F2), ),
                                      ),
                                      suffixIcon: Icon(
                                        Icons.search,
                                        color: Colors.black,
                                        size: 20.0,
                                      ),
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          color:Colors.grey),
                                      hintText: "Search"),
                                ),
                              ),
                            ),

                          ],
                        ),
                        //Cuisine
                        Container(
                          width: double.maxFinite,
                          padding: const EdgeInsets.only(
                              left: 30.0,right:30.0,top:15,bottom:10),
                          child:Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Cuisine",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey,
                                      fontSize: 13.0.sp)),
                              SizedBox(width:10),
                              Expanded(
                                  child:Divider(
                                      color: Colors.grey,thickness: 1
                                  )
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 25.0,right:25.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(0, 0, 0, 0.0),
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
                                                  : Color.fromRGBO(0, 0, 0, 0.0),
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
                                                mystate(() {
                                                  if(cuisine1[index]['isSelected'] == true){
                                                    cuisine1[index]['isSelected'] = false;
                                                  }
                                                  else{
                                                    cuisine1[index]['isSelected'] = true;
                                                  }
                                                  updateSelectedTags(cuisine1[index]['name'].toString());
                                                });
                                              },
                                              title:
                                                  Container(
                                                    child:Text(
                                                        cuisine1[index]['name'].toString().toUpperCase(),
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w600,
                                                          color: cuisine1[index]['isSelected'] == true
                                                              ? Colors.white
                                                              : Colors.white,)
                                                    ),
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
                                  width:20,),

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
                                                  : Color.fromRGBO(0, 0, 0, 0.0),
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
                                                mystate(() {
                                                  if(cuisine2[index]['isSelected'] == true){
                                                    cuisine2[index]['isSelected'] = false;
                                                  }
                                                  else{
                                                    cuisine2[index]['isSelected'] = true;
                                                  }
                                                  updateSelectedTags(cuisine2[index]['name'].toString());
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
                                                        : Colors.white,)
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
                                      color: Colors.grey,
                                      fontSize: 13.0.sp)),
                              SizedBox(width:10),
                              Expanded(
                                  child:Divider(
                                      color: Colors.grey,thickness: 1
                                  )
                              ),

                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 25.0,right:25.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(0, 0, 0, 0.0),
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
                                                  : Color.fromRGBO(0, 0, 0, 0.0),
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
                                                mystate(() {
                                                  if(taste1[index]['isSelected'] == true){
                                                    taste1[index]['isSelected'] = false;
                                                  }
                                                  else{
                                                    taste1[index]['isSelected'] = true;
                                                  }
                                                  updateSelectedTags(taste1[index]['name'].toString());
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
                                                        : Colors.white,)
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
                                      top: 10.0,bottom:10,right:5),
                                  width:20,),

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
                                                  : Color.fromRGBO(0, 0, 0, 0.0),
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
                                                mystate(() {
                                                  if(taste2[index]['isSelected'] == true){
                                                    taste2[index]['isSelected'] = false;
                                                  }
                                                  else{
                                                    taste2[index]['isSelected'] = true;
                                                  }
                                                  updateSelectedTags(taste2[index]['name'].toString());
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
                                                        : Colors.white,)
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
                                      color: Colors.grey,
                                      fontSize: 13.0.sp)),
                              SizedBox(width:10),
                              Expanded(
                                  child:Divider(
                                      color: Colors.grey,thickness: 1
                                  )
                              ),

                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 25.0,right:25.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(0, 0, 0, 0.0),
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
                                                  : Color.fromRGBO(0, 0, 0, 0.0),
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
                                                mystate(() {
                                                  if(category1[index]['isSelected'] == true){
                                                    category1[index]['isSelected'] = false;
                                                  }
                                                  else{
                                                    category1[index]['isSelected'] = true;
                                                  }
                                                  updateSelectedTags(category1[index]['name'].toString());
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
                                                        : Colors.white,)
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
                                      top: 10.0,bottom:10,right:5),
                                  width:20,),

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
                                                  : Color.fromRGBO(0, 0, 0, 0.0),
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
                                                mystate(() {
                                                  if(category2[index]['isSelected'] == true){
                                                    category2[index]['isSelected'] = false;
                                                  }
                                                  else{
                                                    category2[index]['isSelected'] = true;
                                                  }
                                                  updateSelectedTags(category2[index]['name'].toString());
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
                                                        : Colors.white,)
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
                                      color: Colors.grey,
                                      fontSize: 13.0.sp)),
                              SizedBox(width:10),
                              Expanded(
                                  child:Divider(
                                      color: Colors.grey,thickness: 1
                                  )
                              ),

                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 25.0,right:25.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(0, 0, 0, 0.0),
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
                                                  : Color.fromRGBO(0, 0, 0, 0.0),
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
                                                mystate(() {
                                                  if(type1[index]['isSelected'] == true){
                                                    type1[index]['isSelected'] = false;
                                                  }
                                                  else{
                                                    type1[index]['isSelected'] = true;
                                                  }
                                                  updateSelectedTags(type1[index]['name'].toString());
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
                                                        : Colors.white,)
                                              ),

                                            )):
                                        index==0?
                                        Container(
                                          child:Text(
                                              type1[index]['name'].toString(),
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
                                              type1[index]['name'].toString(),
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
                                  width:20,),

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
                                                  : Color.fromRGBO(0, 0, 0, 0.0),
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
                                                mystate(() {
                                                  if(type2[index]['isSelected'] == true){
                                                    type2[index]['isSelected'] = false;
                                                  }
                                                  else{
                                                    type2[index]['isSelected'] = true;
                                                  }
                                                  updateSelectedTags(type2[index]['name'].toString());
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
                                                        : Colors.white,)
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
                                      color: Colors.grey,
                                      fontSize: 13.0.sp)),
                              SizedBox(width:10),
                              Expanded(
                                  child:Divider(
                                      color: Colors.grey,thickness: 1
                                  )
                              ),

                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 25.0,right:25.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(0, 0, 0, 0.0),
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
                                                  : Color.fromRGBO(0, 0, 0, 0.0),
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
                                                mystate(() {
                                                  if(ambiance1[index]['isSelected'] == true){
                                                    ambiance1[index]['isSelected'] = false;
                                                  }
                                                  else{
                                                    ambiance1[index]['isSelected'] = true;
                                                  }
                                                  updateSelectedTags(ambiance1[index]['name'].toString());
                                                });
                                              },
                                              title:
                                              Text(
                                                  ambiance1[index]['name'].toString().toUpperCase(),
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: ambiance1[index]['isSelected'] == true
                                                        ? Colors.white
                                                        : Colors.white,)
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
                                      top: 10.0,bottom:10,right:5),
                                  width:20,),

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
                                                  : Color.fromRGBO(0, 0, 0, 0.0),
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
                                                mystate(() {
                                                  if(ambiance2[index]['isSelected'] == true){
                                                    ambiance2[index]['isSelected'] = false;
                                                  }
                                                  else{
                                                    ambiance2[index]['isSelected'] = true;
                                                  }
                                                  updateSelectedTags(ambiance2[index]['name'].toString());
                                                });
                                              },
                                              title:
                                              Text(
                                                  ambiance2[index]['name'].toString().toUpperCase(),
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: type2[index]['isSelected'] == true
                                                        ? Colors.white
                                                        : Colors.white,)
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

                      ],
                    ),
                    // Align(
                    //   alignment: Alignment.bottomCenter,
                    //   child:
                    // ),
                  ],
                ),
              ),


            );
          });
        });
  }

  void onShowAddress(){
    showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: true,
        backgroundColor: Color.fromRGBO(0, 0, 0, 0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: this.context,
        builder: (context) {
          return  StatefulBuilder(builder: (BuildContext context, StateSetter mystate) {
            return Container(
              height:MediaQuery.of(context).size.height -100,
              // padding:
              padding: MediaQuery.of(context).viewInsets,
              //height:30.0.h,
              child:
              Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 20.0,top:15),
                        child: GestureDetector(
                            onTap:(){
                              Navigator.pop(context);
                            },
                            child:
                            Icon(Icons.arrow_back_ios,size: 20,color:Colors.white)
                        ),
                      ),

                      Expanded(
                        child:Container(
                          //width:250,
                          height:55,
                          margin: const EdgeInsets.only(bottom: 15.0),
                          padding: const EdgeInsets.only(left: 10.0, right: 30.0,top:25),
                          child:TextField(
                            autofocus: false,
                            controller: paletteCtrl,
                            cursorColor: Colors.black,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.go,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: const InputDecoration(
                                counterText: '',
                                filled: true,
                                // Color(0xFFD6D6D6)
                                fillColor: Color(0xFFF2F2F2),
                                contentPadding:EdgeInsets.symmetric(horizontal: 15,vertical:0),
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
                                suffixIcon: Icon(
                                  Icons.search,
                                  color: Colors.black,
                                  size: 20.0,
                                ),
                                hintStyle: TextStyle(
                                    fontSize: 14,
                                    color:Colors.grey),
                                hintText: "Search"),
                          ),
                        ),
                      ),

                    ],
                  ),

                  Expanded(
                    child:MediaQuery.removePadding(
                      removeTop: true,
                      context: context,
                      child:ListView(
                        shrinkWrap: true,
                        //physics: NeverScrollableScrollPhysics(),
                        // crossAxisCount: 2,
                        // // mainAxisSpacing: 10.0,
                        // crossAxisSpacing: 10.0,
                        // childAspectRatio: aspectRatio,
                        children: <Widget>[
                          Container(
                            //color:Colors.black,
                            padding: const EdgeInsets.only(left:20,bottom:10,right:30),
                            child:Column(
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        Image.asset('images/icon_location_camera.png',height: 35.0,color: Color(constant.Color.crave_orange),),
                                        SizedBox(
                                          height:5
                                        ),
                                        Text('0km',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 10.0.sp)),
                                      ],
                                    ),
                                    SizedBox(width:10),
                                    Container(
                                      width:75.0.w,
                                      padding:EdgeInsets.only(left:10),
                                      child:
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Your current location',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 12.0.sp)),
                                          SizedBox(height:0.5.h),
                                          Text(this.widget.address,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10.0.sp)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          Container(
                            padding: const EdgeInsets.only(left:20,right:20,top:0,bottom:5),
                            child:Divider(
                              color: Colors.grey,
                            ),
                          ),
                          Container(
                            //color:Colors.black,
                            padding: const EdgeInsets.only(left:20,bottom:10,right:20),
                            child:Column(
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        Image.asset('images/icon_location_camera.png',height: 35.0),
                                        SizedBox(
                                            height:5
                                        ),
                                        Text('1.2km',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 10.0.sp)),
                                      ],
                                    ),
                                    SizedBox(width:5),
                                    Container(
                                      width:75.0.w,
                                      padding:EdgeInsets.only(left:10),
                                      child:
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Address A',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 12.0.sp)),
                                          SizedBox(height:0.5.h),
                                          Text('Lingkaran Syed Putra, Mid Valley City, 59200 Kuala Lumpur, Wilayah Persekutuan Kuala Lumpur ',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10.0.sp)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left:20,right:20,top:0,bottom:5),
                            child:Divider(
                              color: Colors.grey,
                            ),
                          ),
                          Container(
                            //color:Colors.black,
                            padding: const EdgeInsets.only(left:20,bottom:10,right:20),
                            child:Column(
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        Image.asset('images/icon_location_camera.png',height: 35.0),
                                        SizedBox(
                                            height:5
                                        ),
                                        Text('1.2km',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 10.0.sp)),
                                      ],
                                    ),
                                    SizedBox(width:5),
                                    Container(
                                      width:75.0.w,
                                      padding:EdgeInsets.only(left:10),
                                      child:
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Address A',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 12.0.sp)),
                                          SizedBox(height:0.5.h),
                                          Text('Lingkaran Syed Putra, Mid Valley City, 59200 Kuala Lumpur, Wilayah Persekutuan Kuala Lumpur ',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10.0.sp)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left:20,right:20,top:0,bottom:5),
                            child:Divider(
                              color: Colors.grey,
                            ),
                          ),
                          Container(
                            //color:Colors.black,
                            padding: const EdgeInsets.only(left:20,bottom:10,right:20),
                            child:Column(
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        Image.asset('images/icon_location_camera.png',height: 35.0),
                                        SizedBox(
                                            height:5
                                        ),
                                        Text('1.2km',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 10.0.sp)),
                                      ],
                                    ),
                                    SizedBox(width:5),
                                    Container(
                                      width:75.0.w,
                                      padding:EdgeInsets.only(left:10),
                                      child:
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Address A',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 12.0.sp)),
                                          SizedBox(height:0.5.h),
                                          Text('Lingkaran Syed Putra, Mid Valley City, 59200 Kuala Lumpur, Wilayah Persekutuan Kuala Lumpur ',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10.0.sp)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left:20,right:20,top:0,bottom:5),
                            child:Divider(
                              color: Colors.grey,
                            ),
                          ),
                          Spacer(),

                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: onShowAddAddress,
                    child:Container(
                      decoration: BoxDecoration(
                          border:Border(
                              bottom: BorderSide(
                                color:Colors.white,
                              )
                          )
                      ),
                      //width: double.maxFinite,
                      padding: const EdgeInsets.only(bottom:1,top:20),
                      child:Text("Add your own address",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            // decoration: TextDecoration.underline,
                             // fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontSize: 12.0.sp)),
                    ),
                  ),
                  SizedBox(height:5.0.h)
                ],
              ),


            );
          });
        });
  }

  void onShowAddAddress(){
    showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: this.context,
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
                          padding: const EdgeInsets.only(bottom:15),
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
                                        child:Text("Add Address",
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                          child: Text("Location Name",
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
                            controller: addLocationCtrl,
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
                                hintText: "Location Name"),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.only(left:30,right:30,top:0,bottom:10),
                      child:Divider(
                        color: Color(0x80606060),
                      ),
                    ),

                    //address
                    SizedBox(height:1.0.h),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                          child: Text("Address",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Color(constant.Color.crave_brown),
                                  fontSize: 12.0.sp)),
                        ),

                        Container(
                          //width:250,
                          height:5*24.0,
                          padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                          child:TextField(
                            autofocus: false,
                            maxLines: 5,
                            controller: addAddressCtrl,
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
                                hintText: "Street Address"),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.only(left:30,right:30,top:0,bottom:10),
                      child:Divider(
                        color: Color(0x80606060),
                      ),
                    ),

                    //postcode
                    SizedBox(height:1.0.h),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                          child: Text("Postcode",
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
                            controller: addPostcodeCtrl,
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
                                hintText: "12345"),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.only(left:30,right:30,top:0,bottom:10),
                      child:Divider(
                        color: Color(0x80606060),
                      ),
                    ),

                    //city
                    SizedBox(height:1.0.h),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                          child: Text("City",
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
                            controller: addCityCtrl,
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
                                hintText: "City"),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.only(left:30,right:30,top:0,bottom:10),
                      child:Divider(
                        color: Color(0x80606060),
                      ),
                    ),

                    //state
                    SizedBox(height:1.0.h),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                          child: Text("State",
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
                            controller: addStateCtrl,
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
                                hintText: "State"),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.only(left:30,right:30,top:0,bottom:10),
                      child:Divider(
                        color: Color(0x80606060),
                      ),
                    ),
                  ],
                ),


              );


          });
        });
  }

  void onShowAddCaption(){
    showDialog(
        context: this.context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add Caption'),
            content: TextField(
              controller: captionCtrl,
              decoration: InputDecoration(hintText: "Add Caption"),
            ),
            actions: <Widget>[
              FlatButton(
                color: Color(constant.Color.crave_orange),
                textColor: Colors.white,
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              FlatButton(
                color: Color(constant.Color.crave_blue),
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
    // showModalBottomSheet(
    //     isScrollControlled: true,
    //     isDismissible: true,
    //     backgroundColor: Colors.white,
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(10.0),
    //     ),
    //     context: this.context,
    //     builder: (context) {
    //       return  StatefulBuilder(builder: (BuildContext context, StateSetter mystate) {
    //         return
    //           Container(
    //             //height:MediaQuery.of(context).size.height,
    //             // padding:
    //             padding: MediaQuery.of(context).viewInsets,
    //             //height:30.0.h,
    //             child:
    //             Column(
    //               children: [
    //                 Column(
    //                   children: [
    //                     Container(
    //                       padding: const EdgeInsets.only(bottom:15),
    //                       decoration: BoxDecoration(
    //                         borderRadius: BorderRadius.only(
    //                           bottomRight: Radius.circular(15),
    //                           bottomLeft: Radius.circular(15),
    //                         ),
    //                         border: Border.all(
    //                           width: 2,
    //                           color: Color(constant.Color.crave_grey),
    //                           style: BorderStyle.solid,
    //                         ),
    //                       ),
    //                       child:Column(
    //                         children: [
    //                           SafeArea(
    //                             bottom:false,
    //                             child:
    //                             Row(
    //                               children: [
    //                                 Container(
    //                                   padding: const EdgeInsets.only(left: 20.0,top:50),
    //                                   child: GestureDetector(
    //                                       onTap:(){
    //                                         Navigator.pop(context);
    //                                       },
    //                                       child:
    //                                       Icon(Icons.arrow_back_ios,size: 20,color:Colors.grey)
    //                                   ),
    //                                 ),
    //                                 Container(
    //                                     padding: const EdgeInsets.only(
    //                                         top: 50.0,bottom:0,left:10),
    //                                     //width:MediaQuery.of(context).size.width,
    //                                     child:Text("Add Caption",
    //                                         textAlign: TextAlign.start,
    //                                         style: TextStyle(
    //                                             fontWeight: FontWeight.w700,
    //                                             color: Color(constant.Color.crave_brown),
    //                                             fontSize: 16.0.sp))
    //                                 ),
    //
    //
    //                               ],
    //                             ),
    //
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //
    //                   ],
    //                 ),
    //                 //address
    //                 SizedBox(height:2.0.h),
    //                 Column(
    //                   mainAxisAlignment: MainAxisAlignment.start,
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //                     Container(
    //                       padding: const EdgeInsets.only(left: 30.0, right: 30.0),
    //                       child: Text("Caption",
    //                           textAlign: TextAlign.left,
    //                           style: TextStyle(
    //                               fontWeight: FontWeight.w700,
    //                               color: Color(constant.Color.crave_brown),
    //                               fontSize: 12.0.sp)),
    //                     ),
    //
    //                     Container(
    //                       //width:250,
    //                       height:5*24.0,
    //                       padding: const EdgeInsets.only(left: 30.0, right: 30.0),
    //                       child:TextField(
    //                         autofocus: false,
    //                         maxLines: 5,
    //                         controller: captionCtrl,
    //                         cursorColor: Colors.black,
    //                         keyboardType: TextInputType.text,
    //                         textInputAction: TextInputAction.go,
    //                         textCapitalization: TextCapitalization.sentences,
    //                         decoration: const InputDecoration(
    //                             counterText: '',
    //                             filled: false,
    //                             // Color(0xFFD6D6D6)
    //                             fillColor: Color(0xFFF2F2F2),
    //                             contentPadding:EdgeInsets.symmetric(horizontal: 0,vertical:10),
    //                             labelStyle: TextStyle(
    //                                 fontSize: 14,
    //                                 color:Colors.black
    //                             ),
    //                             enabledBorder: UnderlineInputBorder(
    //                               borderSide: BorderSide(color:Colors.transparent ),
    //                             ),
    //                             border: UnderlineInputBorder(
    //                               borderSide: BorderSide(color:Colors.transparent ),
    //                             ),
    //                             focusedBorder: UnderlineInputBorder(
    //                               borderSide: BorderSide(color:Colors.transparent, ),
    //                             ),
    //                             hintStyle: TextStyle(
    //                               fontSize: 17,
    //                             ),
    //                             hintText: "Image caption"),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //                 Container(
    //                   padding: const EdgeInsets.only(left:30,right:30,top:0,bottom:10),
    //                   child:Divider(
    //                     color: Color(0x80606060),
    //                   ),
    //                 ),
    //
    //               ],
    //             ),
    //
    //
    //           );
    //
    //
    //       });
    //     });
  }

  void onSelectOptions(String option){
    if(option == "music"){
      setState(() {
         isMusic = true;
         isFilter = false;
         isText = false;
      });
    }
    else if(option == "filter"){
      setState(() {
        isMusic = false;
        isFilter = true;
        isText = false;
      });
    }
    else if(option == "text"){
      // onShowAddCaption();
      _tapHandler(_text, _textStyle, _textAlign);
      setState(() {
        isMusic = false;
        isFilter = false;
        isText = true;
      });
    }

  }

  void _onFilterChanged(List<double> value) {
    _filterColor.value = value;
    currentFilter = value.toString();
    print("current color");
    print(currentFilter);
  }

  void _onMusicChanged(index) async{
    currentMusic = _musics[index];
    if(index!=0){
      String url = constant.Url.music_audio_url+_musics[index]+".mp3";
      await player.setUrl(url);
      player.play(url);
    }
    else{
      player.stop();
    }
  }

  Widget _buildFilterSelector() {
    return FilterSelector(
      onFilterChanged: _onFilterChanged,
      filters: _filters,
    );
  }

  Widget _buildMusicSelector() {
    return MusicSelector(
      onFilterChanged: _onMusicChanged,
      musics: _musics,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder:(context, constraints){
          return OrientationBuilder(
              builder:(context, orientation){
                return Sizer(
                    builder: (context, orientation, screenType) {
                      return Scaffold(
                        backgroundColor: Colors.black,
                        body:
                        Stack(
                          children: [
                            ValueListenableBuilder(
                              valueListenable: _filterColor,
                              builder: (context, value, child) {
                                final color = value as List<double>;
                                return
                                //   Container(
                                //   color:color,
                                // );

                                  ColorFiltered(
                                      colorFilter: ColorFilter.matrix(color),
                                      child: Image.file(widget.imageFile,
                                        height: double.infinity,

                                        fit: BoxFit.cover,),

                                );
                              },
                            ),

                            // Image.file(widget.imageFile),
                            // Expanded(
                            //   child:ColorFiltered(
                            //     colorFilter:
                            //     // ColorFilter.matrix([
                            //     //   0.9,0.5,0.1,0.0,0.0,
                            //     //   0.3,0.8,0.1,0.0,0.0,
                            //     //   0.2,0.3,0.5,0.0,0.0,
                            //     //   0.0,0.0,0.0,1.0,0.0
                            //     // ]),
                            //
                            //     ColorFilter.mode(
                            //       Colors.transparent,
                            //       BlendMode.multiply,
                            //     ),
                            //     child:
                            //   ),
                            //
                            // ),

                            //filter wheel
                            Visibility(
                              visible:isFilter,
                              child:RotatedBox(
                                quarterTurns: 3,
                                child:Align(
                                  alignment:Alignment.bottomRight,
                                  child: Container(
                                    child:_buildFilterSelector(),
                                  ),
                                ),

                              ),
                            ),


                            //music wheel
                            Visibility(
                              visible: isMusic,
                              child:RotatedBox(
                                quarterTurns: 3,
                                child:Align(
                                  alignment:Alignment.bottomRight,
                                  child: Container(
                                    child:_buildMusicSelector(),
                                  ),
                                ),

                              ),
                            ),

                            Column(
                              // crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                    color:Color.fromRGBO(0, 0, 0, 0.3),
                                    padding: const EdgeInsets.only(
                                        top: 10.0,bottom:15),
                                    child:SafeArea(
                                      bottom:false,
                                      child: IntrinsicHeight(
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 20.0),
                                              child: GestureDetector(
                                                  onTap:(){
                                                    //Navigator.pop(context);
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => CameraScreen()));
                                                  },
                                                  child:
                                                  Container(
                                                    // height:30,
                                                      width:30,
                                                      color:Colors.transparent,
                                                      child: Icon(Icons.arrow_back_ios,size: 20,color:Colors.white)
                                                  ),
                                              ),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(right: 30.0),
                                              child: GestureDetector(
                                                onTap:(){
                                                  sendMedia();
                                                },
                                                child:Text("DONE",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w700,
                                                        color: Colors.white,
                                                        fontSize: 16.0)),
                                              ),
                                            ),


                                          ],
                                        ),
                                      )
                                    ),

                                ),
                                Spacer(),
                               // SizedBox(height:MediaQuery.of(context).size.height *0.75),
                                GestureDetector(
                                  onTap:onShowAddress,
                                  child: Container(
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
                                          width:MediaQuery.of(context).size.width * 0.85,
                                          margin:const EdgeInsets.only(right:10.0),
                                          padding:const EdgeInsets.only(top: 10.0,left:15.0,right:15.0,bottom:10.0),
                                          decoration: BoxDecoration(
                                              color:Color.fromRGBO(220,220, 220, 0.4),
                                              borderRadius: BorderRadius.all(Radius.circular(30))
                                          ),
                                          child:Text(this.widget.address,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12.0)),
                                        ),


                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap:onShowFoodPalette,
                                  child:Container(
                                    // color:Color.fromRGBO(0, 0, 0, 0.3),
                                    margin: const EdgeInsets.only(bottom: 50.0),
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
                                            child:Text(tags1.toUpperCase(),textAlign: TextAlign.center,
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
                                            child:Text(tags2.toUpperCase(),textAlign: TextAlign.center,
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
                                            child:Text(tags3.toUpperCase(),textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14.0)),
                                          ),
                                        ),
                                        SizedBox(width:8),

                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Align(
                              alignment:Alignment.centerLeft,
                              child: Container(
                                padding: EdgeInsets.only(left: 10.0),
                                child:Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap:(){
                                        onSelectOptions("music");
                                      },
                                      child:isMusic?
                                      Container(
                                        padding:EdgeInsets.all(7),
                                        decoration: BoxDecoration(
                                            color:Color.fromRGBO(0, 0, 0, 0.3),
                                            border: Border.all(
                                              color: Colors.white,
                                            ),
                                            borderRadius: BorderRadius.all(Radius.circular(30))
                                        ),
                                        child: Image.asset('images/icon_music.png',height: 20.0),
                                      ):
                                      Container(
                                        padding:EdgeInsets.all(7),
                                        child: Image.asset('images/icon_music.png',height: 20.0),
                                      )

                                    ),

                                    SizedBox(height:10),
                                    GestureDetector(
                                        onTap:(){
                                          onSelectOptions("filter");
                                        },
                                        child:isFilter?
                                        Container(
                                          padding:EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                              color:Color.fromRGBO(0, 0, 0, 0.3),
                                              border: Border.all(
                                                color: Colors.white,
                                              ),
                                              borderRadius: BorderRadius.all(Radius.circular(30))
                                          ),
                                          child: Image.asset('images/icon_filter.png',height: 30.0),
                                        ):
                                        Container(
                                          padding:EdgeInsets.all(3),
                                          child: Image.asset('images/icon_filter.png',height: 30.0),
                                        )

                                    ),

                                    SizedBox(height:15),
                                    GestureDetector(
                                        onTap:(){
                                          onSelectOptions("text");
                                        },
                                        child:isText?
                                        Container(
                                          padding:EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                              color:Color.fromRGBO(0, 0, 0, 0.3),
                                              border: Border.all(
                                                color: Colors.white,
                                              ),
                                              borderRadius: BorderRadius.all(Radius.circular(30))
                                          ),
                                          child: Image.asset('images/icon_text.png',height: 25.0),
                                        ):
                                        Container(
                                          padding:EdgeInsets.all(3),
                                          child: Image.asset('images/icon_text.png',height: 25.0),
                                        )

                                    ),

                                  ],
                                ),
                              )
                            ),

                            Container(
                              // color:Colors.yellow,
                              height: 100.0.h,
                              width: 100.0.w,
                              margin: EdgeInsets.only(left:15.0.w,bottom:40.0.w),
                              padding: EdgeInsets.only(top:30.w,right:15.0.w),
                              child: Center(
                                child: Text(
                                  _text,
                                  style: _textStyle,
                                  textAlign: _textAlign,
                                ),
                              ),

                            ),


                          ],
                        ),
                      );
                    }
                );
              }
          );
        }
    );

  }
}
