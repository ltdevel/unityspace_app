import 'package:flutter/material.dart';
import 'package:wstore/wstore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final localization = AppLocalizations.of(context);
    return Container(
      color: Colors.blue,
      child: Center(
        child: Text(localization!.settings),
      ),
    );
  }
}
