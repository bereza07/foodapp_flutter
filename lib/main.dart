import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodapp/src/presentations/menu_controller.dart';
import 'package:foodapp/src/presentations/screens/menu_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'src/core/supabase_client.dart';
import 'src/data/menu_repository.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initSupabase();

  final supabase = Supabase.instance.client;
  final repository = MenuRepository(supabase);

  runApp(
    ProviderScope(
      overrides: [
        menuRepositoryProvider.overrideWithValue(repository),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MenuScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
