import 'dart:convert';

import 'package:unityspace/models/spaces_models.dart';
import 'package:unityspace/utils/http_plugin.dart';

Future<List<SpaceResponse>> getSpacesData() async {
  final response = await HttpPlugin().get('/spaces');
  final jsonDataList = json.decode(response.body) as List<dynamic>;
  final result =
      jsonDataList.map((data) => SpaceResponse.fromJson(data)).toList();
  return result;
}

Future<SpaceResponse> createSpaces(final String title, final int order) async {
  final response = await HttpPlugin().post('/spaces', {
    'name': title,
    'order': order
  });
  final jsonData = json.decode(response.body);
  final result = SpaceResponse.fromJson(jsonData);
  return result;
}
