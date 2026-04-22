import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'providers/favorites_provider.dart';
import 'auth_service.dart';
import 'auth_page.dart';
import 'home_page.dart';
import 'admin_page.dart';
import 'aiAssistant_page.dart';
import 'personal_info_page.dart';
import 'welcomepage.dart';
import 'main_wrapper.dart';
import 'explorPage.dart';
import 'hotelBoookingPage.dart';
import 'events_page.dart';
import 'profile.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = const FlutterSecureStorage();
  bool remember = await shouldRememberMe();
  String? accessToken = await storage.read(key: 'access_token');

  if (!remember) {
    await logout();
  }

  Widget initialPage =
      (remember && accessToken != null) ? HomePage() : AuthPage();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: MyApp(initialPage: initialPage),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Widget initialPage;

  const MyApp({super.key, required this.initialPage});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Rahhal App',
      theme: ThemeData(
        primaryColor: const Color(0xFF8B2635),
        useMaterial3: true,
      ),
      home: initialPage,
    );
  }
}
