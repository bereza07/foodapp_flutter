import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodapp/src/features/profile/presentation/screens/order_history_screen.dart';
import '../controllers/profile_controller.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        actions: [
          IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  OrderHistoryScreen()),
            );
          },
          icon: Icon(Icons.receipt_long_outlined),
        ),
        ],
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Ошибка: $e')),
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('Профиль не найден'));
          }

          // Заполняем контроллеры (только если они пустые, иначе при каждом build перезапишет текст)
          _nameController.text = _nameController.text.isEmpty
              ? (profile.name ?? '')
              : _nameController.text;
          _phoneController.text = _phoneController.text.isEmpty
              ? (profile.phone ?? '')
              : _phoneController.text;
          _addressController.text = _addressController.text.isEmpty
              ? (profile.address.isNotEmpty ? profile.address.first : '')
              : _addressController.text;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Имя'),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Введите имя' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(labelText: 'Телефон'),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Введите телефон'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Адрес доставки',
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Введите адрес' : null,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        final updatedProfile = profile.copyWith(
                          name: _nameController.text,
                          phone: _phoneController.text,
                          address: [_addressController.text],
                        );
                        await ref
                            .read(profileControllerProvider.notifier)
                            .updateProfile(updatedProfile);

                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Профиль обновлён')),
                          );
                        }
                      }
                    },
                    child: const Text('Сохранить изменения'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
