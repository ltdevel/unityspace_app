import 'dart:async';

import 'package:flutter/material.dart';
import 'package:unityspace/screens/confirm_screen.dart';
import 'package:unityspace/screens/home_screen.dart';
import 'package:unityspace/screens/loading_screen.dart';
import 'package:unityspace/screens/login_by_email_screen.dart';
import 'package:unityspace/screens/login_screen.dart';
import 'package:unityspace/screens/register_screen.dart';
import 'package:unityspace/screens/restore_password_screen.dart';
import 'package:unityspace/store/auth_store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AuthStore().loadUserTokens();

  runApp(
    MyApp(
      isAuthenticated: AuthStore().isAuthenticated,
    ),
  );
}

class MyApp extends StatefulWidget {
  final bool isAuthenticated;

  const MyApp({
    super.key,
    required this.isAuthenticated,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  late StreamSubscription<bool> isAuthenticatedSubscription;

  @override
  void initState() {
    super.initState();
    // мы пропускаем первое значение потому что оно возвращается сразу
    // а нам нужно мониторить только изменения
    isAuthenticatedSubscription =
        AuthStore().observeIsAuthenticated.skip(1).listen(
      (isAuthenticated) {
        if (isAuthenticated) {
          navigatorKey.currentState?.pushNamedAndRemoveUntil(
            '/loading',
            (route) => false,
          );
        } else {
          navigatorKey.currentState?.pushNamedAndRemoveUntil(
            '/login',
            (route) => false,
          );
        }
      },
    );
  }

  @override
  void dispose() {
    isAuthenticatedSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'UnitySpace',
      theme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: widget.isAuthenticated ? '/loading' : '/login',
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
      },
    );
  }
}
