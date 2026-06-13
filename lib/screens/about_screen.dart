import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';
import '../providers/locale_provider.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEnglish = ref.watch(isEnglishProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEnglish ? 'About Us' : 'Tentang Kami'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'K24 Klik',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: kK24Green,
                    ),
              ),
              const SizedBox(height: 32),
              Text(
                isEnglish
                    ? 'Redesigning the K24 Klik application as part of the final exam project for the HCI and UI/UX course created by Bandar Abdulrab.'
                    : 'Redesign aplikasi K24 Klik sebagai bagian dari proyek ujian akhir mata kuliah HCI dan UI/UX yang dibuat oleh Bandar Abdulrab.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  height: 1.6,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                isEnglish
                    ? 'Disclaimer: This application is purely an academic mockup and is not intended for commercial use. All trademarks, logos, and brand assets belong to PT. K-24 Indonesia. © 2026 Bandar Abdulrab. All Rights Reserved.'
                    : 'Disclaimer: Aplikasi ini murni mockup akademik dan tidak dimaksudkan untuk penggunaan komersial. Semua merek dagang, logo, dan aset merek adalah milik PT. K-24 Indonesia. © 2026 Bandar Abdulrab. All Rights Reserved.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.5,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
