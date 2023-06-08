import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:plant_stein/species_details.dart';

import 'species.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlantCatalogue extends StatefulWidget {
  const PlantCatalogue({super.key});

  @override
  State<PlantCatalogue> createState() => _PlantCatalogueState();
}

class _PlantCatalogueState extends State<PlantCatalogue> {
    final controller = TextEditingController();
   List<Species> species = [];
   List<Species> filteredSpecies = [];

  Future<List<Species>> getSpecies() async {
    var url = Uri.http(dotenv.env["SERVER"]!, 'species/all');
    final response =
        await http.get(url, headers: {'clientId': dotenv.env["CLIENT"]!});
    final jsonData = json.decode(response.body);
    return List<Species>.from(jsonData.map((item) => Species.fromJson(item)));
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        filteredSpecies = getFilteredSpecies();
      });
    });

    getSpecies().then((List<Species> fetchedSpecies) {
      setState(() {
        species = fetchedSpecies;
        filteredSpecies = getFilteredSpecies();
      });
    });
  }

  List<Species> getFilteredSpecies() => species.where((species) {
        final input = controller.text.trim().toLowerCase();
        if (input.isEmpty) return true;

        final speciesName = species.name.trim().toLowerCase();
        return speciesName.contains(input);
      }).toList();

 

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: Text(
            'Plant Catalogue',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
                color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: const Color(0xFFEBEDEB),
        ),
        Container(
          padding: const EdgeInsets.only(top: 5.0),
          color: const Color(0xFFD9D9D9),
          width: double.infinity,
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Look for a plant here',
            ),
            // onChanged: searchSpecies,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: this.filteredSpecies.length,
            itemBuilder: (context, index) {
              final species = this.filteredSpecies[index];

              return Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                  ),
                  ListTile(
                    visualDensity: const VisualDensity(vertical: 4.0),
                    tileColor: const Color(0xFFA0AFA1),
                    contentPadding:
                        const EdgeInsets.only(top: 5.0, bottom: 5.0),
                    leading: Image.asset(
                      'images/pot.png',
                      fit: BoxFit.fitHeight,
                    ),
                    onTap: () {
                      Navigator.push(
                           context,
                          MaterialPageRoute(
                           builder: (context) => 
                           SpeciesDetailsPage(species: species)));
                            },
                    title: Text(species.name),
                    subtitle: Text(species.homeland),
                  ),
                ], 
              );
            },
          ),
        ),
      ],
    );
  }
}
