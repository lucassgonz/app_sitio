import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';  // Importar o SharedPreferences

import 'package:app/screen/LoginScreen.dart';
import 'package:app/cart.dart';
import 'package:app/catalog.dart';
import 'package:app/settings.dart';
import 'package:app/theme.dart';
import 'package:app/models/cart.dart';
import 'package:app/models/catalog.dart';
import 'package:app/cep.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();  // Inicializar o Flutter corretamente

  // Carregar SharedPreferences para verificar login
  final prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;  // Verifica se o usuário está logado

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => CatalogModel()), // Cria o CatalogModel
        ChangeNotifierProvider(
          create: (context) => CartModel(catalog: context.read<CatalogModel>()),
        ),
      ],
      child: MyApp(isLoggedIn: isLoggedIn),  // Passa a informação do login
    ),
  );
}

class MyApp extends StatefulWidget {
  final bool isLoggedIn;  // Recebe a variável do estado de login

  const MyApp({super.key, required this.isLoggedIn});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App',
      debugShowCheckedModeBanner: false,
      darkTheme: darkmode,
      theme: lightmode,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      initialRoute: widget.isLoggedIn ? '/catalog' : '/login',  // Direciona para login caso não esteja logado
      routes: {
        '/login': (context) => LoginPage(),
        '/': (context) => const CepSearchPage(),
        '/settings': (context) => SettingsPage(
              title: 'Settings Screen',
              isDarkMode: _isDarkMode,
              onThemeChanged: (value) {
                setState(() {
                  _isDarkMode = value;
                });
              },
            ),
        '/cart': (context) => MyCart(
              title: 'Cart Screen',
              isDarkMode: _isDarkMode,
              onThemeChanged: (value) {
                setState(() {
                  _isDarkMode = value;
                });
              },
            ),
        '/catalog': (context) => MyCatalog(
              title: 'Catalog Screen',
              isDarkMode: _isDarkMode,
              onThemeChanged: (value) {
                setState(() {
                  _isDarkMode = value;
                });
              },
            ),
      },
    );
  }
}
