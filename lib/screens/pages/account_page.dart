import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:unityspace/models/user_models.dart';
import 'package:unityspace/screens/crop_image_screen.dart';
import 'package:unityspace/screens/dialogs/user_change_birthday_dialog.dart';
import 'package:unityspace/screens/dialogs/user_change_githublink_dialog.dart';
import 'package:unityspace/screens/dialogs/user_change_job_dialog.dart';
import 'package:unityspace/screens/dialogs/user_change_name_dialog.dart';
import 'package:unityspace/screens/dialogs/user_change_password_dialog.dart';
import 'package:unityspace/screens/dialogs/user_change_phone_dialog.dart';
import 'package:unityspace/screens/dialogs/user_change_tg_link_dialog.dart';
import 'package:unityspace/screens/widgets/user_avatar_widget.dart';
import 'package:unityspace/store/user_store.dart';
import 'package:unityspace/utils/logger_plugin.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wstore/wstore.dart';

class AccountPageStore extends WStore {
  String imageFilePath = '';
  String message = '';
  WStoreStatus statusAvatar = WStoreStatus.init;

  User? get currentUser => computedFromStore(
        store: UserStore(),
        getValue: (store) => store.user,
        keyName: 'currentUser',
      );

  int get currentUserId => computed(
        getValue: () => currentUser?.id ?? 0,
        watch: () => [currentUser],
        keyName: 'currentUserId',
      );

  bool get currentUserHasAvatar => computed(
        getValue: () => currentUser?.avatarLink != null,
        watch: () => [currentUser],
        keyName: 'currentUserHasAvatar',
      );

  String get currentUserName => computed(
        getValue: () => currentUser?.name ?? '',
        watch: () => [currentUser],
        keyName: 'currentUserName',
      );

  String get currentUserBirthday => computed(
        getValue: () {
          final birthDate = currentUser?.birthDate;
          if (birthDate == null) return '';
          return DateFormat('dd MMMM yyyy', 'ru_RU').format(birthDate);
        },
        watch: () => [currentUser],
        keyName: 'currentUserBirthday',
      );

  String get currentUserEmail => computed(
        getValue: () => currentUser?.email ?? '',
        watch: () => [currentUser],
        keyName: 'currentUserEmail',
      );

  String get currentUserPhone => computed(
        getValue: () => currentUser?.phoneNumber ?? '',
        watch: () => [currentUser],
        keyName: 'currentUserPhone',
      );

  String get currentUserJobTitle => computed(
    getValue: () => currentUser?.jobTitle ?? '',
    watch: () => [currentUser],
    keyName: 'currentUserJobTitle',
  );

  String get currentUserTelegram => computed(
        getValue: () => currentUser?.telegramLink ?? '',
        watch: () => [currentUser],
        keyName: 'currentUserTelegram',
      );

  String get currentUserGithub => computed(
        getValue: () => currentUser?.githubLink ?? '',
        watch: () => [currentUser],
        keyName: 'currentUserGithub',
      );

  void clearAvatar() {
    if (statusAvatar == WStoreStatus.loading) return;
    //
    setStore(() {
      statusAvatar = WStoreStatus.loading;
    });
    //
    listenFuture(
      UserStore().removeUserAvatar(),
      id: 3,
      onData: (_) {
        setStore(() {
          statusAvatar = WStoreStatus.loaded;
        });
      },
      onError: (error, stack) {
        logger.e('removeUserAvatar error', error: error, stackTrace: stack);
        setStore(() {
          statusAvatar = WStoreStatus.error;
          message =
              'При удалении аватара возникла проблема, пожалуйста, попробуйте ещё раз';
        });
      },
    );
  }

  void setAvatar(Uint8List avatarImage) {
    if (statusAvatar == WStoreStatus.loading) return;
    //
    setStore(() {
      statusAvatar = WStoreStatus.loading;
    });
    //
    listenFuture(
      UserStore().setUserAvatar(avatarImage),
      id: 5,
      onData: (_) {
        setStore(() {
          statusAvatar = WStoreStatus.loaded;
        });
      },
      onError: (error, stack) {
        logger.e('setUserAvatar error', error: error, stackTrace: stack);
        setStore(() {
          statusAvatar = WStoreStatus.error;
          message =
              'При загрузке аватара возникла проблема, пожалуйста, попробуйте ещё раз';
        });
      },
    );
  }

