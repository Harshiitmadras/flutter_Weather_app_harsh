import 'package:flutter/material.dart';
import '../services/weather_service.dart';
import '../models/weather_models.dart';
import '../widgets/glass_card.dart';
import '../utils/unit_prefs.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DetailScreen extends StatefulWidget {
  final String city;
  const DetailScreen({super.key, required this.city});
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final _svc = WeatherService();
  List<HourlyItem> _hourly = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(()=> _loading = true);
    try {
      final h = await _svc.fetchHourly(widget.city, count: 8);
      setState(()=> _hourly = h); _error = null;
    } catch (e) {
      setState(()=> _error = e.toString());
    } finally {
      setState(()=> _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Details - ${widget.city}'), backgroundColor: Colors.transparent, elevation: 0), backgroundColor: Colors.transparent, body: SafeArea(child: Padding(padding: const EdgeInsets.all(12.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Hourly (next 24h)', style: TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      _loading ? Center(child: CircularProgressIndicator()) : SizedBox(height: 120, child: ListView.builder(scrollDirection: Axis.horizontal, itemCount: _hourly.length, itemBuilder: (context,i){ final h = _hourly[i]; final temp = UnitPrefs.unit=='metric'? h.tempC : UnitPrefs.cToF(h.tempC); final label = TimeOfDay.fromDateTime(h.dt).format(context); return Container(width:90, margin: const EdgeInsets.only(left:12), child: GlassCard(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [ Text(label), CachedNetworkImage(imageUrl: 'https://openweathermap.org/img/wn/${h.icon}@2x.png', width:36,height:36), const SizedBox(height:6), Text('${temp.toStringAsFixed(0)}°${UnitPrefs.unit=='metric'?'C':'F'}') ]))); })),
    ]))));
  }
}
