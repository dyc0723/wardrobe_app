import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user.dart';
import '../models/clothing.dart';
import '../models/outfit.dart';

class SupabaseService {
  final SupabaseClient _client;
  SupabaseService._(this._client);

  static SupabaseService? _instance;
  factory SupabaseService() {
    _instance ??= SupabaseService._(Supabase.instance.client);
    return _instance!;
  }

  PostgrestQueryBuilder _table(String name) => _client.from(name);

  // ========== 认证 ==========
  Future<AuthResponse> signUp(String email, String password) =>
      _client.auth.signUp(email: email, password: password);
  Future<AuthResponse> signIn(String email, String password) =>
      _client.auth.signInWithPassword(email: email, password: password);
  Future<void> signOut() => _client.auth.signOut();
  Session? get currentSession => _client.auth.currentSession;

  // ========== 用户 Profile ==========
  Future<AppUser?> getUserProfile(String userId) async {
    final response = await (_table('users').select() as dynamic)
        .eq('id', userId)
        .maybeSingle();
    if (response == null) return null;
    return AppUser.fromJson(response);
  }

  Future<void> upsertUserProfile(AppUser user) async {
    await _table('users').upsert(user.toJson());
  }

  // ========== 衣物 ==========
  Future<List<ClothingItem>> getClothingItems(String userId, {bool? isArchived}) async {
    dynamic query = _table('clothing_items').select();
    query = query.eq('user_id', userId).order('created_at', ascending: false);
    if (isArchived != null) {
      query = query.eq('is_archived', isArchived);
    }
    final response = await query;
    return (response as List).map((e) => ClothingItem.fromJson(e)).toList();
  }

  Future<void> addClothingItem(ClothingItem item) async {
    await _table('clothing_items').insert(item.toJson());
  }

  Future<void> updateClothingItem(ClothingItem item) async {
    await (_table('clothing_items').update(item.toJson()) as dynamic).eq('id', item.id);
  }

  Future<void> deleteClothingItem(String id) async {
    await (_table('clothing_items').delete() as dynamic).eq('id', id);
  }

  // ========== 穿搭方案 ==========
  Future<List<Outfit>> getOutfits(String userId) async {
    final response = await (_table('outfits').select() as dynamic)
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return (response as List).map((e) => Outfit.fromJson(e)).toList();
  }

  Future<void> saveOutfit(Outfit outfit) async {
    await _table('outfits').insert(outfit.toJson());
  }

  // ========== 打卡 ==========
  Future<void> logWear(String userId, List<String> itemIds, String occasion) async {
    await _table('wear_logs').insert({
      'user_id': userId,
      'clothing_item_ids': itemIds,
      'occasion': occasion,
      'worn_date': DateTime.now().toIso8601String().split('T')[0],
    });
  }

  // ========== 文件上传 ==========
  Future<String> uploadImage(String bucket, String path, Uint8List data) async {
    await _client.storage.from(bucket).uploadBinary(path, data);
    return _client.storage.from(bucket).getPublicUrl(path);
  }
}
