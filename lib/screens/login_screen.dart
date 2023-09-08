import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wstore/wstore.dart';

class LoginScreenStore extends WStore {
  // TODO: add data here...

  @override
  LoginScreen get widget => super.widget as LoginScreen;
}

class LoginScreen extends WStoreWidget<LoginScreenStore> {
  const LoginScreen({
    super.key,
  });

  @override
  LoginScreenStore createWStore() => LoginScreenStore();

  @override
  Widget build(BuildContext context, LoginScreenStore store) {
    return Scaffold(
      backgroundColor: const Color(0xFF111012),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 60),
          child: Column(
            children: [
              Row(
                children: [
                  const Spacer(),
                  SvgPicture.asset(
                    'assets/icons/app_icon.svg',
                    width: 42,
                    height: 42,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Пространства',
                    style: TextStyle(
                      fontSize: 24,
                        color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const Spacer(),
                ],
              ),

              // PrimaryButton(
              //   text: "Sign In",
              //   press: () => Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => const ChatsScreen(),
              //     ),
              //   ),
              // ),
              // const SizedBox(height: kDefaultPadding * 1.5),
              // PrimaryButton(
              //   color: Theme.of(context).colorScheme.secondary,
              //   text: "Sign Up",
              //   press: () {},
              // ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
