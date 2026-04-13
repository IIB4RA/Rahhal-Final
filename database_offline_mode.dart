import 'dart:convert';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// ================= CUSTOM EXCEPTION =================
class DatabaseException implements Exception {
  final String message;
  DatabaseException(this.message);

  @override
  String toString() => "DatabaseException: $message";
}

// ================= DATABASE SERVICE =================
class DatabaseService {
  static const String dbName = "database_offline_mode.db";
  Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    try {
      _db = await initDB();
      return _db!;
    } catch (e) {
      throw DatabaseException("Failed to initialize database: $e");
    }
  }

  Future<Database> initDB() async {
    try {
      String path = join(await getDatabasesPath(), dbName);

      return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await createUserTable(db);
          await createPassportTable(db);
          await createVisaTable(db);
          await createJordanPassTable(db);
          await createSyncQueueTable(db);
        },
      );
    } catch (e) {
      throw DatabaseException("Database creation failed: $e");
    }
  }

  int userVerificationStatusConvert(bool status) {
    return status ? 1 : 0;
  }

  // ================= CREATE TABLES =================

  Future<void> createUserTable(Database db) async {
    try {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS User_table (
          user_id INTEGER PRIMARY KEY AUTOINCREMENT,
          email TEXT UNIQUE NOT NULL,
          password_hash TEXT NOT NULL,
          full_name TEXT NOT NULL,
          nationality TEXT NOT NULL,
          language TEXT NOT NULL,
          phone TEXT,
          role TEXT NOT NULL,
          user_verification_status INTEGER NOT NULL,
          avatar_url TEXT,
          created_at TEXT DEFAULT CURRENT_TIMESTAMP,
          updated_at TEXT DEFAULT CURRENT_TIMESTAMP
        );
      ''');
    } catch (e) {
      throw DatabaseException("Failed to create User_table: $e");
    }
  }

  Future<void> createPassportTable(Database db) async {
    try {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS Passport_table (
          passport_id TEXT PRIMARY KEY,
          user_id INTEGER,
          full_name_passport TEXT,
          passport_expiration_date TEXT
        );
      ''');
    } catch (e) {
      throw DatabaseException("Failed to create Passport_table: $e");
    }
  }

  Future<void> createVisaTable(Database db) async {
    try {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS Visa_table (
          reference_no TEXT PRIMARY KEY,
          user_id INTEGER,
          passport_id TEXT,
          visa_type TEXT,
          purpose_of_visit TEXT,
          arrival_date TEXT,
          departure_date TEXT,
          visa_application_status TEXT
        );
      ''');
    } catch (e) {
      throw DatabaseException("Failed to create Visa_table: $e");
    }
  }

  Future<void> createJordanPassTable(Database db) async {
    try {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS Jordan_pass_table (
          pass_id TEXT PRIMARY KEY,
          user_id INTEGER,
          visa_reference_no TEXT,
          jordan_pass_expiration_date TEXT,
          jordan_pass_active_status TEXT
        );
      ''');
    } catch (e) {
      throw DatabaseException("Failed to create Jordan_pass_table: $e");
    }
  }

  // ================= INSERT =================

  Future<int> insertUser(Map<String, dynamic> user) async {
    final database = await db;

    try {
      if (!user.containsKey("email") || !user.containsKey("password_hash")) {
        throw DatabaseException("Missing required user fields");
      }

      user['user_verification_status'] =
          userVerificationStatusConvert(user['user_verification_status'] ?? false);

      return await database.insert("User_table", user);
    } catch (e) {
      throw DatabaseException("Insert user failed: $e");
    }
  }

  Future<void> insertPassport(Map<String, dynamic> passport) async {
    final database = await db;

    try {
      await database.insert("Passport_table", passport);
    } catch (e) {
      throw DatabaseException("Insert passport failed: $e");
    }
  }

  Future<void> insertVisa(Map<String, dynamic> visa) async {
    final database = await db;

    try {
      await database.insert("Visa_table", visa);
    } catch (e) {
      throw DatabaseException("Insert visa failed: $e");
    }
  }

  Future<void> insertJordanPass(Map<String, dynamic> pass) async {
    final database = await db;

    try {
      await database.insert("Jordan_pass_table", pass);
    } catch (e) {
      throw DatabaseException("Insert Jordan pass failed: $e");
    }
  }

  // ================= UPDATE =================

  Future<void> updateUser(int userId, Map<String, dynamic> updates) async {
    final database = await db;

    try {
      if (updates.isEmpty) {
        throw DatabaseException("No fields provided for update");
      }

      if (updates.containsKey("user_verification_status")) {
        updates["user_verification_status"] =
            userVerificationStatusConvert(updates["user_verification_status"]);
      }

      int count = await database.update(
        "User_table",
        updates,
        where: "user_id = ?",
        whereArgs: [userId],
      );

      if (count == 0) {
        throw DatabaseException("User not found");
      }
    } catch (e) {
      throw DatabaseException("Update user failed: $e");
    }
  }

  // ================= GET =================

  Future<Map<String, dynamic>> getUser(int userId) async {
    final database = await db;

    try {
      final result = await database.query(
        "User_table",
        where: "user_id = ?",
        whereArgs: [userId],
      );

      if (result.isEmpty) {
        throw DatabaseException("User not found");
      }

      return result.first;
    } catch (e) {
      throw DatabaseException("Fetch user failed: $e");
    }
  }

  // ================= DELETE =================

  Future<void> deleteUser(int userId) async {
    final database = await db;

    try {
      int count = await database.delete(
        "User_table",
        where: "user_id = ?",
        whereArgs: [userId],
      );

      if (count == 0) {
        throw DatabaseException("User not found for deletion");
      }
    } catch (e) {
      throw DatabaseException("Delete user failed: $e");
    }
  }

  // ================= SYNC QUEUE =================

  Future<void> createSyncQueueTable(Database db) async {
    try {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS Sync_queue_table (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          action TEXT NOT NULL,
          payload TEXT NOT NULL,
          status TEXT DEFAULT 'pending',
          retry_count INTEGER DEFAULT 0,
          created_at TEXT DEFAULT CURRENT_TIMESTAMP
        );
      ''');
    } catch (e) {
      throw DatabaseException("Create sync table failed: $e");
    }
  }

  Future<int> insertAction(String action, Map payload) async {
    final database = await db;

    try {
      return await database.insert("Sync_queue_table", {
        "action": action,
        "payload": jsonEncode(payload),
      });
    } catch (e) {
      throw DatabaseException("Insert sync action failed: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getPendingActions() async {
    final database = await db;

    try {
      return await database.query(
        "Sync_queue_table",
        where: "status = ?",
        whereArgs: ["pending"],
      );
    } catch (e) {
      throw DatabaseException("Fetch pending actions failed: $e");
    }
  }

  Future<void> updateSyncStatus(int id, String status) async {
    final database = await db;

    try {
      await database.update(
        "Sync_queue_table",
        {"status": status},
        where: "id = ?",
        whereArgs: [id],
      );
    } catch (e) {
      throw DatabaseException("Update sync status failed: $e");
    }
  }

  // ================= CLOSE =================

  Future<void> close() async {
    try {
      final database = await db;
      await database.close();
    } catch (e) {
      throw DatabaseException("Close DB failed: $e");
    }
  }
}