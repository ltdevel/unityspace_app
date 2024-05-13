import 'dart:collection';

import 'package:unityspace/models/task_models.dart';
import 'package:wstore/wstore.dart';
import 'package:unityspace/service/task_service.dart' as api;

class TasksStore extends GStore {
  static TasksStore? _instance;

  factory TasksStore() => _instance ??= TasksStore._();

  TasksStore._();

  List<TaskHistory>? history;

  Future<int> getTasksHistory(int page) async {
    final response = await api.getMyTasksHistory(page);
    final maxPageCount = response.maxPageCount;
    final historyResponse = response.history;
    final historyPage =
        historyResponse.map((res) => TaskHistory.fromResponse(res)).toList();
    HashMap<int, TaskHistory>? historyMap = _historyToMap(history);

    setStore(() {
      if (historyMap == null || historyMap.isEmpty) {
        history = historyPage;
      } else {
        for (TaskHistory history in historyPage) {
          if (historyMap.containsKey(history.id)) {
            historyMap.update(history.id, (value) => history);
          } else {
            historyMap[history.id] = history;
          }
        }
        final List<TaskHistory> historyList =
            historyMap.entries.map((element) => element.value).toList();

        historyList.sort((a, b) => a.updateDate.compareTo(b.updateDate));
        history = historyList.reversed.toList();
      }
    });
    return maxPageCount;
  }

  HashMap<int, TaskHistory>? _historyToMap(List<TaskHistory>? history) {
    if (history != null && history.isNotEmpty) {
      return HashMap.fromIterable(
        history,
        key: (element) => element.id,
        value: (element) => element,
      );
    }
  }

  @override
  void clear() {
    super.clear();
    setStore(() {
      history = null;
    });
  }
}
