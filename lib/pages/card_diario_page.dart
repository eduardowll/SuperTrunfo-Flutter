import 'package:flutter/material.dart';
import '../model/hero.dart';
import '../service/card_diario_service.dart';
import '../widgets/powerstats_box.dart';

class CardDiarioPage extends StatefulWidget {
  const CardDiarioPage({super.key});

  @override
  State<CardDiarioPage> createState() => _CardDiarioPageState();
}

class _CardDiarioPageState extends State<CardDiarioPage> {
  final CardDiarioService _service = CardDiarioService();
  HeroModel? hero;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _carregarCardDoDia();
  }

  Future<void> _carregarCardDoDia() async {
    final card = await _service.getCardDoDia();

    setState(() {
      hero = card;
      loading = false;
    });
  }

  Future<void> _adicionarAColecao() async {
    if (hero == null) return;
    final msg = await _service.adicionarAColecao(hero!);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Card Diário'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: loading
            ? const CircularProgressIndicator()
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(hero!.images['md'], height: 250),
            const SizedBox(height: 20),
            Text(hero!.name,
                style: const TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),


            PowerStatsBox(stats: hero!.powerstats),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _adicionarAColecao,
              child: const Text('Adicionar à coleção'),
            ),
          ],
        ),
      ),
    );
  }
}
