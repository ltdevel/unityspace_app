import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
            children: [
              AccountItemWidget(
                text: 'Имя',
                value:
                    'Дмитрий Маслов Дмитрий Маслов Дмитрий Маслов Дмитрий Маслов',
                iconAssetName: 'assets/icons/account_name.svg',
                onTapChange: () {},
              ),
              const Text('День рождения'),
              const Text('Email'),
              const Text('Телефон'),
              const Text('Ссылка на профиль в Telegram'),
              const Text('Ссылка на профиль в Github'),
              const Text('Пароль'),
            ],
          ),
        ),
      ),
    );
  }
}

class AccountItemWidget extends StatelessWidget {
  final String text;
  final String value;
  final String iconAssetName;
  final VoidCallback onTapChange;

  const AccountItemWidget({
    super.key,
    required this.text,
    required this.value,
    required this.iconAssetName,
    required this.onTapChange,
  });

  @override
  Widget build(BuildContext context) {
    const titleColor = Color(0x99111012);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              iconAssetName,
              width: 18,
              height: 18,
              theme: const SvgTheme(currentColor: titleColor),
            ),
            const SizedBox(width: 4),
            Text(
              text,
              style: const TextStyle(
                color: titleColor,
                fontSize: 16,
              ),
              maxLines: 1,
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  color: Color(0xCC111012),
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            TextButton(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(const Size(40, 40)),
              ),
              onPressed: onTapChange,
              child: const Text('Изменить'),
            ),
          ],
        ),
      ],
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
              ...children.expand(
                (child) => [
                  const SizedBox(height: 16),
                  child,
                ],
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
