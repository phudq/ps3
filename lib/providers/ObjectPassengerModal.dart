import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ps3_01/config/AppConfig.dart';
import 'package:ps3_01/models/ObjectPassenger.dart';

class ObjectPassengerModal {
  List<ObjectPassenger> objectPassengers = [];
  ObjectPassengerModal(this.objectPassengers);

  static Future<ObjectPassengerModal> fetchObjectPassengers() async {
    var uri = Uri.http(AppConfig.domain, '/api/objectPassengers');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      List collection = json.decode(response.body);
      return new ObjectPassengerModal(
          collection.map((e) => ObjectPassenger.fromJson(e)).toList());
    } else {
      return new ObjectPassengerModal([]);
    }
  }
}
