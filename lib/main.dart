import 'package:crud_objtbx/modules/app.dart';
import 'package:crud_objtbx/modules/core/db/objectbox_helper.dart';
import 'package:flutter/material.dart';

late ObjectBoxHelper objectbox;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Create an instance of the helper class.
  objectbox = await ObjectBoxHelper.create();
  runApp(const MyApp());
}
