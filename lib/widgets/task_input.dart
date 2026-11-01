import 'package:flutter/material.dart';

class TaskInput extends StatefulWidget {
  final Function(String) onAdd;

  const TaskInput({
    super.key,
    required this.onAdd,
  });

  @override
  State<TaskInput> createState() => _TaskInputState();
}

class _TaskInputState extends State<TaskInput> {
  final TextEditingController controller = TextEditingController();

  void addTask() {
    String text = controller.text.trim();

    if (text.isEmpty) return;

    widget.onAdd(text);
    controller.clear();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Enter your task',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: addTask,
          child: const Text('Add'),
        ),
      ],
    );
  }
}