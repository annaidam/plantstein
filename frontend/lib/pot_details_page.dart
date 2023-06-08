// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plant_stein/statistics.dart';
import 'plant_details.dart';
import 'package:http/http.dart' as http;
import 'package:plant_stein/plant_details.dart';

class PotDetails extends StatefulWidget {
  final int potId;
  const PotDetails(this.potId, {super.key});

  @override
  State<PotDetails> createState() => _PotDetailsState();
}

class _PotDetailsState extends State<PotDetails> {
  Timer? _timer;

  Future<PlantDetails> plantDetails = Future<PlantDetails>.value(
    const PlantDetails(
      plantNickname: 'Loading...',
      moisture: 'Loading...',
      brightness: 0,
      temperature: 0,
      humidity: 0,
    ),
  );

  @override
  void initState() {
    super.initState();
    plantDetails = getPlantDetails();

    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        plantDetails = getPlantDetails();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<PlantDetails> getPlantDetails() async {
    var url =
        Uri.http(dotenv.env["SERVER"]!, 'plant/condition/${widget.potId}');
    final response = await http.get(url);
    return PlantDetails.fromJson(jsonDecode(response.body));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<PlantDetails>(
          future: plantDetails,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();

            PlantDetails plantDetails = snapshot.data!;

            return SingleChildScrollView(
              child: Column(
                children: [
                  AppBar(
                    toolbarHeight: 100,
                    title: Text(
                      plantDetails.plantNickname,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.playfairDisplay(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                    iconTheme: const IconThemeData(color: Color(0xFF5F725F)),
                    centerTitle: true,
                    elevation: 0.0,
                    backgroundColor: const Color(0xFFEBEDEB),
                  ),
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 20.0),
                        child: const Text('Soil Moisture'),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                        height: 95.0,
                        width: 300.0,
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: plantDetails.moistureIsOk == true
                              ? Color(0xFF5F725F)
                              : Color(0xFFD38668),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade600,
                              spreadRadius: -1,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              plantDetails.moisture == null
                                  ? 'No data'
                                  : "${plantDetails.moisture}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 20.0),
                        child: const Text('Room Temperature'),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                        height: 95.0,
                        width: 300.0,
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: plantDetails.tempeartureIsOk == true
                              ? Color(0xFF5F725F)
                              : Color(0xFFD38668),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade600,
                              spreadRadius: -1,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              plantDetails.temperature == null
                                  ? 'No data'
                                  : '${plantDetails.temperature}°C\nCurrent',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                            const SizedBox(
                              width: 40.0,
                            ),
                            Text(
                              '${plantDetails.perfectTemperature}°C\nPreferred',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 20.0),
                        child: const Text('Room Humidity'),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                        height: 95.0,
                        width: 300.0,
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: plantDetails.humidityIsOk == true
                              ? Color(0xFF5F725F)
                              : Color(0xFFD38668),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade600,
                              spreadRadius: -1,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              plantDetails.humidity == null
                                  ? 'No data'
                                  : '${plantDetails.humidity}%\nCurrent',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                            const SizedBox(
                              width: 40.0,
                            ),
                            Text(
                              '${plantDetails.perfectHumidity}%\nPreferred',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 20.0),
                        child: const Text('Light'),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                        height: 95.0,
                        width: 300.0,
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: plantDetails.brightnessIsOk == true
                              ? Color(0xFF5F725F)
                              : Color(0xFFD38668),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade600,
                              spreadRadius: -1,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              plantDetails.brightness == null
                                  ? 'No data'
                                  : '${plantDetails.brightness}\nCurrent',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                            const SizedBox(
                              width: 40.0,
                            ),
                            Text(
                              '${plantDetails.perfectBrightness}\nPreferred',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
      floatingActionButton: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton.extended(
                heroTag: "btn1",
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Statistics(widget.potId)));
                },
                backgroundColor: const Color(0xFFA0AFA1),
                label: const Text(
                  "Statistics",
                ),
                icon: const Icon(Icons.query_stats),
              ),
              const SizedBox(
                height: 10,
              ),
              FloatingActionButton.extended(
                heroTag: "btn2",
                onPressed: () async {
                  final result =
                      await showDeleteConfirmationDialog(context, widget.potId);
                  if (result == true) Navigator.pop(context);
                },
                backgroundColor: const Color(0xFFD38668),
                label: const Text("Delete plant"),
                icon: const Icon(Icons.delete),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton.extended(
                heroTag: "btn3",
                onPressed: () async {
                  final result = await openEditPlantName(context, widget.potId);
                },
                backgroundColor: const Color(0xFFA0AFA1),
                label: const Text("Edit Name"),
                icon: const Icon(Icons.edit),
              ),
              const SizedBox(
                height: 10,
              ),
              FloatingActionButton.extended(
                heroTag: "btn4",
                onPressed: () async {
                  final result = await openEditPlantRoom(context, widget.potId);
                },
                backgroundColor: const Color(0xFFA0AFA1),
                label: const Text("Change Room"),
                icon: const Icon(Icons.meeting_room),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      resizeToAvoidBottomInset: false,
    );
  }
}

Future<List<Room>> getRooms() async {
  var url = Uri.http(dotenv.env["SERVER"]!, 'room/all');
  final response =
      await http.get(url, headers: {'clientId': dotenv.env["CLIENT"]!});
  final jsonData = json.decode(response.body);
  return List<Room>.from(
      jsonData.map((item) => Room(item["id"], item["name"])));
}

Future openEditPlantName(BuildContext context, int potId) async {
  final TextEditingController newNameController = TextEditingController();
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: const Color(0XFF5F725F),
      title: Text(
        'Rename plant',
        textAlign: TextAlign.center,
        style: GoogleFonts.playfairDisplay(color: Colors.white),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextField(
            controller: newNameController,
            autofocus: true,
            decoration: const InputDecoration(
                hintText: 'Enter new pot name',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white))),
          ),
        ],
      ),
      actions: [
        TextButton(
          style: const ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll<Color>(Color(0xFFA85032))),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'CANCEL',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(color: Colors.white),
          ),
        ),
        TextButton(
          style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(Colors.white)),
          onPressed: () async {
            http.Response response = await editPlantName(
                potId, newNameController.text); // load pots again
            debugPrint(response.statusCode.toString());
            Navigator.of(context).pop();
          },
          child: Text(
            'SAVE',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(color: Colors.black),
          ),
        ),
      ],
    ),
  );
}

