class CurrentWeather {
  final String city;
  final String country;
  final double tempC;
  final double feelsLikeC;
  final int humidity;
  final double windMps;
  final String condition;
  final String icon;

  CurrentWeather({required this.city, required this.country, required this.tempC, required this.feelsLikeC, required this.humidity, required this.windMps, required this.condition, required this.icon});

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      city: json['name'] ?? '',
      country: json['sys']?['country'] ?? '',
      tempC: (json['main']['temp'] as num).toDouble(),
      feelsLikeC: (json['main']['feels_like'] as num).toDouble(),
      humidity: json['main']['humidity'] ?? 0,
      windMps: (json['wind']?['speed'] as num?)?.toDouble() ?? 0.0,
      condition: json['weather'][0]['main'] ?? '',
      icon: json['weather'][0]['icon'] ?? '01d',
    );
  }
}

class ForecastItem {
  final DateTime dt;
  final double minC;
  final double maxC;
  final String icon;
  final String condition;

  ForecastItem({required this.dt, required this.minC, required this.maxC, required this.icon, required this.condition});

  factory ForecastItem.fromJson(Map<String, dynamic> json) {
    return ForecastItem(
      dt: DateTime.fromMillisecondsSinceEpoch((json['dt'] as int) * 1000),
      minC: (json['main']['temp_min'] as num).toDouble(),
      maxC: (json['main']['temp_max'] as num).toDouble(),
      icon: json['weather'][0]['icon'] ?? '01d',
      condition: json['weather'][0]['main'] ?? '',
    );
  }
}

class HourlyItem {
  final DateTime dt;
  final double tempC;
  final String icon;
  HourlyItem({required this.dt, required this.tempC, required this.icon});
  factory HourlyItem.fromJson(Map<String, dynamic> json) {
    return HourlyItem(
      dt: DateTime.fromMillisecondsSinceEpoch((json['dt'] as int) * 1000),
      tempC: (json['main']['temp'] as num).toDouble(),
      icon: json['weather'][0]['icon'] ?? '01d',
    );
  }
}
