import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';
import '../widgets/tasks_tile.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<Task> tasks = [];
  late SharedPreferences sharedPreferences;
  String newTaskTitle = '';

  @override
  void initState() {
    loadSharedPreferencesAndData();
    super.initState();
  }

  void loadSharedPreferencesAndData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.26,
                    color: const Color(0xFF757575),
                    child: Container(
                      padding: const EdgeInsets.only(
                          top: 20, left: 30, right: 30, bottom: 30),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20),
                          )),
                      child: Column(
                        children: [
                          const Text(
                            'Add Task',
                            style: TextStyle(
                              color: Colors.lightBlueAccent,
                              fontSize: 30,
                            ),
                          ),
                          TextField(
                            autofocus: true,
                            textAlign: TextAlign.center,
                            onChanged: (newText) {
                              newTaskTitle = newText;
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextButton(
                            onPressed: () {
                              addTask(newTaskTitle);
                              saveData();
                              loadData();
                              Navigator.pop(context);
                            },
                            child: Container(
                              color: Colors.lightBlueAccent,
                              width: double.infinity,
                              height: 50,
                              child: const Center(
                                child: Text(
                                  'Add',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )),
            ),
          );
        },
        backgroundColor: Colors.lightBlueAccent,
        child: const Icon(Icons.add),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.only(top: 60, left: 30, right: 30, bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  child: Icon(
                    Icons.list,
                    size: 30,
                    color: Colors.lightBlueAccent,
                  ),
                  backgroundColor: Colors.white,
                  radius: 30,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Todoey',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    '${tasks.length} Tasks',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              height: 500,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return TaskTile(
                    taskTitle: task.name,
                    isChecked: task.isDone,
                    checkboxCallback: (checkboxState) {
                      updateTask(task);
                      saveData();
                      loadData();
                    },
                    longPressCallback: () {
                      deleteTask(task);
                      saveData();
                      loadData();
                    },
                  );
                },
                itemCount: tasks.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void addTask(String newTaskTitle) {
    final task = Task(name: newTaskTitle, isDone: false);
    tasks.add(task);
  }

  void updateTask(Task task) {
    task.toggleDone();
  }

  void deleteTask(Task task) {
    tasks.remove(task);
  }

  void loadData() {
    List<String>? listString = sharedPreferences.getStringList('task');
    setState(() {
      if (listString != null) {
        tasks =
            listString.map((item) => Task.fromMap(json.decode(item))).toList();
      }
    });
  }

  void saveData() {
    List<String> stringList =
        tasks.map((item) => json.encode(item.toMap())).toList();
    sharedPreferences.setStringList('task', stringList);
  }
}
