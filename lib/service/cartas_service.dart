import 'dart:convert';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import '../model/hero.dart';
import '../db/cartas_db.dart';
import 'hero_service.dart';

class CartasService {
  final _heroService = HeroService();

  static const _chaveHistorico = 'historico_cartas_diarias';

  Future<List<int>> _obterHistorico() async {
    final prefs = await SharedPreferences.getInstance();
    final lista = prefs.getStringList(_chaveHistorico) ?? [];
    return lista.map(int.parse).toList();
  }

  Future<void> _adicionarNoHistorico(int heroId) async {
    final prefs = await SharedPreferences.getInstance();
    final historico = await _obterHistorico();
    historico.add(heroId);
    await prefs.setStringList(_chaveHistorico, historico.map((e) => e.toString()).toList());
  }

  Future<void> _removerDoHistorico(int heroId) async {
    final prefs = await SharedPreferences.getInstance();
    final historico = await _obterHistorico();
    historico.remove(heroId);
    await prefs.setStringList(_chaveHistorico, historico.map((e) => e.toString()).toList());
  }

  Future<void> _limparHistorico() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_chaveHistorico);
  }

  Future<HeroModel> obterCardDoDia() async {
    final db = await CartasDB.database;
    final hoje = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final cards = await db.query('card_diario');
    if (cards.isNotEmpty && cards.first['date'] == hoje) {
      final card = cards.first;
      final todosHerois = await _heroService.fetchHeroes();
      final heroiCompleto = todosHerois.firstWhere(
            (h) => h.id.toString() == card['heroId'].toString(),
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
      return heroiCompleto;
    }

    final todosHerois = await _heroService.fetchHeroes();
    final historico = await _obterHistorico();

    final heroisDisponiveis = todosHerois.where((h) => !historico.contains(h.id)).toList();

    HeroModel heroiSorteado;
    if (heroisDisponiveis.isEmpty) {
      await _limparHistorico();
      heroiSorteado = todosHerois[Random().nextInt(todosHerois.length)];
      await _adicionarNoHistorico(heroiSorteado.id);
    } else {
      heroiSorteado = heroisDisponiveis[Random().nextInt(heroisDisponiveis.length)];
      await _adicionarNoHistorico(heroiSorteado.id);
    }

    await db.delete('card_diario');
    await db.insert('card_diario', {
      'heroId': heroiSorteado.id,
      'name': heroiSorteado.name,
      'image': heroiSorteado.images['md'],
      'date': hoje,
    });

    return heroiSorteado;
  }

  Future<void> abandonarCarta(int heroId) async {
    await _removerDoHistorico(heroId);
    await removerCarta(heroId);
  }

  Future<String> adicionarNaColecao(HeroModel hero) async {
    final db = await CartasDB.database;
    final total = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM colecao'),
    )!;

    if (total >= 15) return 'Você já possui 15 cartas!';

    await db.insert('colecao', {
      'heroId': hero.id,
      'name': hero.name,
      'image': hero.images['sm'],
      'powerstats': jsonEncode(hero.powerstats),
      'dataObtencao': DateTime.now().toIso8601String(),
    });

    return 'Carta adicionada na coleção!';
  }

  Future<List<HeroModel>> getCartas() async {
    final db = await CartasDB.database;
    final dados = await db.query('colecao');
    return dados
        .map((e) => HeroModel(
      id: int.parse(e['heroId'].toString()),
      name: e['name'].toString(),
      slug: '',
      powerstats: jsonDecode(e['powerstats'].toString()),
      appearance: {},
      biography: {},
      work: {},
      images: {'sm': e['image'], 'md': e['image']},
      dataObtencao: e['dataObtencao']?.toString(),
    )).toList();
  }

  Future<void> removerCarta(int heroId) async {
    final db = await CartasDB.database;
    await db.delete('colecao', where: 'heroId = ?', whereArgs: [heroId]);
  }

  Future<int> contarCartas() async {
    final db = await CartasDB.database;
    final res = await db.rawQuery('SELECT COUNT(*) as total FROM colecao');
    return Sqflite.firstIntValue(res) ?? 0;
  }

  /*
  Future<void> popularCartasTeste() async {
    final todosHerois = await _heroService.fetchHeroes();
    final rng = Random();
    final cartasAdicionadas = <int>{};

    while (cartasAdicionadas.length < 15 && cartasAdicionadas.length < todosHerois.length) {
      final hero = todosHerois[rng.nextInt(todosHerois.length)];
      if (!cartasAdicionadas.contains(hero.id)) {
        await adicionarNaColecao(hero);
        cartasAdicionadas.add(hero.id);
      }
    }
   */
}