import 'package:flutter/material.dart';
import 'step_progress_indicator.dart';
import 'visa_payment_page.dart';

class PassportScanPage extends StatelessWidget {
  const PassportScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryRed = Color(0xFF7B2027);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black, title: const Text("Scan Passport")),
      body: Column(
        children: [
          const StepProgressIndicator(currentStep: 2),
          Expanded(
            child: Stack(
              children: [
                const Center(child: Icon(Icons.camera_alt, color: Colors.white, size: 80)),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("Passport Details", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: primaryRed, minimumSize: const Size(double.infinity, 55)),
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const VisaPaymentPage())),
                          child: const Text("Confirm Details", style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}