import 'package:dio/dio.dart';
import '../core/constants.dart';
import '../models/weather_models.dart';

class WeatherService {
  final Dio _dio = Dio();

  double _kToC(double k) => k - 273.15;

  Future<CurrentWeather> fetchCurrent(String city) async {
    final url = '\${Constants.apiBase}/weather?q=\$city&appid=\${Constants.apiKey}';
    final res = await _dio.get(url);
    if (res.statusCode != 200) throw Exception('City not found');
    final js = res.data;
    js['main']['temp'] = _kToC((js['main']['temp'] as num).toDouble());
    js['main']['feels_like'] = _kToC((js['main']['feels_like'] as num).toDouble());
    return CurrentWeather.fromJson(js);
  }

  Future<List<ForecastItem>> fetch5Day(String city) async {
    final url = '\${Constants.apiBase}/forecast?q=\$city&appid=\${Constants.apiKey}';
    final res = await _dio.get(url);
    if (res.statusCode != 200) throw Exception('Forecast not available');
    final js = res.data;
    List list = js['list'];
    Map<String, ForecastItem> byDay = {};
    for (var item in list) {
      item['main']['temp_min'] = _kToC((item['main']['temp_min'] as num).toDouble());
      item['main']['temp_max'] = _kToC((item['main']['temp_max'] as num).toDouble());
      final f = ForecastItem.fromJson(item);
      final key = '\${f.dt.year}-\${f.dt.month}-\${f.dt.day}';
      if (!byDay.containsKey(key)) byDay[key] = f;
      final hour = f.dt.hour;
      if ((hour - 12).abs() < (byDay[key]!.dt.hour - 12).abs()) byDay[key] = f;
    }
    final items = byDay.values.toList()..sort((a,b)=>a.dt.compareTo(b.dt));
    return items.take(5).toList();
  }

  Future<List<HourlyItem>> fetchHourly(String city, {int count = 8}) async {
    final url = '\${Constants.apiBase}/forecast?q=\$city&appid=\${Constants.apiKey}';
    final res = await _dio.get(url);
    if (res.statusCode != 200) throw Exception('Hourly not available');
    final js = res.data;
    List list = js['list'];
    List<HourlyItem> hours = [];
    for (var i=0; i<list.length && hours.length<count; i++) {
      var item = list[i];
      item['main']['temp'] = _kToC((item['main']['temp'] as num).toDouble());
      hours.add(HourlyItem.fromJson(item));
    }
    return hours;
  }

  Future<CurrentWeather> fetchByCoords(double lat, double lon) async {
    final url = '\${Constants.apiBase}/weather?lat=\$lat&lon=\$lon&appid=\${Constants.apiKey}';
    final res = await _dio.get(url);
    if (res.statusCode != 200) throw Exception('Location weather not available');
    final js = res.data;
    js['main']['temp'] = _kToC((js['main']['temp'] as num).toDouble());
    js['main']['feels_like'] = _kToC((js['main']['feels_like'] as num).toDouble());
    return CurrentWeather.fromJson(js);
  }
}
