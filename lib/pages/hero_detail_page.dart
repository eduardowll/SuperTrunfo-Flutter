import 'package:flutter/material.dart';
import '../model/hero.dart';
import '../widgets/powerstats_box.dart';

class HeroDetailPage extends StatelessWidget {
  final HeroModel hero;
  const HeroDetailPage({super.key, required this.hero});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(hero.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.network(hero.images['md']),
            const SizedBox(height: 12),
            Text(
              hero.biography['fullName'] ?? '',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Text('Gênero: ${hero.appearance['gender']}'),
            Text('Raça: ${hero.appearance['race']}'),
            Text('Altura: ${hero.appearance['height']?[1]}'),
            Text('Peso: ${hero.appearance['weight']?[1]}'),
            Text('Occupation: ${hero.work['occupation']}'),

            PowerStatsBox(stats: hero.powerstats),

            Text('Alter Egos: ${hero.biography['alterEgos']}'),
            Text('Aliases: ${(hero.biography['aliases'] as List<dynamic>?)?.join(', ')}'),
            Text('Publisher: ${hero.biography['publisher']}'),
          ],
        ),
      ),
    );
  }
}
