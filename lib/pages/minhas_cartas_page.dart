import 'package:flutter/material.dart';
import '../model/hero.dart';
import '../service/cartas_service.dart';
import '../widgets/hero_card.dart';
import 'carta_detalhe_page.dart';

class MinhasCartasPage extends StatefulWidget {
  const MinhasCartasPage({super.key});

  @override
  State<MinhasCartasPage> createState() => _MinhasCartasPageState();
}

class _MinhasCartasPageState extends State<MinhasCartasPage> {
  List<HeroModel> cartas = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _carregarCartas();
    //_popularCartas();
  }

  //Future<void> _popularCartas() async {
  //  await CartasService().popularCartasTeste();
  //}

  Future<void> _carregarCartas() async {
    final cartasObtidas = await CartasService().getCartas();
    setState(() {
      cartas = cartasObtidas;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas Cartas (${cartas.length}/15)'),
        backgroundColor: Colors.blueAccent,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : cartas.isEmpty
          ? const Center(
        child: Text('Você ainda não possui cartas.'),
      )
          : ListView.builder(
        itemCount: cartas.length,
        itemBuilder: (context, index) {
          final hero = cartas[index];
          return HeroCard(
            hero: hero,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartaDetalhePage(hero: hero),
                ),
              ).then((_) => _carregarCartas());
            },
          );
        },
      ),
    );
  }
}
