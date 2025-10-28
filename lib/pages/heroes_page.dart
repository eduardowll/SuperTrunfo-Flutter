import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../model/hero.dart';
import '../service/hero_service.dart';
import '../widgets/hero_card.dart';
import 'hero_detail_page.dart';

class HeroesPage extends StatefulWidget {
  const HeroesPage({super.key});

  @override
  State<HeroesPage> createState() => _HeroesPageState();
}

class _HeroesPageState extends State<HeroesPage> {
  static const _pageSize = 20;
  final PagingController<int, HeroModel> _pagingController =
  PagingController(firstPageKey: 1);
  final HeroService _service = HeroService();

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage();
    });
  }

  Future<void> _fetchPage() async {
    try {
      final allHeroes = await _service.fetchHeroes();
      final newItems = allHeroes.skip((_pageSize * (_pagingController.itemList?.length ?? 0))).take(_pageSize).toList();
      if (newItems.length < _pageSize) {
        _pagingController.appendLastPage(newItems);
      } else {
        _pagingController.appendPage(newItems, 1);
      }
    } catch (e) {
      _pagingController.error = e;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Heróis'),
        backgroundColor: Colors.blueAccent,
      ),
      body: PagedListView<int, HeroModel>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<HeroModel>(
          itemBuilder: (context, hero, index) => HeroCard(
            hero: hero,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HeroDetailPage(hero: hero),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
