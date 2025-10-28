import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../model/hero.dart';

class HeroCard extends StatelessWidget {
  final HeroModel hero;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const HeroCard({
    super.key,
    required this.hero,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: hero.images['sm'],
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                  const CircularProgressIndicator(strokeWidth: 2),
                  errorWidget: (context, url, error) =>
                  const Icon(Icons.error, color: Colors.red),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hero.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text("Força: ${hero.powerstats['strength']}"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
