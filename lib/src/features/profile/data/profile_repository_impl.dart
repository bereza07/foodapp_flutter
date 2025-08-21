
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodapp/src/features/profile/domain/profile_repository.dart';
import 'package:foodapp/src/features/profile/domain/user_profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRepositoryImpl implements ProfileRepository{
  final SupabaseClient _client;

  ProfileRepositoryImpl(this._client);

  @override
  Future<UserProfile?> getProfile(String userId) async {
    final response = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle(); // может вернуть null

    if (response == null) return null;
    return UserProfile.fromMap(response);
  }
  @override
  Future<void> updateProfile(UserProfile profile) async {
    await _client.from('profiles').upsert(profile.toMap());
  }

}


final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final client = Supabase.instance.client;
  return ProfileRepositoryImpl(client);
});