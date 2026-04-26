import 'package:flutter/material.dart';
import 'api_service.dart';
import 'custom_bottom_nav.dart';
import 'details_page.dart';

class HotelBookingScreen extends StatefulWidget {
  const HotelBookingScreen({super.key});

  @override
  State<HotelBookingScreen> createState() => _HotelBookingScreenState();
}

class _HotelBookingScreenState extends State<HotelBookingScreen> {
  late Future<dynamic> _hotelsFuture;
  List<dynamic> _allHotels = [];
  List<dynamic> _filteredHotels = [];

  String _selectedPriceRange = "Price";
  String _selectedRating = " Rating";
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _hotelsFuture = _fetchHotelsData();
  }

  Future<dynamic> _fetchHotelsData() async {
    try {
      final data = await ApiService().request(
        method: 'GET',
        endpoint: '/tourism/hotel/',
        requiresAuth: true,
      );

      if (data is List) {
        _allHotels = data;
      } else if (data is Map && data.containsKey('results')) {
        _allHotels = data['results'] as List<dynamic>;
      }
      _filteredHotels = _allHotels;
      return data;
    } catch (e) {
      debugPrint("Backend Connection Error: $e");
      rethrow;
    }
  }

  // تصليح منطق الفلترة ليكون أدق
  void _applyFilters() {
    setState(() {
      _filteredHotels = _allHotels.where((hotel) {
        // 1. فلترة البحث بالاسم
        final nameMatches = (hotel['name_en'] ?? "")
            .toString()
            .toLowerCase()
            .contains(_searchController.text.toLowerCase());

        // 2. فلترة السعر
        bool priceMatches = true;
        double price =
            double.tryParse(hotel['price_per_night'].toString()) ?? 0.0;
        if (_selectedPriceRange == "Under \$100") {
          priceMatches = price < 100;
        } else if (_selectedPriceRange == "\$100 - \$200") {
          priceMatches = price >= 100 && price <= 200;
        }

        // 3. فلترة التقييم (Rating)
        bool ratingMatches = true;
        if (_selectedRating != "All") {
          double hotelRating =
              double.tryParse(hotel['avg_rating']?.toString() ?? "0") ?? 0.0;
          double targetRating = double.parse(_selectedRating);
          ratingMatches = hotelRating >= targetRating;
        }

        return nameMatches && priceMatches && ratingMatches;
      }).toList();
    });
  }

  String _getFullImageUrl(String? url) {
    if (url == null || url.isEmpty) {
      return 'https://placehold.co/600x400/png?text=No+Image';
    }
    if (url.toLowerCase().startsWith('http')) {
      return url;
    }
    return 'https://rahhal-final-production.up.railway.app$url';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE7E9D3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF702632)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          children: [
            Text("Rihla Stays",
                style: TextStyle(
                    color: Color(0xFF702632), fontWeight: FontWeight.bold)),
            Text("Jordan", style: TextStyle(color: Colors.brown, fontSize: 12)),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilters(),
          // تم حذف الماب من هنا كما طلبت
          Expanded(
            child: FutureBuilder<dynamic>(
              future: _hotelsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child:
                          CircularProgressIndicator(color: Color(0xFF702632)));
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                if (_filteredHotels.isEmpty) {
                  return const Center(child: Text("No hotels found."));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _filteredHotels.length,
                  itemBuilder: (context, index) {
                    return _buildHotelCard(_filteredHotels[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 3),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: _searchController,
        onChanged: (val) => _applyFilters(),
        decoration: InputDecoration(
          hintText: "Search hotels...",
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _filterDropdown("Price", ["All", "Under \$100", "\$100 - \$200"],
              (val) {
            _selectedPriceRange = val!;
            _applyFilters();
          }),
          const SizedBox(width: 10),
          _filterDropdown("Rating", ["All", "5", "4", "3"], (val) {
            _selectedRating = val!;
            _applyFilters();
          }),
        ],
      ),
    );
  }

  Widget _filterDropdown(
      String hint, List<String> items, Function(String?) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text(hint, style: const TextStyle(fontSize: 12)),
          value: items.contains(hint)
              ? hint
              : items[0], // لضمان وجود قيمة افتراضية
          items: items
              .map((String value) =>
                  DropdownMenuItem(value: value, child: Text(value)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildHotelCard(Map<String, dynamic> hotel) {
    // حل مشكلة الـ Null باستخدام الأسماء المتوقعة من الباك إند
    String name = hotel['name_en'] ?? 'Unknown Hotel';
    String price = hotel['price_per_night']?.toString() ?? '0';
    String rating = hotel['avg_rating']?.toString() ?? '0.0';
    String reviews = hotel['total_reviews']?.toString() ?? '0';
    String location = hotel['location'] ?? hotel['region_name_en'] ?? 'Jordan';
    String finalImageUrl = _getFullImageUrl(hotel['image_url']);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5))
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  finalImageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 200,
                    color: Colors.grey[200],
                    child: const Center(
                        child: Icon(Icons.broken_image,
                            size: 50, color: Colors.grey)),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Text(name,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis)),
                    Text("\$$price",
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF702632))),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    Text(" $rating ($reviews reviews)",
                        style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      const Icon(Icons.location_on,
                          size: 16, color: Color(0xFF702632)),
                      const SizedBox(width: 4),
                      Text(location,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500)),
                    ]),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DetailsPage(attraction: hotel)));
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF702632),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                      child: const Text("Book Now",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
