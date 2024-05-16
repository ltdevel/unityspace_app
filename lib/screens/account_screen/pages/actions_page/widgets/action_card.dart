import 'package:flutter/material.dart';
import 'package:unityspace/models/task_models.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:unityspace/screens/widgets/common/paddings.dart';
import 'package:unityspace/utils/helpers.dart';
import 'package:unityspace/utils/localization_helper.dart';
import 'package:unityspace/utils/theme.dart';

class ActionCard extends StatelessWidget {
  const ActionCard({
    super.key,
    required this.data,
    required this.isSelected,
  });

  final bool isSelected;
  final ({TaskHistory history, String? taskName}) data;

  String getTaskNameString(({TaskHistory history, String? taskName}) data) {
    return data.taskName ?? data.history.taskName ?? '???';
  }

  String taskChangesTypesToString(
      {required ({TaskHistory history, String? taskName}) data,
      required AppLocalizations localizations}) {
    final history = data.history;
    final state = history.state;
    final type = history.type;
    final name = data.taskName ?? history.taskName;
    switch (type) {
      case TaskChangesTypes.createTask:
        return localizations.createTask;
      case TaskChangesTypes.changeDescription:
        return localizations.changeDescription;
      case TaskChangesTypes.changeName:
        return localizations.changeName(name ?? '');
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
          return localizations.changeDateSet(history.state ?? '');
        }
        return localizations.changeDateRemoved;
      case TaskChangesTypes.changeColor:
        if (state == null) {
          return localizations.changeColorSet(history.state ?? '');
        }
        return localizations.changeColorRemoved;
      case TaskChangesTypes.changeResponsible:
        if (state == null) {
          return localizations.changeResponsibleSet(history.state ?? '');
        }
        return localizations.changeResponsibleRemoved;
      case TaskChangesTypes.changeStatus:
        return localizations.changeStatus(history.state ?? '');
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
    final AppLocalizations localizations =
        LocalizationHelper.getLocalizations(context);
    return Container(
      decoration: BoxDecoration(
        color: ColorConstants.white,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: isSelected ? Border.all(color: ColorConstants.main01) : null,
      ),
      child: PaddingAll(
        12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    'Задача: ${getTaskNameString(data)}',
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.labelMedium!.copyWith(
                      color: ColorConstants.grey04,
                    ),
                  ),
                ),
                const PaddingLeft(12),
                Text(
                  timeFromDateString(data.history.updateDate),
                  style: textTheme.labelSmall!.copyWith(
                    color: ColorConstants.grey04,
                  ),
                ),
              ],
            ),
            const PaddingTop(8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 57),
              child: Flexible(
                  child: Text(
                taskChangesTypesToString(
                    data: data, localizations: localizations),
                style: textTheme.headlineSmall!
                    .copyWith(color: ColorConstants.grey03),
              )),
            )
          ],
        ),
      ),
    );
  }
}
