import 'package:flutter/material.dart';
import 'step_progress_indicator.dart'; 
import 'passport_scan_page.dart'; 

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  // Controllers for collecting backend data
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _passportController = TextEditingController();
  final TextEditingController _arrivalController = TextEditingController();
  final TextEditingController _departureController = TextEditingController();

  //Dropdowns
  String? _selectedNationality; //Null initially
  String? _selectedPurpose = "Tourism & Leisure"; // default value

  // Data lists
  final List<String> _nationalities = ["Morocco", "Qatar", "Saudi Arabian", "Egypt"];
  final List<String> _purposes = ["Tourism & Leisure", "Business", "Medical Visit", "Family Visit"];

  //datepicker
  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2035), 
      builder: (context, child) {
     
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF7B2027), 
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
      
        controller.text = "${picked.month}/${picked.day}/${picked.year}";
      });
    }
  }

  //function for simulation function
  Future<void> _sendDataToBackend() async {
    final userData = {
      "full_name": _fullNameController.text,
      "nationality": _selectedNationality,
      "passport_number": _passportController.text,
      "arrival_date": _arrivalController.text,
      "departure_date": _departureController.text,
      "purpose": _selectedPurpose,
    };

    //add Backend code here
        print("Sending data to the backend: $userData");
    
  

    // go to the passportpage
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
      backgroundColor: bgColor, 
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryRed, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Apply for Jordan Tourist Visa",
          style: TextStyle(
            color: primaryRed,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          // steps part
          const StepProgressIndicator(currentStep: 1),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                 
                 //hero section
                  Text(
                    "Please ensure all details match your official passport exactly.",
                    style: TextStyle(color: Colors.blueGrey[600], fontSize: 14),
                  ),
                  const SizedBox(height: 25),

                  //form
                  _buildLabel(Icons.person_outline, "Full Name"),
                  _buildTextField(
                    _fullNameController,
                    "Enter your full name as per passport",
                  ),
                  
                  
                  _buildLabel(Icons.public, "Nationality"),
                  _buildDropdown(
                    hint: "Select your nationality",
                    value: _selectedNationality,
                    items: _nationalities,
                    onChanged: (newValue) {
                      setState(() => _selectedNationality = newValue);
                    },
                  ),

                  
                  _buildLabel(Icons.badge_outlined, "Passport Number"),
                  _buildTextField(
                    _passportController,
                    "e.g. A12345678",
                  ),

                  
                  _buildLabel(Icons.calendar_today_outlined, "Intended Arrival Date"),
                  _buildDateField(
                    _arrivalController,
                    "mm/dd/yyyy",
                  ),

                  _buildLabel(Icons.calendar_month_outlined, "Departure Date"),
                  _buildDateField(
                    _departureController,
                    "mm/dd/yyyy",
                  ),

                
                  _buildLabel(Icons.info_outline, "Purpose of Visit"),
                  _buildDropdown(
                    value: _selectedPurpose,
                    items: _purposes,
                    onChanged: (newValue) {
                      setState(() => _selectedPurpose = newValue);
                    },
                  ),

                  const SizedBox(height: 20),
                  
                  //  info box
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
                            style: TextStyle(fontSize: 12, color: Color(0xFF616161)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Continue button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _sendDataToBackend, 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryRed,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Continue to Passport Scan",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
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

  //builder ui function

  // name& icons
  Widget _buildLabel(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 15),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF7B2027)),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // Name, Passport
  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  // date
  Widget _buildDateField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      readOnly: true, 
      onTap: () => _selectDate(context, controller), 
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: const Icon(Icons.calendar_month, color: Color(0xFF7B2027)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  //Dropdowns
  Widget _buildDropdown({
    String? hint,
    String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: hint != null ? Text(hint) : null,
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF7B2027)),
          items: items.map((String val) {
            return DropdownMenuItem<String>(
              value: val,
              child: Text(val),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}