import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/hero.dart';

class HeroService {

  final String baseUrl = 'https://server-json-hero.vercel.app/api/data';

  Future<List<Hero>> fetchHeroes() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Hero.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar heróis: ${response.statusCode}');
    }
  }
}
