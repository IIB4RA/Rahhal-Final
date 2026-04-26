import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'details_page.dart';

class HotelsMapPage extends StatefulWidget {
  final List<dynamic> hotels;
  const HotelsMapPage({super.key, required this.hotels});

  @override
  State<HotelsMapPage> createState() => _HotelsMapPageState();
}

class _HotelsMapPageState extends State<HotelsMapPage> {
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  void _loadMarkers() {
    setState(() {
      _markers = widget.hotels.where((h) => h['latitude'] != null).map((hotel) {
        return Marker(
          markerId: MarkerId(hotel['id'].toString()),
          position: LatLng(
            double.parse(hotel['latitude'].toString()),
            double.parse(hotel['longitude'].toString()),
          ),
          infoWindow: InfoWindow(
            title: hotel['name_en'],
            snippet: "\$${hotel['price_per_night']} per night",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsPage(attraction: hotel),
                ),
              );
            },
          ),
        );
      }).toSet();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Nearby Hotels", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF8B2323),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _markers.isNotEmpty
              ? _markers.first.position
              : const LatLng(31.9539, 35.9106),
          zoom: 13,
        ),
        markers: _markers,
        myLocationEnabled: true,
        mapToolbarEnabled: true,
      ),
    );
  }
}
