class HeroModel {
  final int id;
  final String name;
  final String slug;
  final Map<String, dynamic> powerstats;
  final Map<String, dynamic> appearance;
  final Map<String, dynamic> biography;
  final Map<String, dynamic> work;
  final Map<String, dynamic> images;
  final String? dataObtencao;

  HeroModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.powerstats,
    required this.appearance,
    required this.biography,
    required this.work,
    required this.images,
    this.dataObtencao,
  });

  factory HeroModel.fromJson(Map<String, dynamic> json) {
    return HeroModel(
      id: json['id'] as int,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      powerstats: Map<String, dynamic>.from(json['powerstats'] ?? {}),
      appearance: Map<String, dynamic>.from(json['appearance'] ?? {}),
      biography: Map<String, dynamic>.from(json['biography'] ?? {}),
      work: Map<String, dynamic>.from(json['work'] ?? {}),
      images: Map<String, dynamic>.from(json['images'] ?? {}),
      dataObtencao: json['dataObtencao'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'slug': slug,
    'powerstats': powerstats,
    'appearance': appearance,
    'biography': biography,
    'work': work,
    'images': images,
    'dataObtencao': dataObtencao,
  };
}



