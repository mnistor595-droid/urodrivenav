import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    runApp(const EuroDriveApp());
  }, (error, stackTrace) {
    runApp(MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.red[900],
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Text(
                'Eroare la pornire:\n$error',
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    ));
  });
}

class EuroDriveApp extends StatelessWidget {
  const EuroDriveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EuroDrive Nav & Radar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: const DashboardScreen(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ro', 'RO'),
        Locale('en', 'US'),
        Locale('ru', 'RU'),
        Locale('tr', 'TR'),
      ],
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String selectedVehicle = 'Camion / Rulotă';
  bool isProUnlocked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EuroDrive (Europa, RU, TR)'),
        actions: [
          IconButton(
            icon: Icon(Icons.star, color: isProUnlocked ? Colors.amber : Colors.grey),
            onPressed: _showMonetizationDialog,
          )
        ],
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.blueGrey[900],
            child: Center(
              child: Text(
                'Profil activ: $selectedVehicle\nHarta Europa / Rusia / Turcia pregătită',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 18),
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildVehicleChip('Auto', Icons.directions_car),
                _buildVehicleChip('Rulotă', Icons.rv_hookup),
                _buildVehicleChip('Camion', Icons.local_shipping),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning, color: Colors.white, size: 28),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Alerta Blitzer: Radar Fix la 500m',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleChip(String title, IconData icon) {
    bool isSelected = selectedVehicle == title;
    return ChoiceChip(
      avatar: Icon(icon, color: isSelected ? Colors.white : Colors.grey),
      label: Text(title),
      selected: isSelected,
      selectedColor: Colors.blue,
      onSelected: (bool selected) {
        setState(() {
          selectedVehicle = title;
        });
      },
    );
  }

  void _showMonetizationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Versiunea PRO (9.99 EUR)'),
        content: const Text('Deblochează rute dedicate pentru camioane/rulote și hărți offline complet detaliate.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Anulare')),
          ElevatedButton(
            onPressed: () {
              setState(() => isProUnlocked = true);
              Navigator.pop(context);
            },
            child: const Text('Cumpără'),
          ),
        ],
      ),
    );
  }
}
