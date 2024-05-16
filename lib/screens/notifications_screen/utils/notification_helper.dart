import 'package:collection/collection.dart';
import 'package:unityspace/models/notification_models.dart';
import 'package:unityspace/models/user_models.dart';
import 'package:unityspace/store/user_store.dart';
import 'package:unityspace/utils/logger_plugin.dart';

class NotificationHelper {
  UserStore userStore = UserStore();
  String notificationText(NotificationModel notification) {
    List<OrganizationMember> organizationMembers =
        userStore.organization?.members ?? [];
    try {
      if (notification.notificationType == 'REGLAMENT_CREATED') {
        return 'Создал(а) регламент';
      }
      if (notification.notificationType == 'REGLAMENT_REQUIRED_SET') {
        return 'Отметил(а) регламент как обязательный';
      }
      if (notification.notificationType == 'REGLAMENT_REQUIRED_UNSET') {
        return 'Отметил(а) регламент как необязательный';
      }
      if (notification.notificationType == "REGLAMENT_UPDATE") {
        const message =
            'Обновил(а) регламент и сбросил(а) участников, прошедших регламент';
        return notification.text.isNotEmpty
            ? '$message\r\n"${notification.text}"'
            : message;
      }
      if (notification.notificationType == 'MESSAGE') {
        // убираем кавычки в начале и в конце
        // заменяем упоминания на осмысленный текст
        String message = notification.text
            .substring(1, notification.text.length - 1)
            .replaceAllMapped(RegExp(r'(?:^@|(?<=\s)@)\S+\w'), (match) {
          switch (match.group(0)) {
            case '@all':
              return '@Всем';
            case '@performer':
              return '@Исполнитель';
            default:
              String? email = match.group(0)?.substring(1);
              final membersMap = organizationMembersByEmailMap(userStore);
              String? name = membersMap[email]?.name ?? email;
              return '@$name';
          }
        });
        return '"$message"';
      }
      if (notification.notificationType == "TASK_CHANGED_RESPONSIBLE") {
        if (notification.text.startsWith('add responsible ')) {
          int userId =
              int.parse(notification.text.substring('add responsible '.length));
          final member = findMemberById(organizationMembers, userId);
          return 'Установил(а) исполнителя: $member';
        }
        if (notification.text.startsWith('change responsible ')) {
          int userId = int.parse(
              notification.text.substring('change responsible '.length));
          final member = findMemberById(organizationMembers, userId);
          return 'Сменил(а) исполнителя на: $member';
        }
        return ('Сменил(а) исполнителя на: ${notification.text.substring('Новый исполнитель '.length)}');
      }
      if (notification.notificationType == 'TASK_DELETED_RESPONSIBLE') {
        final userId = int.tryParse(notification.text);

        if (userId != null) {
          final member = findMemberById(organizationMembers, userId);
          return 'Снял(а) исполнителя: ${member?.name ?? ''}';
        }
        return 'Снял(а) исполнителя';
      }
      if (notification.notificationType == 'TASK_COMPLETED') {
        return 'Завершил(а) задачу';
      }
      if (notification.notificationType == 'TASK_REJECTED') {
        return 'Отменил(а) задачу';
      }
      if (notification.notificationType == 'TASK_IN_WORK') {
        return 'Вернул(а) задачу в работу';
      }
      if (notification.notificationType == 'TASK_PROJECT_CHANGED') {
        return 'Перенес(ла) задачу в проект: ${notification.text}';
      }
      if (notification.notificationType == 'TASK_DELEGATED') {
        return 'Поручил(а) Вам задачу';
      }
      if (notification.notificationType == 'MEMBER_DELETED') {
        return 'Убрал(а) Вам доступ к пространству';
      }

      if (notification.notificationType == 'MEMBER_DELETED_FOR_OWNER') {
        if (notification.parentId == notification.initiatorId) {
          return 'Вышел(а) из пространства';
        }
        final member =
            findMemberById(organizationMembers, notification.parentId);
        final memberName = member?.name;

        return 'Исключил(а) пользователя \'$memberName\' из пространства';
      }

      if (notification.notificationType == 'MEMBER_ADDED' &&
          !isUserOrganizationOwner(user: userStore.user)) {
        return 'Добавил(а) Вас в пространство';
      }

      if (notification.notificationType == 'MEMBER_ACCEPT_INVITE') {
        return 'Принял(а) приглашение в пространство';
      }

      if (notification.notificationType == 'MEMBER_ADDED_FROM_SPACE_LINK') {
        return 'Вступил(а) в пространство по ссылке';
      }

      if (notification.notificationType == 'MEMBER_ADDED_FOR_OWNER') {
        final member =
            findMemberById(organizationMembers, notification.parentId);
        final memberName = member?.name;
        return 'Добавил(а) пользователя \'$memberName\' в пространство';
      }

      if (notification.notificationType == 'TASK_DELETED') {
        return 'Удалил(а) задачу';
      }

      if (notification.notificationType == 'TASK_SEND_TO_ARCHIVE') {
        return 'Отправил(а) задачу в архив';
      }

      if (notification.notificationType == 'TASK_MEMBER_REMOVED') {
        return 'Удалил(а) Вас из участников задачи';
      }

      return notification.text;
    } catch (e, stack) {
      logger.d(e, stackTrace: stack);
      throw Exception(e);
    }
  }

  bool isUserOrganizationOwner({required User? user}) {
    return user?.id == userStore.organization?.ownerId;
  }

  OrganizationMember? findMemberById(List<OrganizationMember> members, int id) {
    return members.firstWhereOrNull((member) => member.id == id);
  }

  Map<String, OrganizationMember?> organizationMembersByEmailMap(state) {
    if (state.organization.members == null) {
      return {};
    }
    return state.organization.members!
        .fold<Map<String, OrganizationMember?>>({}, (acc, member) {
      acc[member.email] = member;
      return acc;
    });
  }

  List<List<NotificationModel>> groupNotificationsByDay(
      List<NotificationModel> notifications) {
    // Создание мапы для группировки уведомлений по дате
    Map<String, List<NotificationModel>> groupedNotifications = {};

    // Группировка уведомлений по дате
    for (var notification in notifications) {
      String dateString = notification.createdAt.toString().split('T').first;
      if (!groupedNotifications.containsKey(dateString)) {
        groupedNotifications[dateString] = [];
      }
      groupedNotifications[dateString]!.add(notification);
    }
    List<String> sortedKeys = groupedNotifications.keys.toList();
    // Создание списка уведомлений для каждого дня
    List<List<NotificationModel>> groupedByDay = [];
    for (var key in sortedKeys) {
      groupedByDay.add(groupedNotifications[key]!);
    }

    return groupedByDay;
  }

  List<List<NotificationModel>> groupNotificationsByParentType(
      {required List<NotificationModel> notifications}) {
    // Группируем уведомления по parentType
    var groupedNotifications = groupBy(notifications,
        (NotificationModel notification) => notification.parentType);

    // Преобразуем группы в список списков
    var result = groupedNotifications.values.toList();

    return result;
  }

  List<OrganizationMember> getOrganizationMembers() {
    return userStore.organization?.members ?? [];
  }

  String extractTime(String dateTimeString) {
    var parts = dateTimeString.split('T')[1].split(':');
    var hours = parts[0];
    var minutes = parts[1];
    return '$hours:$minutes';
  }
}
