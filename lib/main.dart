import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/foundation.dart'; // Tidak perlu lagi jika pakai firebase_options
import 'package:intl/date_symbol_data_local.dart'; 
import 'package:flutter_localizations/flutter_localizations.dart'; 
import 'l10n/app_localizations.dart';
import 'pages/splash_page.dart';

// [PENTING] Import file konfigurasi otomatis
import 'firebase_options.dart'; 

// [1] SAKLAR TEMA GLOBAL
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

// [2] SAKLAR BAHASA GLOBAL
final ValueNotifier<Locale> languageNotifier = ValueNotifier(const Locale('id')); 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // [UPDATED] Inisialisasi Firebase Otomatis (Support Web, Android, iOS)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, 
  );

  // Inisialisasi Format Tanggal Indonesia
  await initializeDateFormatting('id_ID', null);

  runApp(const PlannoApp());
}

class PlannoApp extends StatelessWidget {
  const PlannoApp({super.key});

  @override
  Widget build(BuildContext context) {
    // [BARU] BUNGKUS DENGAN LISTENER BAHASA
    return ValueListenableBuilder<Locale>(
      valueListenable: languageNotifier,
      builder: (_, Locale currentLocale, __) {
        
        // [2] BUNGKUS DENGAN LISTENER TEMA
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: themeNotifier,
          builder: (_, ThemeMode currentMode, __) {
            return MaterialApp(
              title: 'Planno',
              debugShowCheckedModeBanner: false,
              
              // --- [BARU] KONFIGURASI BAHASA ---
              locale: currentLocale, 
              localizationsDelegates: const [
                AppLocalizations.delegate, 
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('id'), // Bahasa Indonesia
                Locale('en'), // Bahasa Inggris
              ],
              // --------------------------------

              // --- KONFIGURASI TEMA TERANG (LIGHT) ---
              theme: ThemeData(
                useMaterial3: true,
                brightness: Brightness.light,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color(0xFF3F51B5),
                  brightness: Brightness.light,
                ),
                scaffoldBackgroundColor: Colors.grey.shade100, 
                appBarTheme: const AppBarTheme(
                  centerTitle: true,
                  elevation: 0,
                  backgroundColor: Color(0xFF3F51B5),
                  foregroundColor: Colors.white,
                ),
                inputDecorationTheme: InputDecorationTheme(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
              ),

              // --- KONFIGURASI TEMA GELAP (DARK) ---
              darkTheme: ThemeData(
                useMaterial3: true,
                brightness: Brightness.dark,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color(0xFF3F51B5),
                  brightness: Brightness.dark,
                ),
                scaffoldBackgroundColor: const Color(0xFF121212), 
                cardColor: const Color(0xFF1E1E1E), 
                appBarTheme: const AppBarTheme(
                  centerTitle: true,
                  elevation: 0,
                  backgroundColor: Color(0xFF1E1E1E), 
                  foregroundColor: Colors.white,
                ),
                inputDecorationTheme: InputDecorationTheme(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: const Color(0xFF2C2C2C), 
                ),
              ),

              // [3] SETTINGAN MODE AKTIF
              themeMode: currentMode,

              // [4] HALAMAN AWAL (SPLASH SCREEN)
              home: const SplashPage(),
            );
          },
        );
      },
    );
  }
}