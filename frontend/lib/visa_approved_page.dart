import 'package:flutter/material.dart';
import 'digitalPass.dart';

class VisaApprovedPage extends StatelessWidget {
  // variable fill from backend
  final String referenceNo;
  final String issueDate;
  final String expiryDate;

  const VisaApprovedPage({
    super.key,
    // Default values ​​
    this.referenceNo = "JOR-99210-AS",
    this.issueDate = "Oct 24, 2023",
    this.expiryDate = "Nov 24, 2023",
  });

  @override
  Widget build(BuildContext context) {
    const primaryRed = Color(0xFF7B2027);

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
                      _buildInfoItem("Issue Date", issueDate), // from backend
                      _buildInfoItem(
                          "Reference No.", referenceNo), // from backend
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      //
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
            const Text("Having trouble? Contact Rihla Support",
                style: TextStyle(color: Colors.white70, fontSize: 10)),
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

class VisaApprovedPageWithNav extends StatelessWidget {
  final String referenceNo;
  final String issueDate;
  final String expiryDate;

  const VisaApprovedPageWithNav({
    super.key,
    this.referenceNo = "JOR-99210-AS",
    this.issueDate = "Oct 24, 2023",
    this.expiryDate = "Nov 24, 2023",
  });

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
      body: VisaApprovedPage(
          referenceNo: referenceNo,
          issueDate: issueDate,
          expiryDate: expiryDate),
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
