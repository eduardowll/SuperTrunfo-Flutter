class Hero {
  final int id;
  final String name;
  final String slug;
  final Map<String, dynamic> powerstats;
  final Map<String, dynamic> appearance;
  final Map<String, dynamic> biography;

  const Hero({
    required this.id,
    required this.name,
    required this.slug,
    required this.powerstats,
    required this.appearance,
    required this.biography,
  });

  factory Hero.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'id': int id,
      'name': String name,
      'slug': String slug,
      'powerstats': Map<String, dynamic> powerstats,
      'appearance': Map<String, dynamic> appearance,
      'biography': Map<String, dynamic> biography,
      } =>
          Hero(
            id: id,
            name: name,
            slug: slug,
            powerstats: powerstats,
            appearance: appearance,
            biography: biography,
          ),
      _ => throw const FormatException('Formato inválido do JSON do herói'),
    };
  }

}
