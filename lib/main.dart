import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app/app.dart';
import 'features/profile/hydration_settings.dart';
import 'features/profile/hydration_settings_storage.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initializeFirebaseIfSupported();

  final savedGoal = await HydrationSettingsStorage.loadDailyGoalMl();
  HydrationSettings.instance.dailyGoalMl = savedGoal;

  runApp(const PlantApp());
}

Future<void> _initializeFirebaseIfSupported() async {
  if (kIsWeb) {
    return;
  }

  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      break;
    case TargetPlatform.iOS:
    case TargetPlatform.macOS:
    case TargetPlatform.windows:
    case TargetPlatform.linux:
      break;
    default:
      break;
  }
}