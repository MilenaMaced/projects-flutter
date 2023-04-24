import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?key=1a07ee64";

class Conversor extends StatefulWidget {
  const Conversor({Key? key}) : super(key: key);

  @override
  State<Conversor> createState() => _ConversorState();
}

class _ConversorState extends State<Conversor> {
  final TextEditingController dolarController = TextEditingController();
  final TextEditingController realController = TextEditingController();
  final TextEditingController euroController = TextEditingController();

  late double dolar;
  late double euro;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('\$ Conversor de Moedas'),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getDados(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(
                child: Text(
                  "Carregando os dados...",
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 25,
                  ),
                ),
              );
            default:
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    "Erro ao carregar os dados...",
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 25,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                dolar = snapshot.data!["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data!["results"]["currencies"]["EUR"]["buy"];

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(
                        Icons.monetization_on,
                        size: 150,
                        color: Colors.amber,
                      ),
                      buildTextField(
                          "Reais", "R\$ ", realController, _conversorReal),
                      const SizedBox(height: 16),
                      buildTextField(
                          "Dólar", "US\$ ", dolarController, _conversorDolar),
                      const SizedBox(height: 16),
                      buildTextField(
                          "Euros", "€ ", euroController, _conversorEuro),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }

  Future<Map> getDados() async {
    http.Response response = await http.get(Uri.parse(request));
    return json.decode(response.body);
  }

  void _limparCampos(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  void _conversorReal(String texto) {
    if(texto.isEmpty) {
      _limparCampos();
      return;
    }
    double real = double.parse(texto);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  void _conversorDolar(String texto) {
    if(texto.isEmpty) {
      _limparCampos();
      return;
    }
    double dolar = double.parse(texto);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void _conversorEuro(String texto) {
    if(texto.isEmpty) {
      _limparCampos();
      return;
    }
    double euro = double.parse(texto);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  Widget buildTextField(
      String label, String prefix, TextEditingController controller, Function func) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        color: Colors.amber
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.amber,
          fontSize: 15,
        ),
        prefixText: prefix,
      ),
      keyboardType: TextInputType.number,
      onChanged: (context) {
        func(context);
      },
    );
  }
}
