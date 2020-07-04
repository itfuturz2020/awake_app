import 'package:awake_app/Common/Constants.dart' as cnst;
import 'package:awake_app/Screens/Achievements.dart';
import 'package:awake_app/Screens/AddOffer.dart';
import 'package:awake_app/Screens/BioSheet.dart';
import 'package:awake_app/Screens/ConclaveBarterPartner.dart';
import 'package:awake_app/Screens/ConclaveCategory.dart';
import 'package:awake_app/Screens/ConclaveCommittee.dart';
import 'package:awake_app/Screens/ConclaveCorporateEmpanellment.dart';
import 'package:awake_app/Screens/ConclaveDashboard.dart';
import 'package:awake_app/Screens/ConclaveDirectory.dart';
import 'package:awake_app/Screens/ConclaveEvents.dart';
import 'package:awake_app/Screens/ConclaveExhibitors.dart';
import 'package:awake_app/Screens/ConclaveFoodStall.dart';
import 'package:awake_app/Screens/ConclaveLogin.dart';
import 'package:awake_app/Screens/ConclaveOTP.dart';
import 'package:awake_app/Screens/ConclaveOneTwoOne.dart';
import 'package:awake_app/Screens/ConclaveProfile.dart';
import 'package:awake_app/Screens/ConclaveSignUp.dart';
import 'package:awake_app/Screens/ConclaveSpeakerDetails.dart';
import 'package:awake_app/Screens/ConclaveSpeakerList.dart';
import 'package:awake_app/Screens/ConclaveSponsor.dart';
import 'package:awake_app/Screens/Events.dart';
import 'package:awake_app/Screens/FeaturePresentation.dart';
import 'package:awake_app/Screens/FeedbackScreen.dart';
import 'package:awake_app/Screens/MemberDirectory.dart';
import 'package:awake_app/Screens/MemberProfile.dart';
import 'package:awake_app/Screens/MyStallVisitorList.dart';
import 'package:awake_app/Screens/Offers.dart';
import 'package:awake_app/Screens/OneTwoOneWithED.dart';
import 'package:awake_app/Screens/RegionalTeam.dart';
import 'package:awake_app/Screens/SearchMember.dart';
import 'package:awake_app/Screens/Splash.dart';
import 'package:awake_app/Screens/SuccessStories.dart';
import 'package:awake_app/Screens/Trainings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String Title;
  String bodymessage;
  @override
  void initState() {
    // TODO: implement initState

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        Title = message["notification"]["title"];
        bodymessage = message["notification"]["body"];
        //Get.to(OverlayScreen(message))
        print("onMessage  $message");
        showNotification('$Title', '$bodymessage');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );

    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings);
  }

  showNotification(String title, String body) async {
    var android = new AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.High, importance: Importance.Max, playSound: false);
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(0, '$title', '$body', platform);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BNI Evolve',
      initialRoute: '/',
      routes: {
        '/': (context) => Splash(),
        '/MemberDirectory': (context) => MemberDirectory(),
        '/MemberProfile': (context) => MemberProfile(),
        '/ConclaveLogin': (context) => ConclaveLogin(),
        '/ConclaveSignUp': (context) => ConclaveSignUp(),
        '/ConclaveDashboard': (context) => ConclaveDashboard(),
        '/ConclaveSpeakerDetails': (context) => ConclaveSpeakerDetails(),
        '/MyVisitorsList': (context) => MyVisitorsList(),
        '/ConclaveProfile': (context) => ConclaveProfile(),
        '/ConclaveCommittee': (context) => ConclaveCommittee(),
        '/ConclaveFoodStall': (context) => ConclaveFoodStall(),
        '/ConclaveEvents': (context) => ConclaveEvents(),
        '/ConclaveDirectory': (context) => ConclaveDirectory(),
        '/FeedbackScreen': (context) => FeedbackScreen(),
        '/ConclaveSponsor': (context) => ConclaveSponsor(),
        '/ConclaveBarterPartner': (context) => ConclaveBarterPartner(),
        '/SearchMember': (context) => SearchMember(),
        '/ConclaveCorporateEmpanellment': (context) =>
            ConclaveCorporateEmpanellment(),
        '/ConclaveOTP': (context) => ConclaveOTP(),
        '/ConclaveSpeakerList': (context) => ConclaveSpeakerList(),
        '/ConclaveOneTwoOne': (context) => ConclaveOneTwoOne(),
        '/ConclaveCategory': (context) => ConclaveCategory(),
        '/ConclaveExhibitors': (context) => ConclaveExhibitors(),
        '/BioSheet': (context) => BioSheet(),
        '/Trainings': (context) => Trainings(),
        '/RegionalTeam': (context) => RegionalTeam(),
        '/Offers': (context) => Offers(),
        '/Events': (context) => Events(),
        '/SuccessStories': (context) => SuccessStories(),
        '/FeaturePresentation': (context) => FeaturePresentation(),
        '/OneTwoOneWithED': (context) => OneTwoOneWithED(),
        '/AddOffer': (context) => AddOffer(),
        '/Achievements': (context) => Achievements(),
      },
      theme: ThemeData(
        fontFamily: 'Montserrat',
        primarySwatch: cnst.appPrimaryMaterialColor,
        accentColor: cnst.appPrimaryMaterialColor,
        buttonColor: cnst.appPrimaryMaterialColor,
      ),
    );
  }
}
