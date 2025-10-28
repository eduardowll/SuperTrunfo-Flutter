import 'dart:math';
import 'package:flutter/material.dart';
import '../model/hero.dart';
import '../widgets/powerstats_box.dart';
import '../widgets/custom_button.dart';

class BatalharPage extends StatefulWidget {
  final List<HeroModel> minhasCartas;

  const BatalharPage({super.key, required this.minhasCartas});

  @override
  State<BatalharPage> createState() => _BatalharPageState();
}

class _BatalharPageState extends State<BatalharPage> {
  late List<HeroModel> filaCartas;
  int indice = 0;
  int vitorias = 0;
  int derrotas = 0;
  int empates = 0;

  @override
  void initState() {
    super.initState();
    filaCartas = List.from(widget.minhasCartas)..shuffle(Random());
  }

  void _proximoRound(String resultado) {
    setState(() {
      if (resultado == 'venci') vitorias++;
      else if (resultado == 'perdi') derrotas++;
      else empates++;
      indice++;
    });

    if (indice >= filaCartas.length) {
      _mostrarResultadoFinal();
    }
  }

  void _mostrarResultadoFinal() {
    String mensagem;

    if (vitorias > derrotas) mensagem = 'Parabéns! Você venceu a batalha!';
    else if (vitorias < derrotas) mensagem = 'Você perdeu a batalha. Tente de novo!';
    else mensagem = 'Empate na batalha!';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Fim da Batalha'),
        content: Text('Vitórias: $vitorias\nDerrotas: $derrotas\nEmpates: $empates\n\n$mensagem'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                filaCartas.shuffle(Random());
                indice = 0;
                vitorias = 0;
                derrotas = 0;
                empates = 0;
              });
            },
            child: const Text('Reiniciar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (indice >= filaCartas.length) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Batalhar'),
          backgroundColor: Colors.blueAccent,
        ),
        body: const Center(child: Text('Fim da batalha')),
      );
    }

    final heroiAtual = filaCartas[indice];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Batalhar'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Rodada ${indice + 1} de ${filaCartas.length}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Card(
              elevation: 3,
              margin: const EdgeInsets.all(8),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Image.network(heroiAtual.images['sm']!, width: 80, height: 80),
                    const SizedBox(height: 6),
                    Text(heroiAtual.name,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    PowerStatsBox(stats: heroiAtual.powerstats),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
                text: 'Venci',
                onPressed: () => _proximoRound('venci')),
            const SizedBox(height: 12),
            CustomButton(
                text: 'Perdi',
                onPressed: () => _proximoRound('perdi'),
                key: const ValueKey('btnPerdi')),
            const SizedBox(height: 12),
            CustomButton(
                text: 'Empate',
                onPressed: () => _proximoRound('empate')),
          ],
        ),
      ),
    );
  }
}
