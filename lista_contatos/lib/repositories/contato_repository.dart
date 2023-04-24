import 'package:lista_contatos/models/contato.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ContatoRepository {
  static final ContatoRepository _instance = ContatoRepository.internal();

  factory ContatoRepository() => _instance;

  ContatoRepository.internal();

  Database? _db;
  Contato? contato;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await inicializarDb();
      return _db;
    }
  }

  Future<Database> inicializarDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'contato.db');

    String sql = 'CREATE TABLE Contato ('
        'idColumn INTEGER PRIMARY KEY,'
        'nomeColumn TEXT, '
        'emailColumn TEXT,'
        'telefoneColumn TEXT,'
        'imagemColumn TEXT'
        ')';

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(sql);
    });
  }

  Future<Contato> salvarContato(Contato contato) async {
    Database? dbContato = await db;
    if (dbContato != null) {
      contato.id = await dbContato.insert('Contato', contato.toMap());
    }
    return contato;
  }

  Future<Contato?> recuperarContato(int id) async {
    Database? dbContato = await db;
    late List<Map> maps;

    if (dbContato != null) {
      maps = await dbContato.query('Contato',
          columns: [
            'idColumn',
            'nomeColumn',
            'emailColumn',
            'telefoneColumn',
            'imagemColumn'
          ],
          where: 'idColumn = ?',
          whereArgs: [id]);
    }
    if (maps.isEmpty) {
      return Contato.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deletarContato(int id) async {
    Database? dbContato = await db;

    if (dbContato != null) {
      return await dbContato
          .delete('Contato', where: 'idColumn = ?', whereArgs: [id]);
    } else {
      return 0;
    }
  }

  Future<int> atualizarContato(Contato contato) async {
    Database? dbContato = await db;

    if (dbContato != null) {
      return await dbContato.update('Contato', contato.toMap(),
          where: 'idColumn = ?', whereArgs: [contato.id]);
    } else {
      return 0;
    }
  }

  Future<List<Contato>?> listarTodosContatos() async {
    Database? dbContato = await db;

    if (dbContato != null) {
      List listMap = await dbContato.rawQuery("SELECT * FROM Contato");
      List<Contato> listaContatos = [];
      for (Map m in listMap) {
        listaContatos.add(Contato.fromMap(m));
      }
      return listaContatos;
    } else {
      return null;
    }
  }

  Future<int?> retonarQuantidadeContatos() async {
    Database? dbContato = await db;

    if (dbContato != null) {
      return Sqflite.firstIntValue(
          await dbContato.rawQuery('SELECT COUNT(*) FROM Contato'));
    } else {
      return 0;
    }
  }

  void fecharDb() async {
    Database? dbContato = await db;
    if (dbContato != null) {
      dbContato.close();
    }
  }
}
