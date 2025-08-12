import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

/// Инициализация Supabase при старте приложения.
Future<void> initSupabase() async {
  await Supabase.initialize(
    url: 'https://jplholjizaxlsrotlzwu.supabase.co',
    anonKey: 'sb_secret_UU_evpjpQ_8acN_nsRre9g_KabqXA2P',
  );
}
