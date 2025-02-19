import 'dart:convert';
import 'package:app/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CepSearchPage extends StatefulWidget {
  const CepSearchPage({super.key});

  @override
  State<CepSearchPage> createState() => _CepSearchPageState();
}

class _CepSearchPageState extends State<CepSearchPage> {
  final TextEditingController _cepController = TextEditingController();
  String _result = '';

  @override
  void initState() {
    super.initState();
    _cepController.addListener(_formatCep);
  }

  @override
  void dispose() {
    _cepController.removeListener(_formatCep);
    _cepController.dispose();
    super.dispose();
  }

  // Função para formatar o CEP automaticamente
  void _formatCep() {
    final text = _cepController.text.replaceAll(RegExp(r'\D'), ''); // Remove caracteres não numéricos

    if (text.length > 5) {
      final formattedCep = '${text.substring(0, 5)}-${text.substring(5, text.length)}';
      _cepController.value = TextEditingValue(
        text: formattedCep,
        selection: TextSelection.collapsed(offset: formattedCep.length), // Mantém o cursor no final
      );
    }
  }

  // Função para consultar o CEP
  Future<void> _buscarCep() async {
    final cep = _cepController.text.replaceAll('-', '').trim(); // Remove o traço antes de buscar

    if (cep.isEmpty || cep.length != 8 || int.tryParse(cep) == null) {
      setState(() {
        _result = 'Por favor, insira um CEP válido com 8 dígitos.';
      });
      return;
    }

    try {
      final dados = await _consultaCep(cep);
      setState(() {
        if (dados.containsKey('erro')) {
          _result = 'CEP não encontrado.';
        } else {
          _result = '''
CEP: ${dados['cep']}
Logradouro: ${dados['logradouro']}
Bairro: ${dados['bairro']}
Cidade: ${dados['localidade']}
Estado: ${dados['uf']}
          ''';
        }
      });
    } catch (e) {
      setState(() {
        _result = 'Erro ao buscar o CEP: $e';
      });
    }
  }

  // Função para realizar a chamada à API ViaCEP
  Future<Map<String, dynamic>> _consultaCep(String cep) async {
    final url = Uri.parse('https://viacep.com.br/ws/$cep/json/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao buscar o CEP');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Consulta CEP",
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _cepController,
              decoration: const InputDecoration(
                labelText: 'Digite o CEP',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _buscarCep,
              child: const Text('Pesquisar'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _result,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
