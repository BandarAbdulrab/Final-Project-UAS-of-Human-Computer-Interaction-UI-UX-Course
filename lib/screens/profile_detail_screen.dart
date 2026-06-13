import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';
import '../providers/locale_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/user_avatar.dart';

class ProfileDetailScreen extends ConsumerStatefulWidget {
  const ProfileDetailScreen({super.key});

  @override
  ConsumerState<ProfileDetailScreen> createState() =>
      _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends ConsumerState<ProfileDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _photoUrlController;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider);
    _nameController = TextEditingController(text: user.name);
    _phoneController = TextEditingController(text: user.phone);
    _addressController = TextEditingController(text: user.address);
    _photoUrlController = TextEditingController(text: user.photoUrl);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _photoUrlController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await ref.read(userProvider.notifier).updateProfile(
            name: _nameController.text.trim(),
            phone: _phoneController.text.trim(),
            address: _addressController.text.trim(),
            photoUrl: _photoUrlController.text.trim(),
          );
      if (mounted) context.pop();
    } catch (_) {
      if (!mounted) return;
      final isEnglish = ref.read(isEnglishProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEnglish
                ? 'Failed to save profile. Please try again.'
                : 'Gagal menyimpan profil. Silakan coba lagi.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEnglish = ref.watch(isEnglishProvider);
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEnglish ? 'Profile Details' : 'Profil & Data Diri'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(child: UserAvatar(user: user)),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: isEnglish ? 'Name' : 'Nama',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return isEnglish
                        ? 'Name is required'
                        : 'Nama wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: isEnglish ? 'Phone' : 'Nomor HP',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return isEnglish
                        ? 'Phone number is required'
                        : 'Nomor HP wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _photoUrlController,
                keyboardType: TextInputType.url,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: isEnglish
                      ? 'Profile Photo URL (Optional)'
                      : 'URL Foto Profil (Opsional)',
                  hintText: 'https://...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                maxLines: 3,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: isEnglish ? 'Address' : 'Alamat',
                  hintText: isEnglish
                      ? 'Enter your delivery address'
                      : 'Masukkan alamat pengiriman',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return isEnglish
                        ? 'Address is required'
                        : 'Alamat wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: _onSave,
                style: FilledButton.styleFrom(
                  backgroundColor: kK24Green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(isEnglish ? 'Save' : 'Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
