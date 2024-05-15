import 'dart:core';

import 'package:unityspace/models/i_base_model.dart';

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
  removeResponsible(23),
  defaultValue(-1),
  ;

  final int value;

  const TaskChangesTypes(this.value);
}

class Task implements BaseModel {
  @override
  final int id;
  final String name;
  final List<TaskStages> stages;
  final String? color;
  final String createdAt;
  final int creatorId;
  final List<int> tags;
  final List<int> responsibleUsersId;
  final bool hasMessages;
  final bool hasDescription;
  final int status;
  final String? dateBegin;
  final String? dateEnd;
  final String dateMove;
  final TaskImportance importance;
  final String? dateStatusChanged;
  final String? blockReason;
  final List<int> members;
  final TaskCover? cover;

  Task({
    required this.id,
    required this.name,
    required this.stages,
    required this.color,
    required this.createdAt,
    required this.creatorId,
    required this.tags,
    required this.responsibleUsersId,
    required this.hasMessages,
    required this.hasDescription,
    required this.status,
    required this.dateBegin,
    required this.dateEnd,
    required this.dateMove,
    required this.importance,
    required this.dateStatusChanged,
    required this.blockReason,
    required this.members,
    required this.cover,
  });

  factory Task.fromResponse(TaskResponse response) {
    return Task(
        id: response.id,
        name: response.name,
        stages: response.stages,
        color: response.color,
        createdAt: response.createdAt,
        creatorId: response.creatorId,
        tags: response.tags,
        responsibleUsersId: response.responsibleUserId,
        hasMessages: response.hasMessages,
        hasDescription: response.hasDescription,
        status: response.status,
        dateBegin: response.dateBegin,
        dateEnd: response.dateEnd,
        dateMove: response.dateMove ?? '',
        importance: response.importance,
        dateStatusChanged: response.dateStatusChanged,
        blockReason: response.blockReason,
        members: response.members,
        cover: response.cover);
  }
}

enum TaskImportance {
  high(1),
  normal(0),
  low(-1);

  final int value;

  const TaskImportance(this.value);
}

class TaskCover {
  final int id;
  final String dominantColor;
  final int height;
  final String pictureUid;
  final int taskId;
  final int width;
  final String? fullLink;

  TaskCover({
    required this.id,
    required this.dominantColor,
    required this.height,
    required this.pictureUid,
    required this.taskId,
    required this.width,
    required this.fullLink,
  });

  factory TaskCover.fromJson(Map<String, dynamic> json) {
    return TaskCover(
      id: json['id'] as int,
      dominantColor: json['dominantColor'] as String,
      height: json['height'] as int,
      pictureUid: json['pictureUid'] as String,
      taskId: json['taskId'] as int,
      width: json['width'] as int,
      fullLink: json['fullLink'] as String?,
    );
  }
}

class TaskStages {
  final int stageId;
  final int order;
  final int projectId;

  TaskStages({
    required this.stageId,
    required this.order,
    required this.projectId,
  });

  factory TaskStages.fromJson(Map<String, dynamic> json) {
    return TaskStages(
      stageId: json['stageId'] as int,
      order: int.parse(json['order'] as String),
      projectId: json['projectId'] as int,
    );
  }
}

class TaskResponse {
  final int id;
  final String name;
  final String? color;
  final List<TaskStages> stages;
  final TaskImportance importance;
  final String createdAt;
  final int creatorId;
  final List<int> tags;
  final List<int> responsibleUserId;
  final bool hasMessages;
  final bool hasDescription;
  final int status;
  final String? dateBegin;
  final String? dateEnd;
  final String? dateStatusChanged;
  final String? blockReason;
  final String? dateMove;
  final List<int> members;
  final TaskCover? cover;

  TaskResponse({
    required this.id,
    required this.name,
    required this.color,
    required this.stages,
    required this.importance,
    required this.createdAt,
    required this.creatorId,
    required this.tags,
    required this.responsibleUserId,
    required this.hasMessages,
    required this.hasDescription,
    required this.status,
    required this.dateBegin,
    required this.dateEnd,
    required this.dateStatusChanged,
    required this.blockReason,
    required this.dateMove,
    required this.members,
    required this.cover,
  });

  factory TaskResponse.fromJson(Map<String, dynamic> json) {
    return TaskResponse(
      id: json['id'] as int,
      name: json['name'] as String,
      color: json['color'] as String?,
      stages: (json['stages'] as List<dynamic>)
          .map((e) => TaskStages.fromJson(e as Map<String, dynamic>))
          .toList(),
      importance: TaskImportance.values.firstWhere(
          (type) => type.value == json['importance'] as int,
          orElse: () => TaskImportance.normal),
      createdAt: json['createdAt'] as String,
      creatorId: json['creatorId'] as int,
      tags: (json['tags'] as List<dynamic>).map((e) => e as int).toList(),
      responsibleUserId: (json['responsibleUserId'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
      hasMessages: json['hasMessages'] as bool,
      hasDescription: json['hasDescription'] as bool,
      status: json['status'] as int,
      dateBegin: json['dateBegin'] as String?,
      dateEnd: json['dateEnd'] as String?,
      dateStatusChanged: json['dateStatusChanged'] as String?,
      blockReason: json['blockReason'] as String?,
      dateMove: json['dateMove'] as String?,
      members: (json['members'] as List<dynamic>).map((e) => e as int).toList(),
      cover: json['cover'] != null
          ? TaskCover.fromJson(json['cover'] as Map<String, dynamic>)
          : null,
    );
  }
}

class TaskResponses {
  final List<TaskResponse> tasks;

  TaskResponses({
    required this.tasks,
  });

  factory TaskResponses.fromJson(List<dynamic> json) {
    return TaskResponses(
      tasks: json
          .map((e) => TaskResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class TaskHistory implements BaseModel {
  @override
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
      type: TaskChangesTypes.values.firstWhere(
          (type) => type.value == response.type,
          orElse: () => TaskChangesTypes.defaultValue),
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
  final List<TaskResponse> tasks;
  MyTaskHistoryResponse(
      {required this.maxPageCount, required this.history, required this.tasks});

  factory MyTaskHistoryResponse.fromJson(Map<String, dynamic> map) {
    final historyList = map['history'] as List<dynamic>;
    final tasksList = map['tasks'] as List<dynamic>;

    return MyTaskHistoryResponse(
        maxPageCount: map['maxPagesCount'] as int,
        history: historyList
            .map((history) => TaskHistoryResponse.fromJson(history))
            .toList(),
        tasks: tasksList.map((task) => TaskResponse.fromJson(task)).toList());
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

  factory TaskHistoryResponse.fromJson(Map<dynamic, dynamic> map) {
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
