import 'package:flutter/material.dart';
import 'package:wstore/wstore.dart';

class UserAvatarWidgetStore extends WStore {
  // TODO: add data here...

  @override
  UserAvatarWidget get widget => super.widget as UserAvatarWidget;
}

class UserAvatarWidget extends WStoreWidget<UserAvatarWidgetStore> {
  final int id;
  final double width;
  final double height;
  final String email;

  const UserAvatarWidget({
    super.key,
    required this.id,
    required this.width,
    required this.height,
    this.email = '',
  });

  @override
  UserAvatarWidgetStore createWStore() => UserAvatarWidgetStore();

  @override
  Widget build(BuildContext context, UserAvatarWidgetStore store) {
    return const SizedBox.shrink();
  }
}
