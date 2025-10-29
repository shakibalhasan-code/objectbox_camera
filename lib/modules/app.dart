import 'package:crud_objtbx/modules/core/config/app_bindings.dart';
import 'package:crud_objtbx/modules/views/screens/home_screen.dart';
import 'package:crud_objtbx/modules/views/screens/video_recording_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ObjBox CRUD',
      initialBinding: AppBindings(),
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}
