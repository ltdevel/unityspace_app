import 'package:flutter/material.dart';
import 'package:unityspace/screens/account_screen/pages/actions_page/action_card.dart';
import 'package:wstore/wstore.dart';
// import 'package:unityspace/utils/localization_helper.dart';

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
    // final localization = LocalizationHelper.getLocalizations(context);
    return Container(
      color: Colors.grey,
      child: const Center(
        child: ActionCard(
          title: 'Такой тип истории не определен :( 8177',
          task: 'Задача: Экран Мой Профиль - Мои Действия',
          time: 'Вчера 16:40',
          isSelected: true,
        ),
      ),
    );
  }
}
