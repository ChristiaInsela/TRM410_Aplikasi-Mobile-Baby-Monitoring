import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:flutter/material.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      // Web configuration
      return const FirebaseOptions(
        apiKey: "AIzaSyDmO0eS-8Plhy1JJkiyqcK3uXYea1_2kkk",
        authDomain: "ivanfirebase-5f82c.firebaseapp.com",
        databaseURL: "https://ivanfirebase-5f82c-default-rtdb.firebaseio.com",
        projectId: "ivanfirebase-5f82c",
        storageBucket: "ivanfirebase-5f82c.appspot.com",
        messagingSenderId: "8717149155",
        appId: "1:8717149155:web:78a055701dd41d86db36d6",
        measurementId: "G-GJDEY0B40G"
      );
    } else {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          return const FirebaseOptions(
            apiKey: "AIzaSyDmO0eS-8Plhy1JJkiyqcK3uXYea1_2kkk",
            authDomain: "ivanfirebase-5f82c.firebaseapp.com",
            databaseURL: "https://ivanfirebase-5f82c-default-rtdb.firebaseio.com",
            projectId: "ivanfirebase-5f82c",
            storageBucket: "ivanfirebase-5f82c.appspot.com",
            messagingSenderId: "8717149155",
            appId: "1:8717149155:android:78a055701dd41d86db36d6",
            measurementId: "G-GJDEY0B40G"
          );
        case TargetPlatform.iOS:
          return const FirebaseOptions(
            apiKey: "AIzaSyDmO0eS-8Plhy1JJkiyqcK3uXYea1_2kkk",
            authDomain: "ivanfirebase-5f82c.firebaseapp.com",
            databaseURL: "https://ivanfirebase-5f82c-default-rtdb.firebaseio.com",
            projectId: "ivanfirebase-5f82c",
            storageBucket: "ivanfirebase-5f82c.appspot.com",
            messagingSenderId: "8717149155",
            appId: "1:8717149155:ios:78a055701dd41d86db36d6",
            measurementId: "G-GJDEY0B40G"
          );
        default:
          throw UnsupportedError(
            'DefaultFirebaseOptions are not supported for this platform.',
          );
      }
    }
  }
}
