import 'package:flutter/material.dart';
import 'personal_info_page.dart';
import 'digitalPass.dart';
import 'visa_approved_page.dart';
import 'custom_bottom_nav.dart';
import 'api_service.dart';



class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

 Future<Map<String, dynamic>> fetchProfileData() async {
    try {
      final data = await ApiService().request(
        method: 'GET',
        endpoint: '/me/', 
        requiresAuth: true,
      );
      return data;
      } catch (e) {
        print("Backend Connection Error: $e");
        throw e;
       }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryRed = Color(0xFF8B2635);
    const Color backgroundBeige = Color(0xFFF9F7F0);
    const Color cardBackground = Colors.white;

    return FutureBuilder<Map<String, dynamic>?>(
    future: fetchProfileData(), 
    builder: (context, snapshot) {
      
      // While waiting for the backend
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      // Extract the data (the 'body')
      final userData = snapshot.data;

    return Scaffold(
      backgroundColor: backgroundBeige,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back, color: Color(0xFF8B2323), size: 28),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Header Section
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor:
                        Colors.grey, // Placeholder for backend image
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                   Text(
                    (userData?['full_name'] != null && userData!['full_name'].toString().isNotEmpty)
                    ? userData!['full_name']
                    : 'User', // Placeholder for name
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A2B48)),
                  ),
                  const Text(
                    'VERIFIED CITIZEN',
                    style: TextStyle(
                        color: primaryRed,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'ID: #JOR-882944',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // PriorityServices Section
            const _SectionHeader(title: 'PRIORITY SERVICES'),
            Row(
              children: [
                Expanded(
                  child: _ServiceCard(
                    icon: Icons.confirmation_number_outlined,
                    title: 'My Jordan Pass',
                    subtitle: 'Active',
                    subtitleColor: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const JordanPassPage()),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _ServiceCard(
                    icon: Icons.badge_outlined,
                    title: 'Visa Status',
                    subtitle: 'Expires: Jan 2025',
                    subtitleColor: Colors.grey,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const VisaApprovedPage()),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // AccountSettings Section
            const _SectionHeader(title: 'ACCOUNT SETTINGS'),
            Container(
              decoration: BoxDecoration(
                color: cardBackground,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  _SettingsTile(
                    icon: Icons.person_outline,
                    title: 'Personal Information',
                    subtitle: 'Edit your profile details',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PersonalInfoPage()),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  _SettingsTile(
                    icon: Icons.description_outlined,
                    title: 'Linked Documents',
                    subtitle: 'Passport, ID, Certificates',
                  ),
                  const Divider(height: 1),
                  _SettingsTile(
                    icon: Icons.tune_outlined,
                    title: 'App Preferences',
                    subtitle: 'Language, Theme, Display',
                  ),
                  const Divider(height: 1),
                  _SettingsTile(
                    icon: Icons.notifications_none_outlined,
                    title: 'Push Notifications',
                    subtitle: 'Alerts, Updates, Reminders',
                    isLast: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
     bottomNavigationBar: const CustomBottomNav(currentIndex: 4),
    );
  }
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              letterSpacing: 1.1,
              color: Color(0xFF1A2B48)),
        ),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color subtitleColor;
  final VoidCallback? onTap;

  const _ServiceCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.subtitleColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: const Color(0xFFF9EBEB),
                  borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: const Color(0xFF8B2635), size: 24),
            ),
            const SizedBox(height: 12),
            Text(title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 4),
            Text(subtitle,
                style: TextStyle(color: subtitleColor, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isLast;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isLast = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF8B2635)),
      title: Text(title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
      subtitle: Text(subtitle,
          style: const TextStyle(fontSize: 12, color: Colors.grey)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}