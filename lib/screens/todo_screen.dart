import 'package:flutter/material.dart';

import '../models/task.dart';
import '../services/storage_service.dart';
import '../widgets/task_input.dart';
import '../widgets/task_item.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<Task> tasks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    List<Task> savedTasks = await StorageService.loadTasks();

    setState(() {
      tasks = savedTasks;
      isLoading = false;
    });
  }

  Future<void> saveTasks() async {
    await StorageService.saveTasks(tasks);
  }

  void addTask(String title) {
    setState(() {
      tasks.add(
        Task(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          title: title,
        ),
      );
    });
    saveTasks();
  }

  void toggleTask(String id) {
    setState(() {
      for (Task task in tasks) {
        if (task.id == id) {
          task.isCompleted = !task.isCompleted;
          break;
        }
      }
    });
    saveTasks();
  }

  void deleteTask(String id) {
    setState(() {
      tasks.removeWhere((task) => task.id == id);
    });
    saveTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My To-Do List'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TaskInput(onAdd: addTask),
            const SizedBox(height: 20),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        Task task = tasks[index];

                        return TaskItem(
                          task: task,
                          onToggle: () => toggleTask(task.id),
                          onDelete: () => deleteTask(task.id),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}