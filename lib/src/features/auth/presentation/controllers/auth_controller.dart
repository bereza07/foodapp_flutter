



import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodapp/src/features/auth/data/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// 1. Возможные состояния авторизации

class AuthState {
  final bool isLoading;
  final User? user;
  final String? error;

  AuthState({
    this.isLoading = false,
    this.user,
    this.error,
  });

  AuthState copyWith({
    bool? isLoading,
    User? user,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error,
    );
  }
}

/// 2. Контроллер
class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthController(this._authRepository) : super(AuthState());

  Future<void> signUpWithPhone(String phone, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final res = await _authRepository.signUpWithPhone(phone, password);

      if (res.user != null) {
        state = state.copyWith(user: res.user, isLoading: false);
      } else {
        state = state.copyWith(error: "Не удалось зарегистрировать", isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> signInWithPhone(String phone, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final res = await _authRepository.signInWithPhone(phone, password);

      if (res.user != null) {
        state = state.copyWith(user: res.user, isLoading: false);
      } else {
        state = state.copyWith(error: "Неверный телефон или пароль", isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    state = AuthState();
  }
}

/// 3. Провайдер
final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthController(repo);
});

final authStateProvider = StreamProvider<User?>((ref) {
  return Supabase.instance.client.auth.onAuthStateChange.map((event) {
    return event.session?.user;
  });
});