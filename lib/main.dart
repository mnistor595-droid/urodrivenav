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
      localizationsDelegates: const [
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
  int _currentIndex = 2;
  String selectedVehicle = 'Camion';
  bool isProUnlocked = false;
  String selectedFilter = 'Combustibil';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getTabContent(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Hartă'),
          BottomNavigationBarItem(icon: Icon(Icons.bolt), label: 'Radare'),
          BottomNavigationBarItem(icon: Icon(Icons.local_shipping), label: 'TIR'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'PRO'),
        ],
      ),
    );
  }

  Widget _getTabContent() {
    switch (_currentIndex) {
      case 0:
        return _buildMapTab();
      case 1:
        return _buildRadarsTab();
      case 2:
        return _buildTirTab();
      case 3:
        return _buildProTab();
      default:
        return _buildTirTab();
    }
  }

  Widget _buildMapTab() {
    return Scaffold(
      appBar: AppBar(title: const Text('Hartă Navigație Europa')),
      body: Center(
        child: Text(
          'Profil activ: $selectedVehicle\nTraseu pregătit spre destinație',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  Widget _buildRadarsTab() {
    return Scaffold(
      appBar: AppBar(title: const Text('Alerte Radare și Blitzer')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(
            leading: Icon(Icons.warning, color: Colors.red),
            title: Text('Radar Fix la 500m'),
            subtitle: Text('Limită: 90 km/h • Drum European E81'),
          ),
          ListTile(
            leading: Icon(Icons.camera_alt, color: Colors.amber),
            title: Text('Control de viteză mobil'),
            subtitle: Text('Raportat acum 15 minute'),
          ),
        ],
      ),
    );
  }

  Widget _buildTirTab() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PROFIL CAMION'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettingsDialog('Setări Generale TIR'),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'TIR și servicii',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const Text('Planifică opriri fără să pierzi traseul principal.',
              style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 16),
          Card(
            color: Colors.blueGrey[800],
            child: ListTile(
              leading: const Icon(Icons.local_shipping, color: Colors.greenAccent, size: 36),
              title: const Text('Profil TIR activ', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Completează gabaritul pentru rutare specializată.'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showSettingsDialog('Configurare Gabarit Camion'),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildFilterChip('Parcări'),
              _buildFilterChip('Combustibil'),
              _buildFilterChip('Odihnă'),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            color: Colors.blueGrey[800],
            child: ListTile(
              leading: const CircleAvatar(backgroundColor: Colors.green, child: Text('P', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
              title: const Text('Parcări sigure'),
              subtitle: const Text('Locații cu rating comunitar și pază'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showInfoMessage('Se caută parcări sigure...'),
            ),
          ),
          Card(
            color: Colors.blueGrey[800],
            child: ListTile(
              leading: const Icon(Icons.local_gas_station, color: Colors.amber, size: 36),
              title: const Text('Combustibil și AdBlue'),
              subtitle: const Text('Stații accesibile pentru TIR cu benzi dedicate'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showInfoMessage('Se afișează benzinăriile compatibile...'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String title) {
    bool isSelected = selectedFilter == title;
    return ChoiceChip(
      label: Text(title),
      selected: isSelected,
      selectedColor: Colors.greenAccent,
      labelStyle: TextStyle(color: isSelected ? Colors.black : Colors.white),
      onSelected: (bool selected) {
        setState(() {
          selectedFilter = title;
        });
      },
    );
  }

  Widget _buildProTab() {
    return Scaffold(
      appBar: AppBar(title: const Text('Versiunea PRO')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star, size: 80, color: Colors.amber),
            const SizedBox(height: 16),
            const Text('EuroDrive PRO (9.99 EUR)', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text('Deblochează hărți offline pentru Europa, Rusia și Turcia.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
              onPressed: () {
                setState(() => isProUnlocked = true);
                _showInfoMessage('Versiunea PRO a fost activată!');
              },
              child: const Text('Activează / Cumpără PRO'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSettingsDialog(String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: const Text('Aici poți modifica setările avansate.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Închide')),
        ],
      ),
    );
  }

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }
}
