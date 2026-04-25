import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/visa_application_provider.dart';
import 'selectTypePage.dart';
import 'api_service.dart';

class QuestionsPage extends StatefulWidget {
  const QuestionsPage({super.key});

  @override
  _QuestionsPageState createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  //default selected values
  String interest = "Relaxation";
  String travelWith = "Solo";
  String budget = "Normal Budget";
  String places = "Historical sites";

  Future<bool> preferences() async {
    Map<String, dynamic> prefData = {
      "interests": interest,
      "travel_style": travelWith,
      "budget_range": budget,
      "preferred_places": places,
    };

    final endpoint = '/preferences/';
    try {
      final response = await ApiService().request(
        method: 'post',
        endpoint: endpoint,
        data: prefData,
        requiresAuth: true,
      );

      if (response != null) {
        return true;
      }
      return false;
    } catch (e) {
      print("Error saving preferences: $e");
      return false;
    }
  }

  final Color backgroundColor = const Color(0xffEAE3D2);
  final Color darkMaroon = const Color.fromRGBO(122, 31, 44, 1);
  final Color darkBlue = const Color(0xff1C2340);
  final Color textGrey = const Color.fromRGBO(122, 31, 44, 0.6);
  final Color labelTextBlack = const Color.fromARGB(190, 20, 26, 47);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: darkMaroon,
              size: 28,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: Text(
          "Rahhal – Heritage Guide",
          style: TextStyle(
            color: darkMaroon,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 40, 16, 40),
        child: Column(
          children: [
            const SizedBox(height: 30),
            // Subtitle Section
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(height: 1.0),
                    children: <TextSpan>[
                      TextSpan(
                        text: "Before we start ...\n",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: darkMaroon,
                          fontFamily: 'serif',
                        ),
                      ),
                      TextSpan(
                        text: "tell us about your interests",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: darkMaroon,
                          fontFamily: 'serif',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                "This helps us recommend places you will love in Jordan",
                textAlign: TextAlign.center,
                style: TextStyle(color: textGrey, fontSize: 13),
              ),
            ),
            const SizedBox(height: 20),

            //  Dropdown list
            _buildCustomDropdownRow(
              "What are your travel interests?",
              interest,
              [
                "History",
                "Nature",
                "Adventure",
                "Food",
                "Relaxation",
                "Shopping"
              ],
              (val) {
                setState(() => interest = val!);
              },
            ),

            _buildCustomDropdownRow(
              "Who are you traveling with?",
              travelWith,
              ["Solo", "Couple", "Family", "Friends"],
              (val) {
                setState(() => travelWith = val!);
              },
            ),

            _buildCustomDropdownRow(
              "What is your travel style",
              budget,
              ["Low Budget", "Normal Budget", "Luxury Travel"],
              (val) {
                setState(() => budget = val!);
              },
            ),

            _buildCustomDropdownRow(
              "What type of places do you enjoy?",
              places,
              [
                "Historical sites",
                "Natural landscapes",
                "Beaches",
                "Cities",
                "Museums"
              ],
              (val) {
                setState(() => places = val!);
              },
            ),

            const SizedBox(height: 6),
            const SizedBox(height: 10),

            Center(
              child: Text(
                "We will personalize your travel experience",
                style: TextStyle(color: darkBlue, fontSize: 12),
              ),
            ),

            const SizedBox(height: 17),

            // LET'S START BUTTON
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: darkBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 27, vertical: 12),
                elevation: 4,
              ),
              onPressed: () async {
                final visaProvider = Provider.of<VisaApplicationProvider>(
                    context,
                    listen: false);
                visaProvider.updatePersonalInfo(purp: interest);

                bool success = await preferences();

                if (success && mounted) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const UserTypePage()));
                } else if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                          "Failed to save preferences. Please check your connection."),
                      backgroundColor: darkMaroon,
                    ),
                  );
                }
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Let’s Start",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(width: 12),
                  Icon(Icons.arrow_forward_outlined, size: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Dropdown 2
  Widget _buildCustomDropdownRow(String title, String value, List<String> items,
      Function(String?) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color.fromARGB(210, 255, 255, 255),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Side
          Expanded(
            child: Row(
              children: [
                Icon(Icons.help_outline, color: darkMaroon, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      color: labelTextBlack,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // Right Side
          IntrinsicWidth(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2),
              decoration: BoxDecoration(
                color: darkMaroon,
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: value,
                  dropdownColor: darkMaroon,
                  borderRadius: BorderRadius.circular(12),
                  isDense: true,
                  icon: const Icon(Icons.keyboard_arrow_down,
                      color: Colors.white, size: 20),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  items: items
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e,
                                style: const TextStyle(color: Colors.white)),
                          ))
                      .toList(),
                  onChanged: onChanged,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
