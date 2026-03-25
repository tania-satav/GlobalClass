import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app/app.dart';
import 'features/profile/hydration_settings.dart';
import 'features/profile/hydration_settings_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await HydrationSettingsStorage.loadInto(HydrationSettings.instance);

  runApp(const PlantApp());
}
