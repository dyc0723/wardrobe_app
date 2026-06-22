import 'dart:math';
import '../models/enums.dart';
import '../models/clothing.dart';

class RecommendService {
  /// 根据条件推荐穿搭组合
  static List<List<ClothingItem>> recommend({
    required List<ClothingItem> wardrobe,
    required Occasion occasion,
    required Season season,
    required double temperature,
    required List<String> recentItemIds,
    int count = 3,
  }) {
    final candidates = _filterByContext(wardrobe, occasion, season, temperature);
    if (candidates.isEmpty) return [];

    final outfits = <List<ClothingItem>>[];
    final usedIds = <String>{};

    for (int attempt = 0; attempt < count * 3 && outfits.length < count; attempt++) {
      final outfit = _buildOutfit(candidates, usedIds, recentItemIds);
      if (outfit != null && outfit.length >= 2) {
        outfits.add(outfit);
        for (final item in outfit) usedIds.add(item.id);
      }
    }
    return outfits;
  }

  static List<ClothingItem> _filterByContext(
    List<ClothingItem> wardrobe, Occasion occasion, Season season, double temp,
  ) {
    return wardrobe.where((item) {
      if (item.isArchived) return false;
      if (item.season != season && item.season != Season.spring) return false;
      if (temp < 10 && item.thickness.value <= 2) return false;
      if (temp > 28 && item.thickness.value >= 4) return false;
      if (!item.suitableOccasions.contains(occasion) &&
          !item.suitableOccasions.contains(Occasion.casual)) return false;
      return true;
    }).toList();
  }

  static List<ClothingItem>? _buildOutfit(
    List<ClothingItem> candidates, Set<String> usedIds, List<String> recentIds,
  ) {
    final available = candidates.where((c) => !usedIds.contains(c.id)).toList();
    if (available.isEmpty) return null;
    final random = Random();
    final outfit = <ClothingItem>[];

    // 选上衣/连衣裙
    final tops = available.where((c) => c.category == Category.top || c.category == Category.dress).toList();
    if (tops.isEmpty) return null;
    outfit.add(_pickItem(tops, recentIds, random));

    if (outfit.first.category == Category.dress) {
      final jackets = available.where((c) => c.category == Category.jacket && !usedIds.contains(c.id)).toList();
      if (jackets.isNotEmpty && random.nextDouble() < 0.4) {
        outfit.add(_pickItem(jackets, recentIds, random));
      }
      return outfit;
    }

    final bottoms = available.where((c) => c.category == Category.bottom && !usedIds.contains(c.id)).toList();
    if (bottoms.isNotEmpty) outfit.add(_pickItem(bottoms, recentIds, random));

    if (random.nextDouble() < 0.3) {
      final jackets = available.where((c) => c.category == Category.jacket && !usedIds.contains(c.id)).toList();
      if (jackets.isNotEmpty) outfit.add(_pickItem(jackets, recentIds, random));
    }
    final shoes = available.where((c) => c.category == Category.shoes && !usedIds.contains(c.id)).toList();
    if (shoes.isNotEmpty) outfit.add(_pickItem(shoes, recentIds, random));

    return outfit;
  }

  static ClothingItem _pickItem(List<ClothingItem> items, List<String> recentIds, Random random) {
    final sorted = List<ClothingItem>.from(items)
      ..sort((a, b) {
        final aR = recentIds.contains(a.id) ? 1 : 0;
        final bR = recentIds.contains(b.id) ? 1 : 0;
        return aR - bR;
      });
    final topN = sorted.take(min(3, sorted.length)).toList();
    return topN[random.nextInt(topN.length)];
  }

  static int colorHarmonyScore(ClothingColor a, ClothingColor b) {
    const neutral = {
      ClothingColor.white, ClothingColor.black, ClothingColor.gray,
      ClothingColor.beige, ClothingColor.khaki, ClothingColor.navy,
    };
    if (neutral.contains(a) && neutral.contains(b)) return 70;
    if (neutral.contains(a) || neutral.contains(b)) return 90;
    if (a == b) return 60;
    return 50;
  }
}
