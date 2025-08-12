

import 'package:foodapp/src/features/menu/domain/menu_item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MenuRepository {
  final SupabaseClient supabase;
  MenuRepository(this.supabase);

  Future<List<MenuItem>> fetchMenu() async{
    final responce = await supabase.from('menu').select();

    if (responce == null){
      throw Exception('Пустой ответ сервера!');
      
    }

    final data = responce as List<dynamic>;

    return data.map((e) => MenuItem.fromMap(e as Map<String, dynamic>),).toList();
  }
}