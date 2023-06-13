import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot_detector/screenshot_detector.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _screenshotDetectorPlugin = ScreenshotDetector();
  bool _isPermissionGranted = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    super.initState();

    _checkPermissions();

    _screenshotDetectorPlugin.setOnScreenCapturedListener(() {
      print("setOnScreenCapturedListener");
      ScaffoldMessenger.of(_scaffoldKey.currentState!.context).showSnackBar(
        const SnackBar(
          content: Text("Screenshot detected!"),
        ),
      );
    });
  }

  _checkPermissions() async {
    Permission permission;
    if (Platform.isIOS) {
      permission = Permission.photos;
    } else if (Platform.isAndroid) {
      permission = Permission.storage;
    } else {
      throw Exception('Permissions are not handled for current platform');
    }

    if (await permission.isDenied && await permission.request().isDenied) {
      return;
    } else {
      debugPrint("Permission granted!");
      setState(() {
        _isPermissionGranted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: _isPermissionGranted
              ? const Text(
                  'All set! You can do the screenshot.',
                  textAlign: TextAlign.center,
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'You should give the storage permission for the screenshot detector to work.',
                      textAlign: TextAlign.center,
                    ),
                    ElevatedButton(onPressed: _checkPermissions, child: const Text("Give Permission"))
                  ],
                ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _screenshotDetectorPlugin.dispose();

    super.dispose();
  }
}
