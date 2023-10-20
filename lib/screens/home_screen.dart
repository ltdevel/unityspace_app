import 'package:flutter/material.dart';
import 'package:wstore/wstore.dart';

class HomeScreenStore extends WStore {
  // TODO: add data here...

  @override
  HomeScreen get widget => super.widget as HomeScreen;
}

class HomeScreen extends WStoreWidget<HomeScreenStore> {
  const HomeScreen({
    super.key,
  });

  @override
  HomeScreenStore createWStore() => HomeScreenStore();

  @override
  Widget build(BuildContext context, HomeScreenStore store) {
    return Scaffold(
      body: Container(),
    );
  }
}
