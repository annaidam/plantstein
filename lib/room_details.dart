// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plant_stein/utils.dart';
import 'pot_details_page.dart';
import 'package:http/http.dart' as http;

class RoomDetails extends StatefulWidget {
  final int roomId;
  final String roomName;
  const RoomDetails(this.roomId, this.roomName, {super.key});

  @override
  State<RoomDetails> createState() => _RoomDetailsState();
}

class _RoomDetailsState extends State<RoomDetails> {
  List<Map<String, dynamic>> pots = [];

  @override
  void initState() {
    super.initState();
    debugPrint("initState");
    // load pots only once (when widget is created)
    loadPots(widget.roomId);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("build");

    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          title: Image.asset(
            'images/logo.png',
            fit: BoxFit.contain,
            height: 70,
          ),
          iconTheme: const IconThemeData(color: Color(0xFF5F725F)),
          centerTitle: true,
          backgroundColor: const Color(0xFFEBEDEB),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 30),
              Text(
                widget.roomName,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              ...getUIRows()
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            final result = await openAddPlant(context);
          },
          backgroundColor: const Color(0xFF5F725F),
          label: const Text("Add Pot"),
          icon: const Icon(Icons.add),
        ),
        resizeToAvoidBottomInset: false);
  }

  Widget getPotButton(int potId) {
    return IconButton(
      onPressed: () {
        Navigator.push(context,
                MaterialPageRoute(builder: (context) => PotDetails(potId)))
            .then((value) => loadPots(widget.roomId));
      },
      icon: Image.asset(
        'images/pot.png',
      ),
      iconSize: 120,
      padding: EdgeInsets.zero,
    );
  }

  Widget getPotTitle(String potName) {
    return Expanded(
      child: Text(
        potName,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: GoogleFonts.playfairDisplay(color: Colors.black),
      ),
    );
  }

  void loadPots(int roomId) async {
    debugPrint("loadPots");
    var url = Uri.http(dotenv.env["SERVER"]!, 'room/$roomId/plants');
    final response =
        await http.get(url, headers: {'clientId': dotenv.env["CLIENT"]!});
    setState(() {
      pots = (json.decode(response.body) as List)
          .map((e) => e as Map<String, dynamic>)
          .toList();
    });
  }

  Future openAddPlant(BuildContext context) async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController plantController = TextEditingController();
    final List<String> plantEntries = await getSpecies();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0XFF5F725F),
        title: Text(
          'Create a pot',
          textAlign: TextAlign.center,
          style: GoogleFonts.playfairDisplay(color: Colors.white),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextField(
              controller: nameController,
              autofocus: true,
              decoration: const InputDecoration(
                  hintText: 'Enter pot name',
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white))),
            ),
            const SizedBox(height: 10),
            DropdownMenu<String>(
              inputDecorationTheme: const InputDecorationTheme(
                  filled: true, fillColor: Colors.white),
              width: 232,
              controller: plantController,
              enableFilter: true,
              hintText: 'Enter a plant type',
              dropdownMenuEntries: plantEntries.map((String name) {
                return DropdownMenuEntry<String>(
                  value: name,
                  label: name,
                );
              }).toList(),
            )
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
              http.Response response = await saveNewPlant(
                  nameController.text, plantController.text, widget.roomId);
              loadPots(widget.roomId); // load pots again
              debugPrint(response.statusCode.toString());
              if (response.statusCode == 201) {
                int potId = json.decode(response.body)["id"];
                Navigator.of(context).pop();
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PotDetails(potId)))
                    .then((_) => loadPots(widget.roomId));
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

  Future<http.Response> saveNewPlant(String name, String species, int roomId) {
    var url = Uri.http(dotenv.env["SERVER"]!, 'plant/add');
    return http.post(url,
        headers: {
          'clientId': dotenv.env["CLIENT"]!,
          "Accept": "application/json",
          "content-type": "application/json"
        },
        body: jsonEncode(
            {"nickname": name, "species": species, "roomId": roomId}));
  }

  Future<List<String>> getSpecies() async {
    var url = Uri.http(dotenv.env["SERVER"]!, 'species/all');
    final response =
        await http.get(url, headers: {'clientId': dotenv.env["CLIENT"]!});
    final jsonData = json.decode(response.body);
    return List<String>.from(jsonData.map((item) => item["name"]));
  }

  List<Widget> getUIRows() {
    debugPrint("getUIRows");
    List<Widget> result = [];

    for (List<Map<String, dynamic>> threePots in splitIntoBatches(pots, 3)) {
      List<Widget> row = [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:
              threePots.map<Widget>((pot) => getPotButton(pot["id"])).toList(),
        ),
        Image.asset('images/shelf.png'),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: threePots
              .map<Widget>((pot) => getPotTitle(pot["nickname"]))
              .toList(),
        ),
        const SizedBox(
          height: 20,
        ),
      ];

      result.addAll(row);

      threePots = pots.take(3).toList();
    }

    return result;
  }
}
