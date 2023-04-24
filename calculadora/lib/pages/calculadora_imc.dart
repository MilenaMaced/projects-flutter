import 'dart:ffi';

import 'package:flutter/material.dart';

class CalculadoraImc extends StatefulWidget {
  const CalculadoraImc({Key? key}) : super(key: key);

  @override
  State<CalculadoraImc> createState() => _CalculadoraImcState();
}

class _CalculadoraImcState extends State<CalculadoraImc> {
  final TextEditingController pesoController = TextEditingController();
  final TextEditingController alturaController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _informeDados = 'Informe seus dados!';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculadora IMC"),
        centerTitle: true,
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            onPressed: _limparCampos,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.person_outline,
                  size: 120,
                  color: Colors.purple,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: pesoController,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    labelText: 'Peso',
                    labelStyle: TextStyle(
                      color: Colors.purple,
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.purple,
                      width: 2,
                    )),
                    suffix: Text('kg'),
                  ),
                  validator: (value) {
                    if(value == null  || value.isEmpty){
                      return 'insira seu peso';
                    }
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: alturaController,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    labelText: 'Altura',
                    labelStyle: TextStyle(
                      color: Colors.purple,
                    ),
                    suffix: Text('cm'),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.purple,
                        width: 2,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return 'insira sua altura!';
                    }
                  },
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Container(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: (){
                        if(_formKey.currentState!.validate()){
                            _calcularImc();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.purple,
                      ),
                      child: const Text(
                        'Calcular',
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  _informeDados,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _limparCampos() {
    pesoController.text = '';
    alturaController.text = '';

    setState(() {
      _informeDados = 'Informe seus dados!';
      _formKey = GlobalKey<FormState>();
    });
  }

  String _calcularImc() {
    setState(() {
      double peso = double.parse(pesoController.text);
      double altura = double.parse(alturaController.text) / 100;
      double imc = peso / (altura * altura);

      if (imc < 18.6) {
        _informeDados = 'Abaixo do peso (${imc.toStringAsPrecision(3)})';
      } else if (imc >= 18.6 && imc < 24.9) {
        _informeDados = 'Peso ideal (${imc.toStringAsPrecision(3)})';
      } else if (imc >= 24.9 && imc < 29.9) {
        _informeDados =
            'Levemente acima do peso (${imc.toStringAsPrecision(3)})';
      } else if (imc >= 29.9 && imc < 34.9) {
        _informeDados = 'Obesidade grau I (${imc.toStringAsPrecision(3)})';
      } else if (imc >= 34.9 && imc < 39.9) {
        _informeDados = 'Obesidade grau II (${imc.toStringAsPrecision(3)})';
      } else if (imc >= 40) {
        _informeDados = 'Obesidade grau III (${imc.toStringAsPrecision(3)})';
      }
    });

    return _informeDados;
  }
}
