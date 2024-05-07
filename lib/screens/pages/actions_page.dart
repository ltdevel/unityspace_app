import 'package:flutter/material.dart';
import 'package:wstore/wstore.dart';
import 'package:unityspace/utils/localization_helper.dart';

class ActionsPageStore extends WStore {
  // TODO: add data here...

  @override
  ActionsPage get widget => super.widget as ActionsPage;
}

class ActionsPage extends WStoreWidget<ActionsPageStore> {
  const ActionsPage({
    super.key,
  });

  @override
  ActionsPageStore createWStore() => ActionsPageStore();

  @override
  Widget build(BuildContext context, ActionsPageStore store) {
    final localization = LocalizationHelper.getLocalizations(context);
    return Container(
      color: Colors.blue,
      child: Center(
        child: Text(localization.my_actions),
      ),
    );
  }
}
