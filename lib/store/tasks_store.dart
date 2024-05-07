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
    final history =
        historyResponse.map((res) => TaskHistory.fromResponse(res)).toList();
    setStore(() {
      this.history = history;
    });
    return maxPageCount;
  }

  @override
  void clear() {
    super.clear();
    setStore(() {
      history = null;
    });
  }
}
