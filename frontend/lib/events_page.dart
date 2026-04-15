import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/event_model.dart';
import 'providers/favorites_provider.dart';
import 'saved_page.dart';
import 'explorPage.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  int _selectedCategory = 0;

  final List<Event> _allEvents = [
    Event(
      title: "Jerash Festival",
      date: "Jul 24 - Aug 03",
      location: "Jerash Ancient City, Jordan",
      description: "Experience world-class performances including opera, ballet, and traditional folklore.",
      imageUrl: "https://images.unsplash.com/photo-1548115184-bc6544d06a58",
      category: "Cultural",
    ),
    Event(
      title: "Petra by Night",
      date: "Every Mon, Wed, Thu • 20:30",
      location: "The Treasury, Petra",
      description: "Walk the Siq by candle-light and enjoy traditional Bedouin music and storytelling.",
      imageUrl: "https://i.pinimg.com/1200x/f3/bf/0f/f3bf0fa68a953acc4fe0307e61373950.jpg",
      buttonText: "Reservations",
      category: "Cultural",
    ),
    Event(
      title: "Amman Jazz Festival",
      date: "Sep 15 - Sep 17",
      location: "Amman, Jordan",
      description: "Annual jazz festival featuring local and international artists.",
      imageUrl: "https://images.unsplash.com/photo-1514320291840-2e0a9bf2a9ae",
      category: "Music",
    ),
    Event(
      title: "Wadi Rum Desert Trek",
      date: "Oct 10 - Oct 12",
      location: "Wadi Rum, Jordan",
      description: "Adventure trek through the stunning desert landscapes.",
      imageUrl: "https://images.unsplash.com/photo-1509316785289-025f5b846b35",
      category: "Adventure",
    ),
  ];

  List<Event> get _filteredEvents {
    if (_selectedCategory == 0) return _allEvents;
    final categories = ["All Events", "Cultural", "Music", "Adventure"];
    return _allEvents.where((e) => e.category == categories[_selectedCategory]).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4E9), 
     appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF8B2323), size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Rahhal Events",
          style: TextStyle(
            color: Color(0xFF8B2323),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildCategoryTabs(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredEvents.length,
              itemBuilder: (context, index) => _buildEventCard(_filteredEvents[index]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF702632),
        unselectedItemColor: Colors.grey,
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ExploreScreen()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SavedPage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Explore"),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: "Events"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Saved"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    final categories = ["All Events", "Cultural", "Music", "Adventure"];
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => setState(() => _selectedCategory = index),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              categories[index],
              style: TextStyle(
                color: _selectedCategory == index ? const Color(0xFF702632) : Colors.grey,
                fontWeight: _selectedCategory == index ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventCard(Event event) {
    final favoritesProvider = context.read<FavoritesProvider>();
    final isSaved = favoritesProvider.isFavorite(event.title);

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.network(event.imageUrl, height: 180, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 14, color: Color(0xFF702632)),
                    const SizedBox(width: 5),
                    Text(event.date, style: const TextStyle(color: Color(0xFF702632), fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(event.location, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                const SizedBox(height: 12),
                Text(event.description, style: TextStyle(color: Colors.grey[800], fontSize: 14, height: 1.4)),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF702632),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text(event.buttonText, style: const TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!), borderRadius: BorderRadius.circular(8)),
                      child: IconButton(
                        onPressed: () {
                          favoritesProvider.toggleFavorite({
                            'name': event.title,
                            'location': event.location,
                            'image': event.imageUrl,
                            'type': 'event',
                          });
                        },
                        icon: Icon(
                          isSaved ? Icons.bookmark : Icons.bookmark_border,
                          color: const Color(0xFF702632),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}