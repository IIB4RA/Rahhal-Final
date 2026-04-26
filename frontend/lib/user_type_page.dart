import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'home_page.dart'; 

void main() => runApp(const RahhalApp());

class RahhalApp extends StatelessWidget {
  const RahhalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: const Color(0xFF8B2323)),
      home: const UserTypePage(),
    );
  }
}

class UserTypePage extends StatelessWidget {
  const UserTypePage({super.key});

final storage = const FlutterSecureStorage(
  webOptions: WebOptions(
    dbName: 'RahhalStorage',
    publicKey: 'RahhalKey',
  ),
);
 
  Future<Map<String, dynamic>?> getValidAccessToken() async {
    try {
      
      String? token = await storage.read(key: 'access_token');
      
      if (token != null) {
        return {'access': token};
      }
    } catch (e) {
      debugPrint("Error reading token: $e");
    }
    return null;
  }

  Future<bool> handleRole(BuildContext context, String role) async {
    // 10.0.2.2 is the alias for the 127.0.0.1 on your dev machine for Android Emulator
   final String url = "https://rahhal-final-production.up.railway.app/api/role/";
    
    try {
      final tokenData = await getValidAccessToken();
      
      if (tokenData == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No session found. Please login again.")),
        );
        return false;
      }

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${tokenData['access']}",
        },
        body: jsonEncode({"role": role}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Server Error: ${response.statusCode}")),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Connection failed: $e")),
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3E7),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Choose Your Profile",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8B2323)),
            ),
            const SizedBox(height: 30),
            _buildTypeButton(
                context, "Tourist", "tourist", Icons.flight_takeoff),
            _buildTypeButton(context, "Resident", "resident", Icons.home_work),
            _buildTypeButton(context, "Operator", "operator", Icons.map),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeButton(
      BuildContext context, String label, String dbValue, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
      child: ElevatedButton.icon(
        onPressed: () async {
          // Show a loading indicator if needed
          bool success = await handleRole(context, dbValue);
          if (success) {
            if (context.mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            }
          }
        },
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 60),
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF1A237E),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }
}