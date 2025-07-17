import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/task_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _db;

  DatabaseHelper._();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'tasks.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }
  Future<List<TaskModel>> getAllTasks() async {
    final db = await database;
    final result = await db.query('tasks');

    return result.map((row) {
      return TaskModel(
        id: row['id'] as int,
        title: row['title'] as String,
        date: DateTime.parse(row['date'] as String),
        category: row['category'] as String,
        priority: row['priority'] as String,
        completed: (row['completed'] as int) == 1,

      );
    }).toList();
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        date TEXT,
        category TEXT,
        priority TEXT,
  completed INTEGER DEFAULT 0
      )
    ''');
  }

  Future<void> insertTask({
    required String title,
    required String date,
    required String category,
    required String priority,
  }) async {
    final db = await database;
    await db.insert(
      'tasks',
      {
        'title': title,
        'date': date,
        'category': category,
        'priority': priority,
        'completed': 0,
      },
    );
  }
  Future<void> updateTask(TaskModel task) async {
    final db = await database;
    await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }
  Future<void> clearAllTasks() async {
    final db = await database;
    await db.delete('tasks');
  }
  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

}
