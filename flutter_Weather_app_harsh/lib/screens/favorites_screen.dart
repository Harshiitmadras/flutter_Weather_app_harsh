import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'detail_screen.dart';
import '../widgets/glass_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<String> _favorites = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    setState(()=> _favorites = p.getStringList('favorites') ?? []);
  }

  Future<void> _remove(int idx) async {
    final p = await SharedPreferences.getInstance();
    _favorites.removeAt(idx);
    await p.setStringList('favorites', _favorites);
    setState(()=> {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Favorite Cities'), backgroundColor: Colors.transparent, elevation: 0), backgroundColor: Colors.transparent, body: SafeArea(child: Padding(padding: const EdgeInsets.all(12.0), child: ListView.separated(itemCount: _favorites.length, separatorBuilder: (_,__)=> const SizedBox(height:8), itemBuilder: (context,i){ final city = _favorites[i]; return GestureDetector(onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(city: city))), child: GlassCard(child: Padding(padding: const EdgeInsets.all(12.0), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [ Text(city, style: const TextStyle(color: Colors.white)), IconButton(icon: const Icon(Icons.delete, color: Colors.white), onPressed: ()=> _remove(i)) ])))); } ))));
  }
}
