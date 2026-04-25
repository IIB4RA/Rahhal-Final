import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'auth_page.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int _tabIndex = 0;
  String _selectedRegion = "All Regions";
  bool _isLoading = true;
  Map<String, dynamic> _apiData = {};

  final storage = const FlutterSecureStorage();
  String _adminName = "Admin";

  final Color primaryMaroon = const Color(0xFF8B2635);
  final Color secondaryMaroon = const Color(0xFF5E1A24);
  final Color zadGold = const Color(0xFFD4AF37);

  @override
  void initState() {
    super.initState();
    _loadAdminName();
    _refreshData();
  }

  Future<void> _loadAdminName() async {
    String? name = await storage.read(key: 'user_name');

    if (name != null && name.trim().isNotEmpty && name != "null") {
      setState(() => _adminName = name);
    } else {
      setState(() => _adminName = 'Admin');
    }
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
      backgroundColor: const Color(0xFFFBFBFB),
      bottomNavigationBar: _buildNavbar(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: primaryMaroon))
          : IndexedStack(
              index: _tabIndex,
              children: [
                _buildLiveMapTab(),
                _buildAnalyticsTab(),
                _buildReportsTab(),
                _buildSettingsTab(),
              ],
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

  Widget _buildRegionFilters() {
    final regions = ["All Regions", "Amman", "Petra", "Aqaba", "Dead Sea"];
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: regions.length,
        itemBuilder: (context, i) {
          bool isSel = _selectedRegion == regions[i];
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ChoiceChip(
              label: Text(regions[i]),
              selected: isSel,
              selectedColor: primaryMaroon,
              labelStyle: TextStyle(
                  color: isSel ? Colors.white : primaryMaroon, fontSize: 12),
              onSelected: (bool selected) {
                setState(() => _selectedRegion = regions[i]);
                _refreshData();
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildJordanMapStack() {
    List<dynamic> pins = _apiData['map_pins'] ?? [];

    if (_selectedRegion != "All Regions") {
      pins = pins.where((pin) => pin['name_en'] == _selectedRegion).toList();
    }

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
            initialCenter: LatLng(31.240, 36.514),
            initialZoom: 6.5,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.rahhal.app',
            ),
            MarkerLayer(
              markers: pins.map((pin) {
                double lat = double.tryParse(pin['latitude'].toString()) ?? 0.0;
                double lng =
                    double.tryParse(pin['longitude'].toString()) ?? 0.0;

                return Marker(
                  point: LatLng(lat, lng),
                  width: 80,
                  height: 60,
                  child: _mapPin(pin['name_en'], "${pin['visitors_count']}"),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _mapPin(String name, String val) => Column(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: primaryMaroon, borderRadius: BorderRadius.circular(8)),
            child: Text("$name: $val",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold)),
          ),
          const Icon(Icons.location_on, color: Colors.red, size: 30),
        ],
      );

  Widget _buildAnalyticsTab() {
    final stats = _apiData['stats'] ?? {};
    final segmentationData = _apiData['segmentation'] as List<dynamic>? ?? [];

    return CustomScrollView(
      slivers: [
        _buildMinistryHeader("Data Insights", "Aggregated performance metrics"),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildStatGrid(stats),
                const SizedBox(height: 20),
                _buildMarketSegmentation(segmentationData),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildStatGrid(Map stats) => GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 1.4,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _statCard("TOTAL TOURISTS", stats['tourists'] ?? "0", "+12.5%",
              Icons.groups),
          _statCard("TOTAL REVENUE", stats['revenue'] ?? "JD 0", "+8.2%",
              Icons.account_balance_wallet),
          _statCard("BOOKINGS", stats['bookings'] ?? "0", "+5.1%",
              Icons.calendar_month),
          _statCard(
              "AVG. STAY", stats['avg_stay'] ?? "0d", "-2.0%", Icons.timer),
        ],
      );

  Widget _statCard(String l, String v, String g, IconData i) => Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade100)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Icon(i, color: primaryMaroon, size: 18),
            Text(g,
                style: const TextStyle(
                    color: Colors.green,
                    fontSize: 10,
                    fontWeight: FontWeight.bold)),
          ]),
          const Spacer(),
          Text(v,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(l, style: const TextStyle(color: Colors.grey, fontSize: 9)),
        ]),
      );

  Widget _buildMarketSegmentation(List<dynamic> segmentationData) {
    if (segmentationData.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: const Text("No segmentation data available yet.",
            style: TextStyle(color: Colors.grey)),
      );
    }

    int total = segmentationData.fold(
        0, (sum, item) => sum + ((item['count'] ?? 0) as int));

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Market Segmentation",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 15),
          ...segmentationData.map((data) {
            String name = data['nationality'] ?? 'Unknown';
            int count = data['count'] ?? 0;
            double pct = total > 0 ? count / total : 0.0;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(name, style: const TextStyle(fontSize: 12)),
                      Text("$count (${(pct * 100).toInt()}%)",
                          style: const TextStyle(
                              fontSize: 11, fontWeight: FontWeight.bold)),
                    ]),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                    value: pct,
                    backgroundColor: Colors.grey.shade200,
                    color: primaryMaroon,
                    minHeight: 6),
              ]),
            );
          }).toList(),
        ],
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
              _buildSectorCard("Transport & Aviation", "1.2M Pax", "-2.1%",
                  [60, 50, 40, 30, 35, 20]),
              _buildSectorCard("Heritage Sites", "450k Visits", "+12.8%",
                  [5, 10, 25, 30, 45, 70]),
              const SizedBox(height: 20),
              _buildEntityTable(),
              const SizedBox(height: 30),
              _buildExecutiveSummary(),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildEntityTable() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(children: [
            Expanded(
                flex: 3,
                child: Text("Entity",
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey))),
            Expanded(
                child: Text("Vol.",
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey))),
            Expanded(
                child: Text("Trend",
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey))),
            Expanded(
                child: Text("Yield",
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey))),
          ]),
        ),
        _tableRow("Luxury Hotels", "124k", "+8.4%", "\$342.0"),
        _tableRow("National Airways", "840k", "-3.2%", "\$112.5"),
        _tableRow("The Royal Citadel", "210k", "+15.2%", "\$24.0"),
      ]),
    );
  }

  Widget _tableRow(String name, String vol, String trend, String yieldNum) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(children: [
          Expanded(
              flex: 3,
              child: Text(name,
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.bold))),
          Expanded(child: Text(vol, style: const TextStyle(fontSize: 11))),
          Expanded(
              child: Text(trend,
                  style: TextStyle(
                      fontSize: 11,
                      color: trend.contains('+') ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold))),
          Expanded(child: Text(yieldNum, style: const TextStyle(fontSize: 11))),
        ]),
      );

  Widget _buildSectorCard(
          String title, String val, String trend, List<double> pts) =>
      Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade100)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 5),
                    Text(val,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    Text(trend,
                        style: TextStyle(
                            color:
                                trend.contains('+') ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold)),
                  ]),
            ),
            SizedBox(
                width: 120, height: 60, child: LineChart(_sparklineData(pts))),
          ],
        ),
      );

  LineChartData _sparklineData(List<double> pts) => LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: pts
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value))
                .toList(),
            isCurved: true,
            color: primaryMaroon,
            barWidth: 3,
            dotData: const FlDotData(show: false),
            belowBarData:
                BarAreaData(show: true, color: primaryMaroon.withOpacity(0.05)),
          )
        ],
      );

  Widget _buildExecutiveSummary() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: secondaryMaroon,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "EXECUTIVE SUMMARY",
            style: TextStyle(
                color: zadGold,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5),
          ),
          const SizedBox(height: 12),
          const Text(
              "Overall tourism sector performance shows 4.8% growth. Heritage sites remain the primary drivers of revenue.",
              style: TextStyle(color: Colors.white, fontSize: 14, height: 1.5)),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () =>
                launchUrl(Uri.parse('http://10.0.2.2:8000/api/admin/export/')),
            style: ElevatedButton.styleFrom(
                backgroundColor: zadGold,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
            icon: const Icon(Icons.file_download_outlined),
            label: const Text("Generate Full Report",
                style: TextStyle(fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    return CustomScrollView(
      slivers: [
        _buildMinistryHeader(
            "SYSTEM SETUP", "Configure Ministry Portal Settings"),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _setupSectionTitle("Admin Profile"),
                _setupTile(
                    Icons.person_outline, "User: $_adminName", "Active Session",
                    () {
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                          title: const Text("Profile"),
                          content: Text("Logged in as: $_adminName")));
                }),
                const SizedBox(height: 20),
                _setupSectionTitle("Database & Sync"),
                _setupTile(Icons.storage, "Supabase Connection",
                    "Active - Latency 24ms", () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Database connection stable.")));
                }),
                _setupTile(Icons.sync, "Automatic Data Sync", "Every 5 Minutes",
                    () {}),
                const SizedBox(height: 20),
                _setupSectionTitle("Account Actions"),

                // --- زر الـ Logout ---
                _setupTile(Icons.logout, "Logout", "Sign out of portal",
                    () async {
                  await storage.deleteAll();
                  if (mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => AuthPage()),
                      (route) => false,
                    );
                  }
                }),

                const SizedBox(height: 30),
                Center(
                  child: Text("App Version 1.0.4 - Rahhal Backend v2",
                      style:
                          TextStyle(color: Colors.grey.shade400, fontSize: 10)),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _setupSectionTitle(String t) => Text(t,
      style: const TextStyle(
          fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey));

  Widget _setupTile(IconData i, String t, String s, VoidCallback onTap) =>
      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
            backgroundColor: Colors.grey.shade100,
            child: Icon(i, color: primaryMaroon, size: 20)),
        title: Text(t,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(s, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right, size: 16),
        onTap: onTap,
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

  Widget _buildMinistryHeader(String t, String s) => SliverAppBar(
        pinned: true,
        expandedHeight: 120,
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

  Widget _buildRegionDetailList() => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Regional Status",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _regionRow("Amman", "3.8k", "Normal"),
            _regionRow("Petra", "4.1k", "Busy"),
          ],
        ),
      );

  Widget _regionRow(String n, String v, String s) => ListTile(
        title: Text(n),
        trailing: Text("$v ($s)",
            style:
                TextStyle(color: primaryMaroon, fontWeight: FontWeight.bold)),
      );
}
