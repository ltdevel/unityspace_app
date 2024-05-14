import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:unityspace/models/task_models.dart';
import 'package:unityspace/screens/account_screen/pages/actions_page/action_card.dart';
import 'package:unityspace/screens/account_screen/pages/actions_page/paddings.dart';
import 'package:unityspace/store/tasks_store.dart';
import 'package:unityspace/utils/helpers.dart';
import 'package:unityspace/utils/logger_plugin.dart';
import 'package:wstore/wstore.dart';
// import 'package:unityspace/utils/localization_helper.dart';

class ActionsPageStore extends WStore {
  WStoreStatus status = WStoreStatus.init;
  String error = '';
  int maxPagesCount = 1;
  int currentPage = 1;
  @override
  ActionsPage get widget => super.widget as ActionsPage;
  List<TaskHistory>? get history => computedFromStore(
        store: TasksStore(),
        getValue: (store) => store.history,
        keyName: 'history',
      );
  void nextPage() {
    if (currentPage < maxPagesCount) {
      setStore(() {
        currentPage += 1;
      });
      loadNextPage();
    }
  }

  void loadNextPage() {
    TasksStore().getTasksHistory(currentPage);
  }

  List<({String title, String taskName, String timeAgo, String date})>
      getActionPresentations(List<TaskHistory> history) {
    final List<({String title, String taskName, String timeAgo, String date})>
        actions = [];
    for (TaskHistory action in history) {
      final Task? task = TasksStore().getTaskById(action.taskId);
      if (task != null) {
        actions.add(_getActionView(action, task));
      }
    }

    return actions;
  }

  Future<void> loadData() async {
    if (status == WStoreStatus.loading) return;
    setStore(() {
      status = WStoreStatus.loading;
      error = '';
    });

    try {
      final int pages = await TasksStore().getTasksHistory(currentPage);
      setStore(() {
        maxPagesCount = pages;
        status = WStoreStatus.loaded;
      });
    } catch (e, stack) {
      logger.d('ActionsPageStore loadData error=$e\nstack=$stack');
      String errorText =
          'При загрузке данных возникла проблема, пожалуйста, попробуйте ещё раз';
      status = WStoreStatus.error;
      error = errorText;
    }
  }

  ({String title, String taskName, String timeAgo, String date}) _getActionView(
      TaskHistory history, Task task) {
    String title = taskChangesTypesToString(history, task);
    String taskName = 'Задача: ${history.taskName}';

    String time =
        '${timeAgo(history.updateDate)} ${timeFromDateString(history.updateDate)}';
    String date = formatDate(history.updateDate);

    return (title: title, taskName: taskName, timeAgo: time, date: date);
  }

  String taskChangesTypesToString(TaskHistory history, Task task) {
    final state = history.state;
    final type = history.type;
    switch (type) {
      case TaskChangesTypes.createTask:
        return 'Вы создали задачу';
      case TaskChangesTypes.changeDescription:
        return 'Вы изменили описание задачи';
      case TaskChangesTypes.changeName:
        return 'Вы изменили название задачи на ${task.name}';
      case TaskChangesTypes.changeBlockReason:
        if (state == null) {
          return 'Вы установили задаче статус "Требует внимания"';
        }
        return 'Вы сняли с задачи статус "Требует внимания"';
      case TaskChangesTypes.overdueTaskNoResponsible:
        return 'Задача просрочена и на ней нет исполнителя!';
      case TaskChangesTypes.overdueTaskWithResponsible:
        return 'Задача просрочена';
      case TaskChangesTypes.changeDate:
        if (state == null) {
          return 'Вы перенесли задачу на новую дату ${task.dateEnd}';
        }
        return 'Вы убрали дату у задачи ';
      case TaskChangesTypes.changeColor:
        if (state == null) {
          return 'Вы изменили цвет задачи на ${task.color}';
        }
        return 'Вы убрали цвет с задачи';
      case TaskChangesTypes.changeResponsible:
        if (state == null) {
          return 'Вы добавили исполнителя к задаче - ${task.responsibleUsersId}';
        }
        return 'Вы убрали исполнителя с задачи';
      case TaskChangesTypes.changeStatus:
        return 'Вы изменили статус задачи на ${task.status}';
      case TaskChangesTypes.changeStage:
        if (state == 'archive_tasks') {
          return 'Вы отправили задачу  в архив в проекте ';
        }

        return 'Вы переместили задачу в колонку "${state == null}" в проекте ${history.projectName}';
      case TaskChangesTypes.addTag:
        return 'Вы добавили к задаче  ярлык';
      case TaskChangesTypes.deleteTag:
        return 'Вы удалили у задачи ярлык';
      case TaskChangesTypes.sendMessage:
        return 'Вы оставили комментарий';
      case TaskChangesTypes.deleteTask:
        return 'Вы удалили задачу';
      case TaskChangesTypes.addCover:
        return 'Вы изменили обложку у задачи';
      case TaskChangesTypes.deleteCover:
        return 'Вы удалили обложку задачи ';
      case TaskChangesTypes.changeImportance:
        return 'Вы изменили важность задачи на ${state == null}';
      case TaskChangesTypes.commit:
        return 'Новый коммит по задаче: ${history.commitName}';
      default:
        return 'Такой тип истории не определен :( ${history.userId}';
    }
  }
}

class ActionsPage extends WStoreWidget<ActionsPageStore> {
  const ActionsPage({
    super.key,
  });

  @override
  ActionsPageStore createWStore() => ActionsPageStore()..loadData();

  @override
  Widget build(BuildContext context, ActionsPageStore store) {
    return PaddingHorizontal(
      12,
      child: Expanded(
        child: WStoreStatusBuilder(
          store: store,
          watch: (store) => store.status,
          builder: (context, _) {
            return const SizedBox.shrink();
          },
          builderLoaded: (context) {
            return const ActionsList();
          },
          builderLoading: (context) {
            return Center(
              child: Lottie.asset('assets/animations/main_loader.json',
                  width: 200, height: 200),
            );
          },
          builderError: (context) {
            return const Text('error');
          },
        ),
      ),
    );
  }
}

class ActionsList extends StatelessWidget {
  const ActionsList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollEndNotification>(
      onNotification: (notification) {
        if (notification.metrics.atEdge) {
          // if have scrolled to the bottom
          if (notification.metrics.pixels != 0) {
            context.wstore<ActionsPageStore>().nextPage();
          }
        }
        return true;
      },
      child: WStoreValueBuilder<ActionsPageStore, List<TaskHistory>>(
        watch: (store) => store.history ?? [],
        store: context.wstore<ActionsPageStore>(),
        builder: (context, history) {
          final actions = context
              .wstore<ActionsPageStore>()
              .getActionPresentations(history);
          return ListView.builder(
              itemCount: actions.length,
              itemBuilder: (context, index) {
                final action = actions[index];
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LayoutBuilder(builder: (context, _) {
                      if (index == 0 ||
                          (dateFromDateString(history[index].updateDate) !=
                              dateFromDateString(
                                  history[index - 1].updateDate))) {
                        return Column(
                          children: [
                            const PaddingTop(12),
                            Text(action.date),
                            const PaddingTop(12),
                          ],
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),
                    PaddingBottom(
                      12,
                      child: ActionCard(
                        title: action.title,
                        task: action.taskName,
                        time: action.timeAgo,
                      ),
                    ),
                  ],
                );
              });
        },
      ),
    );
  }
}
