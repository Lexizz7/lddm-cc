import 'dart:math';
import 'package:flutter/material.dart';
import 'package:app_tarefas/task_list.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'model/task.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de tarefas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Tarefas'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final nameController = TextEditingController();

  List<Task> tasks = [];

  bool initialized = false;

  _getDatabase() async {
    final path = await getDatabasesPath().then((res) => join(res, "tasks.db"));

    return openDatabase(path, version: 1, onCreate: (db, version) {
      String sql =
          "CREATE TABLE tasks (id INTEGER PRIMARY KEY AUTOINCREMENT, name VARCHAR, isDone INTEGER, date DATETIME) ";
      db.execute(sql);
    });
  }

  _getTasks() async {
    Database db = await _getDatabase();

    String sql = "SELECT * FROM tasks ORDER BY date DESC";
    List tasks = await db.rawQuery(sql);

    return tasks;
  }

  _addTask(Task task) async {
    Database db = await _getDatabase();

    Map<String, dynamic> data = {
      "name": task.name,
      "isDone": task.isDone ? 1 : 0,
      "date": task.date.toIso8601String()
    };

    int id = await db.insert("tasks", data);

    task.id = id.toString();

    _showSnackbar("Tarefa adicionada");

    setState(() {
      tasks.insert(0, task);
    });
  }

  _checkTask(Task task, bool value) async {
    Database db = await _getDatabase();

    Map<String, dynamic> data = {"isDone": value ? 1 : 0};

    await db.update("tasks", data, where: "id = ?", whereArgs: [task.id]);

    _showSnackbar(value ? "Tarefa concluída" : "Tarefa reaberta");

    setState(() {
      task.isDone = value;
    });
  }

  _removeTask(Task task) async {
    Database db = await _getDatabase();

    await db.delete("tasks", where: "id = ?", whereArgs: [task.id]);

    _showSnackbar("Tarefa removida");

    setState(() {
      tasks.remove(task);
    });
  }

  @override
  void initState() {
    super.initState();
    _getTasks().then((res) {
      setState(() {
        tasks = res
            .map<Task>((e) => Task(e["id"].toString(), e["name"],
                e["isDone"] == 1 ? true : false, DateTime.parse(e["date"])))
            .toList();

        initialized = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          elevation: 1,
          bottom: !initialized
              ? const PreferredSize(
                  preferredSize: Size.fromHeight(4.0),
                  child: LinearProgressIndicator(),
                )
              : null,
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          initialized
              ? TaskList(
                  tasks: tasks,
                  onCheck: _checkTask,
                  onDelete: _removeTask,
                )
              : Container()
        ]),
        floatingActionButton: initialized
            ? FloatingActionButton(
                onPressed: () {
                  _showDialog();
                },
                child: const Icon(Icons.add),
              )
            : null);
  }

  void _showDialog() {
    showDialog(
      context: this.context,
      builder: (BuildContext context) {
        String name = "";
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text("Nova tarefa"),
            content: TextField(
              controller: nameController,
              autofocus: true,
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: "Nome"),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                  nameController.clear();
                },
              ),
              TextButton(
                onPressed: name.isEmpty
                    ? null
                    : () {
                        if (nameController.text.isEmpty) return;
                        _addTask(Task(Random().nextInt(100).toString(),
                            nameController.text, false, DateTime.now()));
                        Navigator.of(context).pop();
                        nameController.clear();
                      },
                child: const Text('Inserir'),
              ),
            ],
          ),
        );
      },
    );
  }

  _showSnackbar(String text) {
    ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(
      content: Text(text),
      action: SnackBarAction(
        label: 'Fechar',
        onPressed: () {
          ScaffoldMessenger.of(this.context).hideCurrentSnackBar();
        },
      ),
      duration: const Duration(seconds: 1),
    ));
  }
}
