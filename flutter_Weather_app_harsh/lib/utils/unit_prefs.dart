import 'package:shared_preferences/shared_preferences.dart';

class UnitPrefs {
  static const _key = 'unit_pref';
  static String unit = 'metric'; // metric or imperial

  static Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    unit = p.getString(_key) ?? 'metric';
  }

  static Future<void> setUnit(String u) async {
    unit = u;
    final p = await SharedPreferences.getInstance();
    await p.setString(_key, u);
  }

  static double cToF(double c) => (c * 9/5) + 32;
  static double mpsToKmh(double m) => m * 3.6;
  static double mpsToMph(double m) => m * 2.237;
}
