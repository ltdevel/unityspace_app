import 'package:unityspace/models/user_models.dart';
import 'package:unityspace/service/user_service.dart' as api;
import 'package:unityspace/utils/wstore_plugin.dart';

class UserStore extends GStore {
  static UserStore? _instance;

  factory UserStore() => _instance ??= UserStore._();

  UserStore._();

  User? user;
  Organization? organization;

  bool get hasLicense {
    final license = organization?.licenseEndDate;
    if (license == null) return false;
    return license.isAfter(DateTime.now());
  }

  bool get hasTrial {
    final trial = organization?.trialEndDate;
    if (trial == null) return false;
    return trial.isAfter(DateTime.now());
  }

  bool get trialNeverStarted {
    return organization?.trialEndDate == null;
  }

  bool get isOrganizationOwner {
    if (user == null || organization == null) return false;
    return organization?.ownerId == user?.id;
  }

  Map<int, OrganizationMember> get organizationMembers {
    final members = organization?.members ?? [];
    return members.fold(<int, OrganizationMember>{}, (map, member) {
      map[member.id] = member;
      return map;
    });
  }

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

  Future<void> removeUserAvatar() async {
    final userData = await api.removeUserAvatar();
    final user = User.fromResponse(userData);
    setStore(() {
      this.user = user;
      final organizationMembersCount = organization?.members.length ?? 0;
      for (int i = 0; i < organizationMembersCount; i++) {
        final member = organization!.members[i];
        if (member.id == user.id) {
          organization!.members[i] = member.copyWithNoAvatar();
          break;
        }
      }
    });
  }

  void clear() {
    setStore(() {
      user = null;
      organization = null;
    });
  }
}
