import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/weather_service.dart';
import '../models/weather_models.dart';
import '../widgets/animated_background.dart';
import '../widgets/glass_card.dart';
import 'detail_screen.dart';
import 'favorites_screen.dart';
import '../utils/unit_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _svc = WeatherService();
  final _ctrl = TextEditingController();
  CurrentWeather? _current;
  List<ForecastItem> _forecast = [];
  List<HourlyItem> _hourly = [];
  bool _loading = false;
  String? _error;
  List<String> _favorites = [];
  List<String> _suggestions = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final p = await SharedPreferences.getInstance();
    setState(() { _favorites = p.getStringList('favorites') ?? []; });
  }

  Future<void> _saveFavorites() async {
    final p = await SharedPreferences.getInstance();
    await p.setStringList('favorites', _favorites);
  }

  void _onSearchChanged(String v) {
    if (v.isEmpty) { setState(()=> _suggestions = []); return; }
    setState(()=> _suggestions = [v, '\$v City', '\${v}ville']); // naive suggestions for hackathon
  }

  Future<void> _search(String city) async {
    setState(()=> _loading = true);
    try {
      final c = await _svc.fetchCurrent(city);
      final f = await _svc.fetch5Day(city);
      final h = await _svc.fetchHourly(city, count: 8);
      setState(() { _current = c; _forecast = f; _hourly = h; _error = null; });
    } catch (e) {
      setState(()=> _error = e.toString());
    } finally {
      setState(()=> _loading = false);
    }
  }

  Future<void> _useLocation() async {
    setState(()=> _loading = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw Exception('Location services disabled');
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) throw Exception('Location permission denied forever');
      final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      final c = await _svc.fetchByCoords(pos.latitude, pos.longitude);
      final f = await _svc.fetch5Day(c.city);
      final h = await _svc.fetchHourly(c.city, count: 8);
      setState(()=> _current = c); setState(()=> _forecast = f); setState(()=> _hourly = h);
    } catch (e) {
      setState(()=> _error = e.toString());
    } finally {
      setState(()=> _loading = false);
    }
  }

  void _toggleFavorite(String city) {
    if (_favorites.contains(city)) _favorites.remove(city); else _favorites.add(city);
    _saveFavorites();
    setState(() {});
  }

  Widget _unitToggle() {
    return Row(children: [
      const Text('°C', style: TextStyle(color: Colors.white)),
      Switch(value: UnitPrefs.unit=='imperial', onChanged: (v){ UnitPrefs.setUnit(v? 'imperial':'metric').then((_)=> setState((){})); }, activeColor: Colors.orangeAccent),
      const Text('°F', style: TextStyle(color: Colors.white)),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final cond = _current?.condition ?? 'Clear';
    return Stack(
      children: [
        AnimatedBackground(condition: cond),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text('Flutter Weather — Harsh', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            actions: [ _unitToggle(), IconButton(icon: const Icon(Icons.my_location), onPressed: _useLocation), IconButton(icon: const Icon(Icons.star), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FavoritesScreen()))) ],
          ),
          body: SafeArea(child: SingleChildScrollView(
            child: Padding(padding: const EdgeInsets.all(16.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              TextField(controller: _ctrl, decoration: InputDecoration(fillColor: Colors.white.withOpacity(0.12), filled: true, hintText: 'Search city', prefixIcon: const Icon(Icons.search), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)), onChanged: _onSearchChanged, onSubmitted: (v)=> _search(v.trim())),
              if (_suggestions.isNotEmpty) Wrap(spacing: 8, children: _suggestions.map((s)=> ActionChip(label: Text(s), onPressed: (){ _ctrl.text = s; _search(s); })).toList()),
              const SizedBox(height: 12),
              if (_loading) Center(child: SizedBox(height:80, child: Column(children:[CircularProgressIndicator(color: Colors.white), SizedBox(height:8), Text('Fetching weather...', style: TextStyle(color: Colors.white))]))),
              if (_error != null) Padding(padding: const EdgeInsets.symmetric(vertical:8.0), child: Text(_error!, style: const TextStyle(color: Colors.white))),
              if (_current != null) Column(children: [
                Hero(tag: 'city_${_current!.city}', child: GlassCard(child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('${_current!.city}, ${_current!.country}', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height:6),
                    Text('${_current!.condition} • Feels like ${(UnitPrefs.unit=='metric'? _current!.feelsLikeC : UnitPrefs.cToF(_current!.feelsLikeC)).toStringAsFixed(1)}°${UnitPrefs.unit=='metric'?'C':'F'}', style: const TextStyle(color: Colors.white70)),
                  ]),
                  Column(children: [
                    CachedNetworkImage(imageUrl: 'https://openweathermap.org/img/wn/\${_current!.icon}@2x.png', width:72, height:72, placeholder: (c,u)=>SizedBox(width:72,height:72, child: Center(child:CircularProgressIndicator())), errorWidget: (c,u,e)=>Icon(Icons.error, color: Colors.white)),
                    const SizedBox(height:6),
                    Text('${(UnitPrefs.unit=='metric'? _current!.tempC : UnitPrefs.cToF(_current!.tempC)).toStringAsFixed(1)}°', style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                  ])
                ]))),
                const SizedBox(height: 12),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  GlassCard(child: Column(children: [Icon(Icons.water_drop, color: Colors.white), const SizedBox(height:6), Text('${_current!.humidity}%', style: const TextStyle(color: Colors.white))])),
                  GlassCard(child: Column(children: [Icon(Icons.air, color: Colors.white), const SizedBox(height:6), Text('${(UnitPrefs.unit=='metric'? UnitPrefs.mpsToKmh(_current!.windMps).toStringAsFixed(1)+' km/h' : UnitPrefs.mpsToMph(_current!.windMps).toStringAsFixed(1)+' mph')}', style: const TextStyle(color: Colors.white))])),
                  IconButton(icon: Icon(_favorites.contains(_current!.city)? Icons.favorite:Icons.favorite_border, color: Colors.redAccent), onPressed: ()=> _toggleFavorite(_current!.city))
                ]),
                const SizedBox(height: 12),
                ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent).call(null);
                ElevatedButton(onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(city: _current!.city,))), style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent), child: const Text('View Details')),
              ]),
              const SizedBox(height: 20),
              if (_forecast.isNotEmpty) Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('5-Day Forecast', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                SizedBox(height: 150, child: ListView.builder(scrollDirection: Axis.horizontal, itemCount: _forecast.length, itemBuilder: (context,i){ final f = _forecast[i]; final min = UnitPrefs.unit=='metric'? f.minC : UnitPrefs.cToF(f.minC); final max = UnitPrefs.unit=='metric'? f.maxC : UnitPrefs.cToF(f.maxC); return Container(width:120, margin: const EdgeInsets.only(left:12), child: GlassCard(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [ Text('${f.dt.day}/${f.dt.month}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), Image.network('https://openweathermap.org/img/wn/${f.icon}@2x.png', width:48,height:48), Text(f.condition, style: const TextStyle(color: Colors.white70)), const SizedBox(height:6), Text('Min ${min.toStringAsFixed(0)}°${UnitPrefs.unit=='metric'?'C':'F'}', style: const TextStyle(color: Colors.white)), Text('Max ${max.toStringAsFixed(0)}°${UnitPrefs.unit=='metric'?'C':'F'}', style: const TextStyle(color: Colors.white)) ]))); }))
              ]),
            ])),
          )),
        )
      ],
    );
  }
}
