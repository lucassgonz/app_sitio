import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:another_flushbar/flushbar.dart';
import '../cart.dart';  // Ajuste conforme o caminho correto
import 'RegisterScreen.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String errorMessage = '';

  Future<void> login() async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/api/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': emailController.text,
        'password': passwordController.text,
      }),
    );

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', responseData['token']);

      // Exibe a mensagem de sucesso com Flushbar
      Flushbar(
        title: 'Sucesso!',
        message: 'Você foi conectado com sucesso.',
        duration: Duration(seconds: 3),
        backgroundColor: Colors.green,
        icon: Icon(Icons.check, color: Colors.white),
        leftBarIndicatorColor: Colors.green,
      ).show(context);

      // Navega para a tela de carrinho
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyCart(
              title: 'Cart Screen',
              isDarkMode: false,  // Aqui você deve passar o valor correto de 'isDarkMode'
              onThemeChanged: (value) {
                setState(() {
                  // Atualiza o estado de 'isDarkMode' se necessário
                });
              },
            )),
      );
    } else {
      setState(() {
        errorMessage = responseData['message'];
      });

      // Exibe o pop-up de erro
      Flushbar(
        title: 'Erro!',
        message: responseData['message'],
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
        icon: Icon(Icons.error, color: Colors.white),
        leftBarIndicatorColor: Colors.red,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: login, child: Text('Entrar')),
            Text(errorMessage, style: TextStyle(color: Colors.red)),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: Text('É novo por aqui? Cadastre-se'),
            ),
          ],
        ),
      ),
    );
  }
}
