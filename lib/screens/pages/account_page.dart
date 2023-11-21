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
    return Container(
      color: Colors.blue,
      child: const Center(
        child: Text('Достижения'),
      ),
    );
  }
}
