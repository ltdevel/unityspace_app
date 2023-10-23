import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:unityspace/store/user_store.dart';
import 'package:unityspace/widgets/color_button_widget.dart';
import 'package:wstore/wstore.dart';

class LoadingScreenStore extends WStore {
  bool loading = false;
  String error = '';

  void loadData() {
    if (loading) return;
    //
    setStore(() {
      loading = true;
    });
    //
    subscribe(
      subscriptionId: 1,
      future: UserStore().getUserData(),
      onData: (_) {
        setStore(() {
          loading = false;
          error = '';
        });
      },
      onError: (e, __) {
        String errorText =
            'При загрузке данных возникла проблема, пожалуйста, попробуйте ещё раз';
        setStore(() {
          loading = false;
          error = errorText;
        });
      },
    );
  }

  @override
  LoadingScreen get widget => super.widget as LoadingScreen;
}

class LoadingScreen extends WStoreWidget<LoadingScreenStore> {
  const LoadingScreen({
    super.key,
  });

  @override
  LoadingScreenStore createWStore() => LoadingScreenStore()..loadData();

  @override
  Widget build(BuildContext context, LoadingScreenStore store) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: SafeArea(
        child: Center(
          child: WStoreConsumer(
            store: store,
            watch: () => [store.loading],
            builder: (context, _) {
              if (store.loading) {
                return Lottie.asset(
                  'assets/animations/main_loader.json',
                  width: 200,
                  height: 200,
                );
              } else if (store.error.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        store.error,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF111012).withOpacity(0.8),
                          fontSize: 20,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ColorButtonWidget(
                        width: double.infinity,
                        onPressed: () {
                          store.loadData();
                        },
                        text: 'Повтор',
                        loading: false,
                        colorBackground: const Color(0xFF111012),
                        colorText: Colors.white.withOpacity(0.9),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
            onChange: (context) {
              if (store.loading == false && store.error.isEmpty) {
                Navigator.of(context).pushReplacementNamed('/home');
              }
            },
          ),
        ),
      ),
    );
  }
}
