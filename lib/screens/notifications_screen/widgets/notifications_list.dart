import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'package:unityspace/models/notification_models.dart';
import 'package:unityspace/models/user_models.dart';
import 'package:unityspace/screens/widgets/user_avatar_widget.dart';
import 'package:unityspace/utils/localization_helper.dart';

class NotificationsList extends StatelessWidget {
  final List<OrganizationMember> organizationMembers;
  final List<NotificationModel> items;
  final void Function(int index) onArchiveButtonTap;
  final void Function(int index) onOptionalButtonTap;
  const NotificationsList({
    super.key,
    required this.onArchiveButtonTap,
    required this.items,
    required this.onOptionalButtonTap,
    required this.organizationMembers,
  });

  @override
  Widget build(BuildContext context) {
    final localization = LocalizationHelper.getLocalizations(context);
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        final item = items[index];
        final member = findMemberById(organizationMembers, item.initiatorId);
        return Card(
          color: Colors.white,
          child: ListTile(
            leading: UserAvatarWidget(
                id: member?.id ?? 0, width: 20, height: 20, fontSize: 15),
            title: Text(item.taskName ?? ''),
            subtitle: Text(item.text),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    onArchiveButtonTap(index);
                  },
                  child: Text(item.archived
                      ? localization.restore_from_archive
                      : localization.archive),
                ),
                InkWell(
                  onTap: () {
                    onOptionalButtonTap(index);
                  },
                  child: item.archived
                      ? Text(localization.delete)
                      : item.unread
                          ? const Text(
                              "прочитать",
                              style: TextStyle(color: Colors.red),
                            )
                          : const Text(
                              "прочитано",
                              style: TextStyle(color: Colors.blue),
                            ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Поиск Member по id
OrganizationMember? findMemberById(List<OrganizationMember> members, int id) {
  return members.firstWhereOrNull((member) => member.id == id);
}