  void copy(final String text, final String successMessage) {
    listenFuture(
      _copyToClipboard(text),
      id: 1,
      onData: (_) {
        setStore(() {
          message = successMessage;
        });
      },
      onError: (error, stack) {
        logger.e('copyToClipboard error', error: error, stackTrace: stack);
        setStore(() {
          message = 'Не удалось скопировать данные';
        });
      },
    );
  }

  void open(final String link) {
    listenFuture(
      _gotoLink(link),
      id: 2,
      onData: (_) {},
      onError: (error, stack) {
        logger.e('gotoLink error', error: error, stackTrace: stack);
        setStore(() {
          message = 'Не удалось открыть ссылку';
        });
      },
    );
  }

  Future<void> _copyToClipboard(final String text) async {
    if (text.isEmpty) throw 'Empty text';
    final data = ClipboardData(text: text);
    await Clipboard.setData(data);
  }

  Future<void> _gotoLink(final String link) async {
    if (link.isEmpty) throw 'Empty link';
    final url = Uri.parse(link);
    bool result = await launchUrl(url, mode: LaunchMode.externalApplication);
    if (!result) throw 'Could not launch $link';
  }

  void pickAvatar() async {
    setStore(() {
      statusAvatar = WStoreStatus.loading;
    });
    listenFuture(
      _pickImage(),
      id: 4,
      onData: (filePath) {
        setStore(() {
          if (filePath != null) {
            imageFilePath = filePath;
          }
          statusAvatar = WStoreStatus.loaded;
        });
      },
      onError: (error, stack) {
        logger.e('pickAvatar error', error: error, stackTrace: stack);
        setStore(() {
          statusAvatar = WStoreStatus.error;
          message =
              'При выборе из галереи возникла проблема, пожалуйста, попробуйте ещё раз';
        });
      },
    );
  }

