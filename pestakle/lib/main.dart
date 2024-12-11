// Dart Imports
// Flutter Imports

//import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pestakle/controllers/provider/index_provider.dart';
import 'package:pestakle/controllers/provider/user_provider.dart';
import 'package:pestakle/views/loading_screen.dart';
// External Imports

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => IndexProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
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
    // On définit les paramètres de notre application
    return MaterialApp(
      title: 'App FB',
      debugShowCheckedModeBanner: false,
      //  supportedLocales: L10n.all, // Setup de la langue
      locale: const Locale('fr', 'FR'), // .
      /*  localizationsDelegates: const [
        AppLocalizations.delegate, // .
        GlobalMaterialLocalizations.delegate, // .
        GlobalWidgetsLocalizations.delegate, // .
        GlobalCupertinoLocalizations.delegate, // .
      ], */

      theme: ThemeData(
        primarySwatch: Colors.amber,
      ), // (Objet Provider <ClasseTheme>).Function == Theme
      home: const LoadingPage(), // Page à l'ouverture
    );
  }
}
