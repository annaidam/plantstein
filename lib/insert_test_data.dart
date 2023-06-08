import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

List<String> rooms = const ["Kitchen", "Living Room", "Bedroom", "Bathroom"];
List<String> plantNames = const [
  "Planty",
  "Greenie",
  "Leafy",
  "Flower",
  "Ferny"
];

extension RandomListItem<T> on List<T> {
  T randomItem() {
    return this[Random().nextInt(length)];
  }
}

void insertTestData() async {
  if (!await _isDbEmpty()) return;

  List<String> species = await _getSpecies();

  Random random = Random();

  for (String room in rooms) {
    await _insertRoom(room);
  }

  await _insertPlant("Microcontroller Plant", species[0], 1);

  for (String room in rooms) {
    for (int i = 0; i < random.nextInt(10) + 3; i++) {
      await _insertPlant(plantNames.randomItem(), species.randomItem(),
          random.nextInt(rooms.length) + 1);
    }
  }
  debugPrint("inserted test data");
}

Future<bool> _isDbEmpty() async {
  var url = Uri.http(dotenv.env["SERVER"]!, 'room/all');
  debugPrint("test:" + dotenv.env["CLIENT"]!);
  final response =
      await http.get(url, headers: {'clientId': dotenv.env["CLIENT"]!});
  final jsonData = json.decode(response.body);
  return jsonData.length == 0;
}

_getSpecies() async {
  var url = Uri.http(dotenv.env["SERVER"]!, 'species/all');
  final response =
      await http.get(url, headers: {'clientId': dotenv.env["CLIENT"]!});
  final jsonData = json.decode(response.body);
  return List<String>.from(jsonData.map((item) => item["name"]));
}

Future<Response> _insertRoom(String roomName) {
  var url = Uri.http(dotenv.env["SERVER"]!, 'room/add');
  return http.post(url,
      headers: {
        'clientId': dotenv.env["CLIENT"]!,
        "Accept": "application/json",
        "content-type": "application/text"
      },
      body: roomName);
}

Future<Response> _insertPlant(String name, String species, int room) {
  var url = Uri.http(dotenv.env["SERVER"]!, 'plant/add');
  return http.post(url,
      headers: {
        'clientId': dotenv.env["CLIENT"]!,
        "Accept": "application/json",
        "content-type": "application/json"
      },
      body: jsonEncode({"nickname": name, "species": species, "roomId": room}));
}
