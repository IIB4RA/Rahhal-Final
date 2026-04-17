import 'package:flutter/material.dart';
import 'visa_payment_page.dart';

class PersonalInfoPage extends StatefulWidget {
  // data comes from the pass_scan page
  final Map<String, dynamic>? passportData;

  const PersonalInfoPage({super.key, this.passportData});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  // Controllers for the form fields
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _passportNoController = TextEditingController();
  final TextEditingController _arrivalDateController = TextEditingController();
  final TextEditingController _departureDateController = TextEditingController();

  String? _selectedNationality;
  String? _selectedPurpose = "Tourism & Leisure";

  final List<String> _purposes = ["Tourism & Leisure", "Business", "Medical", "Visit"];
  final List<String> _nationalities = ["Jordanian", "Saudi Arabian", "Moroccan", "Qatari", "Egyptian", "United States"];


  static const Color primaryMaroon = Color(0xFF7B2027);
  static const Color bgCream = Color(0xFFF3F1E5);
  static const Color borderLight = Color(0xFFE0DCC8);
  static const Color textGrey = Color(0xFF7D7D7D);

  @override
  void initState() {
    super.initState();
    _fillDataFromScan();
  }

  //  function maps data 
  void _fillDataFromScan() {
    if (widget.passportData != null) {
      final data = widget.passportData!;
      
      _fullNameController.text = "${data['given_names'] ?? ""} ${data['surname'] ?? ""}".trim();
      _passportNoController.text = data['document_number']?.toString() ?? "";
      
      
      if (data['nationality'] != null) {
        String scannedNationality = data['nationality'].toString().toLowerCase();
        
        
        Iterable<String> matches = _nationalities.where(
          (n) => n.toLowerCase().contains(scannedNationality)
        );

        setState(() {
          _selectedNationality = matches.isNotEmpty ? matches.first : null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgCream,
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
        child: Column(
          children: [
            
            Container(
              color: bgCream,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStepCircle("1", "PASSPORT", false, isCompleted: true), 
                  _buildStepLine(isCompleted: true),
                  _buildStepCircle("2", "PERSONAL", true), 
                  _buildStepLine(isCompleted: false),
                  _buildStepCircle("3", "PAYMENT", false),
                  _buildStepLine(isCompleted: false),
                  _buildStepCircle("4", "APPROVAL", false),
                ],
              ),
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Personal Information",
                    style: TextStyle(color: primaryMaroon, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Please ensure all details match your official passport exactly.",
                    style: TextStyle(color: Color(0xFF91A3B0), fontSize: 13),
                  ),
                  const SizedBox(height: 25),

                  _buildInputLabel(Icons.person_outline, "Full Name"),
                  _buildTextField(_fullNameController, "Enter your full name"),

                  _buildInputLabel(Icons.public, "Nationality"),
                  _buildDropdown(_selectedNationality, _nationalities, (val) => setState(() => _selectedNationality = val)),

                  _buildInputLabel(Icons.badge_outlined, "Passport Number"),
                  _buildTextField(_passportNoController, "e.g. A12345678"),

                  _buildInputLabel(Icons.calendar_month_outlined, "Intended Arrival Date"),
                  _buildDateField(_arrivalDateController, "mm/dd/yyyy"),

                  _buildInputLabel(Icons.calendar_month_outlined, "Departure Date"),
                  _buildDateField(_departureDateController, "mm/dd/yyyy"),

                  _buildInputLabel(Icons.info_outline, "Purpose of Visit"),
                  _buildDropdown(_selectedPurpose, _purposes, (val) => setState(() => _selectedPurpose = val)),

                  const SizedBox(height: 20),

                  // Info Box
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F3F3),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: primaryMaroon.withOpacity(0.1)),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info, color: primaryMaroon, size: 20),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "A single entry tourist visa for Jordan is valid for 1 month from the date of issue.",
                            style: TextStyle(fontSize: 11, color: Colors.black54),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryMaroon,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
  
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const VisaPaymentPage(),
    ),
  );
},
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Continue to Payment", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(width: 10),
                          Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //UI Helpers 

  Widget _buildStepCircle(String number, String label, bool isActive, {bool isCompleted = false}) {
    return Column(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: isActive || isCompleted ? primaryMaroon : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: isActive || isCompleted ? primaryMaroon : borderLight, width: 2),
          ),
          child: Center(
            child: isCompleted 
              ? const Icon(Icons.check, size: 16, color: Colors.white)
              : Text(
                  number,
                  style: TextStyle(color: isActive ? Colors.white : textGrey, fontWeight: FontWeight.bold, fontSize: 12),
                ),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: isActive || isCompleted ? primaryMaroon : textGrey, fontSize: 9, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildStepLine({required bool isCompleted}) {
    return Container(width: 30, height: 2, color: isCompleted ? primaryMaroon : borderLight);
  }

  Widget _buildInputLabel(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 15),
      child: Row(
        children: [
          Icon(icon, size: 16, color: primaryMaroon),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF4A4A4A))),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: borderLight)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: primaryMaroon)),
      ),
    );
  }

  Widget _buildDateField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2030),
        );
        if (picked != null) {
          setState(() => controller.text = "${picked.month}/${picked.day}/${picked.year}");
        }
      },
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        suffixIcon: const Icon(Icons.calendar_today, size: 18, color: primaryMaroon),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: borderLight)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: primaryMaroon)),
      ),
    );
  }

  Widget _buildDropdown(String? value, List<String> items, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderLight),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(value) ? value : null, 
          isExpanded: true,
          hint: const Text("Select option", style: TextStyle(fontSize: 14, color: Colors.black26)),
          icon: const Icon(Icons.keyboard_arrow_down, color: primaryMaroon),
          items: items.map((e) => DropdownMenuItem(
            value: e, 
            child: Text(e, style: const TextStyle(fontSize: 14))
          )).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}