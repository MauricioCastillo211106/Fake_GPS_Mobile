import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:trust_location/trust_location.dart';
import 'package:location_permissions/location_permissions.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _latitude = '0';
  String _longitude = '0';
  bool _isMockLocation = false;

  @override
  void initState() {
    super.initState();
    requestLocationPermission();
    // Iniciar la obtención de ubicación cada 5 segundos.
    TrustLocation.start(5);
    getLocation();
  }

  /// Método para obtener la ubicación.
  Future<void> getLocation() async {
    try {
      TrustLocation.onChange.listen((values) => setState(() {
        _latitude = values.latitude ?? '0'; // Asigna '0' si el valor es null
        _longitude = values.longitude ?? '0'; // Asigna '0' si el valor es null
        _isMockLocation = values.isMockLocation ?? false; // Asigna false si el valor es null
      }));
    } on PlatformException catch (e) {
      print('PlatformException $e');
    }
  }

  /// Solicitar permiso de ubicación en tiempo de ejecución.
  void requestLocationPermission() async {
    PermissionStatus permission =
    await LocationPermissions().requestPermissions();
    print('permissions: $permission');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Trust Location Detector'),
          backgroundColor: Colors.teal,
          leading: Icon(Icons.location_on),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Card(
                  elevation: 5,
                  color: Colors.white.withOpacity(0.9),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Mock Location Detected:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          _isMockLocation ? 'YES' : 'NO',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: _isMockLocation ? Colors.red : Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Card(
                  elevation: 5,
                  color: Colors.white.withOpacity(0.9),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Location Coordinates:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Latitude: $_latitude',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          'Longitude: $_longitude',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
