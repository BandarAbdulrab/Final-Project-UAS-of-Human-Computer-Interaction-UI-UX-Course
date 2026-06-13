import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';
import '../providers/auth_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/main_tab_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/user_avatar.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _onSignOut(BuildContext context, WidgetRef ref) async {
    final isEnglish = ref.read(isEnglishProvider);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(isEnglish ? 'Sign Out' : 'Keluar'),
        content: Text(
          isEnglish
              ? 'Are you sure you want to sign out?'
              : 'Apakah Anda yakin ingin keluar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(isEnglish ? 'Cancel' : 'Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: FilledButton.styleFrom(backgroundColor: kK24Green),
            child: Text(isEnglish ? 'Yes, Sign Out' : 'Ya, Keluar'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await ref.read(authProvider.notifier).logout();
      if (context.mounted) {
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEnglish = ref.watch(isEnglishProvider);
    final isDarkMode = ref.watch(isDarkModeProvider);
    final user = ref.watch(userProvider);
    final colorScheme = Theme.of(context).colorScheme;

    final menuItems = [
      _ProfileMenuItem(
        icon: Icons.person_outline,
        title: isEnglish ? 'Profile Details' : 'Profil & Data Diri',
        onTap: () => context.push('/profile_detail'),
      ),
      _ProfileMenuItem(
        icon: Icons.receipt_long_outlined,
        title: isEnglish ? 'Orders' : 'Pesanan Saya',
        onTap: () => ref.read(mainTabProvider.notifier).state = 2,
      ),
      _ProfileMenuItem(
        icon: Icons.favorite_outline,
        title: isEnglish ? 'Likes' : 'Obat Favorit',
        onTap: () => context.push('/favorites'),
      ),
      _ProfileMenuItem(
        icon: Icons.language,
        title: isEnglish ? 'Language' : 'Bahasa / Language',
        trailing: Switch(
          value: isEnglish,
          activeTrackColor: kK24Green.withValues(alpha: 0.5),
          activeThumbColor: kK24Green,
          onChanged: (value) {
            ref.read(isEnglishProvider.notifier).state = value;
          },
        ),
      ),
      _ProfileMenuItem(
        icon: Icons.dark_mode,
        title: isEnglish ? 'Dark Mode' : 'Tema Gelap',
        trailing: Switch(
          value: isDarkMode,
          activeTrackColor: kK24Green.withValues(alpha: 0.5),
          activeThumbColor: kK24Green,
          onChanged: (value) {
            ref.read(isDarkModeProvider.notifier).state = value;
          },
        ),
      ),
      _ProfileMenuItem(
        icon: Icons.info_outline,
        title: isEnglish ? 'About Us' : 'Tentang Kami',
        onTap: () => context.push('/about'),
      ),
      _ProfileMenuItem(
        icon: Icons.logout,
        title: isEnglish ? 'Sign Out' : 'Keluar',
        titleColor: Colors.red,
        onTap: () => _onSignOut(context, ref),
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  UserAvatar(user: user),
                  const SizedBox(height: 16),
                  Text(
                    user.name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.phone,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: menuItems.length,
                separatorBuilder: (_, _) =>
                    Divider(color: colorScheme.outlineVariant),
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  return ListTile(
                    leading: Icon(
                      item.icon,
                      color: item.titleColor ?? colorScheme.onSurface,
                    ),
                    title: Text(
                      item.title,
                      style: TextStyle(
                        color: item.titleColor ?? colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: item.trailing,
                    onTap: item.onTap,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileMenuItem {
  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    this.titleColor,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final Color? titleColor;
  final Widget? trailing;
  final VoidCallback? onTap;
}
