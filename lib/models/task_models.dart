import 'dart:core';

enum TaskChangesTypes {
  createTask(0),
  changeName(1),
  changeDescription(2),
  changeResponsible(3),
  changeStage(4),
  changeColor(5),
  changeStatus(6),
  changeDate(7),
  sendMessage(8),
  addTag(9),
  deleteTag(10),
  deleteTask(11),
  changeBlockReason(12),
  addCover(13),
  deleteCover(14),
  overdueTaskNoResponsible(15),
  overdueTaskWithResponsible(16),
  changeImportance(17),
  commit(18),
  addStage(19),
  deleteStage(20),
  removeMember(21),
  addResponsible(22),
  removeResponsible(23);

  final int value;

  const TaskChangesTypes(this.value);
}

class TaskHistory {
  final int id;
  final String? state;
  final int taskId;
  final TaskChangesTypes type;
  final String updateDate;
  final int userId;
  final String? projectName;
  final String? taskName;
  final String? commitName;

  TaskHistory({
    required this.id,
    required this.state,
    required this.taskId,
    required this.type,
    required this.updateDate,
    required this.userId,
    required this.projectName,
    required this.taskName,
    required this.commitName,
  });

  factory TaskHistory.fromResponse(TaskHistoryResponse response) {
    return TaskHistory(
      id: response.id,
      state: response.state,
      taskId: response.taskId,
      type: TaskChangesTypes.values
          .firstWhere((type) => type.value == response.type),
      updateDate: response.updateDate,
      userId: response.userId,
      projectName: response.projectName,
      taskName: response.taskName,
      commitName: response.commitName,
    );
  }
}

class MyTaskHistoryResponse {
  final int maxPageCount;
  final List<TaskHistoryResponse> history;
  MyTaskHistoryResponse({required this.maxPageCount, required this.history});

  factory MyTaskHistoryResponse.fromJson(Map<String, dynamic> map) {
    final historyList = map['history'] as List<dynamic>;

    return MyTaskHistoryResponse(
        maxPageCount: map['maxPageCount'] as int,
        history: historyList
            .map((history) => TaskHistoryResponse.fromJson(history))
            .toList());
  }
}

class TaskHistoryResponse {
  final int id;
  final String updateDate;
  final int taskId;
  final String? taskName;
  final int userId;
  final int type;
  final String? state;
  final String? projectName;
  final String? commitName;

  TaskHistoryResponse(
      {required this.id,
      required this.updateDate,
      required this.taskId,
      required this.taskName,
      required this.userId,
      required this.type,
      required this.state,
      required this.projectName,
      required this.commitName});

  factory TaskHistoryResponse.fromJson(Map<String, dynamic> map) {
    return TaskHistoryResponse(
      id: map['id'] as int,
      updateDate: map['updateDate'] as String,
      taskId: map['taskId'] as int,
      taskName: map['taskName'] as String?,
      userId: map['userId'] as int,
      type: map['type'] as int,
      state: map['state'] as String?,
      projectName: map['projectName'] as String?,
      commitName: map['commitName'] as String?,
    );
  }
}
