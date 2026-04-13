import 'package:flutter/material.dart';
import 'step_progress_indicator.dart';
import 'visa_approved_page.dart';

class VisaPaymentPage extends StatefulWidget {
  const VisaPaymentPage({super.key});

  @override
  State<VisaPaymentPage> createState() => _VisaPaymentPageState();
}

class _VisaPaymentPageState extends State<VisaPaymentPage> {
  //select payment method
  String _selectedMethod = "Credit / Debit Card";

  @override
  Widget build(BuildContext context) {
    const primaryRed = Color(0xFF7B2027);
    const bgColor = Color(0xFFE8E5D8);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryRed),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Payment",
          style: TextStyle(color: primaryRed, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: const [
          Icon(Icons.shield_outlined, color: primaryRed),
          SizedBox(width: 15),
        ],
      ),
      body: Column(
        children: [
          const StepProgressIndicator(currentStep: 3),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Summary", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  
                  // Invoice Details section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildSummaryRow("Tourist Visa Fee", "\$150.00", subtitle: "Single Entry - 30 Days"),
                        _buildSummaryRow("Service Fee", "\$25.00"),
                        _buildSummaryRow("Processing Fee", "\$4.50"),
                        const Divider(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text("Total Amount", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryRed)),
                            Text("\$179.50", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryRed)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  const Text("Payment Method", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),

                  // Payment method
                  _buildPaymentMethodTile("Apple Pay", Icons.apple, "Apple Pay"),
                  _buildPaymentMethodTile("Google Pay", Icons.language, "Google Pay"),
                  _buildPaymentMethodTile("Credit / Debit Card", Icons.credit_card, "Credit / Debit Card"),

                  // Card fields (if the card is selected) 
                  if (_selectedMethod == "Credit / Debit Card") ...[
                    const SizedBox(height: 15),
                    _buildCardFields(),
                  ],

                  const SizedBox(height: 30),
                  
                  // security text
                  const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lock_outline, size: 14, color: Colors.grey),
                        SizedBox(width: 5),
                        Text("SECURE 256-BIT SSL ENCRYPTED PAYMENT", style: TextStyle(fontSize: 10, color: Colors.grey)),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),

                  // payment button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const VisaApprovedPage())),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryRed,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Pay and Submit", style: TextStyle(color: Colors.white, fontSize: 16)),
                          SizedBox(width: 10),
                          Icon(Icons.arrow_forward, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // summery builder function
  Widget _buildSummaryRow(String label, String price, {String? subtitle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
              if (subtitle != null) Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          Text(price, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  //PaymentMethod builder function
  Widget _buildPaymentMethodTile(String title, IconData icon, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: RadioListTile<String>(
        value: value,
        groupValue: _selectedMethod,
        activeColor: const Color(0xFF7B2027),
        onChanged: (val) => setState(() => _selectedMethod = val!),
        title: Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 15),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  //CardFields builder function
  Widget _buildCardFields() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          TextField(decoration: InputDecoration(hintText: "Card number", border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)))),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: TextField(decoration: InputDecoration(hintText: "MM/YY", border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))))),
              const SizedBox(width: 10),
              Expanded(child: TextField(decoration: InputDecoration(hintText: "CVV", border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))))),
            ],
          ),
        ],
      ),
    );
  }
}