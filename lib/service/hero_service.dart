import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/hero.dart';
import 'hero_cache.dart';

class HeroService {
  final String baseUrl = 'https://server-json-hero.vercel.app/api/data';

  Future<List<HeroModel>> fetchHeroes() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final heroes = data.map((json) => HeroModel.fromJson(json)).toList();
        await HeroCache.saveHeroes(heroes);
        return heroes;
      } else {
        throw Exception('Erro HTTP ${response.statusCode}');
      }
    } catch (e) {
      return await HeroCache.loadHeroes();
    }
  }

}

