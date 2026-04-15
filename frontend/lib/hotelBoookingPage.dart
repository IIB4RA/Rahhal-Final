
import 'package:flutter/material.dart';
import 'models/hotel_model.dart';

class HotelBookingScreen extends StatelessWidget {
  const HotelBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // will replace this with API call 
    final List<Hotel> hotels = [
      Hotel(
        id: "1",
        name: "Al Maha Luxury Resort",
        location: "Downtown",
        rating: 4.9,
        reviews: 1240,
        price: "420",
        distance: "0.8 km from you",
        imageUrl: "https://images.unsplash.com/photo-1566073771259-6a8506099945",
      ),
      Hotel(
        id: "2",
        name: "Urban Oasis Suites",
        location: "Business Bay",
        rating: 4.7,
        reviews: 850,
        price: "215",
        distance: "2.4 km from you",
        imageUrl: "https://images.unsplash.com/photo-1582719478250-c89cae4dc85b",
      ),
      Hotel(
        id: "3",
        name: "The Palm Marina Hotel",
        location: "Palm Jumeirah",
        rating: 4.8,
        reviews: 2100,
        price: "385",
        distance: "5.1 km from you",
        imageUrl: "https://images.unsplash.com/photo-1542314831-068cd1dbfeeb",
        isTopRated: true,
      ),
    ];

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
            Text("Rihla Stays", style: TextStyle(color: Color(0xFF702632), fontWeight: FontWeight.bold)),
            Text("Jordan", style: TextStyle(color: Colors.brown, fontSize: 12)),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search, color: Color(0xFF702632))),
        ],
      ),
      body: Column(
        children: [
          _buildFilters(),
          _buildMiniMap(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: hotels.length,
              itemBuilder: (context, index) => _buildHotelCard(hotels[index]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: const Color(0xFF702632), borderRadius: BorderRadius.circular(8)),
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
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
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
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.map_outlined, size: 16),
              SizedBox(width: 4),
              Text("View Map", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHotelCard(Hotel hotel) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(hotel.imageUrl, height: 200, width: double.infinity, fit: BoxFit.cover),
              ),
              if (hotel.isTopRated)
                Positioned(
                  top: 12, left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFF702632), borderRadius: BorderRadius.circular(4)),
                    child: const Text("TOP RATED", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
              const Positioned(
                top: 12, right: 12,
                child: CircleAvatar(backgroundColor: Colors.white, radius: 15, child: Icon(Icons.favorite_border, size: 18, color: Colors.black)),
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
                    Text(hotel.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text("\$${hotel.price}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF702632))),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${hotel.rating} (${hotel.reviews} reviews) • ${hotel.location}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    const Text("per night", style: TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [const Icon(Icons.location_on_outlined, size: 16, color: Colors.brown), Text(hotel.distance, style: const TextStyle(fontSize: 11))]),
                    ElevatedButton(
                      onPressed: () {}, // ask bara if ther is a booking detail/checkout page
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF702632), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      child: const Text("Book Now", style: TextStyle(color: Colors.white)),
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
      selectedItemColor: const Color(0xFF702632),
      currentIndex: 0,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Explore"),
        BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: "Saved"),
        BottomNavigationBarItem(icon: Icon(Icons.business_center_outlined), label: "Bookings"),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
      ],
    );
  }
}