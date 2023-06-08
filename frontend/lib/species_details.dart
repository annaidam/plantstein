import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:plant_stein/species.dart';

class SpeciesDetailsPage extends StatelessWidget {
  final Species species;

  const SpeciesDetailsPage({Key? key, required this.species}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      body: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        species.name,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: GoogleFonts.playfairDisplay(
                          color: const Color(0xFF5F725F),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Height: ${species.maxHeight}',
                        style: GoogleFonts.playfairDisplay(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Botanical name: ${species.botanicalName}',
                        style: GoogleFonts.playfairDisplay(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Homeland: ${species.homeland}',
                        style: GoogleFonts.playfairDisplay(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Bloom time: ${species.bloomTime}',
                        style: GoogleFonts.playfairDisplay(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            'images/leaf1.png',
                            width: 80,
                            height: 80,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Image.asset(
                        'images/pot.png',
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width * 0.5,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Image.asset(
                'images/friendly_plant.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 50),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 50),
                      Text(
                        'Perfect temperature: ${species.perfectTemperature}',
                        style: GoogleFonts.playfairDisplay(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Perfect humidity: ${species.perfectHumidity}',
                        style: GoogleFonts.playfairDisplay(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Perfect moisture: ${species.perfectMoisture}',
                        style: GoogleFonts.playfairDisplay(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Perfect light: ${species.perfectLight}',
                        style: GoogleFonts.playfairDisplay(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Image.asset(
                  'images/leaf1inverted.png',
                  width: 100,
                  height: 100,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
