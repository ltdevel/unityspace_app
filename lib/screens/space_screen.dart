import 'package:flutter/material.dart';
import 'package:unityspace/screens/app_navigation_drawer.dart';
import 'package:wstore/wstore.dart';
import 'package:unityspace/utils/localization_helper.dart';

class SpaceScreenStore extends WStore {
  // TODO: add data here...

  @override
  SpaceScreen get widget => super.widget as SpaceScreen;
}

class SpaceScreen extends WStoreWidget<SpaceScreenStore> {
  final int spaceId;

  const SpaceScreen({
    super.key,
    required this.spaceId,
  });

  @override
  SpaceScreenStore createWStore() => SpaceScreenStore();

  @override
  Widget build(BuildContext context, SpaceScreenStore store) {
    final localization = LocalizationHelper.getLocalizations(context);
    return Scaffold(
      drawer: const AppNavigationDrawer(),
      appBar: AppBar(
        title: Text('${localization.space} $spaceId'),
      ),
      body: Container(),
    );
  }
}
