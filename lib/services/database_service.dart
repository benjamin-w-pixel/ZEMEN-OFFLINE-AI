import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'ai_engine_service.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'zemen_ai.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Chat History Table
    await db.execute('''
      CREATE TABLE messages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        text TEXT,
        isUser INTEGER,
        timestamp TEXT
      )
    ''');

    // Academic Modules Table
    await db.execute('''
      CREATE TABLE modules (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        category TEXT,
        isDownloaded INTEGER,
        lastAccessed TEXT
      )
    ''');

    // Pre-populate some modules
    await db.insert('modules', {'name': 'Mathematics', 'category': 'STEM', 'isDownloaded': 1, 'lastAccessed': DateTime.now().toIso8601String()});
    await db.insert('modules', {'name': 'Biology', 'category': 'STEM', 'isDownloaded': 0, 'lastAccessed': DateTime.now().toIso8601String()});
    await db.insert('modules', {'name': 'Ethio History', 'category': 'Social', 'isDownloaded': 1, 'lastAccessed': DateTime.now().toIso8601String()});
  }

  // --- Message Methods ---

  Future<void> saveMessage(ChatMessage msg) async {
    final db = await database;
    await db.insert('messages', {
      'text': msg.text,
      'isUser': msg.isUser ? 1 : 0,
      'timestamp': msg.timestamp.toIso8601String(),
    });
  }

  Future<List<ChatMessage>> getMessages() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('messages', orderBy: 'id ASC');
    return List.generate(maps.length, (i) {
      return ChatMessage(
        text: maps[i]['text'],
        isUser: maps[i]['isUser'] == 1,
        timestamp: DateTime.parse(maps[i]['timestamp']),
      );
    });
  }

  Future<void> clearHistory() async {
    final db = await database;
    await db.delete('messages');
  }
}
