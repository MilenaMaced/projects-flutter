class Contato {
  int? id;
  String? nome;
  String? email;
  String? telefone;
  String? imagem;

  Contato();

  Contato.fromMap(Map map) {
    id = map['idColumn'];
    nome = map['nomeColumn'];
    email = map['emailColumn'];
    telefone = map['telefoneColumn'];
    imagem = map['imagemColumn'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'nomeColumn': nome,
      'emailColumn': email,
      'telefoneColumn': telefone,
      'imagemColumn': imagem
    };
    if (id != null) {
      map['idColumn'] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Contact(id: $id, nome: $nome, email: $email, telefone: $telefone, img: $imagem)";
  }
}
