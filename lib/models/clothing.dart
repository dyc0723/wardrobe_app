import 'enums.dart';

class ClothingItem {
  final String id;
  final String userId;
  final String name;
  final Category category;
  final ClothingColor color;
  final List<ClothingColor> secondaryColors;
  final MaterialType material;
  final Season season;
  final Thickness thickness;
  final int formalityLevel;
  final List<Occasion> suitableOccasions;
  final String? imageUrl;
  final String? brand;
  final double? price;
  final DateTime? purchaseDate;
  final String? notes;
  final bool isFavorite;
  final bool isArchived;
  final DateTime createdAt;

  ClothingItem({
    required this.id,
    required this.userId,
    required this.name,
    required this.category,
    required this.color,
    this.secondaryColors = const [],
    this.material = MaterialType.other,
    this.season = Season.spring,
    this.thickness = Thickness.medium,
    this.formalityLevel = 3,
    this.suitableOccasions = const [Occasion.casual],
    this.imageUrl,
    this.brand,
    this.price,
    this.purchaseDate,
    this.notes,
    this.isFavorite = false,
    this.isArchived = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  ClothingItem copyWith({
    String? name,
    Category? category,
    ClothingColor? color,
    List<ClothingColor>? secondaryColors,
    MaterialType? material,
    Season? season,
    Thickness? thickness,
    int? formalityLevel,
    List<Occasion>? suitableOccasions,
    String? imageUrl,
    String? brand,
    double? price,
    DateTime? purchaseDate,
    String? notes,
    bool? isFavorite,
    bool? isArchived,
  }) =>
      ClothingItem(
        id: id,
        userId: userId,
        name: name ?? this.name,
        category: category ?? this.category,
        color: color ?? this.color,
        secondaryColors: secondaryColors ?? this.secondaryColors,
        material: material ?? this.material,
        season: season ?? this.season,
        thickness: thickness ?? this.thickness,
        formalityLevel: formalityLevel ?? this.formalityLevel,
        suitableOccasions: suitableOccasions ?? this.suitableOccasions,
        imageUrl: imageUrl ?? this.imageUrl,
        brand: brand ?? this.brand,
        price: price ?? this.price,
        purchaseDate: purchaseDate ?? this.purchaseDate,
        notes: notes ?? this.notes,
        isFavorite: isFavorite ?? this.isFavorite,
        isArchived: isArchived ?? this.isArchived,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'name': name,
        'category': category.name,
        'color': color.name,
        'secondary_colors': secondaryColors.map((e) => e.name).toList(),
        'material': material.name,
        'season': season.name,
        'thickness': thickness.value,
        'formality_level': formalityLevel,
        'suitable_occasions': suitableOccasions.map((e) => e.name).toList(),
        'image_url': imageUrl,
        'brand': brand,
        'price': price,
        'purchase_date': purchaseDate?.toIso8601String(),
        'notes': notes,
        'is_favorite': isFavorite,
        'is_archived': isArchived,
        'created_at': createdAt.toIso8601String(),
      };

  factory ClothingItem.fromJson(Map<String, dynamic> json) => ClothingItem(
        id: json['id'] ?? '',
        userId: json['user_id'] ?? '',
        name: json['name'] ?? '',
        category: Category.values.firstWhere(
          (e) => e.name == json['category'],
          orElse: () => Category.top,
        ),
        color: ClothingColor.values.firstWhere(
          (e) => e.name == json['color'],
          orElse: () => ClothingColor.white,
        ),
        secondaryColors: (json['secondary_colors'] as List<dynamic>?)
                ?.map((e) => ClothingColor.values.firstWhere(
                      (c) => c.name == e,
                      orElse: () => ClothingColor.white,
                    ))
                .toList() ??
            [],
        material: MaterialType.values.firstWhere(
          (e) => e.name == json['material'],
          orElse: () => MaterialType.other,
        ),
        season: Season.values.firstWhere(
          (e) => e.name == json['season'],
          orElse: () => Season.spring,
        ),
        thickness: Thickness.values.firstWhere(
          (e) => e.value == (json['thickness'] ?? 3),
          orElse: () => Thickness.medium,
        ),
        formalityLevel: json['formality_level'] ?? 3,
        suitableOccasions: (json['suitable_occasions'] as List<dynamic>?)
                ?.map((e) => Occasion.values.firstWhere(
                      (o) => o.name == e,
                      orElse: () => Occasion.casual,
                    ))
                .toList() ??
            [Occasion.casual],
        imageUrl: json['image_url'],
        brand: json['brand'],
        price: (json['price'] as num?)?.toDouble(),
        purchaseDate: json['purchase_date'] != null
            ? DateTime.parse(json['purchase_date'])
            : null,
        notes: json['notes'],
        isFavorite: json['is_favorite'] ?? false,
        isArchived: json['is_archived'] ?? false,
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'])
            : DateTime.now(),
      );
}
