import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ListaTarefas extends StatefulWidget {
  const ListaTarefas({Key? key}) : super(key: key);

  @override
  State<ListaTarefas> createState() => _ListaTarefasState();
}

class _ListaTarefasState extends State<ListaTarefas> {
  final TextEditingController tarefaController = TextEditingController();
  List tarefas = [];

  @override
  void initState() {
    lerDados().then((dados) {
      setState(() {
        tarefas = json.decode(dados!);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text("Lista de Tarefas"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(17, 15, 10, 1),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: tarefaController,
                    decoration: const InputDecoration(
                      labelText: 'Adicione uma Tarefa',
                      hintText: 'Ex. Estudar inglês',
                      labelStyle: TextStyle(color: Colors.purple),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.purple,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                ElevatedButton(
                  onPressed: adicionarTarefas,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.purple,
                    padding: const EdgeInsets.all(18),
                  ),
                  child: const Text('ADD'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 10),
              itemCount: tarefas.length,
              itemBuilder: (BuildContext context, int index) {
                return CheckboxListTile(
                  title: Text(tarefas[index]['tarefa']),
                  value: tarefas[index]['status'],
                  checkColor: Colors.white,
                  activeColor: Colors.purple,
                  secondary: CircleAvatar(
                      backgroundColor: Colors.purple,
                      child: Icon(
                        tarefas[index]['status']
                            ? Icons.check
                            : Icons.error_outline_outlined,
                        color: Colors.white,
                      )),
                  onChanged: (context) {
                    setState(() {
                      tarefas[index]['status'] = context;
                      savarDados();
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void adicionarTarefas() {
    setState(() {
      Map<String, dynamic> novaTarefa = {};
      novaTarefa['tarefa'] = tarefaController.text;
      tarefaController.text = "";
      novaTarefa['status'] = false;
      tarefas.add(novaTarefa);
    });
  }

  Future<File> pegarArquivo() async {
    final diretorio = await getApplicationDocumentsDirectory();
    return File('${diretorio.path}/dados.json');
  }

  Future<File> savarDados() async {
    String dados = json.encode(tarefas);
    final arquivo = await pegarArquivo();
    return arquivo.writeAsString(dados);
  }

  Future<String?> lerDados() async {
    try {
      final arquivo = await pegarArquivo();

      return arquivo.readAsString();
    } catch (e) {
      return null;
    }
  }
}
