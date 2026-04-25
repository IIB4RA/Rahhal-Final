import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'providers/favorites_provider.dart';
import 'providers/visa_application_provider.dart';
import 'welcomepage.dart';
import 'home_page.dart';
import 'auth_service.dart';

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
      (remember && accessToken != null) ? const HomePage() : WelcomePage();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => VisaApplicationProvider()),
      ],
      child: MaterialApp(
        title: 'Rahhal App',
        navigatorKey: navigatorKey,
        home: initialPage,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFF8B2323),
          useMaterial3: true,
        ),
      ),
    ),
  );
}
