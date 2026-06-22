import 'enums.dart';

class Outfit {
  final String id;
  final String userId;
  final String name;
  final List<String> clothingItemIds;
  final Occasion occasion;
  final String? imageUrl;
  final double? rating;
  final int wearCount;
  final DateTime? lastWornAt;
  final bool isFavorite;
  final DateTime createdAt;

  Outfit({
    required this.id,
    required this.userId,
    required this.name,
    this.clothingItemIds = const [],
    this.occasion = Occasion.casual,
    this.imageUrl,
    this.rating,
    this.wearCount = 0,
    this.lastWornAt,
    this.isFavorite = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'name': name,
        'clothing_item_ids': clothingItemIds,
        'occasion': occasion.name,
        'image_url': imageUrl,
        'rating': rating,
        'wear_count': wearCount,
        'last_worn_at': lastWornAt?.toIso8601String(),
        'is_favorite': isFavorite,
        'created_at': createdAt.toIso8601String(),
      };

  factory Outfit.fromJson(Map<String, dynamic> json) => Outfit(
        id: json['id'] ?? '',
        userId: json['user_id'] ?? '',
        name: json['name'] ?? '',
        clothingItemIds: (json['clothing_item_ids'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
        occasion: Occasion.values.firstWhere(
          (e) => e.name == json['occasion'],
          orElse: () => Occasion.casual,
        ),
        imageUrl: json['image_url'],
        rating: (json['rating'] as num?)?.toDouble(),
        wearCount: json['wear_count'] ?? 0,
        lastWornAt: json['last_worn_at'] != null
            ? DateTime.parse(json['last_worn_at'])
            : null,
        isFavorite: json['is_favorite'] ?? false,
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'])
            : DateTime.now(),
      );
}
