import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  
  final Map<String, dynamic> attraction; 

  const DetailsPage({super.key, required this.attraction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4E9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF8B2323), size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Rahhal – Heritage Guide",
          style: TextStyle(
            color: Color(0xFF8B2323),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                _buildHeader(context),
                
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRatingRow(),
                      const SizedBox(height: 16),
                      Text(
                        attraction['description'],
                        style: const TextStyle(height: 1.5, fontSize: 14),
                      ),
                      const SizedBox(height: 20),
                      _buildInfoCards(),
                      const SizedBox(height: 24),
                      const Text("Location", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      _buildMapPlaceholder(),
                      const SizedBox(height: 24),
                      _buildBookButton(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          attraction['image'], 
          height: 400, width: double.infinity, fit: BoxFit.cover
        ),
        // Back Button
        Positioned(
          top: 50, left: 16,
          child: CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.7),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        // Share Button
        Positioned(
          top: 50, right: 16,
          child: CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.7),
            child: const Icon(Icons.share, color: Colors.black, size: 20),
          ),
        ),
        
        Positioned(
          bottom: 30, left: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFF702632), borderRadius: BorderRadius.circular(4)),
                child: const Text("WORLD HERITAGE", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              Text(attraction['name'], style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
              Row(children: [const Icon(Icons.location_on, color: Colors.white, size: 16), Text(attraction['location'], style: const TextStyle(color: Colors.white))]),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildRatingRow() {
    return Row(
      children: [
        ...List.generate(5, (index) => const Icon(Icons.star, color: Colors.amber, size: 20)),
        const SizedBox(width: 8),
        Text("${attraction['rating']} (12k reviews)", style: const TextStyle(fontWeight: FontWeight.bold)),
        const Spacer(),
        const Icon(Icons.bookmark_border, size: 28),
      ],
    );
  }

  Widget _buildInfoCards() {
    return Row(
      children: [
        _infoBox(Icons.access_time, "VISITING HOURS", "06:00 AM - 06:00 PM"),
        const SizedBox(width: 12),
        _infoBox(Icons.confirmation_number_outlined, "ENTRY PRICE", "50 JOD / \$70 USD"),
      ],
    );
  }

  Widget _infoBox(IconData icon, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFFD9D9C3), borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [Icon(icon, size: 14), const SizedBox(width: 4), Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold))]),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildMapPlaceholder() {
    return Container(
      height: 150, width: double.infinity,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), image: const DecorationImage(image: NetworkImage('https://via.placeholder.com/400x150'), fit: BoxFit.cover)),
      child: Center(child: ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.navigation), label: const Text("Navigate"), style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black))),
    );
  }

  Widget _buildBookButton() {
    return SizedBox(
      width: double.infinity, height: 56,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF702632), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        child: const Text("Book Experience", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}