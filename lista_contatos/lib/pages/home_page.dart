import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lista_contatos/pages/contato_page.dart';
import 'package:lista_contatos/repositories/contato_repository.dart';
import "package:url_launcher/url_launcher.dart";
import '../models/contato.dart';

enum OrderOptions { orderaz, orderza }

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ContatoRepository contatoRepository = ContatoRepository();
  List<Contato> contatos = [];

  @override
  void initState() {
      retornarTodosContatos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Contatos"),
        backgroundColor: Colors.purple,
        centerTitle: true,
        actions: [
          PopupMenuButton<OrderOptions>(
            itemBuilder: ((context) => <PopupMenuEntry<OrderOptions>>[
                  const PopupMenuItem<OrderOptions>(
                    value: OrderOptions.orderaz,
                    child: Text("Ordenar de A-Z"),
                  ),
                  const PopupMenuItem<OrderOptions>(
                    value: OrderOptions.orderza,
                    child: Text("Ordenar de Z-A"),
                  )
                ]),
            onSelected: _orderList,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          mudarTelaContatoPage();
        },
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: contatos.length,
        itemBuilder: (context, index) {
          return contatoCard(context, index);
        },
      ),
    );
  }

  Widget contatoCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              FutureBuilder(
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      final img = snapshot.data as ImageProvider<Object>;
                      return Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: img,
                          ),
                        ),
                      );
                    } else {
                      return const SizedBox(
                        width: 80,
                        height: 80,
                      );
                    }
                  } else {
                    return const SizedBox(
                      width: 80,
                      height: 80,
                    );
                  }
                },
                future: getImagemContato(contatos[index].imagem),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contatos[index].nome ?? "",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      contatos[index].email ?? "",
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      contatos[index].telefone ?? "",
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        _showOptions(context, index);
      },
    );
  }

  void mudarTelaContatoPage({Contato? contato}) async {
    final recuperarContato = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContatoPage(
          contato: contato,
        ),
      ),
    );
    if (recuperarContato != null) {
      if (contato != null) {
        await contatoRepository.atualizarContato(recuperarContato);
      } else {
        await contatoRepository.salvarContato(recuperarContato);
      }
      retornarTodosContatos();
    }
  }

  void retornarTodosContatos() {
    setState(() {
      contatoRepository.listarTodosContatos().then((lista) {
        if (lista != null) {
          contatos = lista;
        }
      });
    });
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
              onClosing: () {},
              builder: (context) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () {
                          launch("tel:${contatos[index].telefone}");
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Ligar",
                          style: TextStyle(
                            color: Colors.purple,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          mudarTelaContatoPage(contato: contatos[index]);
                        },
                        child: const Text(
                          "Editar",
                          style: TextStyle(
                            color: Colors.purple,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          contatoRepository.deletarContato(contatos[index].id!);
                          setState(() {
                            contatos.removeAt(index);
                            Navigator.pop(context);
                          });
                        },
                        child: const Text(
                          "Excluir",
                          style: TextStyle(
                            color: Colors.purple,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
        });
  }

  Future<ImageProvider<Object>> getImagemContato(String? path) async {
    if (path != null) {
      FileImage img = FileImage(File(path));
      try {
        await img.file.readAsBytes();
        return FileImage(File(path));
      } catch (e) {
        return const AssetImage("assets/images/user.png");
      }
    } else {
      return const AssetImage("assets/images/user.png");
    }
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderaz:
        contatos.sort((a, b) {
          return a.nome!.toLowerCase().compareTo(b.nome!.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        contatos.sort((a, b) {
          return b.nome!.toLowerCase().compareTo(a.nome!.toLowerCase());
        });
        break;
    }
    setState(() {});
  }
}
