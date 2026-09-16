import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'analytics_service.dart';

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

      // Log User ID and User Properties to Firebase Analytics
      await AnalyticsService.setUserId(user.uid);
      await AnalyticsService.setUserProperty(name: 'language', value: langCode);
      await AnalyticsService.setUserProperty(name: 'platform', value: platform);

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

  /// Update FCM token in Firestore for the current user
  static Future<void> updateFcmToken() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      String? fcmToken;
      final messaging = FirebaseMessaging.instance;

      if (Platform.isIOS) {
        var apnsToken = await messaging.getAPNSToken();
        if (apnsToken == null) {
          await Future.delayed(const Duration(milliseconds: 1000));
          apnsToken = await messaging.getAPNSToken();
        }
        if (apnsToken != null) {
          fcmToken = await messaging.getToken();
        }
      } else {
        fcmToken = await messaging.getToken();
      }

      if (fcmToken != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'fcmToken': fcmToken,
        });
        debugPrint('FCM token updated in Firestore');
      }
    } catch (e) {
      debugPrint('Error updating FCM token: $e');
    }
  }

  /// Remove FCM token from Firestore for the current user
  static Future<void> removeFcmToken() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      await _firestore.collection('users').doc(user.uid).update({
        'fcmToken': FieldValue.delete(),
      });

      // Also delete the FCM token from Firebase Messaging
      await FirebaseMessaging.instance.deleteToken();
      debugPrint('FCM token removed from Firestore');
    } catch (e) {
      debugPrint('Error removing FCM token: $e');
    }
  }
}
