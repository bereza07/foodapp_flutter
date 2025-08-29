

import 'dart:math';

import 'package:foodapp/src/features/menu/domain/menu_item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MenuRepository {
  final SupabaseClient supabase;
  MenuRepository(this.supabase);

  Future<List<MenuItem>> fetchMenu() async{
    final response = await supabase
    .from('menu')
    .select('*, option_groups(*, option_items(*))')
    .order('category');

    final data = response as List<dynamic>;
    //print(data[2]);
    return data.map((e) => MenuItem.fromMap(e)).toList();
  }
}