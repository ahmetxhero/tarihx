import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAjXQbaDclEhseLBOpWpYYRUQkeCQ6dIqA',
    appId: '1:80353237986:web:df5a04dd44ac23858db7bb',
    messagingSenderId: '80353237986',
    projectId: 'tarihx',
    authDomain: 'tarihx.firebaseapp.com',
    databaseURL: 'https://tarihx-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'tarihx.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAjXQbaDclEhseLBOpWpYYRUQkeCQ6dIqA',
    appId: '1:80353237986:android:eb97e51815ef7d048db7bb',
    messagingSenderId: '80353237986',
    projectId: 'tarihx',
    databaseURL: 'https://tarihx-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'tarihx.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDvJ9r-fnLuZBVKWLnHIegJCckQNFpkW_M',
    appId: '1:80353237986:ios:8f15c146546e09e58db7bb',
    messagingSenderId: '80353237986',
    projectId: 'tarihx',
    databaseURL: 'https://tarihx-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'tarihx.firebasestorage.app',
    iosClientId: '80353237986-hte4b9ul895v2leu1cte68fm5q5oviqs.apps.googleusercontent.com',
    iosBundleId: 'app.web.tarihx',
  );
}
