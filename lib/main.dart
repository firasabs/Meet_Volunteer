import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sce_project/interface/otherprofile.dart';
import 'package:sce_project/interface/usercontact.dart';
import 'package:sce_project/intro/login_page.dart';
import 'package:sce_project/interface/meet_volunteer.dart';
import 'package:sce_project/intro/register_page.dart';
import 'package:sce_project/intro/safetyguidelines.dart';
import 'package:sce_project/intro/welcome_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'helpers/firebase_options.dart';
import 'package:sce_project/interface/contact.dart';
import 'package:sce_project/helpers/preference.dart';
import 'interface/browse.dart';
import 'intro/setup.dart';
import 'interface/settings.dart';
import 'interface/yourprofile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../helpers/fetching_user.dart' as userInfo;
import 'package:sce_project/interface/browse.dart' as FetchUser;
import 'package:onesignal_flutter/onesignal_flutter.dart';

String? checkroute;
String? mtoken;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;
FetchUser.User1? otherUser;
Future<void> updateUserLastSeen() async {
  if (_auth.currentUser != null) {
    final userRef = _firestore.collection('users').doc(_auth.currentUser!.uid);
    await userRef.update({'lastSeen': FieldValue.serverTimestamp()});
  }
}

void getToken() async {
  await FirebaseMessaging.instance.getToken().then((token) {
    mtoken = token;
    print('My token is $mtoken');
  });
  saveToken(mtoken!);
}

void saveToken(String token) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid).set({
        'token' : token,
      });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

  OneSignal.initialize("78b4808d-46dc-41c4-8c12-8a58db22916f");

  bool isLoggedIn = await isUserLoggedIn();
  await _requestPermissions();

  requestPermission();
  checkroute = _auth.currentUser != null ? 'meet_volunteer' : 'welcome_page';
  if (checkroute == 'meet_volunteer') {
    await updateUserLastSeen();
  }
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: checkroute,
      routes: {
        "/": (context) => const WelcomePage(),
        WelcomePage.id: (context) => const WelcomePage(),
        LoginPage.id: (context) => const LoginPage(),
        RegisterPage.id: (context) => const RegisterPage(),
        ContactPage.id: (context) => const ContactPage(),
        MeetVolunteer.id: (context) =>
            const MeetVolunteer(key: Key('meetVolunteerWidgetKey')),
        BrowsePage.id: (context) => const BrowsePage(),
        SettingsPage.id: (context) => const SettingsPage(),
        ProfilePage.id: (context) => const ProfilePage(),
        OtherProfile.id: (context) => OtherProfile(otherUser: otherUser!),
        ContactUser.id: (context) => ContactUser(otherUser: otherUser!),
        Setup.id: (context) => const Setup(),
        SafetyGuideLines.id: (context) => const SafetyGuideLines(),
      },
    );
  }
}

Future<void> _requestPermissions() async {
  var storageStatus = await Permission.storage.status;
  if (!storageStatus.isGranted) {
    await Permission.storage.request();
  }

  var galleryStatus = await Permission.photos.status;
  if (!galleryStatus.isGranted) {
    await Permission.photos.request();
  }

  var cameraStatus = await Permission.camera.status;
  if (!cameraStatus.isGranted) {
    await Permission.camera.request();
  }
}

void requestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }
}
