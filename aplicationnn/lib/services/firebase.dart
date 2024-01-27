import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseService{

  late final FirebaseMessaging messaging;

  void settingNotification()async{
    await messaging.requestPermission(
      alert: true,
      sound: true,

      badge: true
    );
  }

  static Future setupOneSignal( )async{

 OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
   OneSignal.shared.setAppId("252114c9-9268-4c06-9841-f7b3bb31c0ab");
OneSignal.shared
        .promptUserForPushNotificationPermission() // kullanıcıdan izin al
        .then((accepted) {
      debugPrint("Accepted permission: $accepted");
    });


    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result){

      //kullanıcı bildirime tıkladığında sonuc döndürüyor
      print("vERİİİİİİİİİİİİİİİİİ");
      print(result.notification.androidNotificationId);
      /*result.notification.additionalData?['id'];
      OSNotificationActionType? actionType= result.action?.type;
Map<String, dynamic>? data=  result.notification?.additionalData;

if(actionType== OSNotificationActionType.actionTaken){

 String? actionId= result.action?.actionId;
 if(actionId==1){
   Navigator.push(context, MaterialPageRoute(builder: (context)=>NotificationScreen() ));
 }
}*/
    });


// The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    /*OneSignal.Notifications.requestPermission(true);
    OneSignal.User.pushSubscription.optIn();
    OneSignal.User.pushSubscription.optedIn;
    OneSignal.User.pushSubscription.id;
    OneSignal.User.pushSubscription.token;
    print(OneSignal.User.pushSubscription.token);
    print("+++++++++++");
    print(OneSignal.User.pushSubscription.id);*/
  }
  void connectNotification() async{
    await Firebase.initializeApp();
    messaging=FirebaseMessaging.instance;
    messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        sound: true,
        badge: true);
    settingNotification();
    FirebaseMessaging.onMessage.listen((RemoteMessage event) { //mesajı dinleme
      print(event.notification!.title);

    });
    messaging.getToken().then((value) async{
      SharedPreferences tokenn = await SharedPreferences.getInstance();
      tokenn.setString('token', "Token:$value");
          print("Token:$value");
    },  );

  }
}