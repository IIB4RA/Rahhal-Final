import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'details_page.dart';
import 'providers/favorites_provider.dart';
import 'custom_bottom_nav.dart';
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {

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
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildAttractionCard(
                  context,
                  "Petra",
                  "Ma'an Governorate",
                  "4.9",
                  "A world-renowned archaeological site featuring tombs and temples carved into pink sandstone cliffs.",
                  "https://i.pinimg.com/1200x/f3/bf/0f/f3bf0fa68a953acc4fe0307e61373950.jpg",
                ),
                _buildAttractionCard(
                  context,
                  "Wadi Rum",
                  "Aqaba Governorate",
                  "4.8",
                  "Known as the Valley of the Moon, featuring prehistoric carvings and majestic dunes.",
                  "https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd",
                ),
              ],
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
        decoration: InputDecoration(
          hintText: "Search destinations in Jordan...",
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
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
    final categories = ["All", "Historical", "Nature", "Adventure"];
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          bool isSelected = index == 0;
          return Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF702632) : const Color(0xFFD9D9C3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              categories[index],
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAttractionCard(BuildContext context, String title, String location, String rating, String desc, String imgUrl) {
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
                'description': desc,
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
                  child: Image.network(imgUrl, height: 180, width: double.infinity, fit: BoxFit.cover),
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