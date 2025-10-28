import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import 'card_diario_page.dart';
import 'heroes_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SuperTrunfo'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              text: 'Heróis',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HeroesPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Card Diário',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CardDiarioPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Minhas Cartas',
              onPressed: () {
                //Navegar pra tela de cartas
              },
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Batalhar',
              onPressed: () {
                //Navegar pra tela de batalha
              },
            ),
          ],
        ),
      ),
    );
  }
}
