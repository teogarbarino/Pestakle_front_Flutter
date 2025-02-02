// Dart Imports
// Flutter Imports

//import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:pestakle/controllers/provider/theme_provider.dart';
import 'package:pestakle/views/auth/forget_password.screen.dart';
import 'package:pestakle/views/auth/login_screen.dart';
import 'package:pestakle/views/auth/on_boardscreen.dart';
import 'package:pestakle/views/auth/register_screen.dart';
import 'package:pestakle/views/MainController.dart';
import 'package:pestakle/views/product/create_product_screen.dart';
import 'package:pestakle/views/profile/profile_page.dart';
import 'package:pestakle/views/tutorial/tutorial_screen.dart';
import 'package:provider/provider.dart';
import 'package:pestakle/controllers/provider/index_provider.dart';
import 'package:pestakle/controllers/provider/user_provider.dart';
// External Imports

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => IndexProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'App FB',
          debugShowCheckedModeBanner: false,
          locale: const Locale('fr', 'FR'),
          theme: themeProvider.currentTheme,
          home: const OnboardingPage(),
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/home':
                return _buildRoute(const OnboardingPage());
              case '/signup':
                return _buildRoute(const RegisterPage());
              case '/login':
                return _buildRoute(const LoginPage());
              case '/forgotPassword':
                return _buildRoute(const ForgotPasswordPage());
              case '/profile':
                return _buildRoute(const ProfilePage());
              case '/tutorial':
                return _buildRoute(const TutorialPage());
              case '/main':
                return _buildRoute(MainPage());
              case '/createProduct':
                return _buildRoute(const CreateProduitsScreen());
              /* case '/loading':
              return _buildRoute(const LoadingScreen());*/
              default:
                return _buildRoute(const OnboardingPage());
            }
          },
        );
      },
    );
  }

  PageRouteBuilder _buildRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final slideAnimation = Tween<Offset>(
          begin: const Offset(1.0, 0.0), // Commence à droite de l'écran
          end: Offset.zero, // Arrive à la position normale
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        ));

        final fadeAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        ));
        return SlideTransition(
          position: slideAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 250),
    );
  }
}
