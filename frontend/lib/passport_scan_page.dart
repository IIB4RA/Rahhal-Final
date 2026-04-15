import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'step_progress_indicator.dart';
import 'visa_payment_page.dart';
import 'database_offline_mode.dart';

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

  final String kApiUrl = 'http://10.0.2.2:8000/api/passport/scan/';

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

  @override
  Widget build(BuildContext context) {
    const primaryRed = Color(0xFF7B2027);
    const bgColor = Color(0xFFF5F5F5);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: primaryRed,
        title: const Text("Scan Passport",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: bgColor,
              padding: const EdgeInsets.only(bottom: 15, top: 10),
              child: const StepProgressIndicator(currentStep: 2),
            ),

            // 👈 التعديل تم هنا: أضفنا Center عشان المربع يلف على الصورة بالضبط
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Center(
                  child: GestureDetector(
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
                            spreadRadius: 2,
                          )
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: _image != null
                            ? Image.file(
                                _image!,
                                fit: BoxFit
                                    .cover, // الآن المربع رح يكون فت 100% مع الصورة
                              )
                            : const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.document_scanner_outlined,
                                      color: Colors.grey, size: 60),
                                  SizedBox(height: 10),
                                  Text("Tap to upload passport",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 16)),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Passport Details",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      if (_scanResult != null)
                        Icon(Icons.check_circle, color: Colors.green[700]),
                    ],
                  ),
                  const SizedBox(height: 15),
                  if (_isLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: CircularProgressIndicator(color: primaryRed),
                    )
                  else if (_scanResult != null) ...[
                    _buildDetailRow("Full Name",
                        "${_scanResult!['given_names']} ${_scanResult!['surname']}"),
                    _buildDetailRow("Passport No",
                        _scanResult!['document_number']?.toString() ?? ""),
                    _buildDetailRow(
                        "Nationality", _scanResult!['nationality'] ?? ""),
                    _buildDetailRow(
                        "Date of Birth", _scanResult!['date_of_birth'] ?? ""),
                    _buildDetailRow(
                        "Expiry Date", _scanResult!['expiry_date'] ?? ""),
                    _buildDetailRow("Sex", _scanResult!['sex'] ?? ""),
                    const SizedBox(height: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Raw MRZ Data",
                            style: TextStyle(color: Colors.grey, fontSize: 14)),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _scanResult!['raw_mrz'] ?? "",
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 11,
                              letterSpacing: 1.5,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ] else if (_errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Text(_errorMessage,
                          style: const TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold)),
                    )
                  else
                    const Padding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: Text(
                          "Please upload a clear image of the passport data page.",
                          style: TextStyle(color: Colors.grey),
                          textAlign: TextAlign.center),
                    ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryRed,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: () async {
                      if (_scanResult != null) {
                        try {
                          await DatabaseService.instance
                              .insertPassport(_scanResult!);
                        } catch (e) {
                          debugPrint(
                              "DB Notice: Passport might already exist. $e");
                        }

                        if (context.mounted) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const VisaPaymentPage()));
                        }
                      } else {
                        _pickAndUploadImage();
                      }
                    },
                    child: Text(
                      _scanResult != null ? "Confirm Details" : "Start AI Scan",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
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
