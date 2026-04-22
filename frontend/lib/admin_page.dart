import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int _tabIndex = 1;
  String _selectedRegion = "All Regions";
  bool _isLoading = true;
  Map<String, dynamic> _apiData = {};

  final Color primaryMaroon = const Color(0xFF8B2635);
  final Color secondaryMaroon = const Color(0xFF5E1A24);
  final Color zadGold = const Color(0xFFD4AF37);
  final Color bgColor = const Color(0xFFF1F3E9);

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(Uri.parse(
          'http://10.0.2.2:8000/api/admin/analytics/?region=$_selectedRegion'));

      if (response.statusCode == 200) {
        setState(() {
          _apiData = jsonDecode(utf8.decode(response.bodyBytes))['data'];
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Connection Error: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      bottomNavigationBar: _buildNavbar(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: primaryMaroon))
          : IndexedStack(
              index: _tabIndex,
              children: [
                _buildLiveMapTab(),
                _buildModernAnalyticsTab(),
                _buildReportsTab(),
                _buildSettingsTab(),
              ],
            ),
    );
  }

  Widget _buildModernAnalyticsTab() {
    final stats = _apiData['stats'] ?? {};
    final segmentationData = _apiData['segmentation'] as List<dynamic>? ?? [];

    final List<double> chartValues = List<double>.from(
        _apiData['chart_data'] ?? [160.0, 140.0, 130.0, 100.0]);

    return CustomScrollView(
      slivers: [
        _buildMinistryHeader(
            "TOURISM OVERVIEW", "Comprehensive insights for planning"),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatCard(
                    "Total Visitors",
                    stats['tourists']?.toString() ?? "0",
                    12.5,
                    Icons.people_outline),
                _buildStatCard(
                    "Monthly Revenue",
                    stats['revenue']?.toString() ?? "JD 0",
                    8.2,
                    Icons.account_balance_wallet_outlined),
                _buildStatCard(
                    "Top Locations",
                    stats['top_locations']?.toString() ?? "0",
                    2.0,
                    Icons.location_on_outlined),
                const SizedBox(height: 30),
                Text("VISITED LOCATIONS TREND",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: primaryMaroon)),
                Text("Popularity scale across destinations",
                    style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                const SizedBox(height: 20),
                _buildBarChart(chartValues),
                const SizedBox(height: 30),
                _buildMarketSegmentation(segmentationData),
                const SizedBox(height: 40),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, double growth, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(color: Colors.black54, fontSize: 15)),
              const SizedBox(height: 5),
              Text(value,
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(Icons.trending_up, size: 16, color: Colors.green),
                  const SizedBox(width: 5),
                  Text("+$growth% vs last month",
                      style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                          fontSize: 13)),
                ],
              )
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: const Color(0xFF4A5568),
                borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: Colors.white, size: 28),
          )
        ],
      ),
    );
  }

  Widget _buildBarChart(List<double> values) {
    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(values.length, (index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 40,
                height: values[index],
                decoration: BoxDecoration(
                  color: primaryMaroon.withOpacity(0.7),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(5)),
                ),
              ),
              const SizedBox(height: 8),
              Text("AREA ${index + 1}",
                  style: const TextStyle(
                      fontSize: 9, fontWeight: FontWeight.bold)),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildLiveMapTab() {
    return CustomScrollView(
      slivers: [
        _buildMinistryHeader(
            "LIVE OPERATIONS", "Real-time regional monitoring"),
        SliverToBoxAdapter(
          child: Column(
            children: [
              _buildRegionFilters(),
              _buildJordanMapStack(),
              _buildRegionDetailList(),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildJordanMapStack() {
    List<dynamic> pins = _apiData['map_pins'] ?? [];
    return Container(
      height: 350,
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: FlutterMap(
          options: const MapOptions(
              initialCenter: LatLng(31.240, 36.514), initialZoom: 6.5),
          children: [
            TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.rahhal.app'),
            MarkerLayer(
              markers: pins.map((pin) {
                double lat = double.tryParse(pin['latitude'].toString()) ?? 0.0;
                double lng =
                    double.tryParse(pin['longitude'].toString()) ?? 0.0;
                return Marker(
                  point: LatLng(lat, lng),
                  width: 80,
                  height: 60,
                  child: _mapPin(
                      pin['name_en'] ?? '', "${pin['visitors_count'] ?? 0}"),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportsTab() {
    return CustomScrollView(
      slivers: [
        _buildMinistryHeader(
            "Sector Performance", "Refine Analysis: Last 30 Days"),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildSectorCard("Hotels & Accommodation", "84% Occ.", "+5.2%",
                  [10, 25, 20, 45, 35, 60]),
              _buildSectorCard("Heritage Sites", "450k Visits", "+12.8%",
                  [5, 10, 25, 30, 45, 70]),
              const SizedBox(height: 20),
              _buildExecutiveSummary(),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildExecutiveSummary() => Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
            color: secondaryMaroon, borderRadius: BorderRadius.circular(20)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("EXECUTIVE SUMMARY",
              style: TextStyle(
                  color: zadGold,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5)),
          const SizedBox(height: 12),
          const Text(
              "Overall tourism sector performance shows 4.8% growth. Heritage sites remain the primary drivers.",
              style: TextStyle(color: Colors.white, fontSize: 14, height: 1.5)),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () =>
                launchUrl(Uri.parse('http://10.0.2.2:8000/api/admin/export/')),
            style: ElevatedButton.styleFrom(
                backgroundColor: zadGold, foregroundColor: Colors.black),
            icon: const Icon(Icons.file_download_outlined),
            label: const Text("Generate Full Report"),
          )
        ]),
      );

  Widget _buildMarketSegmentation(List<dynamic> segmentationData) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text("Market Segmentation",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 15),
        ...segmentationData
            .map((data) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: LinearProgressIndicator(
                    value: (data['count'] ?? 0) / 100,
                    backgroundColor: Colors.grey.shade200,
                    color: primaryMaroon,
                    minHeight: 6,
                  ),
                ))
            .toList(),
      ]),
    );
  }

  Widget _buildMinistryHeader(String t, String s) => SliverAppBar(
        pinned: true,
        expandedHeight: 100,
        backgroundColor: primaryMaroon,
        flexibleSpace: FlexibleSpaceBar(
          title: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold)),
                Text(s,
                    style: const TextStyle(fontSize: 8, color: Colors.white70)),
              ]),
        ),
      );

  Widget _buildNavbar() => BottomNavigationBar(
        currentIndex: _tabIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryMaroon,
        unselectedItemColor: Colors.grey,
        onTap: (i) => setState(() => _tabIndex = i),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined), label: "Live Map"),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart), label: "Analytics"),
          BottomNavigationBarItem(
              icon: Icon(Icons.description_outlined), label: "Reports"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined), label: "Setup"),
        ],
      );

  Widget _mapPin(String name, String val) => Column(children: [
        Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: primaryMaroon, borderRadius: BorderRadius.circular(8)),
            child: Text("$name: $val",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold))),
        const Icon(Icons.location_on, color: Colors.red, size: 30)
      ]);

  Widget _buildRegionFilters() {
    final regions = ["All Regions", "Amman", "Petra", "Aqaba"];
    return Container(
        height: 50,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: regions.length,
            itemBuilder: (context, i) => Padding(
                padding: const EdgeInsets.only(left: 15),
                child: ChoiceChip(
                    label: Text(regions[i]),
                    selected: _selectedRegion == regions[i],
                    onSelected: (s) {
                      setState(() => _selectedRegion = regions[i]);
                      _refreshData();
                    }))));
  }

  Widget _buildRegionDetailList() => const SizedBox.shrink();
  Widget _buildSectorCard(String t, String v, String tr, List<double> p) =>
      const SizedBox.shrink();
  Widget _buildSettingsTab() =>
      const Center(child: Text("System Settings - Rahhal v2"));
}
