import 'package:flutter/material.dart';
import 'package:unityspace/models/user_models.dart';
import 'package:unityspace/screens/widgets/user_avatar_widget.dart';
import 'package:unityspace/store/user_store.dart';
import 'package:unityspace/utils/wstore_plugin.dart';
import 'package:wstore/wstore.dart';

class AccountPageStore extends WStore {
  User? get currentUser => computedFromStore(
        store: UserStore(),
        getValue: (store) => store.user,
        keyName: 'currentUser',
      );

  int get currentUserId => computed<int>(
        getValue: () => currentUser?.id ?? 0,
        watch: () => [currentUser],
        keyName: 'currentUserId',
      );

  @override
  AccountPage get widget => super.widget as AccountPage;
}

class AccountPage extends WStoreWidget<AccountPageStore> {
  const AccountPage({
    super.key,
  });

  @override
  AccountPageStore createWStore() => AccountPageStore();

  @override
  Widget build(BuildContext context, AccountPageStore store) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          constraints: const BoxConstraints(maxWidth: 660),
          child: AccountContentWidget(
            avatar: AccountAvatarWidget(
              currentUserId: store.currentUserId,
              onChangeAvatar: () {},
              onClearAvatar: () {},
            ),
            children: const [
              Text('Имя'),
              Text('День рождения'),
              Text('Email'),
              Text('Телефон'),
              Text('Ссылка на профиль в Telegram'),
              Text('Ссылка на профиль в Github'),
              Text('Пароль'),
            ],
          ),
        ),
      ),
    );
  }
}

class AccountAvatarWidget extends StatelessWidget {
  final int currentUserId;
  final VoidCallback onChangeAvatar;
  final VoidCallback onClearAvatar;

  const AccountAvatarWidget({
    super.key,
    required this.currentUserId,
    required this.onChangeAvatar,
    required this.onClearAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UserAvatarWidget(
          id: currentUserId,
          width: 120,
          height: 120,
          fontSize: 48,
          radius: 16,
        ),
        const SizedBox(height: 4),
        MenuAnchor(
          menuChildren: [
            MenuItemButton(
              onPressed: onChangeAvatar,
              child: const Text('Обновить фото'),
            ),
            MenuItemButton(
              onPressed: onClearAvatar,
              child: const Text('Удалить фото'),
            ),
          ],
          builder: (context, controller, _) {
            return TextButton(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(const Size(120, 40)),
              ),
              onPressed: () {
                if (controller.isOpen) {
                  controller.close();
                } else {
                  controller.open();
                }
              },
              child: const Text('Изменить'),
            );
          },
        ),
      ],
    );
  }
}

class AccountContentWidget extends StatelessWidget {
  final Widget avatar;
  final List<Widget> children;

  const AccountContentWidget({
    super.key,
    required this.avatar,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 420) {
          return Column(
            children: [
              avatar,
              const SizedBox(height: 16),
              const Divider(
                height: 1,
                thickness: 1,
                color: Color(0xFFE5E7EB),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: Wrap(
                  spacing: 16,
                  direction: Axis.vertical,
                  clipBehavior: Clip.hardEdge,
                  children: children,
                ),
              ),
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            avatar,
            const SizedBox(width: 32),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 16),
                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Color(0xFFE5E7EB),
                    ),
                  ),
                ),
                child: Wrap(
                  spacing: 16,
                  direction: Axis.vertical,
                  clipBehavior: Clip.hardEdge,
                  children: children,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
