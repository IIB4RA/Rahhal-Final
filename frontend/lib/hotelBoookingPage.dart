import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

import 'api_service.dart';

class HotelBookingScreen extends StatelessWidget {
  const HotelBookingScreen({super.key});

 Future<dynamic> fetchHotels() async {
    try {
      final data = await ApiService().request(
        method: 'GET',
        endpoint: '/tourism/hotel/', 
        requiresAuth: true,
      );
      return data;
      } catch (e) {
        print("Backend Connection Error: $e");
        throw e;
       }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
    future: fetchHotels(), 
    builder: (context, snapshot) {
      
      // While waiting for the backend
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      if (snapshot.hasError) {
        return Scaffold(
            body: Center(child: Text("Error loading hotels: ${snapshot.error}")));
      }

      final data = snapshot.data;
      List<dynamic> hotelsList = [];

      // Extract the data (the 'body')
      if (data is List) {
        hotelsList = data;
      } else if (data is Map && data.containsKey('results')) {
        hotelsList = data['results'] as List<dynamic>;
      }

  if (hotelsList.isEmpty) {
    return const Scaffold(body: Center(child: Text("No hotels available")));
  }
      


    return Scaffold(
      backgroundColor: const Color(0xFFE7E9D3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF702632)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: const [
            Text("Rihla Stays",
                style: TextStyle(
                    color: Color(0xFF702632), fontWeight: FontWeight.bold)),
            Text("Jordan", style: TextStyle(color: Colors.brown, fontSize: 12)),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search, color: Color(0xFF702632))),
        ],
      ),
      body: Column(
        children: [
          _buildFilters(),
          _buildMiniMap(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: hotelsList.length,
              itemBuilder: (context, index) {
                final hotelMap = hotelsList[index] as Map<String, dynamic>;
                return _buildHotelCard(hotelMap);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
    }
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: const Color(0xFF702632),
                borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.tune, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 8),
          _filterChip("Price Range"),
          const SizedBox(width: 8),
          _filterChip("Rating"),
        ],
      ),
    );
  }

  Widget _filterChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontSize: 12)),
          const Icon(Icons.keyboard_arrow_down, size: 16),
        ],
      ),
    );
  }

  Widget _buildMiniMap() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 80,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: const DecorationImage(
          image: NetworkImage("https://via.placeholder.com/400x80"),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.map_outlined, size: 16),
              SizedBox(width: 4),
              Text("View Map",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHotelCard(Map<String, dynamic> hotel) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  hotel['imageUrl'] ?? 'https://via.placeholder.com/400x200?text=No+Image',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                  ),
                ),
              ),
              if (hotel['stars'] == true)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        color: const Color(0xFF702632),
                        borderRadius: BorderRadius.circular(4)),
                    child: const Text("TOP RATED",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              const Positioned(
                top: 12,
                right: 12,
                child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 15,
                    child: Icon(Icons.favorite_border,
                        size: 18, color: Colors.black)),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(hotel['name_en'] ?? 'Unknown Hotel',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text("\$${hotel['price_per_night'] ?? '0'}",
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF702632))),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        "${hotel['rating'] ?? '0'} (${hotel['reviews'] ?? '0'} reviews) • ${hotel['location'] ?? 'Unknown Location'}",
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey)),
                    const Text("per night",
                        style: TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      const Icon(Icons.location_on_outlined,
                          size: 16, color: Colors.brown),
                      Text(hotel['distance'] ?? 'Distance N/A',
                          style: const TextStyle(fontSize: 11))
                    ]),
                    ElevatedButton(
                      onPressed:
                          () {}, // ask bara if ther is a booking detail/checkout page
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF702632),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                      child: const Text("Book Now",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF8B2323),
      unselectedItemColor: Colors.grey,
      currentIndex: 3,
      onTap: (index) {},
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
        BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined), label: "Explore"),
        BottomNavigationBarItem(
            icon: Icon(Icons.badge_outlined), label: "Pass"),
        BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined), label: "Services"),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outline), label: "Profile"),
      ],
    );
  }
}