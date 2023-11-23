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
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
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
                value: 'Дмитрий Маслов',
                iconAssetName: 'assets/icons/account_name.svg',
                onTapChange: () {},
              ),
              AccountItemWidget(
                text: 'День рождения',
                value: 'Не указано',
                iconAssetName: 'assets/icons/account_birthday.svg',
                onTapChange: () {},
              ),
              AccountItemWidget(
                text: 'Email',
                value: 'dmitry.maslov.home@gmail.com',
                iconAssetName: 'assets/icons/account_email.svg',
                onTapChange: () {},
              ),
              AccountItemWidget(
                text: 'Телефон',
                value: 'Не указано',
                iconAssetName: 'assets/icons/account_phone.svg',
                onTapChange: () {},
              ),
              AccountItemWidget(
                text: 'Профиль в Telegram',
                value: 'https://t.me/ivanov_ivan',
                iconAssetName: 'assets/icons/account_telegram.svg',
                onTapChange: () {},
              ),
              AccountItemWidget(
                text: 'Профиль в Github',
                value: 'https://github.com/devmaslove',
                iconAssetName: 'assets/icons/account_github.svg',
                onTapChange: () {},
              ),
              AccountItemWidget(
                text: 'Пароль',
                value: '********',
                iconAssetName: 'assets/icons/account_password.svg',
                onTapChange: () {},
              ),
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
  final VoidCallback? onTapValue;
  final VoidCallback? onLongTapValue;

  const AccountItemWidget({
    super.key,
    required this.text,
    required this.value,
    required this.iconAssetName,
    required this.onTapChange,
    this.onTapValue,
    this.onLongTapValue,
  });

  @override
  Widget build(BuildContext context) {
    const titleColor = Color(0x99111012);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const SizedBox(width: 12),
            SvgPicture.asset(
              iconAssetName,
              width: 18,
              height: 18,
              theme: const SvgTheme(currentColor: titleColor),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color: titleColor,
                  fontSize: 16,
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
        TextButton(
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(
              const Size(double.infinity, 40),
            ),
            padding: MaterialStateProperty.all<EdgeInsets>(
              const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            ),
            alignment: Alignment.centerLeft,
          ),
          onPressed: onTapValue,
          onLongPress: onLongTapValue,
          child: FittedBox(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xCC111012),
                fontSize: 20,
                fontWeight: FontWeight.w500,
                height: 32 / 20,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
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
        if (constraints.maxWidth < 496) {
          return Column(
            children: [
              avatar,
              const SizedBox(height: 16),
              const Divider(
                height: 1,
                thickness: 1,
                color: Color(0xFFE5E7EB),
                indent: 12,
                endIndent: 12,
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
            const SizedBox(width: 12),
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
                child: Column(
                  children: [
                    if (children.isNotEmpty)
                      ...children
                          .expand(
                            (child) => [
                              child,
                              const SizedBox(height: 16),
                            ],
                          )
                          .take(children.length * 2 - 1),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
