import 'package:flutter/material.dart';
import 'package:steganografy_app/screens/home.dart';
import 'package:steganografy_app/utils/constants.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(windowsWidth, windowsHeight),
    minimumSize: Size(windowsWidth, windowsHeight),
    center: true,
    backgroundColor: Colors.transparent,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Steganografy App',
      home: const Home(),
    );
  }
}
