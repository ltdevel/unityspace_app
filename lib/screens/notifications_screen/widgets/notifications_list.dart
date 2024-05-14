import 'package:flutter/material.dart';
import 'package:unityspace/models/notification_models.dart';
import 'package:unityspace/utils/localization_helper.dart';

class NotificationsList extends StatelessWidget {
  final List<NotificationModel> items;
  final void Function(int index) onArchiveButtonTap;
  final void Function(int index) onOptionalButtonTap;
  const NotificationsList({
    super.key,
    required this.onArchiveButtonTap,
    required this.items,
    required this.onOptionalButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    final localization = LocalizationHelper.getLocalizations(context);
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        final item = items[index];
        return Card(
          color: Colors.white,
          child: ListTile(
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
