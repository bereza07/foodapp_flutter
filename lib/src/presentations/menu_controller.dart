

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodapp/src/data/menu_repository.dart';
import 'package:foodapp/src/domain/menu_item.dart';

final menuRepositoryProvider = Provider<MenuRepository>((ref) {
  throw UnimplementedError(); // Мы позже передадим репозиторий через ProviderScope
});

final menuProvider = AsyncNotifierProvider<MenuNotifier, List<MenuItem>>(() {
  return MenuNotifier();
});


class MenuNotifier extends AsyncNotifier<List<MenuItem>> {
  late final MenuRepository repository;

  @override
  Future<List<MenuItem>> build() async {
    // Можно получить репозиторий через ref.read
    repository = ref.read(menuRepositoryProvider);
    return await repository.fetchMenu();
  }

  // Метод для обновления меню вручную
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => repository.fetchMenu());
  }
}