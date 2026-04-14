import 'package:flutter/material.dart';

class JordanPassPage extends StatelessWidget {
  const JordanPassPage({super.key});

  @override
  Widget build(BuildContext context) {
    
    const Color primaryBurgundy = Color(0xFF7A2021);
    const Color lightCream = Color(0xFFF9F4E8);
//Jordan Pass
    return Scaffold(
      backgroundColor: Colors.white,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Main Digital ID Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: primaryBurgundy,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("HASHEMITE KINGDOM OF JORDAN", style: TextStyle(color: Colors.white70, fontSize: 10, letterSpacing: 1.2)),
                          Text("Jordan Pass", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.shield, color: Colors.amber, size: 20),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Profile and Info Section
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          'https://via.placeholder.com/100', // Replace with user image asset
                          width: 80, height: 80, fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 15),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("FULL NAME", style: TextStyle(color: Colors.white70, fontSize: 10)),
                          Text("Abdullah Al-\nHashem", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text("PASSPORT NUMBER", style: TextStyle(color: Colors.white70, fontSize: 10)),
                          Text("Z12345678", style: TextStyle(color: Colors.white, fontSize: 14)),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 25),
                  // QR Scan Area
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D5A52), // Dark teal background from UI
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            color: Colors.white,
                            child: const Icon(Icons.qr_code_2, size: 80, color: Colors.black), // Replace with actual QR
                          ),
                          const SizedBox(height: 10),
                          const Text("SCAN FOR VERIFICATION", style: TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  // Status and Expiration
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("VISA STATUS", style: TextStyle(color: Colors.white70, fontSize: 10)),
                          Text("● ACTIVE / VALID", style: TextStyle(color: Colors.greenAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("EXPIRATION DATE", style: TextStyle(color: Colors.white70, fontSize: 10)),
                          Text("12 NOV 2025", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Action Buttons
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.wallet, color: Colors.white),
              label: const Text("Add to Wallet", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBurgundy,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 15),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.stars, color: primaryBurgundy),
              label: const Text("View Benefits", style: TextStyle(color: Colors.black87)),
              style: OutlinedButton.styleFrom(
                backgroundColor: lightCream,
                side: BorderSide.none,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 20),
            // Premium Traveler Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: const Row(
                children: [
                  CircleAvatar(backgroundColor: Color(0xFFF2E7E7), child: Icon(Icons.info_outline, color: primaryBurgundy)),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Rihla Premium Traveler", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("Priority entry at 40+ historical sites", style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
            ),
          ],
        ),
      ),
      // Simple Bottom Navigation matching the UI
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryBurgundy,
        unselectedItemColor: Colors.grey,
        currentIndex: 2, // Set to Jordan Pass
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), label: "Explore"),
          BottomNavigationBarItem(icon: Icon(Icons.card_membership), label: "Jordan Pass"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), label: "Bookings"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
        ],
      ),
    );
  }
}