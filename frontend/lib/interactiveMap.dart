import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http; // Don't forget to add http to pubspec.yaml
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<Marker> markers = [];
  
  // NOTE: If using Android Emulator, use 10.0.2.2. 
  // If using a real phone, use your Computer's Local IP (e.g., 192.168.1.5)
  final String apiUrl = 'http://10.0.2.2:8000/api/locations/'; 

  @override
  void initState() {
    super.initState();
    fetchPlaces(); // Load existing markers from Django when app starts
  }

  // --- DATABASE FUNCTIONS ---

  // 1. GET: Load markers from Django
  Future<void> fetchPlaces() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          markers = data.map((place) {
            return Marker(
              width: 40,
              height: 40,
              point: LatLng(place['latitude'], place['longitude']),
              child: GestureDetector(
                onTap: () => _showPlaceInfo(place['title']),
                child: const Icon(Icons.location_on, color: Colors.red, size: 40),
              ),
            );
          }).toList();
        });
      }
    } catch (e) {
      debugPrint("Error fetching data: $e");
    }
  }

  // 2. POST: Save the tap location to Django
  Future<void> _saveLocationToDatabase(LatLng point) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "title": "Jordan Location", // You can later add a TextField to change this
          "latitude": point.latitude,
          "longitude": point.longitude,
          "description": "Location added from Interactive Map",
        }),
      );

      if (response.statusCode == 201) {
        debugPrint("Saved to Database!");
        fetchPlaces(); // Refresh the map to show the new marker
      }
    } catch (e) {
      debugPrint("Error saving location: $e");
    }
  }

  void _showPlaceInfo(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Place: $title")),
    );
  }

  // --- UI BUILD ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jordan Interactive Map"),
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            onPressed: fetchPlaces, 
            icon: const Icon(Icons.refresh)
          )
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: const LatLng(31.9539, 35.9106), // Amman Center
          initialZoom: 13,
          onTap: (tapPosition, point) {
            _saveLocationToDatabase(point); // Save to Django on tap
          },
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            // FIX FOR 403 ERROR: Identifying the app to OpenStreetMap
            userAgentPackageName: 'com.rahhal.jordan_map', 
          ),
          MarkerLayer(markers: markers),
        ],
      ),
    );
  }
}