// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:plant_stein/room_details.dart';
import 'package:http/http.dart' as http;
import 'package:plant_stein/utils.dart';
import 'package:google_fonts/google_fonts.dart';

enum EditOptions { editRoomName, deleteRoom }

class RoomPage extends StatefulWidget {
  const RoomPage({super.key});

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  List<Map<String, dynamic>> rooms = [];

  @override
  void initState() {
    super.initState();
    debugPrint("initState");
    // load rooms only once (when widget is created)
    loadRooms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [const SizedBox(height: 30), ...getRoomRows()],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            final result = await openCreateRoom(context);
          },
          backgroundColor: const Color(0xFF5F725F),
          label: const Text("Add Room"),
          icon: const Icon(Icons.add),
        ),
        resizeToAvoidBottomInset: false);
  }

  Widget getRoomButton(int roomId, String roomName) {
    return InkWell(
      child: Card(
        color: const Color(0xFFA0AFA1),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            PopupMenuButton(
              onSelected: (EditOptions item) {
                if (item == EditOptions.editRoomName) {
                  openEditRoomName(context, roomId);
                } else if (item == EditOptions.deleteRoom) {
                  openDeleteRoom(context, roomId, roomName);
                }
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<EditOptions>>[
                const PopupMenuItem<EditOptions>(
                  value: EditOptions.editRoomName,
                  child: Text('Edit name'),
                ),
                const PopupMenuItem<EditOptions>(
                  value: EditOptions.deleteRoom,
                  child: Text('Delete room'),
                ),
              ],
            ),
            SizedBox(
              width: 150,
              height: 100,
              child: Center(
                child: Text(
                  roomName,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RoomDetails(roomId, roomName)))
            .then((value) => loadRooms());
      },
    );
  }

  void loadRooms() async {
    debugPrint("loadRooms");
    var url = Uri.http(dotenv.env["SERVER"]!, 'room/all');
    final response =
        await http.get(url, headers: {'clientId': dotenv.env["CLIENT"]!});
    setState(() {
      rooms = (json.decode(response.body) as List)
          .map((e) => e as Map<String, dynamic>)
          .toList();
    });
  }

  List<Widget> getRoomRows() {
    debugPrint("getRoomRows");
    List<Widget> result = [];

    for (List<Map<String, dynamic>> twoRooms in splitIntoBatches(rooms, 2)) {
      List<Widget> row = [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: twoRooms
              .map<Widget>((room) => getRoomButton(room["id"], room["name"]))
              .toList(),
        ),
        const SizedBox(
          height: 20,
        ),
      ];

      result.addAll(row);

      twoRooms = rooms.take(2).toList();
    }

    return result;
  }

  Future openCreateRoom(BuildContext context) async {
    final TextEditingController nameController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0XFF5F725F),
        title: Text(
          'Create a room',
          textAlign: TextAlign.center,
          style: GoogleFonts.playfairDisplay(color: Colors.white),
        ),
        content: TextField(
          controller: nameController,
          autofocus: true,
          decoration: const InputDecoration(
              hintText: 'Enter room name',
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white))),
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
              http.Response response = await saveNewRoom(nameController.text);
              loadRooms(); // load rooms again
              debugPrint(response.statusCode.toString());
              if (response.statusCode == 201) {
                int roomId = json.decode(response.body)["id"];
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            RoomDetails(roomId, nameController.text)));
              } else {
                Navigator.of(context).pop();
              }
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

  Future<http.Response> saveNewRoom(String roomName) {
    var url = Uri.http(dotenv.env["SERVER"]!, 'room/add');
    return http.post(url,
        headers: {
          'clientId': dotenv.env["CLIENT"]!,
          "Accept": "application/json",
          "content-type": "application/json"
        },
        body: roomName);
  }

  Future openEditRoomName(BuildContext context, int roomId) async {
    final TextEditingController newNameController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0XFF5F725F),
        title: Text(
          'Rename room',
          textAlign: TextAlign.center,
          style: GoogleFonts.playfairDisplay(color: Colors.white),
        ),
        content: TextField(
          controller: newNameController,
          autofocus: true,
          decoration: const InputDecoration(
              hintText: 'Enter new room name',
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white))),
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
              http.Response response = await editRoomName(
                  roomId, newNameController.text); // load rooms again
              loadRooms();
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

  Future<http.Response> editRoomName(int roomId, String newName) {
    var url = Uri.http(dotenv.env["SERVER"]!, 'room/rename/$roomId/$newName');
    return http.put(
      url,
      headers: {
        'clientId': dotenv.env["CLIENT"]!,
        "Accept": "application/json",
        "content-type": "application/json"
      },
    );
  }

  Future openDeleteRoom(
      BuildContext context, int roomId, String roomName) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0XFF5F725F),
        title: Text(
          'Are you sure you want to delete $roomName?',
          textAlign: TextAlign.center,
          style: GoogleFonts.playfairDisplay(color: Colors.white, fontSize: 30),
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
              'NO',
              textAlign: TextAlign.center,
              style: GoogleFonts.playfairDisplay(color: Colors.white),
            ),
          ),
          TextButton(
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(Colors.white)),
            onPressed: () async {
              http.Response response = await deleteRoom(roomId);
              loadRooms(); // load rooms again
              debugPrint(response.statusCode.toString());
              Navigator.of(context).pop();
            },
            child: Text(
              'YES',
              textAlign: TextAlign.center,
              style: GoogleFonts.playfairDisplay(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Future<http.Response> deleteRoom(int roomId) {
    var url = Uri.http(dotenv.env["SERVER"]!, 'room/delete/$roomId');
    return http.delete(
      url,
      headers: {
        'clientId': dotenv.env["CLIENT"]!,
        "Accept": "application/json",
        "content-type": "application/json"
      },
    );
  }
}
