import 'package:flutter/material.dart';
import '../model/hero.dart';
import '../service/cartas_service.dart';
import '../widgets/powerstats_box.dart';
import '../widgets/custom_button.dart';

class CardDiarioPage extends StatefulWidget {
  const CardDiarioPage({super.key});

  @override
  State<CardDiarioPage> createState() => _CardDiarioPageState();
}

class _CardDiarioPageState extends State<CardDiarioPage> {
  final CartasService _cartasService = CartasService();
  HeroModel? hero;
  bool loading = true;
  bool adicionando = false;

  @override
  void initState() {
    super.initState();
    _carregarCardDoDia();
  }

  Future<void> _carregarCardDoDia() async {
    final carta = await _cartasService.obterCardDoDia();
    setState(() {
      hero = carta;
      loading = false;
    });
  }

  Future<void> _adicionarNaColecao() async {
    if (hero == null || adicionando) return;

    setState(() {
      adicionando = true;
    });

    final cartas = await _cartasService.getCartas();
    final existe = cartas.any((c) => c.id == hero!.id);
    if (existe) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Você já possui esta carta na coleção.')),
      );
    } else {
      final total = await _cartasService.contarCartas();
      if (total >= 15) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Você já possui 15 cartas na coleção.')),
        );
      } else {
        final msg = await _cartasService.adicionarNaColecao(hero!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg)),
        );
      }
    }

    setState(() {
      adicionando = false;
    });
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
            : Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(hero!.images['md'], height: 250),
              const SizedBox(height: 20),
              Text(
                hero!.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              PowerStatsBox(stats: hero!.powerstats),
              const SizedBox(height: 20),
              CustomButton(
                text: adicionando ? 'Adicionando...' : 'Adicionar à coleção',
                onPressed: _adicionarNaColecao,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
