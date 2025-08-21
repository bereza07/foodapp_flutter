import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodapp/src/features/cart/presentation/controllers/cart_controller.dart';
import 'package:foodapp/src/features/cart/presentation/screens/cart_screen.dart';
import 'package:foodapp/src/features/menu/presentation/controllers/menu_controller.dart';
import 'package:foodapp/src/features/menu/presentation/widgets/menu_item_tile.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key});

  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  final ScrollController categoriesScrollController = ScrollController();
  int selectedCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    final menuAsync = ref.watch(menuProvider);
    final cart = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Меню ресторана'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  );
                },
              ),
              if (cart.isNotEmpty)
                Positioned(
                  right: 4,
                  top: 4,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                      '${cart.length}',
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: menuAsync.when(
        data: (menu) {
          // 🔹 сортируем меню по категориям
          final sortedMenu = List.from(menu)
            ..sort((a, b) => a.category.compareTo(b.category));

          // 🔹 формируем список уникальных категорий
          final categories = <String>[];
          for (var item in sortedMenu) {
            if (!categories.contains(item.category)) {
              categories.add(item.category);
            }
          }

          // 🔹 слушаем позиции для подсветки категории
          itemPositionsListener.itemPositions.addListener(() {
            final positions = itemPositionsListener.itemPositions.value;
            if (positions.isNotEmpty) {
              final firstVisible = positions
                  .where((p) => p.itemLeadingEdge >= 0)
                  .reduce((a, b) => a.index < b.index ? a : b);
              final currentCategory = sortedMenu[firstVisible.index].category;
              final index = categories.indexOf(currentCategory);
              if (index != -1 && selectedCategoryIndex != index) {
                setState(() {
                  selectedCategoryIndex = index;
                  // прокручиваем список категорий
                  categoriesScrollController.animateTo(
                    index * 100.0, // приближённая ширина кнопки
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                });
              }
            }
          });

          return Column(
            children: [
              // 🔹 горизонтальный список категорий
              SizedBox(
                height: 60,
                child: ListView.builder(
                  controller: categoriesScrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final isSelected = index == selectedCategoryIndex;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
                          foregroundColor: isSelected ? Colors.white : Colors.black,
                        ),
                        onPressed: () {
                          final itemIndex = sortedMenu.indexWhere((item) => item.category == category);
                          if (itemIndex != -1) {
                            itemScrollController.scrollTo(
                              index: itemIndex,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        child: Text(category),
                      ),
                    );
                  },
                ),
              ),
              const Divider(height: 1),
              // 🔹 список товаров
              Expanded(
                child: ScrollablePositionedList.builder(
                  itemScrollController: itemScrollController,
                  itemPositionsListener: itemPositionsListener,
                  itemCount: sortedMenu.length,
                  itemBuilder: (context, index) {
                    final item = sortedMenu[index];

                    bool showCategoryHeader = false;
                    if (index == 0) {
                      showCategoryHeader = true;
                    } else if (sortedMenu[index].category != sortedMenu[index - 1].category) {
                      showCategoryHeader = true;
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (showCategoryHeader)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            child: Text(
                              item.category,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        MenuItemTile(item: item),
                        const Divider(height: 1),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Ошибка: $error')),
      ),
    );
  }
}
