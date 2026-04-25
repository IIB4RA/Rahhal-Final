import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/visa_application_provider.dart';
import 'aiAssistant_page.dart';
import 'explorPage.dart';
import 'hotelBoookingPage.dart';
import 'passport_scan_page.dart';
import 'visa_approved_page.dart';
import 'profile.dart';
import 'user_type_page.dart';
import 'custom_bottom_nav.dart';
import 'interactiveMap.dart';

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

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final int _currentIndex = 3;

  @override
  Widget build(BuildContext context) {
    const Color bgColor = Color(0xFFF2F4E8);

    // سحب البيانات من الـ Provider
    final visaData = Provider.of<VisaApplicationProvider>(context);
    final displayName = visaData.fullName ?? "Guest User";
    final passportNo = visaData.passportNumber ?? "0000000";

    final userData = UserServiceData(
      name: displayName.toUpperCase(),
      validity: "12 Months",
      qrData: "REF_$passportNo", // ربطنا الـ QR برقم الجواز عشان يكون حقيقي
    );

    return Scaffold(
      backgroundColor: bgColor,
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
          "All Services",
          style: TextStyle(
            color: Color(0xFF8B2323),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _buildBody(userData),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 3),
    );
  }

  Widget _buildBody(UserServiceData userData) {
    if (_currentIndex != 3) {
      return Center(
        child: Text(
          "Content for Tab Index $_currentIndex Coming Soon",
          style: const TextStyle(color: Colors.grey),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          HeritageCard(data: userData),
          const SizedBox(height: 30),
          const Text(
            "Main Services",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
              _buildServiceIcon(context, Icons.description_outlined, "Visa",
                  const VisaApprovedPage()),
              _buildServiceIcon(context, Icons.confirmation_number_outlined,
                  "Jordan Pass", const PassportScanPage()),
              _buildServiceIcon(context, Icons.psychology_outlined,
                  "AI Planner", const AIChatScreen()),
              _buildServiceIcon(
                  context, Icons.map_outlined, "Smart Map", const MapScreen()),
              _buildServiceIcon(context, Icons.temple_buddhist_outlined,
                  "Explore", const ExploreScreen()),
              _buildServiceIcon(context, Icons.hotel_outlined, "Hotels",
                  const HotelBookingScreen()),
              //_buildServiceIcon(context, Icons.directions_car_outlined,
              //   "Transport", const TransportPage()),
              // _buildServiceIcon(context, Icons.medical_services_outlined,
              //   "SOS Help", const SOSPage()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceIcon(
      BuildContext context, IconData icon, String label, Widget destination) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => destination),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
              ],
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
              const Text("Heritage Explorer",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold)),
              Text("Validity: ${data.validity}",
                  style: const TextStyle(color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 40),
              const Text("ACCOUNT HOLDER",
                  style: TextStyle(
                      color: Colors.white54,
                      fontSize: 10,
                      fontWeight: FontWeight.bold)),
              Text(
                data.name,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
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
          const Positioned(
            right: 0,
            bottom: 0,
            child: CircleAvatar(
              radius: 12,
              backgroundColor: Colors.white12,
              child: Text("JO",
                  style: TextStyle(color: Colors.white, fontSize: 8)),
            ),
          ),
        ],
      ),
    );
  }
}
