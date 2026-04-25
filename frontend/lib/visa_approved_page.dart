import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/visa_application_provider.dart';
import 'digitalPass.dart';

class VisaApprovedPage extends StatelessWidget {
  const VisaApprovedPage({super.key});

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "PENDING";
    try {
      DateTime date = DateTime.parse(dateStr);
      List<String> months = [
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec"
      ];
      return "${months[date.month - 1]} ${date.day}, ${date.year}";
    } catch (e) {
      return "PENDING";
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryRed = Color(0xFF7B2027);

    final visaProvider = Provider.of<VisaApplicationProvider>(context);

    String dynamicIssueDate = _formatDate(visaProvider.arrivalDate);

    String passportSuffix = visaProvider.passportNumber != null &&
            visaProvider.passportNumber!.length > 2
        ? visaProvider.passportNumber!
            .substring(visaProvider.passportNumber!.length - 2)
        : "XX";
    String dynamicReferenceNo = "JOR-99210-$passportSuffix".toUpperCase();

    return Scaffold(
      backgroundColor: primaryRed,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Application Status",
            style: TextStyle(color: Colors.white, fontSize: 16)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            //green Icon
            const CircleAvatar(
              radius: 45,
              backgroundColor: Color(0xFF4ADE80),
              child: Icon(Icons.check, color: Colors.white, size: 50),
            ),
            const SizedBox(height: 20),
            const Text(
              "Visa Approved",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Congratulations! Your entry visa for the\nHashemite Kingdom of Jordan is ready.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 30),

            // Visa details card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("OFFICIAL DOCUMENT",
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey)),
                          Text("Jordanian Entry Visa",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Image.network('https://flagcdn.com/w80/jo.png',
                          width: 40), // Jordanian flag
                    ],
                  ),
                  const Divider(height: 30),
                  Row(
                    children: [
                      _buildInfoItem("Validity", "30 Days"),
                      _buildInfoItem("Visa Type", "Tourist / Single Entry"),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      _buildInfoItem("Issue Date", dynamicIssueDate),
                      _buildInfoItem("Reference No.", dynamicReferenceNo),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const JordanPassPage()),
                        );
                      },
                      icon: const Icon(Icons.remove_red_eye_outlined,
                          size: 18, color: primaryRed),
                      label: const Text("View Digital Visa",
                          style: TextStyle(color: primaryRed)),
                      style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFE0E0E0))),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Jordan Pass card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFDF8F0),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Icon(Icons.confirmation_number_outlined,
                          color: Colors.orange),
                      SizedBox(width: 10),
                      Text("Jordan Pass",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: primaryRed)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Bundle your visa with entry to 40+ attractions including Petra, Wadi Rum, and more for a better experience.",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const JordanPassPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: primaryRed,
                      minimumSize: const Size(double.infinity, 45),
                      elevation: 0,
                      side: const BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    child: const Text("Generate Jordan Pass"),
                  )
                ],
              ),
            ),

            const SizedBox(height: 30),

            // back to homePage
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF7B2027),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  "Back to Home",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 20),
            const Text("Having trouble? Contact Rihla Support",
                style: TextStyle(color: Colors.white70, fontSize: 10)),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          Text(value,
              style:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// الكلاس الثاني الخاص بالتنقل
class VisaApprovedPageWithNav extends StatelessWidget {
  const VisaApprovedPageWithNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7B2027),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Application Status",
            style: TextStyle(color: Colors.white, fontSize: 16)),
      ),
      body: const VisaApprovedPage(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF8B2323),
        unselectedItemColor: Colors.grey,
        currentIndex: 3,
        onTap: (index) => Navigator.pushReplacementNamed(context, '/services'),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined), label: "Explore"),
          BottomNavigationBarItem(
              icon: Icon(Icons.badge_outlined), label: "Pass"),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined), label: "Services"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: "Profile"),
        ],
      ),
    );
  }
}
