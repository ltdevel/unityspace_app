import 'package:flutter/material.dart';
import 'package:wstore/wstore.dart';

class SettingsPageStore extends WStore {
  // TODO: add data here...

  @override
  SettingsPage get widget => super.widget as SettingsPage;
}

class SettingsPage extends WStoreWidget<SettingsPageStore> {
  const SettingsPage({
    super.key,
  });

  @override
  SettingsPageStore createWStore() => SettingsPageStore();

  @override
  Widget build(BuildContext context, SettingsPageStore store) {
    return Container(
      color: Colors.blue,
      child: const Center(
        child: Text('Настройки'),
      ),
    );
  }
}
