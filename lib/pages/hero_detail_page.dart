import 'package:cached_network_image/cached_network_image.dart';
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
            CachedNetworkImage(
              imageUrl: hero.images['md'],
              height: 250,
              placeholder: (context, url) =>
              const CircularProgressIndicator(strokeWidth: 2),
              errorWidget: (context, url, error) =>
              const Icon(Icons.error, color: Colors.red),
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
