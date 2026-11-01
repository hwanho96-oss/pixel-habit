import 'package:flutter/material.dart';
import 'package:pixel_habit/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();
  runApp(PixelHabitApp(preferences: preferences));
}
