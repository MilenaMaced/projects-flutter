import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/contato.dart';

class ContatoPage extends StatefulWidget {
  final Contato? contato;

  const ContatoPage({Key? key, this.contato}) : super(key: key);

  @override
  State<ContatoPage> createState() => _ContatoPageState();
}

class _ContatoPageState extends State<ContatoPage> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();

  late Contato editarContato;
  bool editarCampo = false;

  final foco = FocusNode();

  @override
  void initState() {
    if (widget.contato == null) {
      editarContato = Contato();
    } else {
      editarContato = Contato.fromMap(widget.contato!.toMap());
      nomeController.text = editarContato.nome!;
      emailController.text = editarContato.email!;
      telefoneController.text = editarContato.telefone!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          title: Text(editarContato.nome ?? "Novo Contato"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (editarContato!.nome != null &&
                editarContato!.nome!.isNotEmpty) {
              Navigator.pop(context, editarContato);
            } else {
              FocusScope.of(context).requestFocus(foco);
            }
          },
          backgroundColor: Colors.purple,
          child: const Icon(Icons.save_outlined),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              GestureDetector(
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: editarContato.imagem != null
                          ? FileImage(File(editarContato.imagem!))
                          : const AssetImage('assets/images/user.png')
                              as ImageProvider,
                    ),
                  ),
                ),
                onTap: () {
                  ImagePicker()
                      .pickImage(source: ImageSource.camera)
                      .then((file) {
                    if (file == null) {
                      return;
                    }
                    setState(() {
                      editarContato!.imagem = file.path;
                    });
                  });
                },
              ),
              TextField(
                controller: nomeController,
                focusNode: foco,
                decoration: const InputDecoration(
                  labelText: "Nome",
                ),
                keyboardType: TextInputType.text,
                onChanged: (text) {
                  editarCampo = true;
                  setState(() {
                    editarContato.nome = text;
                  });
                },
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (text) {
                  editarCampo = true;
                  setState(() {
                    editarContato.email = text;
                  });
                },
              ),
              TextField(
                controller: telefoneController,
                decoration: const InputDecoration(
                  labelText: "Telefone",
                ),
                keyboardType: TextInputType.phone,
                onChanged: (text) {
                  editarCampo = true;
                  setState(() {
                    editarContato.telefone = text;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop() {
    if (editarCampo) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Descartar alterações?"),
              content: const Text("Se sair, as alterações serão perdidas!"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancelar"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text("Sim"),
                ),
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
