import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';

class SavedPage extends StatelessWidget {
  const SavedPage({super.key});

  @override
  Widget build(BuildContext context) {
    //  list from provider
    final savedList = context.watch<FavoritesProvider>().savedItems;

    return Scaffold(
      backgroundColor: const Color(0xFFE7E9D3),
      appBar: AppBar(
        title: const Text("Saved Items", style: TextStyle(color: Color(0xFF702632))),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: savedList.isEmpty
          ? const Center(child: Text("No saved items yet!"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: savedList.length,
              itemBuilder: (context, index) {
                final item = savedList[index];
                
                return ListTile(
                  title: Text(item['name']),
                  subtitle: Text(item['location']),
                  leading: Image.network(item['image'], width: 50, fit: BoxFit.cover),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => context.read<FavoritesProvider>().toggleFavorite(item),
                  ),
                );
              },
            ),
    );
  }
}