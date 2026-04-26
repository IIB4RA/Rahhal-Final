import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'providers/visa_application_provider.dart';
import 'step_progress_indicator.dart';
import 'personal_info_page.dart';
import 'custom_bottom_nav.dart';

class PassportScanPage extends StatefulWidget {
  const PassportScanPage({super.key});

  @override
  State<PassportScanPage> createState() => _PassportScanPageState();
}

class _PassportScanPageState extends State<PassportScanPage> {
  File? _image;
  Map<String, dynamic>? _scanResult;
  bool _isLoading = false;
  String _errorMessage = '';
  final ImagePicker _picker = ImagePicker();

  final String kApiUrl = 'https://rahhal-final-production.up.railway.app/api/passport/scan/';

  Future<void> _pickAndUploadImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    setState(() {
      _image = File(pickedFile.path);
      _isLoading = true;
      _scanResult = null;
      _errorMessage = '';
    });
    try {
      var request = http.MultipartRequest('POST', Uri.parse(kApiUrl));
      request.files
          .add(await http.MultipartFile.fromPath('image', _image!.path));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        setState(() {
          _scanResult = responseData['data'];
        });
      } else {
        setState(() {
          _errorMessage = "Server Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Connection failed. Check network.";
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildBody() {
    const primaryRed = Color(0xFF7B2027);

    final visaProvider = Provider.of<VisaApplicationProvider>(context);
    bool isPassActive = false;
    String formattedExpiry = "";

    if (visaProvider.passportNumber != null &&
        visaProvider.passportNumber!.isNotEmpty) {
      if (visaProvider.arrivalDate != null &&
          visaProvider.arrivalDate!.isNotEmpty) {
        try {
          DateTime arrival = DateTime.parse(visaProvider.arrivalDate!);
          DateTime expiry = arrival.add(const Duration(days: 30));

          if (DateTime.now().isBefore(expiry)) {
            isPassActive = true;
            formattedExpiry = "${expiry.day}/${expiry.month}/${expiry.year}";
          }
        } catch (e) {
          isPassActive = true;
        }
      } else {
        isPassActive = true;
      }
    }

    return SafeArea(
      child: Column(
        children: [
          const StepProgressIndicator(currentStep: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Center(
                child: isPassActive
                    ? _buildLockedUI(formattedExpiry)
                    : GestureDetector(
                        onTap: _isLoading ? null : _pickAndUploadImage,
                        child: Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(minHeight: 220),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  spreadRadius: 2)
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: _image != null
                                ? Image.file(_image!, fit: BoxFit.cover)
                                : const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.document_scanner_outlined,
                                          color: Colors.grey, size: 60),
                                      SizedBox(height: 10),
                                      Text("Tap to upload passport",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16)),
                                    ],
                                  ),
                          ),
                        ),
                      ),
              ),
            ),
          ),
          if (!isPassActive) _buildBottomPanel(primaryRed),
        ],
      ),
    );
  }

  Widget _buildLockedUI(String expiryDate) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: const Color(0xFF7B2027).withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 2)
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.lock_clock, color: Color(0xFF7B2027), size: 70),
          const SizedBox(height: 20),
          const Text(
            "Application Locked",
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
          const SizedBox(height: 15),
          Text(
            "You already have an active Jordan Pass.\nIt is valid until $expiryDate.",
            textAlign: TextAlign.center,
            style:
                const TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
          ),
          const SizedBox(height: 20),
          const Text(
            "You can apply for a new pass once your current one expires (30 days after your arrival).",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomPanel(Color primaryRed) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5))
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Passport Details",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              if (_scanResult != null)
                Icon(Icons.check_circle, color: Colors.green[700]),
            ],
          ),
          const SizedBox(height: 15),
          if (_isLoading)
            const CircularProgressIndicator(color: Color(0xFF7B2027))
          else if (_scanResult != null) ...[
            _buildDetailRow("Full Name",
                "${_scanResult!['given_names']} ${_scanResult!['surname']}"),
            _buildDetailRow("Passport No",
                _scanResult!['document_number']?.toString() ?? ""),
            _buildDetailRow("Nationality", _scanResult!['nationality'] ?? ""),
            const SizedBox(height: 20),
          ] else
            Text(
                _errorMessage.isNotEmpty
                    ? _errorMessage
                    : "Please upload a clear image.",
                style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryRed,
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
            ),
            onPressed: () {
              if (_scanResult != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PersonalInfoPage(passportData: _scanResult),
                  ),
                );
              } else {
                _pickAndUploadImage();
              }
            },
            child: Text(
                _scanResult != null ? "Confirm Details" : "Start AI Scan",
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7B2027),
        title: const Text("Scan Passport",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _buildBody(),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 2),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text(value,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}
