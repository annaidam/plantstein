import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:onboarding/onboarding.dart';
import 'package:plant_stein/loading_page.dart';
import 'package:plant_stein/plant_catalogue.dart';
import 'package:plant_stein/pot_details_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'insert_test_data.dart';
import 'onboarding.dart';
import 'room_page.dart';

Future<void> setup() async {
  await dotenv.load(fileName: ".env");

  // if in debug mode, insert test data
  if (dotenv.env['TEST_DATA'] == 'true') {
    insertTestData();
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: FutureBuilder(
          future: setup(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done)
              return SplashScreen();
            return Container();
          }),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int currentPage = 0;

  final screens = [
    RoomPage(),
    PlantCatalogue(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          toolbarHeight: 100,
          title: Image.asset(
            'images/logo.png',
            fit: BoxFit.contain,
            height: 70,
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFFEBEDEB),
        ),
        // body: const PotDetails(1)
        body: screens[currentPage],
        backgroundColor: const Color(0xFFEBEDEB),
        bottomNavigationBar: BottomNavigationBar(
          // currentIndex: currentPage,
          onTap: (index) => {
            setState(() {
              currentPage = index;
            })
          },

          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('images/home.png'),
                  color: Color(0xFF5F725F)),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('images/catalogue.png'),
                  color: Color(0xFF5F725F)),
              label: '',
            ),
          ],
        ));
    ;
  }
}
