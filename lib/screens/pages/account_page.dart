import 'package:flutter/material.dart';
import 'package:wstore/wstore.dart';

class AccountPageStore extends WStore {
  // TODO: add data here...

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
            avatar: Container(
              width: 40,
              height: 40,
              color: Colors.deepPurple,
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
