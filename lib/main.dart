import 'dart:io';

import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kneron_fr/comport/com_port.dart';
import 'package:flutter_kneron_fr/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const double screenX = 600.0;
const double screenY = 900.0;

Future<void> main() async {
  if (Platform.isWindows | Platform.isLinux | Platform.isMacOS) {
    WidgetsFlutterBinding.ensureInitialized();
    await DesktopWindow.setWindowSize(
        const Size(screenX, screenY)); // 가로 사이즈, 세로 사이즈 기본 사이즈 부여
    await DesktopWindow.setMinWindowSize(
        const Size(screenX, screenY)); // 최소 사이즈 부여
    await DesktopWindow.setMaxWindowSize(
        const Size(screenX, screenY)); // 최대 사이즈 부여

    utils.log("Window size configured");
  }

  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: const ComPort(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Column(
        children: [
          ComPort(),
        ],
      ),
    );
  }
}
