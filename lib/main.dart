import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app/app.dart';
import 'features/profile/hydration_settings.dart';
import 'features/profile/hydration_settings_storage.dart';
import 'firebase_options.dart';

import 'package:provider/provider.dart';
import 'features/home/water_intake_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  MaterialApp(
  theme: ThemeData(
    fontFamily: 'Quicksand',
  ),
);

  await _initializeFirebaseIfSupported();

  final savedGoal = await HydrationSettingsStorage.loadDailyGoalMl();
  HydrationSettings.instance.dailyGoalMl = savedGoal;

  

  runApp(
    ChangeNotifierProvider(
      create: (_) => WaterIntakeController(
        goalMl: savedGoal,
        currentMl: 0,
      ),
      child: const PlantApp(),
    ),
  );
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