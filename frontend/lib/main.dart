import 'package:flutter/material.dart';

import 'package:frontend/home_page.dart';
import 'package:provider/provider.dart';
import 'providers/favorites_provider.dart';
import 'aiAssistant_page.dart';
import'personal_info_page.dart';
import 'welcomepage.dart';
import 'main_wrapper.dart';
import 'explorPage.dart';
import 'hotelBoookingPage.dart';
import 'events_page.dart';
import 'admin_page.dart';
import 'profile.dart';
import "home_page.dart";
import 'auth_page.dart';
import "auth_service.dart";
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = const FlutterSecureStorage();
  bool remember = await shouldRememberMe();
  String? accessToken = await storage.read(key: 'access_token');

  if (!remember) {
    await logout();
  }

  Widget initialPage = (remember && accessToken != null) ?  HomePage() :  WelcomePage();

  runApp(
   MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: MaterialApp(
        home: initialPage,
        navigatorKey: navigatorKey,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: WelcomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}