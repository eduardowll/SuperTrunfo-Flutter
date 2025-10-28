import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../model/hero.dart';
import '../service/cartas_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/powerstats_box.dart';

class CartaDetalhePage extends StatelessWidget {
  final HeroModel hero;
  const CartaDetalhePage({super.key, required this.hero});

  Future<void> _removerCarta(BuildContext context) async {
    final service = CartasService();

    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.scale,
      title: 'Abandonar Carta',
      desc: 'Tem certeza que deseja remover ${hero.name} da sua coleção?',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        await service.removerCarta(hero.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${hero.name} foi removido da coleção.')),
          );
          Navigator.pop(context);
        }
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(hero.name),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CachedNetworkImage(
              imageUrl: hero.images['md'],
              height: 250,
              placeholder: (context, url) =>
              const CircularProgressIndicator(strokeWidth: 2),
              errorWidget: (context, url, error) =>
              const Icon(Icons.error, color: Colors.red),
            ),
            const SizedBox(height: 20),
            Text(
              hero.name,
              style:
              const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            PowerStatsBox(stats: hero.powerstats),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Abandonar carta',
              onPressed: () => _removerCarta(context),
            ),
          ],
        ),
      ),
    );
  }
}
