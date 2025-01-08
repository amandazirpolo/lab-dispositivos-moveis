import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class BancoDados {
  static final BancoDados _instancia = BancoDados.internal();
  static Database? _bd;

  factory BancoDados() => _instancia;

  BancoDados.internal();

  Future<Database> get bd async {
    if (_bd == null) {
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        sqfliteFfiInit();
        databaseFactory = databaseFactoryFfi;
      }
      _bd = await iniciaBanco();
    }
    return _bd!;
  }

  Future<Database> iniciaBanco() async {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    String caminho = join(await getDatabasesPath(), 'sudoku.db');

    const String scriptBanco =
        "CREATE TABLE sudoku(id INTEGER PRIMARY KEY AUTOINCREMENT, name VARCHAR NOT NULL, result INTEGER, date VARCHAR NOT NULL, level INTEGER);";

    return await openDatabase(caminho, version: 1, onCreate: (bd, version) async {
      await bd.execute(scriptBanco);
    });
  }

  Future<int> insereDados(String nome, int resultado, String nivel) async {
    final banco = await bd;
    Map<String, dynamic> usuario = {
      'name': nome,
      'result': resultado,
      'date': DateTime.now().toString(),
      'level': nivel
    };
    
    int id = await banco.insert('sudoku', usuario, conflictAlgorithm: ConflictAlgorithm.abort);
    return id;
  } 

  Future<List<Map<String, dynamic>>> getDadosUsuario(String nome) async {
    final banco = await bd;
    String script = 'name = ?';
    List<Map<String, dynamic>> usuario = await banco
        .query('sudoku', where: script, whereArgs: [nome]);

    if(usuario.isNotEmpty) {
      return usuario;
    } else {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getTodosOsUsuarios () async {
    final banco = await bd;
    return await banco.query('sudoku');
  }

  Future<void> apagarDados() async {
    final banco = await bd;
    await banco.delete('sudoku');
  }

  Future<void> atualizarResultado (String nome, int? id) async {
    final banco = await bd;
    const String query = 'nome = ? AND id = ?';
    List<Map<String, dynamic>> idUsuario = await banco.query('sudoku', where: query, whereArgs: [nome, id]);

    if (idUsuario.isEmpty) {
      return;
    }
    
    int resultado = (idUsuario.first['result'] as int) + 1;
    await banco.update('sudoku', {'result': resultado}, where: query, whereArgs: [nome, id]);
  }

  Future<int> getPartidasPorDificuldade(String dificuldade) async {
    final banco = await bd;

    const String query = 'SELECT COUNT(*) FROM sudoku WHERE level = ?';
  
    List<Map<String, dynamic>> resultado = await banco.rawQuery(query, [dificuldade]);

    if (resultado.isNotEmpty) {
      int valor = resultado.first['COUNT(*)'] as int;
      return valor;
    } else {
      return 0;
    }
  }

}