import 'package:flutter/material.dart';
import '../api_service.dart'; // Ensure this path matches your project structure

class VisaApplicationProvider extends ChangeNotifier {
  String? fullName;
  String? passportNumber;
  String? nationality;
  String? arrivalDate;
  String? departureDate;
  String? purpose;

  void updatePersonalInfo({
    String? name,
    String? passNumber,
    String? nat,
    String? arrival,
    String? departure,
    String? purp,
  }) {
    fullName = name;
    passportNumber = passNumber;
    nationality = nat;
    arrivalDate = arrival;
    departureDate = departure;
    purpose = purp;
    notifyListeners();
  }

  // --- NEW: Data Persistence Method ---
  Future<void> loadPersistedData() async {
    try {
      final data = await ApiService().request(
        method: 'GET',
        endpoint: '/me/',
        requiresAuth: true,
      );

      if (data != null) {
        // If the backend has data, load it into the app's memory
        updatePersonalInfo(
          name: data['full_name'],
          passNumber: data['passport_number'],
          nat: data['nationality'],
          arrival: data['arrival_date'],
          departure: data['departure_date'],
          purp: data['purpose_of_visit'],
        );
      }
    } catch (e) {
      debugPrint("No previous data found or offline: $e");
      // Fails silently so the user isn't bothered if it's a new account
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "full_name": fullName,
      "passport_number": passportNumber,
      "nationality": nationality,
      "arrival_date": arrivalDate,
      "departure_date": departureDate,
      "purpose_of_visit": purpose,
    };
  }
}
