import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
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
  
 
  final String apiUrl = 'http://10.0.2.2:8000/api/locations/'; 

  @override
  void initState() {
    super.initState();
    fetchPlaces(); 
  }

  //DATABASE FUNCTIONS

  //  GET
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

  // POST
  Future<void> _saveLocationToDatabase(LatLng point) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "title": "Jordan Location", 
          "latitude": point.latitude,
          "longitude": point.longitude,
          "description": "Location added from Interactive Map",
        }),
      );

      if (response.statusCode == 201) {
        debugPrint("Saved to Database!");
        fetchPlaces(); 
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

  // UI BUILD 

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
            
            userAgentPackageName: 'com.rahhal.jordan_map', 
          ),
          MarkerLayer(markers: markers),
        ],
      ),
    );
  }
}

