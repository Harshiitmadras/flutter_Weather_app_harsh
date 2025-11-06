import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../core/theme.dart';

class AnimatedBackground extends StatelessWidget {
  final String condition;
  const AnimatedBackground({super.key, required this.condition});

  LinearGradient _gradientFor(String cond) {
    final c = cond.toLowerCase();
    if (c.contains('rain')) return const LinearGradient(colors: [WeatherColors.rainStart, WeatherColors.rainEnd], begin: Alignment.topCenter, end: Alignment.bottomCenter);
    if (c.contains('cloud')) return const LinearGradient(colors: [WeatherColors.cloudStart, WeatherColors.cloudEnd], begin: Alignment.topCenter, end: Alignment.bottomCenter);
    if (c.contains('thunder')) return const LinearGradient(colors: [WeatherColors.thunderStart, WeatherColors.thunderEnd], begin: Alignment.topCenter, end: Alignment.bottomCenter);
    if (c.contains('snow')) return const LinearGradient(colors: [WeatherColors.snowStart, WeatherColors.snowEnd], begin: Alignment.topCenter, end: Alignment.bottomCenter);
    if (c.contains('mist') || c.contains('fog')) return const LinearGradient(colors: [WeatherColors.mistStart, WeatherColors.mistEnd], begin: Alignment.topCenter, end: Alignment.bottomCenter);
    return const LinearGradient(colors: [WeatherColors.clearStart, WeatherColors.clearEnd], begin: Alignment.topCenter, end: Alignment.bottomCenter);
  }

  String _lottieFor(String cond) {
    final c = cond.toLowerCase();
    if (c.contains('rain')) return 'assets/lottie/rain.json';
    if (c.contains('cloud')) return 'assets/lottie/clouds.json';
    if (c.contains('thunder')) return 'assets/lottie/thunder.json';
    if (c.contains('snow')) return 'assets/lottie/snow.json';
    if (c.contains('mist') || c.contains('fog')) return 'assets/lottie/mist.json';
    return 'assets/lottie/clear.json';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: _gradientFor(condition)),
      child: Stack(
        children: [
          Positioned.fill(child: Opacity(opacity: 0.9, child: Lottie.asset(_lottieFor(condition), fit: BoxFit.cover))),
          Positioned.fill(child: Container(color: Colors.black.withOpacity(0.08))),
        ],
      ),
    );
  }
}
