import 'package:unityspace/models/spaces_models.dart';
import 'package:unityspace/utils/helpers.dart';
import 'package:unityspace/utils/http_plugin.dart';
import 'package:unityspace/service/spaces_service.dart' as api;
import 'package:wstore/wstore.dart';

class SpacesStore extends GStore {
  static SpacesStore? _instance;

  factory SpacesStore() => _instance ??= SpacesStore._();

  SpacesStore._();

  List<Space>? spaces;

  Future<void> getSpacesData() async {
    final spacesData = await api.getSpacesData();
    final spaces = spacesData.map(Space.fromResponse).toList();
    setStore(() {
      this.spaces = spaces;
    });
  }

  Future<int> createSpace(final String title) async {
    try {
      final maxOrder = this.spaces?.fold<double>(
                0,
                (max, space) => max > space.order ? max : space.order,
              ) ??
          0;
      final newOrder = maxOrder + 1;
      final spaceData = await api.createSpaces(
        title,
        makeIntFromOrder(newOrder),
      );
      final newSpace = Space.fromResponse(spaceData);
      final spaces = [...?this.spaces, newSpace];
      setStore(() {
        this.spaces = spaces;
      });
      return newSpace.id;
    } on HttpPluginException catch (e) {
      if (e.message == 'Cannot add more spaces, check paid tariff or remove spaces') {
        throw 'paid tariff';
      }
      rethrow;
    }
  }

  @override
  void clear() {
    super.clear();
    setStore(() {
      spaces = null;
    });
  }
}
