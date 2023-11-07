import 'package:flutter/material.dart';
import 'package:unityspace/screens/app_navigaion_drawer.dart';
import 'package:unityspace/store/auth_store.dart';
import 'package:unityspace/widgets/color_button_widget.dart';
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
      drawer: const AppNavigationDrawer(),
      appBar: AppBar(
        title: const Text('Главная'),
      ),
      body: Center(
        child: ColorButtonWidget(
          width: double.infinity,
          onPressed: () {
            AuthStore().signOut();
          },
          text: 'Выйти из аккаунта',
          loading: false,
          colorBackground: const Color(0xFF111012),
          colorText: Colors.white.withOpacity(0.9),
        ),
      ),
    );
  }
}
