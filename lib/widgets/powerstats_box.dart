import 'package:flutter/material.dart';
import 'package:primer_progress_bar/primer_progress_bar.dart';

class PowerStatsBox extends StatelessWidget {
  final Map<String, dynamic> stats;
  final double? width;

  const PowerStatsBox({
    super.key,
    required this.stats,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    print(stats);
    final segments = <Segment>[
      Segment(
        value: (stats['strength'] ?? 0) as int,
        color: Colors.red,
        label: const Text('Força'),
      ),
      Segment(
        value: (stats['intelligence'] ?? 0) as int,
        color: Colors.blue,
        label: const Text('Inteligência'),
      ),
      Segment(
        value: (stats['speed'] ?? 0) as int,
        color: Colors.green,
        label: const Text('Velocidade'),
      ),
      Segment(
        value: (stats['power'] ?? 0) as int,
        color: Colors.purple,
        label: const Text('Poder'),
      ),
      Segment(
        value: (stats['combat'] ?? 0) as int,
        color: Colors.orange,
        label: const Text('Combate'),
      ),
      Segment(
        value: (stats['durability'] ?? 0) as int,
        color: Colors.teal,
        label: const Text('Durabilidade'),
      ),
    ];

    return SizedBox(
      width: width ?? double.infinity,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Power Stats',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              PrimerProgressBar(segments: segments),

              const SizedBox(height: 12),

              Wrap(
                spacing: 10,
                runSpacing: 6,
                children: segments.map((s) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(width: 12, height: 12, color: s.color),
                      const SizedBox(width: 4),
                      Text(
                        s.label?.data ?? '',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
