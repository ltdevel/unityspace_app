import 'package:unityspace/models/user_models.dart';
import 'package:unityspace/plugins/store.dart';
import 'package:unityspace/service/user_service.dart' as api;

class UserStore extends GStore {
  static UserStore? _instance;
  factory UserStore() => _instance ??= UserStore._();
  UserStore._();

  User? user;

  Future<void> getUserData() async {
    final userData = await api.getUserData();
    final user = User(
      id: userData.id,
      globalId: userData.globalId,
      name: userData.name,
      email: userData.email,
      avatar: userData.avatar ?? '',
      phoneNumber: userData.phoneNumber ?? '',
      telegramLink: userData.telegramLink ?? '',
      githubLink: userData.githubLink ?? '',
      birthDate: userData.birthDate ?? '',
    );
    setStore(() {
      this.user = user;
    });
  }
}