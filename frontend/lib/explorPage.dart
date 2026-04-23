import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'details_page.dart';
import 'providers/favorites_provider.dart';
import 'custom_bottom_nav.dart';
import 'api_service.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  Future<dynamic> explore() async {
    try {
      final data = await Future.wait([
        ApiService().request(method: 'GET', endpoint: '/tourism/attraction/', requiresAuth: true),
        ApiService().request(method: 'GET', endpoint: '/tourism/tour/', requiresAuth: true),
        ApiService().request(method: 'GET', endpoint: '/tourism/event/', requiresAuth: true),
      ]);
      return {
        'attractions': data[0],
        'tours': data[1],
        'events': data[2],
      };
    } catch (e) {
      print("Backend Connection Error: $e");
      throw e;
    }
  }

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late Future<dynamic> _exploreFuture;

  String _selectedCategory = "All";

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _exploreFuture = widget.explore();
  }

  List<dynamic> _filterItems(Map<String, dynamic> data) {
    final attractions = data['attractions'] ?? [];
    final events = data['events'] ?? [];
    final tours = data['tours'] ?? [];

    List<dynamic> results;
    if (_selectedCategory == "All") {
      results = [...attractions, ...events, ...tours];
    } else if (_selectedCategory == "Historical") {
      results = attractions.where((item) => item['category'] == 'historical').toList();
    } else if (_selectedCategory == "Nature") {
      results = attractions.where((item) => item['category'] == 'nature').toList();
    } else if (_selectedCategory == "Adventure") {
      results = attractions.where((item) => item['category'] == 'adventure').toList();
    } else if (_selectedCategory == "Religious") {
      results = attractions.where((item) => item['category'] == 'religious').toList();
    } else if (_selectedCategory == "Cultural") {
      results = attractions.where((item) => item['category'] == 'cultural').toList();
    } else if (_selectedCategory == "Beach") {
      results = attractions.where((item) => item['category'] == 'beach').toList();
    } else if (_selectedCategory == "Desert") {
      results = attractions.where((item) => item['category'] == 'desert').toList();
    } else {
      results = [];
    }

    if (_searchQuery.isNotEmpty) {
      results = results.where((item) {
        final name = (item['name_en'] ?? "").toLowerCase();
        final location = (item['region_name_en'] ?? "").toLowerCase();
        return name.contains(_searchQuery) || location.contains(_searchQuery);
      }).toList();
    }

    return results;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE7E9D3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF8B2323), size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Rahhal – Heritage Guide",
          style: TextStyle(
            color: Color(0xFF8B2323),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildCategoryFilter(),
          Expanded(
            child: FutureBuilder<dynamic>(
              future: _exploreFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF8B2323)),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Error: ${snapshot.error}"),
                  );
                } else if (!snapshot.hasData) {
                  return const Center(child: Text("No data found"));
                }

                final filteredItems = _filterItems(snapshot.data);

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];
                    return _buildAttractionCard(
                      context,
                      item['name_en'] ?? 'Unknown',
                      item['region_name_en'] ?? 'Jordan',
                      (item['avg_rating'] ?? '0.0').toString(),
                      (item['total_reviews'] ?? '0.0').toString(),
                      item['description_en'] ?? 'No description available',
                      (item['max_guests'] != null)
                          ? "${item['max_guests']} guests, ${item['duration_hours']} hours"
                          : (item['event_date'] ?? '--'),
                      (item['price'] ?? item['entry_fee']) ?? 'Free',
                      item['image'] ?? "https://i.pinimg.com/1200x/f3/bf/0f/f3bf0fa68a953acc4fe0307e61373950.jpg",
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 1),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value.toLowerCase();
          });
        },
        decoration: InputDecoration(
          hintText: "Search destinations in Jordan...",
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = "";
                    });
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    final categories = ["All", "Historical", "Nature", "Adventure", "Religious", "Cultural", "Beach", "Desert"];
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final categoryName = categories[index];
          bool isSelected = _selectedCategory == categoryName;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = categoryName;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF702632) : const Color(0xFFD9D9C3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                categoryName,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAttractionCard(BuildContext context, String title, String location, String rating, String total_reviews, String desc, String details, String price, String imgUrl) {
    final favorites = context.watch<FavoritesProvider>();
    bool isSaved = favorites.isFavorite(title);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsPage(
              attraction: {
                'name': title,
                'location': location,
                'rating': rating,
                'reviews': total_reviews,
                'description': desc,
                'price': price,
                'details': details,
                'image': imgUrl,
              },
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.network(
                    imgUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 180,
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: () {
                      favorites.toggleFavorite({
                        'name': title,
                        'location': location,
                        'rating': rating,
                        'description': desc,
                        'image': imgUrl,
                      });
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.white70,
                      radius: 15,
                      child: Icon(
                        isSaved ? Icons.favorite : Icons.favorite_border,
                        size: 18,
                        color: isSaved ? const Color(0xFF702632) : Colors.black,
                      ),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          Text(" $rating", style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(location, style: const TextStyle(color: Color(0xFF702632), fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text(
                    desc,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[600], fontSize: 13, height: 1.4),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}