import 'package:unityspace/models/spaces_models.dart';
import 'package:unityspace/plugins/gstore.dart';
import 'package:unityspace/service/spaces_service.dart' as api;

class SpacesStore extends GStore {
  static SpacesStore? _instance;

  factory SpacesStore() => _instance ??= SpacesStore._();

  SpacesStore._();

  List<Space>? spaces;

  Stream<List<Space>?> get observeSpaces => observe(() => spaces);

  Future<void> getSpacesData() async {
    final spacesData = await api.getSpacesData();
    final spaces = spacesData.map(Space.fromResponse).toList();
    setStore(() {
      this.spaces = spaces;
    });
  }

  void clear() {
    setStore(() {
      spaces = null;
    });
  }
}
