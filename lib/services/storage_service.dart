import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class StorageService {
  static const String key = 'tasks';

  static Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();

    String data = jsonEncode(
      tasks.map((task) => task.toJson()).toList(),
    );

    await prefs.setString(key, data);
  }

  static Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();

    String? data = prefs.getString(key);

    if (data == null) {
      return [];
    }

    List<dynamic> decoded = jsonDecode(data);

    return decoded.map((item) {
      return Task.fromJson(item);
    }).toList();
  }
}