import 'dart:convert';

import 'package:unityspace/models/spaces_models.dart';
import 'package:unityspace/plugins/http_plugin.dart';

Future<List<SpaceResponse>> getSpacesData() async {
  final response = await HttpPlugin().get('/spaces');
  final jsonDataList = json.decode(response.body) as List<dynamic>;
  final result =
      jsonDataList.map((data) => SpaceResponse.fromJson(data)).toList();
  return result;
}
