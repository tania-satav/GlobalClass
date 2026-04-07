import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app/app.dart';
import 'features/profile/hydration_settings.dart';
import 'features/profile/hydration_settings_storage.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final savedGoal = await HydrationSettingsStorage.loadDailyGoalMl();
  HydrationSettings.instance.dailyGoalMl = savedGoal;

  runApp(const PlantApp());
}
