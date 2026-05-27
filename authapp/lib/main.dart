import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(const MyApp());
}

// 1. App Configuration
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const AuthPage(),
    );
  }
}

// 2. SQLite Database Helper
class DBHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    
    // Create or open the database file
    String path = join(await getDatabasesPath(), 'users.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, password TEXT)',
        );
      },
    );
    return _database!;
  }

  Future<void> registerUser(String username, String password) async {
    final db = await database;
    await db.insert('users', {'username': username, 'password': password});
  }

  Future<bool> userExists(String username) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return result.isNotEmpty;
  }

  Future<bool> loginUser(String username, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty; // Returns true if a match is found
  }
}

final dbHelper = DBHelper();

// 3. User Interface (Single Page for both Login & Signup)
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final userCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  
  bool isLoginMode = true; // Toggle between Login and Sign Up
  String message = "";

  void handleSubmit() async {
    String user = userCtrl.text.trim();
    String pass = passCtrl.text.trim();

    // 1. Basic Input Validation
    if (user.isEmpty || pass.isEmpty) {
      setState(() => message = "Please fill in all fields!");
      return;
    }

    if (isLoginMode) {
      // Handle Login
      bool success = await dbHelper.loginUser(user, pass);
      setState(() {
        message = success ? "Login Successful!" : "Invalid Credentials!";
      });
    } else {
      // 2. Password Length Validation
      if (pass.length < 6) {
        setState(() => message = "Password must be at least 6 characters.");
        return;
      }

      // 3. Database Verification (Does user already exist?)
      bool exists = await dbHelper.userExists(user);
      if (exists) {
        setState(() => message = "Username already exists!");
        return;
      }

      // Handle Sign Up
      await dbHelper.registerUser(user, pass);
      setState(() {
        message = "Account Created! You can now Login.";
        isLoginMode = true; // Switch back to login view automatically
        userCtrl.clear();   // Optional: clear fields after signup
        passCtrl.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLoginMode ? "Login" : "Sign Up")),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                isLoginMode ? Icons.lock_person : Icons.person_add_alt_1, 
                size: 80, 
                color: Theme.of(context).colorScheme.primary
              ),
              const SizedBox(height: 32),
              
              TextField(
                controller: userCtrl,
                decoration: const InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              
              TextField(
                controller: passCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 32),
              
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: handleSubmit,
                child: Text(
                  isLoginMode ? "Login" : "Sign Up", 
                  style: const TextStyle(fontSize: 16)
                ),
              ),
              const SizedBox(height: 16),
              
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: message.contains("!") && !message.contains("Invalid") ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              
              TextButton(
                onPressed: () {
                  setState(() {
                    isLoginMode = !isLoginMode; // Flip the mode
                    message = ""; // Clear errors
                  });
                },
                child: Text(isLoginMode ? "Don't have an account? Sign Up" : "Already have an account? Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}