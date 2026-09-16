import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class UserService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> saveUserProfile(User user, Locale locale) async {
    try {
      final docRef = _firestore.collection('users').doc(user.uid);
      final docSnapshot = await docRef.get();
      final langCode = locale.languageCode;
      final platform = Platform.isIOS ? 'ios' : 'android';

      String? fcmToken;
      try {
        final messaging = FirebaseMessaging.instance;
        await messaging.requestPermission(
          alert: true,
          badge: true,
          sound: true,
          provisional: false,
        );

        if (Platform.isIOS) {
          var apnsToken = await messaging.getAPNSToken();
          if (apnsToken == null) {
            await Future.delayed(const Duration(milliseconds: 1000));
            apnsToken = await messaging.getAPNSToken();
          }
          if (apnsToken != null) {
            fcmToken = await messaging.getToken();
          } else {
            debugPrint('APNS token is not available yet (e.g. Simulator).');
          }
        } else {
          fcmToken = await messaging.getToken();
        }
      } catch (e) {
        debugPrint('Error getting FCM token: $e');
      }

      final userData = <String, dynamic>{
        'uid': user.uid,
        'email': user.email ?? '',
        'displayName': user.displayName ?? '',
        'photoURL': user.photoURL ?? '',
        'language': langCode,
        'platform': platform,
        'fcmToken': fcmToken ?? '',
        'lastLoginAt': FieldValue.serverTimestamp(),
      };

      if (!docSnapshot.exists) {
        userData['createdAt'] = FieldValue.serverTimestamp();
        await docRef.set(userData);
      } else {
        await docRef.update(userData);
      }
    } catch (e) {
      debugPrint('Error saving user profile to Firestore: $e');
    }
  }
}
