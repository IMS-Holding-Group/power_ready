import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'themes/dark_theme.dart';
import 'pages/splash_page.dart';
import 'pages/home_page.dart';
import 'pages/add_home_page.dart';

class PowerReadyApp extends StatelessWidget {
  const PowerReadyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PowerReady',
      debugShowCheckedModeBanner: false,
      theme: DarkTheme.getTheme(),
      locale: const Locale('ar', 'SA'),
      supportedLocales: const [
        Locale('ar', 'SA'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routes: {
        '/': (context) => const SplashPage(),
        '/home': (context) => const HomePage(),
        '/add-home': (context) => const AddHomePage(),
      },
      initialRoute: '/',
    );
  }
}

