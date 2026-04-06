import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
<<<<<<< HEAD
import 'app/app.dart';
import 'features/profile/hydration_settings.dart';
import 'features/profile/hydration_settings_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await HydrationSettingsStorage.loadInto(HydrationSettings.instance);

  runApp(const PlantApp());
=======
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Keep Me Hydrated',
      home: const Scaffold(
        body: Center(
          child: Text('Keep Me Hydrated App Running'),
        ),
      ),
    );
  }
>>>>>>> feature/database-stuff
}
