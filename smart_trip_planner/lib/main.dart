import 'package:flutter/material.dart';
import 'package:smart_trip_planner/core/theme/app_theme.dart';
import 'package:smart_trip_planner/features/auth/presentation/pages/sing_up_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Itinera AI',
      theme: AppTheme.lightTheme,
      home: const SingUpPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
