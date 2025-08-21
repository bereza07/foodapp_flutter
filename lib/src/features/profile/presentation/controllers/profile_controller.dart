import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodapp/src/features/orders/data/order_repository.dart';
import 'package:foodapp/src/features/orders/domain/order.dart';
import 'package:foodapp/src/features/profile/data/profile_repository_impl.dart';
import 'package:foodapp/src/features/profile/domain/profile_repository.dart';
import 'package:foodapp/src/features/profile/domain/user_profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileController extends StateNotifier<AsyncValue<UserProfile?>> {
  final ProfileRepository _repository;

  ProfileController(this._repository) : super(const AsyncValue.loading()) {
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        state = const AsyncValue.data(null);
        
        return;
      }

      final profile = await _repository.getProfile(user.id);
      state = AsyncValue.data(profile);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateProfile(UserProfile profile) async {
    try {
      state = const AsyncValue.loading();
      await _repository.updateProfile(profile);
      state = AsyncValue.data(profile);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final profileControllerProvider = StateNotifierProvider<ProfileController, AsyncValue<UserProfile?>>((ref) {
  final repo = ref.watch(profileRepositoryProvider);
  return ProfileController(repo);
});

final ordersProvider =
    FutureProvider.autoDispose<List<Order>>((ref) async {
  final repo = OrderRepository();
  final user = Supabase.instance.client.auth.currentUser;
  if (user == null) return [];
  return repo.getUserOrders(user.id);
});