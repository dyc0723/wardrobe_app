import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/supabase_service.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthNotifier extends StateNotifier<AuthStatus> {
  final SupabaseService _supabase;
  AuthNotifier(this._supabase) : super(AuthStatus.unknown) {
    _checkSession();
  }

  void _checkSession() {
    state = _supabase.currentSession != null
        ? AuthStatus.authenticated
        : AuthStatus.unauthenticated;
  }

  Future<void> signIn(String email, String password) async {
    await _supabase.signIn(email, password);
    state = AuthStatus.authenticated;
  }

  Future<void> signUp(String email, String password) async {
    await _supabase.signUp(email, password);
    state = AuthStatus.authenticated;
  }

  Future<void> signOut() async {
    await _supabase.signOut();
    state = AuthStatus.unauthenticated;
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthStatus>((ref) {
  return AuthNotifier(SupabaseService());
});
