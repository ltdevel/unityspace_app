import 'package:flutter/material.dart';
import 'package:unityspace/screens/app_navigation_drawer.dart';
import 'package:wstore/wstore.dart';

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
    return Scaffold(
      drawer: const AppNavigationDrawer(),
      appBar: AppBar(
        title:  Text('Пространство $spaceId'),
      ),
      body: Container(),
    );
  }
}
