import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: JordanVisaForm(),
    debugShowCheckedModeBanner: false,
  ));
}

class JordanVisaForm extends StatefulWidget {
  const JordanVisaForm({super.key});

  @override
  State<JordanVisaForm> createState() => _JordanVisaFormState();
}

class _JordanVisaFormState extends State<JordanVisaForm> {
  // Controllers for backend data collection
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _passportController = TextEditingController();
  final TextEditingController _arrivalDateController = TextEditingController();
  final TextEditingController _departureDateController = TextEditingController();
  String _nationality = "Select your nationality";
  String _purpose = "Tourism & Leisure";

 
  Future<void> _saveDataToBackend() async {
    final userData = {
      "full_name": _fullNameController.text,
      "nationality": _nationality,
      "passport_number": _passportController.text,
      "arrival_date": _arrivalDateController.text,
      "departure_date": _departureDateController.text,
      "purpose": _purpose,
    };

    // Replace with API call or Firebase logic
    print("Saving to backend: $userData");
    
    // Navigate to the next page after saving
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => const PassportScanPage()),
    );
  }

  
  @override
  Widget build(BuildContext context) {
    const primaryRed = Color(0xFF7B2027);
    const bgColor = Color(0xFFE8E5D8);

    return Scaffold(
      backgroundColor: Color(0xFFE8E5D8),
      //  APPBAR 
      appBar: AppBar(
        backgroundColor: bgColor, 
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryRed, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Rahhal – Heritage Guide",
          style: TextStyle(
            color: primaryRed,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
      body: Center(
        child: Container(
          
          decoration: const BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
          ),
          child: Column(
            children: [
              // Custom Stepper
              const StepProgressIndicator(currentStep: 1),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Personal Information",
                        style: TextStyle(
                          color: primaryRed,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Please ensure all details match your official passport exactly.",
                        style: TextStyle(color: Colors.blueGrey[600], fontSize: 14),
                      ),
                      const SizedBox(height: 25),

                      // Form Fields
                      _buildLabel(Icons.person_outline, "Full Name"),
                      _buildTextField(_fullNameController, "Enter your full name as per passport"),
                      
                      _buildLabel(Icons.public, "Nationality"),
                      _buildDropdown(["Select your nationality", "Jordanian", "American", "British"], 
                          (val) => setState(() => _nationality = val!)),

                      _buildLabel(Icons.badge_outlined, "Passport Number"),
                      _buildTextField(_passportController, "e.g. A12345678"),

                      _buildLabel(Icons.calendar_today_outlined, "Intended Arrival Date"),
                      _buildTextField(_arrivalDateController, "mm/dd/yyyy"),

                      _buildLabel(Icons.calendar_month_outlined, "Departure Date"),
                      _buildTextField(_departureDateController, "mm/dd/yyyy"),

                      _buildLabel(Icons.info_outline, "Purpose of Visit"),
                      _buildDropdown(["Tourism & Leisure", "Business", "Medical"], 
                          (val) => setState(() => _purpose = val!)),

                      const SizedBox(height: 20),
                      
                      // Info validation Box
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1EDE4),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.info_outline, color: primaryRed, size: 20),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "A single entry tourist visa for Jordan is valid for 1 month from the date of issue. Please ensure your passport has at least 6 months validity.",
                                style: TextStyle(fontSize: 11, color: Color(0xFF616161)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Continue Button
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _saveDataToBackend,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryRed,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Continue to Passport Scan", style: TextStyle(color: Colors.white, fontSize: 16)),
                              SizedBox(width: 5),
                              Icon(Icons.arrow_forward, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

  Widget _buildLabel(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 15),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF7B2027)),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400] , fontSize: 12),
        filled: true,
     
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(7), borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(7), borderSide: BorderSide(color: Colors.grey.shade300)),
      ),
    );
  }

  Widget _buildDropdown(List<String> items, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        
        color: Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          
          value: items.first.contains("Select") ? items.first : null,
          isExpanded: true,
          items: items.map((String value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }


//  Stepper Widget 
class StepProgressIndicator extends StatelessWidget {
  final int currentStep;
  const StepProgressIndicator({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    const activeColor = Color(0xFF7B2027);
    const inactiveColor = Color(0xFFD1CDC0);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStep(1, "PERSONAL", currentStep >= 1 ? activeColor : inactiveColor),
          _buildStep(2, "PASSPORT", currentStep >= 2 ? activeColor : inactiveColor),
          _buildStep(3, "PAYMENT", currentStep >= 3 ? activeColor : inactiveColor),
          _buildStep(4, "APPROVAL", currentStep >= 4 ? activeColor : inactiveColor),
        ],
      ),
    );
  }

  Widget _buildStep(int number, String label, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: color,
          child: Text(number.toString(), style: const TextStyle(color: Colors.white, fontSize: 12)),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

// --- Next Page Placeholder ---
class PassportScanPage extends StatelessWidget {
  const PassportScanPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Passport Scan")),
      body: const Center(child: StepProgressIndicator(currentStep: 2)), // Color changes to red for step 2
    );
  }
}