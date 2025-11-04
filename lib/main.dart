import 'package:flutter/material.dart';
import 'package:inilab/app.dart';
import 'package:inilab/helper/initialize_app.dart';

Future<void> main() async {
  await InitializeApp.initialize();
  runApp(const MyApp());
}


