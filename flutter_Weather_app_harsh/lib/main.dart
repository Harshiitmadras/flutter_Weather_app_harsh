import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'core/theme.dart';
import 'utils/unit_prefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UnitPrefs.load();
  runApp(const WeatherHarshApp());
}

class WeatherHarshApp extends StatelessWidget {
  const WeatherHarshApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter_Weather_app_harsh',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}
