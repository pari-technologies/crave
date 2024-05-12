import 'package:a_crave/profileUser.dart';

import 'chatPage.dart';
import 'cravingsPage.dart';
import 'homepage.dart';
import 'reels.dart';

import 'almostThere.dart';
import 'feed.dart';
import 'feedDetails.dart';
import 'forgotPassword.dart';
import 'profileSetupPalette.dart';
import 'profileSetupPicture.dart';
import 'reelsDetails.dart';
import 'resetPassword.dart';
import 'forgotPasswordSend.dart';
import 'showStories.dart';
import 'splashscreen.dart';
import 'splashscreen2.dart';
import 'verification.dart';
import 'package:flutter/material.dart';
import 'dataClass.dart';

import 'login.dart';
import 'register.dart';
import 'welcome.dart';
import 'package:camera/camera.dart';

import 'package:flutter/services.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

List<CameraDescription> cameras = [];
// late final FirebaseMessaging _messaging;
Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  // registerNotification();
  runApp(MyApp());
}
// void main() {
//   runApp(const MyApp());
// }

// void registerNotification() async {
//   // 1. Initialize the Firebase app
//   await Firebase.initializeApp();
//
//   // 2. Instantiate Firebase Messaging
//   _messaging = FirebaseMessaging.instance;
//
//   // Add the following line
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//
//   // 3. On iOS, this helps to take the user permissions
//   NotificationSettings settings = await _messaging.requestPermission(
//     alert: true,
//     badge: true,
//     provisional: false,
//     sound: true,
//   );
//
//   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//     print('User granted permission');
//
//     // For handling the received notifications
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       // Parse the message received
//       PushNotification notification = PushNotification(
//         title: message.notification?.title,
//         body: message.notification?.body,
//       );
//
//       // setState(() {
//       //   _notificationInfo = notification;
//       //   _totalNotifications++;
//       // });
//     });
//   } else {
//     print('User declined or has not accepted permission');
//   }
// }
//
// Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print("Handling a background message: ${message.messageId}");
// }

Widget randomScreen(int max) {
  //getFirebase();
  var num = 1;
  print(num);
  switch (num) {
    case 1: return const SplashScreen();break;
  }
  return const SplashScreen();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: randomScreen(4),
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.cyan[600],

        // Define the default font family.
        fontFamily: 'Poppins',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.

      ),
      routes: <String, WidgetBuilder> {
        '/splash': (BuildContext context) => const SplashScreen(),
        '/splash2': (BuildContext context) => const SplashScreenTwo(),
        '/welcome': (BuildContext context) => const Welcome(),
        '/login': (BuildContext context) => const Login(),
        '/register': (BuildContext context) => const Register(),
        '/verification': (BuildContext context) => const Verification(),
        '/almostThere': (BuildContext context) => const AlmostThere(),
        '/forgotPassword': (BuildContext context) => const ForgotPassword(),
        '/forgotPasswordSend': (BuildContext context) => const ForgotPasswordSend(),
        '/resetPass': (BuildContext context) => const ResetPassword(),
        '/profileSetupPicture': (BuildContext context) => const ProfileSetupPicture(),
        // '/profileSetupPalette': (BuildContext context) => const ProfileSetupPalette(),
        // '/homepage': (BuildContext context) => const Homepage(),
        // '/feed': (BuildContext context) => const Feed(),
        // '/feedDetails': (BuildContext context) => const FeedDetails(),
        '/stories': (BuildContext context) => StoryPageView(),
        // '/reels': (BuildContext context) => Reels(),
        // '/reelsDetails': (BuildContext context) => ReelsDetails(),
        // '/chatPage': (BuildContext context) => ChatPage(),
        // '/profileUser': (BuildContext context) => ProfileUser(),
        '/cravingsPage': (BuildContext context) => CravingsPage(),

      },
    );
  }
}
