import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/visa_application_provider.dart';
import 'api_service.dart';
import 'visa_payment_page.dart';
import 'utils/country_data.dart';

class PersonalInfoPage extends StatefulWidget {
  final Map<String, dynamic>? passportData;
  const PersonalInfoPage({super.key, this.passportData});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _passportNoController = TextEditingController();
  final TextEditingController _arrivalDateController = TextEditingController();
  final TextEditingController _departureDateController =
      TextEditingController();

  DateTime? _selectedArrivalDate;
  String? _selectedNationality;
  String? _selectedPurpose = "Tourism & Leisure";

  final List<String> _purposes = [
    "Tourism & Leisure",
    "Business",
    "Medical",
    "Visit"
  ];

  static const Color primaryMaroon = Color(0xFF7B2027);
  static const Color bgCream = Color(0xFFF3F1E5);

  @override
  void initState() {
    super.initState();
    _fillDataFromScan();
  }

  void _fillDataFromScan() {
    if (widget.passportData != null) {
      final data = widget.passportData!;
      _fullNameController.text =
          "${data['given_names'] ?? ""} ${data['surname'] ?? ""}".trim();
      _passportNoController.text = data['document_number']?.toString() ?? "";

      if (data['nationality'] != null) {
        String code = data['nationality'].toString().toUpperCase();
        setState(() {
          if (CountryData.isoToName.containsKey(code)) {
            _selectedNationality = CountryData.isoToName[code];
          } else {
            _selectedNationality =
                CountryData.allNationalities.cast<String?>().firstWhere(
                      (n) => n!.toUpperCase().contains(code),
                      orElse: () => null,
                    );
          }
        });
      }
    }
  }

  Future<void> _submitApplication() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final visaProvider =
        Provider.of<VisaApplicationProvider>(context, listen: false);
    visaProvider.updatePersonalInfo(
      name: _fullNameController.text,
      passNumber: _passportNoController.text,
      nat: _selectedNationality,
      arrival: _arrivalDateController.text,
      departure: _departureDateController.text,
      purp: _selectedPurpose,
    );

    try {
      await ApiService().request(
        method: 'PATCH',
        endpoint: '/me/',
        data: visaProvider.toJson(),
        requiresAuth: true,
      );

      if (mounted) {
        setState(() => _isSubmitting = false);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const VisaPaymentPage()));
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("DB Error: $e"),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 6),
          ),
        );
        debugPrint("==== DB REJECTION REASON ====\n$e");
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
        title: const Text("Personal Information",
            style: TextStyle(
                color: primaryMaroon,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildField(
                  "Full Name", _fullNameController, Icons.person_outline),
              const SizedBox(height: 15),
              _buildDropdown(
                  "Nationality",
                  _selectedNationality,
                  CountryData.allNationalities,
                  (v) => setState(() => _selectedNationality = v)),
              const SizedBox(height: 15),
              _buildField("Passport Number", _passportNoController,
                  Icons.badge_outlined),
              const SizedBox(height: 15),
              _buildArrivalPicker(),
              const SizedBox(height: 15),
              _buildDeparturePicker(),
              const SizedBox(height: 15),
              _buildDropdown("Purpose of Visit", _selectedPurpose, _purposes,
                  (v) => setState(() => _selectedPurpose = v)),
              const SizedBox(height: 35),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  // اختيار تاريخ الوصول
  Widget _buildArrivalPicker() {
    return _buildDatePicker("Intended Arrival Date", _arrivalDateController,
        firstDate: DateTime.now(), onPicked: (date) {
      setState(() {
        _selectedArrivalDate = date;
        _departureDateController.clear();
      });
    });
  }

  Widget _buildDeparturePicker() {
    return _buildDatePicker(
      _selectedArrivalDate == null
          ? "Select Arrival First"
          : "Departure Date (Max 30 days)",
      _departureDateController,
      enabled: _selectedArrivalDate != null,
      firstDate:
          _selectedArrivalDate?.add(const Duration(days: 1)) ?? DateTime.now(),
      lastDate: _selectedArrivalDate
          ?.add(const Duration(days: 30)), // هنا تحديد الـ 30 يوم
      onPicked: (date) {},
    );
  }

  Widget _buildDatePicker(String label, TextEditingController ctrl,
      {required DateTime firstDate,
      DateTime? lastDate,
      bool enabled = true,
      required Function(DateTime) onPicked}) {
    return TextFormField(
      controller: ctrl,
      readOnly: true,
      enabled: enabled,
      validator: (v) => v!.isEmpty ? 'Required' : null,
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: firstDate,
          firstDate: firstDate,
          lastDate: lastDate ?? DateTime(2030),
        );
        if (picked != null) {
          setState(() => ctrl.text =
              "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}");
          onPicked(picked);
        }
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon:
            const Icon(Icons.calendar_month, color: primaryMaroon, size: 20),
        filled: true,
        fillColor: enabled ? Colors.white : Colors.grey.shade200,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl, IconData icon) {
    return TextFormField(
      controller: ctrl,
      validator: (v) => v!.isEmpty ? 'Required field' : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: primaryMaroon, size: 20),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildDropdown(String label, String? val, List<String> items,
      Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: val,
      onChanged: onChanged,
      validator: (v) => v == null ? 'Required' : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.public, color: primaryMaroon, size: 20),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
      ),
      items: items
          .map((e) => DropdownMenuItem(
              value: e, child: Text(e, style: const TextStyle(fontSize: 13))))
          .toList(),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: primaryMaroon,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        onPressed: _isSubmitting ? null : _submitApplication,
        child: _isSubmitting
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text("Continue to Payment",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
      ),
    );
  }
}
