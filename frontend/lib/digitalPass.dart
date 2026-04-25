import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:provider/provider.dart';
import 'providers/visa_application_provider.dart';

class JordanPassPage extends StatefulWidget {
  const JordanPassPage({super.key});

  @override
  State<JordanPassPage> createState() => _JordanPassPageState();
}

class _JordanPassPageState extends State<JordanPassPage> {
  String _getFormattedExpiry(String? arrivalDateStr) {
    if (arrivalDateStr == null || arrivalDateStr.isEmpty) return "NOT SET";
    try {
      DateTime arrival = DateTime.parse(arrivalDateStr);
      DateTime expiry = arrival.add(const Duration(days: 30));

      List<String> months = [
        "JAN",
        "FEB",
        "MAR",
        "APR",
        "MAY",
        "JUN",
        "JUL",
        "AUG",
        "SEP",
        "OCT",
        "NOV",
        "DEC"
      ];

      return "${expiry.day} ${months[expiry.month - 1]} ${expiry.year}";
    } catch (e) {
      return "PENDING";
    }
  }

  void _showExpandedQrDialog(BuildContext context, String qrData) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Jordan Pass QR",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8B2323))),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: QrImageView(
                    data: qrData,
                    version: QrVersions.auto,
                    size: 250.0,
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.zero,
                    errorCorrectionLevel: QrErrorCorrectLevel.M,
                  ),
                ),
                const SizedBox(height: 10),
                const Text("Scan this code at the gate.",
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBurgundy = Color(0xFF7A2021);
    const Color lightCream = Color(0xFFF9F4E8);

    final visaProvider = Provider.of<VisaApplicationProvider>(context);

    String displayName = visaProvider.fullName ?? "GUEST TRAVELER";
    String displayPassport = visaProvider.passportNumber ?? "-------";
    String dynamicQrData = "RAHHAL-PASS-$displayPassport-VALID";
    String expiryDate = _getFormattedExpiry(visaProvider.arrivalDate);

    return Scaffold(
      backgroundColor: Colors.white,
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
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),
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
                          Text("HASHEMITE KINGDOM OF JORDAN",
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 10,
                                  letterSpacing: 1.2)),
                          Text("Jordan Pass",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.shield,
                            color: Colors.amber, size: 20),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.person,
                            color: Colors.white, size: 45),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("FULL NAME",
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 10)),
                            Text(
                              displayName.toUpperCase(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            const Text("PASSPORT NUMBER",
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 10)),
                            Text(
                              displayPassport,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 25),
                  Center(
                    child: GestureDetector(
                      onTap: () =>
                          _showExpandedQrDialog(context, dynamicQrData),
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2D5A52),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: QrImageView(
                                data: dynamicQrData,
                                version: QrVersions.auto,
                                size: 80.0,
                                backgroundColor: Colors.white,
                                padding: EdgeInsets.zero,
                                errorCorrectionLevel: QrErrorCorrectLevel.M,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text("SCAN FOR VERIFICATION",
                                style: TextStyle(
                                    color: Colors.amber,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold)),
                            const Text("(Tap to enlarge)",
                                style: TextStyle(
                                    color: Colors.white54, fontSize: 8)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("VISA STATUS",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 10)),
                          Text("● ACTIVE / VALID",
                              style: TextStyle(
                                  color: Colors.greenAccent,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text("EXPIRATION DATE",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 10)),
                          Text(expiryDate,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.wallet, color: Colors.white),
              label: const Text("Add to Wallet",
                  style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBurgundy,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 15),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.stars, color: primaryBurgundy),
              label: const Text("View Benefits",
                  style: TextStyle(color: Colors.black87)),
              style: OutlinedButton.styleFrom(
                backgroundColor: lightCream,
                side: BorderSide.none,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                      backgroundColor: Color(0xFFF2E7E7),
                      child: Icon(Icons.info_outline, color: primaryBurgundy)),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Rihla Premium Traveler",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("Priority entry at 40+ historical sites",
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryBurgundy,
        unselectedItemColor: Colors.grey,
        currentIndex: 2,
        onTap: (index) {},
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
