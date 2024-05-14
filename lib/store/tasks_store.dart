import 'dart:collection';

import 'package:unityspace/models/task_models.dart';
import 'package:wstore/wstore.dart';
import 'package:unityspace/service/task_service.dart' as api;

class TasksStore extends GStore {
  static TasksStore? _instance;

  factory TasksStore() => _instance ??= TasksStore._();

  TasksStore._();

  List<TaskHistory>? history;
  List<Task>? tasks;

  Future<int> getTasksHistory(int page) async {
    final response = await api.getMyTasksHistory(page);
    final maxPageCount = response.maxPageCount;
    _setHistory(response);
    _setTasks(response);
    return maxPageCount;
  }

  Task? getTaskById(int id) {
    return tasks?.firstWhere((element) => element.id == id);
  }

  void _setTasks(MyTaskHistoryResponse response) {
    final tasksResponse = response.tasks;
    final List<Task> tasksList =
        tasksResponse.map((res) => Task.fromResponse(res)).toList();
    HashMap<int, Task>? tasksMap = HashMap.fromIterable(
      tasksList,
      key: (element) => element.id,
      value: (element) => element,
    );

    setStore(() {
      if (tasksMap.isEmpty) {
        tasks = tasksList;
      } else {
        List<Task> updatedTasksList =
            _updateTasksListLocally(tasksList, tasksMap);
        tasks = updatedTasksList;
      }
    });
  }

  void _setHistory(MyTaskHistoryResponse response) {
    final historyResponse = response.history;
    final historyPage =
        historyResponse.map((res) => TaskHistory.fromResponse(res)).toList();
    HashMap<int, TaskHistory>? historyMap = HashMap.fromIterable(
      historyPage,
      key: (element) => element.id,
      value: (element) => element,
    );

    setStore(() {
      if (historyMap.isEmpty) {
        history = historyPage;
      } else {
        List<TaskHistory> updatedHistoryList =
            _updateHistoryListLocally(historyPage, historyMap);

        updatedHistoryList.sort((a, b) => a.updateDate.compareTo(b.updateDate));
        history = updatedHistoryList.reversed.toList();
      }
    });
  }

  List<TaskHistory> _updateHistoryListLocally(
      List<TaskHistory> historyPage, HashMap<int, TaskHistory> historyMap) {
    for (TaskHistory history in historyPage) {
      if (historyMap.containsKey(history.id)) {
        historyMap.update(history.id, (_) => history);
      } else {
        historyMap[history.id] = history;
      }
    }
    final List<TaskHistory> newHistory =
        historyMap.entries.map((element) => element.value).toList();
    return newHistory;
  }

  List<Task> _updateTasksListLocally(
      List<Task> tasks, HashMap<int, Task> tasksMap) {
    for (Task tasks in tasks) {
      if (tasksMap.containsKey(tasks.id)) {
        tasksMap.update(tasks.id, (_) => tasks);
      } else {
        tasksMap[tasks.id] = tasks;
      }
    }
    final List<Task> newTasks =
        tasksMap.entries.map((element) => element.value).toList();
    return newTasks;
  }

  @override
  void clear() {
    super.clear();
    setStore(() {
      history = null;
    });
  }
}
