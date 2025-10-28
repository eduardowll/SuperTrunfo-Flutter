import 'dart:math';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import '../model/hero.dart';
import 'hero_service.dart';
import '../db/cartas_db.dart';

class CardDiarioService {
  final _heroService = HeroService();

  Future<HeroModel> getCardDoDia() async {
    final db = await CartasDB.database;
    final hoje = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final cards = await db.query('card_diario');
    if (cards.isNotEmpty && cards.first['date'] == hoje) {
      final card = cards.first;
      final allHeroes = await _heroService.fetchHeroes();
      final heroCompleto = allHeroes.firstWhere(
            (h) => h.id == int.parse(card['heroId'].toString()),
        orElse: () => HeroModel(
          id: int.parse(card['heroId'].toString()),
          name: card['name'].toString(),
          slug: '',
          powerstats: {},
          appearance: {},
          biography: {},
          work: {},
          images: {'md': card['image'], 'sm': card['image']},
        ),
      );
      return heroCompleto;
    }

    final heroes = await _heroService.fetchHeroes();
    final randomHero = heroes[Random().nextInt(heroes.length)];

    await db.delete('card_diario');
    await db.insert('card_diario', {
      'heroId': randomHero.id,
      'name': randomHero.name,
      'image': randomHero.images['md'],
      'date': hoje,
    });

    return randomHero;
  }

  Future<String> adicionarAColecao(HeroModel hero) async {
    final db = await CartasDB.database;
    final total = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM colecao'),
    )!;

    if (total >= 15) {
      return 'Você já possui 15 cartas!';
    }

    await db.insert('colecao', {
      'heroId': hero.id,
      'name': hero.name,
      'image': hero.images['sm'],
    });

    return 'Carta adicionada à sua coleção!';
  }
}
