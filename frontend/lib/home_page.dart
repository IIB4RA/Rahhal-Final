import 'package:flutter/material.dart';
import 'all_services_page.dart';
import 'passport_scan_page.dart'; // Correctly imported
import 'personal_info_page.dart';
import 'main_wrapper.dart';
import 'custom_bottom_nav.dart';
import 'aiAssistant_page.dart';

void main() => runApp(const RahhalApp());

class RahhalApp extends StatelessWidget {
  const RahhalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: const Color(0xFF8B2323)),
      home: const UserTypePage(),
    );
  }
}

int _currentIndex = 0;

// --- USER TYPE PAGE ---
class UserTypePage extends StatelessWidget {
  const UserTypePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3E7),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Choose Your Profile",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8B2323)),
            ),
            const SizedBox(height: 30),
            _buildTypeButton(context, "Tourist", Icons.flight_takeoff),
            _buildTypeButton(context, "Resident", Icons.home_work),
            _buildTypeButton(context, "Operator", Icons.map),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeButton(BuildContext context, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        },
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 60),
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF1A237E),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }
}

// --- HOME PAGE ---
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3E7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back, color: Color(0xFF8B2323), size: 28),
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildHeroCard(context),
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Quick Services",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A237E)),
              ),
            ),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 2.2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: [
                _buildServiceCard("Visa Application", "Apply Now",
                    Icons.description, Colors.red[900]!),
                _buildServiceCard("Plan Your Trip", "With AI",
                    Icons.grid_view_rounded, Colors.blue[900]!, onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AIChatScreen()),
                  );
                }),
                _buildServiceCard("Book", "Hotels & Destinations",
                    Icons.location_on, Colors.teal),
                _buildServiceCard("Digital Permit", "Unified QR Code",
                    Icons.qr_code_2, Colors.orange[800]!),
              ],
            ),
            const SizedBox(height: 20),
            _buildViewAllButton(context),
            const SizedBox(height: 40),
            const Text(
              "How does the system work?",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A237E)),
            ),
            const Text("A smooth experience from start to finish",
                style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            _buildStepRow(
                "1",
                "Before Arrival",
                "Apply for your visa, plan your trip, and book hotels.",
                const Color(0xFF8B2323)),
            _buildStepRow(
                "2",
                "During Your Visit",
                "Use the digital QR permit and the interactive map.",
                const Color(0xFFCD853F)),
            _buildStepRow(
                "3",
                "After Departure",
                "Share your experience and receive your certificate.",
                const Color(0xFF2F3E46)),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 0),
    );
  }

  Widget _buildHeroCard(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: AssetImage('assets/images/homePageImage.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.black.withOpacity(0.29),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome to Your Travel Journey",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PassportScanPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF8B2323),
                elevation: 2,
              ),
              child: const Text("Start Your Journey Now →"),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(
      String title, String subtitle, IconData icon, Color color,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.bold)),
                  Text(subtitle,
                      style: TextStyle(fontSize: 8, color: Colors.red[900])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewAllButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const ServicesScreen()));
      },
      icon: const Icon(Icons.arrow_forward_rounded, size: 18),
      label: const Text("View All Services"),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1E213A),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
    );
  }

  Widget _buildStepRow(String number, String title, String desc, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(40)),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color,
              radius: 18,
              child: Text(number, style: const TextStyle(color: Colors.white)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color,
                          fontSize: 14)),
                  Text(desc,
                      style:
                          const TextStyle(fontSize: 11, color: Colors.black54)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
