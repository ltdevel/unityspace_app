import 'package:flutter/material.dart';
import 'package:wstore/wstore.dart';

class LoadingScreenStore extends WStore {
  bool loading = false;

  void loadData() {
    if (loading) return;
    //
    setStore(() {
      loading = true;
    });
    //
    setStore(() {
      loading = false;
    });
  }

  @override
  LoadingScreen get widget => super.widget as LoadingScreen;
}

class LoadingScreen extends WStoreWidget<LoadingScreenStore> {
  const LoadingScreen({
    super.key,
  });

  @override
  LoadingScreenStore createWStore() => LoadingScreenStore();

  @override
  Widget build(BuildContext context, LoadingScreenStore store) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
