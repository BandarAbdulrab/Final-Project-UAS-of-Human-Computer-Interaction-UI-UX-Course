import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:k24_mvp/l10n/app_localizations.dart';

import 'constants/app_colors.dart';
import 'firebase_options.dart';
import 'providers/theme_provider.dart';
import 'models/product_model.dart';
import 'screens/about_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/favorite_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/login_screen.dart';
import 'screens/main_layout.dart';
import 'screens/profile_detail_screen.dart';
import 'screens/register_screen.dart';
import 'screens/splash_screen.dart';

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/forgot_password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const MainLayout(),
    ),
    GoRoute(
      path: '/detail',
      builder: (context, state) {
        final product = state.extra as Product?;
        if (product == null) {
          return const Scaffold(
            body: Center(child: Text('Product not found')),
          );
        }
        return DetailScreen(product: product);
      },
    ),
    GoRoute(
      path: '/checkout',
      builder: (context, state) => const CheckoutScreen(),
    ),
    GoRoute(
      path: '/profile_detail',
      builder: (context, state) => const ProfileDetailScreen(),
    ),
    GoRoute(
      path: '/about',
      builder: (context, state) => const AboutScreen(),
    ),
    GoRoute(
      path: '/favorites',
      builder: (context, state) => const FavoriteScreen(),
    ),
  ],
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kIsWeb) {
    GoogleFonts.config.allowRuntimeFetching = true;
  }

  runApp(
    const ProviderScope(
      child: K24App(),
    ),
  );
}

const Color _kK24GreenDark = Color(0xFF4CAF50);

ThemeData _buildLightTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.fromSeed(
      seedColor: kK24Green,
      primary: kK24Green,
      surface: Colors.white,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      elevation: 0,
    ),
  );
}

ThemeData _buildDarkTheme() {
  final base = ThemeData.dark(useMaterial3: true);
  return base.copyWith(
    colorScheme: base.colorScheme.copyWith(
      primary: _kK24GreenDark,
      onPrimary: Colors.white,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(base.textTheme),
    appBarTheme: base.appBarTheme.copyWith(
      backgroundColor: base.colorScheme.surface,
      foregroundColor: base.colorScheme.onSurface,
      elevation: 0,
    ),
  );
}

class K24App extends ConsumerWidget {
  const K24App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(isDarkModeProvider);

    return MaterialApp.router(
      title: 'K-24 Pharmacy',
      debugShowCheckedModeBanner: false,
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: _router,
    );
  }
}
