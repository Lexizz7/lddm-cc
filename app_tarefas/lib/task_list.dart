import 'package:flutter/material.dart';
import 'package:app_tarefas/model/task.dart';
import 'package:intl/intl.dart';

class TaskList extends StatelessWidget {
  const TaskList(
      {required this.tasks,
      required this.onCheck,
      required this.onDelete,
      super.key});

  final List<Task> tasks;
  final Function(Task, bool) onCheck;
  final Function(Task) onDelete;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: tasks.isNotEmpty
            ? ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (ctx, idx) => TaskCard(
                    task: tasks[idx], onCheck: onCheck, onDelete: onDelete),
                padding: const EdgeInsets.all(16),
              )
            : Center(
                child: Text("Nenhuma tarefa cadastrada",
                    style: TextStyle(fontSize: 20, color: Colors.grey[400]))));
  }
}

class TaskCard extends StatelessWidget {
  const TaskCard(
      {required this.task,
      required this.onCheck,
      required this.onDelete,
      super.key});

  final Task task;
  final Function(Task, bool) onCheck;
  final Function(Task) onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: task.isDone ? Colors.deepPurple[300] : null,
      child: ListTile(
        leading: Checkbox(
          value: task.isDone,
          onChanged: (value) {
            onCheck(task, value ?? false);
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        title: Text(
          task.name,
          style: task.isDone
              ? const TextStyle(decoration: TextDecoration.lineThrough)
              : null,
        ),
        subtitle: Text(DateFormat("dd/MM").format(task.date),
            style: task.isDone
                ? const TextStyle(decoration: TextDecoration.lineThrough)
                : null),
        trailing: IconButton(
            icon: const Icon(Icons.delete_rounded),
            onPressed: () {
              onDelete(task);
            },
            color: Colors.red[300]),
      ),
    );
  }
}
