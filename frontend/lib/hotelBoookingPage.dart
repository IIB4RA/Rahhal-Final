import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HotelBookingPage extends StatefulWidget {
  const HotelBookingPage({super.key});

  @override
  State<HotelBookingPage> createState() => _HotelBookingPageState();
}

class _HotelBookingPageState extends State<HotelBookingPage> {
  static const Color primaryBurgundy = Color(0xFF7A2021);
  static const Color backgroundCream = Color(0xFFF1F4E8);

  // دالة جلب البيانات من Django API
  Future<List<dynamic>> fetchHotels() async {
    // ملاحظة: استبدل YOUR_SERVER_IP بـ 10.0.2.2 إذا كنت تستخدم المحاكي (Emulator)
    const String apiUrl = 'http://10.0.2.2:8000/api/hotels/'; 
    
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        // تحويل النص القادم (JSON) إلى قائمة
        return json.decode(utf8.decode(response.bodyBytes)); 
      } else {
        throw Exception('فشل في تحميل الفنادق من السيرفر');
      }
    } catch (e) {
      throw Exception('تأكد من تشغيل سيرفر Django: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundCream,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: fetchHotels(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: primaryBurgundy));
                } else if (snapshot.hasError) {
                  return Center(child: Text("خطأ: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("لا توجد فنادق مضافة حالياً"));
                }

                final hotels = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: hotels.length + 1, // +1 من أجل الخريطة في البداية
                  itemBuilder: (context, index) {
                    if (index == 0) return _buildMapPreview();
                    
                    final hotel = hotels[index - 1];
                    return _buildHotelCard(
                      title: hotel['name'] ?? 'بدون اسم',
                      location: hotel['location'] ?? 'غير محدد',
                      price: hotel['price'].toString(),
                      rating: hotel['rating']?.toString() ?? '0.0',
                      reviews: hotel['reviews_count']?.toString() ?? '0',
                      distance: hotel['distance'] ?? 'قريب منك',
                      imageUrl: hotel['image_url'] ?? 'https://via.placeholder.com/150',
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- Widgets البناء ---

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: backgroundCream,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: Column(
        children: const [
          Text("Rihla Stays", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
          Text("Jordan Heritage Hotels", style: TextStyle(color: primaryBurgundy, fontSize: 12)),
        ],
      ),
      centerTitle: true,
      actions: [
        IconButton(icon: const Icon(Icons.search, color: Colors.black), onPressed: () {}),
      ],
    );
  }

  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          _buildFilterButton(Icons.tune, "Filters", isSelected: true),
          const SizedBox(width: 8),
          _buildDropdownFilter("Price"),
          const SizedBox(width: 8),
          _buildDropdownFilter("Rating"),
        ],
      ),
    );
  }

  Widget _buildFilterButton(IconData icon, String label, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? primaryBurgundy : Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: isSelected ? Colors.white : Colors.black),
          const SizedBox(width: 5),
          Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildDropdownFilter(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontSize: 12)),
          const Icon(Icons.keyboard_arrow_down, size: 16),
        ],
      ),
    );
  }

  Widget _buildMapPreview() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: const DecorationImage(
          image: NetworkImage("https://www.google.com/maps/d/u/0/thumbnail?mid=1_75Z9yLq_x-2E8H9m8Lp0G1v8I8"), 
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.map, size: 16, color: primaryBurgundy),
              SizedBox(width: 5),
              Text("View Map", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHotelCard({
    required String title,
    required String location,
    required String price,
    required String rating,
    required String reviews,
    required String distance,
    required String imageUrl,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.network(imageUrl, height: 180, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text("\$$price", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryBurgundy)),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    Text(" $rating ($reviews reviews) • $location", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("📍 $distance from you", style: const TextStyle(fontSize: 11, color: Colors.black54)),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: primaryBurgundy, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      child: const Text("Book Now", style: TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}