Future<http.Response> editPlantName(int plant, String newName) {
  var url = Uri.http(dotenv.env["SERVER"]!, 'plant/rename/$plant/$newName');
  return http.put(
    url,
    headers: {
      'clientId': dotenv.env["CLIENT"]!,
      "Accept": "application/json",
      "content-type": "application/json"
    },
  );
}

Future openEditPlantRoom(BuildContext context, int potId) async {
  final TextEditingController newRoomController = TextEditingController();
  final List<Room> roomEntries = await getRooms();
  Room? selectedRoom;
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: const Color(0XFF5F725F),
      title: Text(
        "Change plant's room",
        textAlign: TextAlign.center,
        style: GoogleFonts.playfairDisplay(color: Colors.white),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          DropdownMenu<Room>(
            inputDecorationTheme: const InputDecorationTheme(
                filled: true, fillColor: Colors.white),
            width: 232,
            controller: newRoomController,
            enableFilter: true,
            hintText: 'Choose room',
            dropdownMenuEntries: roomEntries.map((Room room) {
              return DropdownMenuEntry<Room>(
                value: room,
                label: room.name,
              );
            }).toList(),
            onSelected: (Room? newRoom) {
              selectedRoom = newRoom;
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          style: const ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll<Color>(Color(0xFFA85032))),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'CANCEL',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(color: Colors.white),
          ),
        ),
        TextButton(
          style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(Colors.white)),
          onPressed: () async {
            http.Response response =
                await editPlantRoom(potId, selectedRoom?.id); // load pots again
            debugPrint(response.statusCode.toString());
            Navigator.of(context).pop();
          },
          child: Text(
            'SAVE',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(color: Colors.black),
          ),
        ),
      ],
    ),
  );
}

Future<http.Response> editPlantRoom(int plant, int? newRoom) {
  var url =
      Uri.http(dotenv.env["SERVER"]!, 'plant/change-room/$plant/$newRoom');
  return http.put(
    url,
    headers: {
      'clientId': dotenv.env["CLIENT"]!,
      "Accept": "application/json",
      "content-type": "application/json"
    },
  );
}

class Room {
  int id;
  String name;
  Room(this.id, this.name);
}

Future showDeleteConfirmationDialog(BuildContext context, int plantId) async {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Are you sure you want to delete this pot?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(
            context,
          ),
          child: const Text(
            'No',
            selectionColor: Color(0xFF5F725F),
          ),
        ),
        TextButton(
          onPressed: () async {
            await deletePlant(plantId);
            Navigator.pop(context, true);
          },
          child: const Text(
            'Yes',
            selectionColor: Color(0xFF5F725F),
          ),
        )
      ],
    ),
  );
}

Future<http.Response> deletePlant(int plantId) {
  var url = Uri.http(dotenv.env["SERVER"]!, 'plant/delete/$plantId');
  return http.delete(
    url,
    headers: {
      'clientId': dotenv.env["CLIENT"]!,
      "Accept": "application/json",
      "content-type": "application/json"
    },
  );
}
