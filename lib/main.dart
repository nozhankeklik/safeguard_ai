import 'package:flutter/material.dart';
import 'package:safeguard_ai/features/camera/camera_screen.dart';

void main() {
  runApp(const SafeGuardApp());
}

class SafeGuardApp extends StatelessWidget {
  const SafeGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SafeGuard AI',
      theme: ThemeData(
        colorScheme: ColorScheme.dark(
          brightness: Brightness.dark,
          primary: Colors.blue,
          secondary: Colors.cyan,
          surface: Colors.black,
          background: Colors.black,
        ),
        scaffoldBackgroundColor: Colors.black,
        useMaterial3: true,
      ),
      home: const CameraScreen(),
    );
  }
}
