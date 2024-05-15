import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:unityspace/models/task_models.dart';
import 'package:unityspace/screens/account_screen/pages/actions_page/widgets/action_card.dart';
import 'package:unityspace/screens/notifications_screen/utils/errors.dart';
import 'package:unityspace/screens/widgets/common/paddings.dart';
import 'package:unityspace/store/tasks_store.dart';
import 'package:unityspace/utils/helpers.dart';
import 'package:unityspace/utils/localization_helper.dart';
import 'package:unityspace/utils/logger_plugin.dart';
import 'package:wstore/wstore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:unityspace/utils/localization_helper.dart';

class ActionsPageStore extends WStore {
  WStoreStatus status = WStoreStatus.init;
  ActionsErrors error = ActionsErrors.none;
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

  Future<void> loadData() async {
    if (status == WStoreStatus.loading) return;
    setStore(() {
      status = WStoreStatus.loading;
      error = ActionsErrors.none;
    });

    try {
      final int pages = await TasksStore().getTasksHistory(currentPage);
      setStore(() {
        maxPagesCount = pages;
        status = WStoreStatus.loaded;
      });
    } catch (e, stack) {
      logger.d('on ActionsPage'
          'ActionsPage loadData error=$e\nstack=$stack');
      setStore(() {
        status = WStoreStatus.error;
        error = ActionsErrors.loadingDataError;
      });
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

  List<({String title, String taskName, String timeAgo, String date})>
      getActionPresentations(
          {required AppLocalizations localizations,
          required List<TaskHistory> history}) {
    final List<({String title, String taskName, String timeAgo, String date})>
        actions = [];
    for (TaskHistory action in history) {
      final Task? task = TasksStore().getTaskById(action.taskId);
      if (task != null) {
        actions.add(_getActionView(
            history: action, task: task, localizations: localizations));
      }
    }

    return actions;
  }

  ({String title, String taskName, String timeAgo, String date}) _getActionView(
      {required TaskHistory history,
      required Task task,
      required AppLocalizations localizations}) {
    String title = taskChangesTypesToString(
        history: history, task: task, localizations: localizations);
    String taskName = 'Задача: ${history.taskName}';

    String time =
        '${timeAgo(date: history.updateDate, localizations: localizations)} ${timeFromDateString(history.updateDate)}';
    String date = formatDate(
        dateString: history.updateDate, locale: localizations.localeName);

    return (title: title, taskName: taskName, timeAgo: time, date: date);
  }

  String taskChangesTypesToString(
      {required TaskHistory history,
      required Task task,
      required AppLocalizations localizations}) {
    final state = history.state;
    final type = history.type;
    switch (type) {
      case TaskChangesTypes.createTask:
        return localizations.createTask;
      case TaskChangesTypes.changeDescription:
        return localizations.changeDescription;
      case TaskChangesTypes.changeName:
        return localizations.changeName(task.name);
      case TaskChangesTypes.changeBlockReason:
        if (state == null) {
          return localizations.changeBlockReasonSet;
        }
        return localizations.changeBlockReasonRemoved;
      case TaskChangesTypes.overdueTaskNoResponsible:
        return localizations.overdueTaskNoResponsible;
      case TaskChangesTypes.overdueTaskWithResponsible:
        return localizations.overdueTaskWithResponsible;
      case TaskChangesTypes.changeDate:
        if (state == null) {
          return localizations.changeDateSet(task.dateEnd ?? '');
        }
        return localizations.changeDateRemoved;
      case TaskChangesTypes.changeColor:
        if (state == null) {
          return localizations.changeColorSet(task.color ?? '');
        }
        return localizations.changeColorRemoved;
      case TaskChangesTypes.changeResponsible:
        if (state == null) {
          return localizations.changeResponsibleSet(task.responsibleUsersId);
        }
        return localizations.changeResponsibleRemoved;
      case TaskChangesTypes.changeStatus:
        return localizations.changeStatus(task.status);
      case TaskChangesTypes.changeStage:
        if (state == 'archive_tasks') {
          return localizations.changeStageArchived(history.projectName ?? '');
        }
        return localizations.changeStageColumn(
            history.projectName ?? '', state ?? '');
      case TaskChangesTypes.addTag:
        return localizations.addTag;
      case TaskChangesTypes.deleteTag:
        return localizations.deleteTag;
      case TaskChangesTypes.sendMessage:
        return localizations.sendMessage;
      case TaskChangesTypes.deleteTask:
        return localizations.deleteTask;
      case TaskChangesTypes.addCover:
        return localizations.addCover;
      case TaskChangesTypes.deleteCover:
        return localizations.deleteCover;
      case TaskChangesTypes.changeImportance:
        return localizations.changeImportance(state ?? '');
      case TaskChangesTypes.commit:
        return localizations.commit(history.commitName ?? '');
      case TaskChangesTypes.defaultValue:
      default:
        return localizations.unhandledType(history.userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localization =
        LocalizationHelper.getLocalizations(context);
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
          final actions = getActionPresentations(
              history: history, localizations: localization);
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
