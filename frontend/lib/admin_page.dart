import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// DATA MODEL
class TourismAnalyticsData {
  final int totalVisitors;
  final double totalVisitorsGrowth;
  final int monthlyVisitors;
  final double monthlyVisitorsGrowth;
  final int topLocationsCount;
  final double locationsGrowth;
  final List<double> chartData;

  TourismAnalyticsData({
    required this.totalVisitors,
    required this.totalVisitorsGrowth,
    required this.monthlyVisitors,
    required this.monthlyVisitorsGrowth,
    required this.topLocationsCount,
    required this.locationsGrowth,
    required this.chartData,
  });

  factory TourismAnalyticsData.fromJson(Map<String, dynamic> json) {
    return TourismAnalyticsData(
      totalVisitors: json['total_visitors'] ?? 0,
      totalVisitorsGrowth: (json['total_growth'] ?? 0).toDouble(),
      monthlyVisitors: json['monthly_visitors'] ?? 0,
      monthlyVisitorsGrowth: (json['monthly_growth'] ?? 0).toDouble(),
      topLocationsCount: json['top_locations'] ?? 0,
      locationsGrowth: (json['locations_growth'] ?? 0).toDouble(),
      chartData: List<double>.from(json['chart_data'] ?? [150, 130, 110, 90]),
    );
  }
}

//  MAIN PAGE 
class TourismAnalyticsScreen extends StatefulWidget {
  @override
  _TourismAnalyticsScreenState createState() => _TourismAnalyticsScreenState();
}

class _TourismAnalyticsScreenState extends State<TourismAnalyticsScreen> {
   //Connect  with API endpoint :)
  final String apiUrl = "http://your-django-backend.com/api/admin-stats/";
  late Future<TourismAnalyticsData> _analyticsFuture;

  @override
  void initState() {
    super.initState();
    _analyticsFuture = fetchAnalytics();
  }

  Future<TourismAnalyticsData> fetchAnalytics() async {
    try {
      
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Token YOUR_ADMIN_TOKEN", 
        },
      );

      if (response.statusCode == 200) {
        return TourismAnalyticsData.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Failed to load statistics");
      }
    } catch (e) {
      // defult UI
      return TourismAnalyticsData(
        totalVisitors: 2847532,
        totalVisitorsGrowth: 12.5,
        monthlyVisitors: 234876,
        monthlyVisitorsGrowth: 8.2,
        topLocationsCount: 8,
        locationsGrowth: 2.0,
        chartData: [160, 140, 130, 100],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF8B2635); 
    const bgColor = Color(0xFFF1F3E9);      

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "Tourism Analytics",
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.menu, color: primaryColor),
            itemBuilder: (context) => [
              PopupMenuItem(value: 'Dashboard', child: Text('Dashboard')),
              PopupMenuItem(value: 'Visitors', child: Text('Visitors')),
              PopupMenuItem(value: 'Locations', child: Text('Locations')),
              PopupMenuItem(value: 'Movement', child: Text('Movement')),
            ],
          )
        ],
      ),
      
      body: FutureBuilder<TourismAnalyticsData>(
        future: _analyticsFuture,
        builder: (context, snapshot) {
          builder: (context, snapshot) {

  if (snapshot.connectionState == ConnectionState.waiting) {
    return Center(child: CircularProgressIndicator(color: primaryColor));
  }

  if (snapshot.hasError) {
    return Center(child: Text("Something went wrong"));
  }

  if (!snapshot.hasData) {
    return Center(child: Text("No data"));
  }

  final data = snapshot.data!;

  return SingleChildScrollView(
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       
      ],
    ),
  );
};
          final data = snapshot.data!;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Text("TOURISM OVERVIEW", 
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: primaryColor)),
                Text("Comprehensive analytics and insights for tourism planning",
                  style: TextStyle(color: Colors.grey[700], fontSize: 13)),
                
                SizedBox(height: 25),
                
                // Stat Cards
                _buildStatCard("Total Visitors", data.totalVisitors.toString(), 
                    data.totalVisitorsGrowth, Icons.people_outline),
                _buildStatCard("Monthly Visitors", data.monthlyVisitors.toString(), 
                    data.monthlyVisitorsGrowth, Icons.bar_chart),
                _buildStatCard("Top Locations", data.topLocationsCount.toString(), 
                    data.locationsGrowth, Icons.location_on_outlined),

                SizedBox(height: 30),
                Text("TOP 5 VISITED LOCATIONS", 
                    style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
                Text("Most popular tourist destinations",
                    style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                
                SizedBox(height: 20),
                
               
                _buildBarChart(data.chartData),
                SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, double growth, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: Offset(0, 4))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: Colors.black54, fontSize: 15)),
              SizedBox(height: 5),
              Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(Icons.trending_up, size: 16, color: Colors.green),
                  SizedBox(width: 5),
                  Text("+$growth% vs last month", 
                      style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500, fontSize: 13)),
                ],
              )
            ],
          ),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFF4A5568),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          )
        ],
      ),
    );
  }

  Widget _buildBarChart(List<double> values) {
    return Container(
      height: 220,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(values.length, (index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 45,
                height: values[index], 
                decoration: BoxDecoration(
                  color: Color(0xFF94A3B8),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
                ),
              ),
              SizedBox(height: 8),
              Text("PLACE ${index + 1}", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          );
        }),
      ),
    );
  }
}