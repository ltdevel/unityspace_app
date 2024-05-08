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
  @override
  ActionsPage get widget => super.widget as ActionsPage;

  List<TaskHistory>? get history => computedFromStore(
        store: TasksStore(),
        getValue: (store) => store.history,
        keyName: 'history',
      );

  void loadData() {
    if (status == WStoreStatus.loading) return;
    setStore(() {
      status = WStoreStatus.loading;
      error = '';
    });

    subscribe(
        future: TasksStore().getTasksHistory(1),
        subscriptionId: 1,
        onData: (value) {
          maxPagesCount = value;
          setStore(() {
            status = WStoreStatus.loaded;
          });
        },
        onError: (e, stack) {
          logger.d('ActionsPageStore loadData error=$e\nstack=$stack');
          String errorText =
              'При загрузке данных возникла проблема, пожалуйста, попробуйте ещё раз';
          status = WStoreStatus.error;
          error = errorText;
        });
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
    final colorScheme = Theme.of(context).colorScheme;
    return PaddingHorizontal(
      12,
      child: Expanded(
        child: WStoreStatusBuilder(
          store: store,
          watch: (store) => store.status,
          builder: (context, _) {
            return const SizedBox.shrink();
          },
          onStatusLoaded: (context) {},
          builderLoaded: (context) {
            print("HISTORY: ${store.history}");
            return ActionsList(actions: store.history);
            // return SizedBox(
            //   height: 400,
            //   child: ListView.builder(
            //     itemCount: store.history?.length,
            //     itemBuilder: (BuildContext context, int index) {
            //       return ActionsList(actions: store.history);
            //     },
            //   ),
            // );
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
          // child: Placeholder(

          // ),
        ),
      ),
    );
  }
}

class ActionsList extends StatelessWidget {
  const ActionsList({
    super.key,
    required this.actions,
  });

  final List<TaskHistory>? actions;

  @override
  Widget build(BuildContext context) {
    return actions != null
        ? CustomScrollView(
            slivers: [
              SliverList.builder(
                  itemCount: actions!.length,
                  itemBuilder: (context, index) {
                    final TaskHistory action = actions![index];
                    final dateTime = action.updateDate;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LayoutBuilder(builder: (context, _) {
                          if (index == 0 ||
                              (dateFromDateString(action.updateDate) !=
                                  dateFromDateString(
                                      actions![index - 1].updateDate))) {
                            return Column(
                              children: [
                                const PaddingTop(12),
                                Text(action.updateDate),
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
                            title: action.type.toString(),
                            task: 'Задача: ${action.taskName}',
                            time:
                                '${timeAgo(dateTime)} ${timeFromDateString(dateTime)}',
                            // isSelected: true,
                          ),
                        ),
                      ],
                    );
                  }),
            ],
          )
        : const SizedBox.shrink();
  }
}
