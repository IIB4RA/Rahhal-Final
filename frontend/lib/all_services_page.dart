import 'package:flutter/material.dart';

// DATA MODEL (Backend Structure)
class UserServiceData {
  final String name;
  final String validity;
  final String qrData;

  UserServiceData({
    required this.name,
    required this.validity,
    required this.qrData,
  });
}

// MAIN SCREEN 
class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
 
  int _currentIndex = 3; 

   // Simulated Backend Data ** we will replace it
  late UserServiceData userData;

  @override
  void initState() {
    super.initState();
    userData = UserServiceData(
      name: "Alex Johnson",
      validity: "12 Months",
      qrData: "REF_0987654321",
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryRed = Color(0xFF8B2323);
    const Color bgColor = Color(0xFFF2F4E8);

    return Scaffold(
      backgroundColor: bgColor,
     appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color.fromRGBO(122, 31, 44, 1), size: 28),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text(
          "All Services",
          style: TextStyle(
            color: Color.fromRGBO(122, 31, 44, 1),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
     body: _currentIndex != 3 
          ? Center(child: Text("Page Index: $_currentIndex")) // Placeholder for other pages
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  HeritageCard(data: userData),
                  const SizedBox(height: 30),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Main Services",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 4,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.7,
                    children: [
                      
                      _buildServiceIcon(context, Icons.description_outlined, "Visa Application", const VisaPage()),
                      _buildServiceIcon(context, Icons.confirmation_number_outlined, "Jordan Pass", const JordanPassPage()),
                      _buildServiceIcon(context, Icons.psychology_outlined, "AI Planner", const AIPlannerPage()),
                      _buildServiceIcon(context, Icons.map_outlined, "Smart Map", const MapPage()),
                      _buildServiceIcon(context, Icons.temple_buddhist_outlined, "Explore", const ExplorePage()),
                      _buildServiceIcon(context, Icons.hotel_outlined, "Hotels", const HotelPage()),
                      _buildServiceIcon(context, Icons.directions_car_outlined, "Transport", const TransportPage()),
                      _buildServiceIcon(context, Icons.medical_services_outlined, "SOS Help", const SOSPage()),
                    ],
                  ),
                ],
              ),
            ),
      //nav buttons
     bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryRed,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex, 
        onTap: (index) {
         
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home",),
          BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), label: "Explore"),
          BottomNavigationBarItem(icon: Icon(Icons.badge_outlined), label: "Jordan Pass"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), label: "Services"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
        ],
      ),
    );
  }

  // To BUILD ICONS 
  Widget _buildServiceIcon(BuildContext context, IconData icon, String label, Widget destination) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => destination)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, 2))],
            ),
            child: Icon(icon, color: const Color(0xFF8B2323), size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

// REUSABLE CARD COMPONENT 
class HeritageCard extends StatelessWidget {
  final UserServiceData data;
  const HeritageCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF8B2323), Color(0xFF5A1010)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Heritage Explorer", style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold)),
              Text("Validity: ${data.validity}", style: TextStyle(color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 40),
              const Text("ACCOUNT HOLDER", style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold)),
              Text(data.name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)),
            ],
          ),
        
          Positioned(
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                
                color: const Color(0xFF233A2E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white, width: 2),
              ),
              
              child: const Icon(Icons.qr_code_2, color: Colors.white, size: 45),
              
            ),
          ),
          Positioned(
           
            right: 0,
            bottom: 0,
            child: const CircleAvatar(
              radius: 12,
              backgroundColor: Colors.white12,
              child: Text("JO", style: TextStyle(color: Colors.white, fontSize: 8)),
            ),
          ),
        ],
      ),
    );
  }
}

// connect services with pages
class VisaPage extends StatelessWidget { const VisaPage({super.key}); @override Widget build(BuildContext context) => const Scaffold(body: Center(child: Text("Visa Page"))); }
class JordanPassPage extends StatelessWidget { const JordanPassPage({super.key}); @override Widget build(BuildContext context) => const Scaffold(body: Center(child: Text("Jordan Pass Page")));
 }
class AIPlannerPage extends StatelessWidget { const AIPlannerPage({super.key}); @override Widget build(BuildContext context) => const Scaffold(body: Center(child: Text("AI Planner Page"))); }
class MapPage extends StatelessWidget { const MapPage({super.key}); @override Widget build(BuildContext context) => const Scaffold(body: Center(child: Text("Map Page"))); }
class ExplorePage extends StatelessWidget { const ExplorePage({super.key}); @override Widget build(BuildContext context) => const Scaffold(body: Center(child: Text("Explore Page"))); }
class HotelPage extends StatelessWidget { const HotelPage({super.key}); @override Widget build(BuildContext context) => const Scaffold(body: Center(child: Text("Hotel Page"))); }
class TransportPage extends StatelessWidget { const TransportPage({super.key}); @override Widget build(BuildContext context) => const Scaffold(body: Center(child: Text("Transport Page"))); }
class SOSPage extends StatelessWidget { const SOSPage({super.key}); @override Widget build(BuildContext context) => const Scaffold(body: Center(child: Text("SOS Page"))); }