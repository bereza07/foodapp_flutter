


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository{
  final SupabaseClient _client;

  AuthRepository(this._client);


  Future<AuthResponse> signUpWithPhone(String phone, String password) async{
    final email = "$phone@foodapp.com";
    final response = await _client.auth.signUp(email:email, password:  password);

    if (response.user != null){
      await _client.from('profiles').insert(
        {
          'id': response.user!.id,
          'phone': phone,
        }
      );
    }
    return response;
  }
  

  Future<AuthResponse> signInWithPhone(String phone, String password){
    final email = "$phone@foodapp.com";
    return _client.auth.signInWithPassword( email:email, password:  password);

  }

  User? getCurrentUser() => _client.auth.currentUser;

  Future<void> signOut() => _client.auth.signOut();
}

/// Провайдер репозитория
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(Supabase.instance.client);
});