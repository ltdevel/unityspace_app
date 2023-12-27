import 'package:flutter/material.dart';
import 'package:unityspace/utils/wstore_plugin.dart';
import 'package:wstore/wstore.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:unityspace/screens/account_screen.dart';
import 'package:unityspace/screens/confirm_screen.dart';
import 'package:unityspace/screens/home_screen.dart';
import 'package:unityspace/screens/loading_screen.dart';
import 'package:unityspace/screens/login_by_email_screen.dart';
import 'package:unityspace/screens/login_screen.dart';
import 'package:unityspace/screens/notifications_screen.dart';
import 'package:unityspace/screens/register_screen.dart';
import 'package:unityspace/screens/restore_password_screen.dart';
import 'package:unityspace/screens/space_screen.dart';
import 'package:unityspace/store/auth_store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthStore().loadUserTokens();
  await initializeDateFormatting('ru_RU', null);

  runApp(
    MyApp(
      isAuthenticated: AuthStore().isAuthenticated,
    ),
  );
}

class MyAppStore extends WStore {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  bool get isAuthenticated => computedFromStore(
        store: AuthStore(),
        getValue: (store) => store.isAuthenticated,
        keyName: 'isAuthenticated',
      );

  @override
  MyApp get widget => super.widget as MyApp;
}

class MyApp extends WStoreWidget<MyAppStore> {
  final bool isAuthenticated;

  const MyApp({
    super.key,
    required this.isAuthenticated,
  });

  @override
  MyAppStore createWStore() => MyAppStore();

  @override
  Widget build(BuildContext context, MyAppStore store) {
    return WStoreBoolListener(
      store: store,
      watch: (store) => store.isAuthenticated,
      onTrue: (context) {
        store.navigatorKey.currentState?.pushNamedAndRemoveUntil(
          '/loading',
          (route) => false,
        );
      },
      onFalse: (context) {
        store.navigatorKey.currentState?.pushNamedAndRemoveUntil(
          '/login',
          (route) => false,
        );
      },
      child: MaterialApp(
        navigatorKey: store.navigatorKey,
        title: 'UnitySpace',
        theme: ThemeData(
          fontFamily: 'Roboto',
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0C5B35)),
          scaffoldBackgroundColor: const Color(0xFFF5F5F5),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFF5F5F5),
            surfaceTintColor: Color(0xFFF5F5F5),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
            ),
          ),
          useMaterial3: true,
        ),
        initialRoute: isAuthenticated ? '/loading' : '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/email': (context) => const LoginByEmailScreen(),
          '/home': (context) => const HomeScreen(),
          '/loading': (context) => const LoadingScreen(),
          '/restore': (context) => const RestorePasswordScreen(),
          '/register': (context) => const RegisterScreen(),
          '/confirm': (context) => ConfirmScreen(
                email:
                    ModalRoute.of(context)?.settings.arguments as String? ?? '',
              ),
          '/space': (context) => SpaceScreen(
                spaceId:
                    ModalRoute.of(context)?.settings.arguments as int? ?? 0,
              ),
          '/notifications': (context) => const NotificationsScreen(),
          '/account': (context) {
            final arguments = ModalRoute.of(context)?.settings.arguments
                as Map<String, String>?;
            return AccountScreen(
              tab: arguments?['page'] ?? '',
              action: arguments?['action'] ?? '',
            );
          },
        },
      ),
    );
  }
}
