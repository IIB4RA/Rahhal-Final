import 'package:flutter/material.dart';

class VisaApplicationProvider with ChangeNotifier {
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
    if (name != null) fullName = name;
    if (passNumber != null) passportNumber = passNumber;
    if (nat != null) nationality = nat;
    if (arrival != null) arrivalDate = arrival;
    if (departure != null) departureDate = departure;
    if (purp != null) purpose = purp;
    notifyListeners(); // This updates all screens instantly
  }

  Map<String, dynamic> toJson() {
    return {
      "full_name": fullName,
      "passport_number": passportNumber,
      "nationality": nationality,
      "arrival_date": arrivalDate,
      "departure_date": departureDate,
    };
  }
}
