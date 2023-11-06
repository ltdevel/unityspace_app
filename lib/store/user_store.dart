import 'package:unityspace/models/user_models.dart';
import 'package:unityspace/plugins/gstore.dart';
import 'package:unityspace/service/user_service.dart' as api;

class UserStore extends GStore {
  static UserStore? _instance;

  factory UserStore() => _instance ??= UserStore._();

  UserStore._();

  User? user;
  Organization? organization;

  Future<void> getUserData() async {
    final userData = await api.getUserData();
    final user = User.fromResponse(userData);
    setStore(() {
      this.user = user;
    });
  }

  Future<void> getOrganizationData() async {
    final organizationData = await api.getOrganizationData();
    final organization = Organization.fromResponse(organizationData);
    setStore(() {
      this.organization = organization;
    });
  }
}
