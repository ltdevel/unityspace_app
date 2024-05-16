import 'package:flutter/material.dart';

import 'package:unityspace/models/notification_models.dart';
import 'package:unityspace/screens/notifications_screen/utils/notification_helper.dart';
import 'package:unityspace/screens/widgets/user_avatar_widget.dart';
import 'package:unityspace/utils/helpers.dart';
import 'package:unityspace/utils/localization_helper.dart';

class NotificationsList extends StatelessWidget {
  final List<NotificationModel> items;
  final void Function(List<NotificationModel> list) onArchiveButtonTap;
  final void Function(List<NotificationModel> list) onOptionalButtonTap;
  NotificationsList({
    super.key,
    required this.onArchiveButtonTap,
    required this.items,
    required this.onOptionalButtonTap,
  });

  final notificationHelper = NotificationHelper();
  @override
  Widget build(BuildContext context) {
    final localization = LocalizationHelper.getLocalizations(context);
    final dayLists = notificationHelper.groupNotificationsByDay(items);
    return ListView.builder(
        itemCount: dayLists.length,
        itemBuilder: (BuildContext context, int index) {
          final dayList = dayLists[index];
          final typeLists = notificationHelper.groupNotificationsByParentType(
              notifications: dayList);
          return Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  timeAgo(
                      date: dayList.first.createdAt,
                      localizations: localization),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: typeLists.length,
                    itemBuilder: (BuildContext context, int index) {
                      final typeList = typeLists[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    onArchiveButtonTap(typeList);
                                  },
                                  child: Text(typeList
                                          .any((element) => element.archived)
                                      ? localization.restore_from_archive
                                      : localization.archive),
                                ),
                                InkWell(
                                  onTap: () {
                                    onOptionalButtonTap(typeList);
                                  },
                                  child: typeList
                                          .any((element) => element.archived)
                                      ? Text(localization.delete)
                                      : typeList
                                              .any((element) => element.unread)
                                          ? const Text(
                                              "прочитать",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            )
                                          : const Text(
                                              "прочитано",
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            ),
                                ),
                              ],
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: typeList.length,
                              itemBuilder: (BuildContext context, int index) {
                                final item = typeList[index];
                                final member =
                                    notificationHelper.findMemberById(
                                        notificationHelper
                                            .getOrganizationMembers(),
                                        item.initiatorId);
                                return Card(
                                  color: Colors.white,
                                  child: ListTile(
                                    leading: member != null
                                        ? UserAvatar(
                                            member: member,
                                            width: 30,
                                            height: 30,
                                            fontSize: 10)
                                        : null,
                                    title: Text(
                                      item.taskName ?? item.text,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Text(notificationHelper
                                        .notificationText(item)),
                                    trailing: Text(notificationHelper
                                        .extractTime(item.createdAt)),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    }),
              ],
            ),
          );
        });
  }
}
