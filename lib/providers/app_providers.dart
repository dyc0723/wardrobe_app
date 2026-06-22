import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../models/clothing.dart';
import '../models/outfit.dart';
import '../models/enums.dart';
import '../services/supabase_service.dart';
import '../services/recommend_service.dart';

// ============ 当前用户 ============
final currentUserProvider = StateNotifierProvider<CurrentUserNotifier, AppUser?>((ref) {
  return CurrentUserNotifier(SupabaseService());
});

class CurrentUserNotifier extends StateNotifier<AppUser?> {
  final SupabaseService _supabase;
  CurrentUserNotifier(this._supabase) : super(null);

  Future<void> loadProfile(String userId) async {
    final profile = await _supabase.getUserProfile(userId);
    if (profile != null) state = profile;
  }

  Future<void> saveProfile(AppUser user) async {
    await _supabase.upsertUserProfile(user);
    state = user;
  }
}

// ============ 衣橱 ============
final wardrobeProvider = StateNotifierProvider<WardrobeNotifier, List<ClothingItem>>((ref) {
  return WardrobeNotifier(SupabaseService());
});

class WardrobeNotifier extends StateNotifier<List<ClothingItem>> {
  final SupabaseService _supabase;
  WardrobeNotifier(this._supabase) : super([]);

  Future<void> loadItems(String userId) async {
    final items = await _supabase.getClothingItems(userId);
    state = items;
  }

  Future<void> addItem(ClothingItem item) async {
    await _supabase.addClothingItem(item);
    state = [item, ...state];
  }

  Future<void> updateItem(ClothingItem item) async {
    await _supabase.updateClothingItem(item);
    state = state.map((e) => e.id == item.id ? item : e).toList();
  }

  Future<void> deleteItem(String id) async {
    await _supabase.deleteClothingItem(id);
    state = state.where((e) => e.id != id).toList();
  }
}

// ============ 穿搭方案 ============
final outfitsProvider = StateNotifierProvider<OutfitsNotifier, List<Outfit>>((ref) {
  return OutfitsNotifier(SupabaseService());
});

class OutfitsNotifier extends StateNotifier<List<Outfit>> {
  final SupabaseService _supabase;
  OutfitsNotifier(this._supabase) : super([]);

  Future<void> loadOutfits(String userId) async {
    final outfits = await _supabase.getOutfits(userId);
    state = outfits;
  }

  Future<void> saveOutfit(Outfit outfit) async {
    await _supabase.saveOutfit(outfit);
    state = [outfit, ...state];
  }
}

// ============ 今日推荐 ============
final todaysRecommendationProvider = FutureProvider.auto((ref) async {
  final items = ref.watch(wardrobeProvider);
  if (items.isEmpty) return <List<ClothingItem>>[];

  final now = DateTime.now();
  final season = Season.fromMonth(now.month);

  return RecommendService.recommend(
    wardrobe: items,
    occasion: Occasion.casual,
    season: season,
    temperature: 22.0,
    recentItemIds: const [],
    count: 3,
  );
});
