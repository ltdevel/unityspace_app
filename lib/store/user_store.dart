import 'package:unityspace/models/user_models.dart';
import 'package:unityspace/plugins/gstore.dart';
import 'package:unityspace/service/user_service.dart' as api;

class UserStore extends GStore {
  static UserStore? _instance;

  factory UserStore() => _instance ??= UserStore._();

  UserStore._();

  User? user;
  Organization? organization;

  Stream<User?> get observeUser => observe(() => user);

  bool get hasLicense {
    final license = organization?.licenseEndDate;
    if (license == null) return false;
    return license.isAfter(DateTime.now());
  }

  Map<int, OrganizationMember> get organizationMembers {
    final members = organization?.members ?? [];
    return members.fold(<int, OrganizationMember>{}, (map, member) {
      map[member.id] = member;
      return map;
    });
  }

  Stream<Map<int, OrganizationMember>> get observeOrganizationMembers =>
      observe(() => organizationMembers);

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

  void clear() {
    setStore(() {
      user = null;
      organization = null;
    });
  }
}
