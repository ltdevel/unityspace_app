import 'dart:core';

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