  Future<String?> _pickImage() async {
    final xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    return xFile?.path;
  }

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
    return WStoreStringListener(
      store: store,
      watch: (store) => store.message,
      reset: (store) => store.message = '',
      onNotEmpty: (context, message) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
          ),
        );
      },
      child: SingleChildScrollView(
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
              avatar: WStoreStringListener(
                store: store,
                watch: (store) => store.imageFilePath,
                reset: (store) => store.imageFilePath = '',
                onNotEmpty: (context, imageFilePath) async {
                  Uint8List? avatarImage =
                      await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CropImageScreen(
                                imageFilePath: imageFilePath,
                              )));
                  if (avatarImage != null) {
                    store.setAvatar(avatarImage);
                  }
                },
                child: WStoreValueBuilder(
                  store: store,
                  watch: (store) => store.currentUserHasAvatar,
                  builder: (context, hasAvatar) => AccountAvatarWidget(
                    hasAvatar: hasAvatar,
                    onChangeAvatar: () {
                      store.pickAvatar();
                    },
                    onClearAvatar: () {
                      store.clearAvatar();
                    },
                  ),
                ),
              ),
              children: [
                WStoreValueBuilder(
                  store: store,
                  watch: (store) => store.currentUserName,
                  builder: (context, name) => AccountItemWidget(
                    text: 'Имя',
                    value: name.isNotEmpty ? name : 'Не указано',
                    iconAssetName: 'assets/icons/account_name.svg',
                    onTapChange: () {
                      showUserChangeNameDialog(context, name);
                    },
                    onTapValue: name.isNotEmpty
                        ? () => store.copy(
                              name,
                              'Имя скопировано в буфер обмена',
                            )
                        : null,
                  ),
                ),
                WStoreValueBuilder(
                  store: store,
                  watch: (store) => store.currentUserBirthday,
                  builder: (context, birthday) => AccountItemWidget(
                    text: 'День рождения',
                    value: birthday.isNotEmpty ? birthday : 'Не указано',
                    iconAssetName: 'assets/icons/account_birthday.svg',
                    onTapChange: () {
                      showUserChangeBirthdayDialog(
                        context,
                        store.currentUser?.birthDate,
                      );
                    },
                    onTapValue: birthday.isNotEmpty
                        ? () => store.copy(
                              birthday,
                              'Дата рождения скопирована в буфер обмена',
                            )
                        : null,
                  ),
                ),
                WStoreValueBuilder(
                  store: store,
                  watch: (store) => store.currentUserEmail,
                  builder: (context, email) => AccountItemWidget(
                    text: 'Email',
                    value: email.isNotEmpty ? email : 'Не указано',
                    iconAssetName: 'assets/icons/account_email.svg',
                    onTapChange: () {},
                    onTapValue: email.isNotEmpty
                        ? () => store.copy(
                              email,
                              'Email скопирован в буфер обмена',
                            )
                        : null,
                  ),
                ),
                WStoreValueBuilder(
                  store: store,
                  watch: (store) => store.currentUserPhone,
                  builder: (context, phone) => AccountItemWidget(
                    text: 'Телефон',
                    value: phone.isNotEmpty ? phone : 'Не указано',
                    iconAssetName: 'assets/icons/account_phone.svg',
                    onTapChange: () {
                      showUserChangePhoneDialog(context, phone);
                    },
                    onTapValue: phone.isNotEmpty
                        ? () => store.copy(
                              phone,
                              'Телефон скопирован в буфер обмена',
                            )
                        : null,
                  ),
                ),
                WStoreValueBuilder(
                  store: store,
                  watch: (store) => store.currentUserJobTitle,
                  builder: (context, jobTitle) => AccountItemWidget(
                    text: 'Должность',
                    value: jobTitle.isNotEmpty ? jobTitle : 'Не указано',
                    iconAssetName: 'assets/icons/account_job.svg',
                    onTapChange: () {
                      showUserChangeJobDialog(context, jobTitle);
                    },
                    onTapValue: jobTitle.isNotEmpty
                        ? () => store.copy(
                      jobTitle,
                      'Должность скопирована в буфер обмена',
                    )
                        : null,
                  ),
                ),
                WStoreValueBuilder(
                  store: store,
                  watch: (store) => store.currentUserTelegram,
                  builder: (context, telegram) => AccountItemWidget(
                    text: 'Профиль в Telegram',
                    value: telegram.isNotEmpty ? telegram : 'Не указано',
                    iconAssetName: 'assets/icons/account_telegram.svg',
                    onTapChange: () {
                      showUserChangeTgLinkDialog(context, telegram);
                    },
                    onTapValue:
                        telegram.isNotEmpty ? () => store.open(telegram) : null,
                    onLongTapValue: telegram.isNotEmpty
                        ? () => store.copy(
                              telegram,
                              'Ссылка скопирована в буфер обмена',
                            )
                        : null,
                  ),
                ),
                WStoreValueBuilder(
                  store: store,
                  watch: (store) => store.currentUserGithub,
                  builder: (context, github) => AccountItemWidget(
                    text: 'Профиль в Github',
                    value: github.isNotEmpty ? github : 'Не указано',
                    iconAssetName: 'assets/icons/account_github.svg',
                    onTapChange: () {
                      showUserChangeGitHubLinkDialog(context, github);
                    },
                    onTapValue:
                        github.isNotEmpty ? () => store.open(github) : null,
                    onLongTapValue: github.isNotEmpty
                        ? () => store.copy(
                              github,
                              'Ссылка скопирована в буфер обмена',
                            )
                        : null,
                  ),
                ),
                AccountItemWidget(
                  text: 'Пароль',
                  value: '********',
                  iconAssetName: 'assets/icons/account_password.svg',
                  onTapChange: () {
                    showUserChangePasswordDialog(context);
                  },
                ),
              ],
            ),
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
  final VoidCallback onChangeAvatar;
  final VoidCallback onClearAvatar;
  final bool hasAvatar;

  const AccountAvatarWidget({
    super.key,
    required this.hasAvatar,
    required this.onChangeAvatar,
    required this.onClearAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WStoreValueBuilder<AccountPageStore, int>(
          watch: (store) => store.currentUserId,
          builder: (context, currentUserId) => UserAvatarWidget(
            id: currentUserId,
            width: 120,
            height: 120,
            fontSize: 48,
            radius: 16,
          ),
        ),
        const SizedBox(height: 4),
        MenuAnchor(
          menuChildren: [
            MenuItemButton(
              onPressed: onChangeAvatar,
              child: const Text('Обновить фото'),
            ),
            if (hasAvatar)
              MenuItemButton(
                onPressed: onClearAvatar,
                child: const Text('Удалить фото'),
              ),
          ],
          builder: (context, controller, _) {
            return WStoreStatusBuilder<AccountPageStore>(
              watch: (store) => store.statusAvatar,
              builder: (context, status) {
                final loading = status == WStoreStatus.loading;
                return TextButton(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(120, 40)),
                  ),
                  onPressed: loading
                      ? null
                      : () {
                          if (controller.isOpen) {
                            controller.close();
                          } else {
                            controller.open();
                          }
                        },
                  child: loading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Изменить'),
                );
              },
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
