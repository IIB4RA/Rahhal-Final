import 'package:flutter/material.dart';
import 'package:frontend/home_page.dart';
import 'questionsPage.dart';
import 'api_service.dart';
import 'auth_service.dart';
import 'admin_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthPage extends StatefulWidget {
  final bool initialIsLogin;
  final String selectedLanguage;
  AuthPage({
    super.key,
    this.initialIsLogin = true,
    this.selectedLanguage = 'en',
  });

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late bool isLogin = true;
  late String currentLanguage;
  bool rememberMe = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    isLogin = widget.initialIsLogin;
    currentLanguage = widget.selectedLanguage;
  }

  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Future<Map<String, dynamic>?> handleAuth() async {
    final String identifier = _identifierController.text.trim();
    final String password = _passwordController.text.trim();
    final String confirmPassword = _confirmPasswordController.text.trim();

    Map<String, String> authData = {
      "identifier": identifier,
      "password": password,
    };

    if (!isLogin) {
      authData["confirm_password"] = confirmPassword;
      authData['language'] = currentLanguage;
    }

    final endpoint = isLogin ? '/login/' : '/register/';

    try {
      debugPrint("DEBUG AUTH: calling endpoint=$endpoint with data=$authData");
      final data = await ApiService().request(
        method: 'post',
        endpoint: endpoint,
        data: authData,
        requiresAuth: false,
      );

      if (data != null && data['access_token'] != null) {
        await saveRememberMe(rememberMe);
        await saveTokens(data['access_token'], data['refresh_token']);
        return data;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 59, 56, 56),
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 280,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: const AssetImage(
                          "assets/images/signinLoginPHOTO.jpg"),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.4),
                        BlendMode.darken,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: SafeArea(
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white, size: 28),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isLogin ? "Welcome again !" : "Welcome !",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 33,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isLogin
                            ? "Your journey awaits"
                            : "Start your unforgettable journey in Jordan.",
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 25,
                  left: 20,
                  right: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        _buildToggleButton("LOGIN", true),
                        _buildToggleButton("SIGNUP", false),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xffEAE3D2),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label("Email / Phone"),
                      _inputField(
                        controller: _identifierController,
                        hint: "Enter your Email / Phone here",
                        icon: Icons.phone,
                      ),
                      const SizedBox(height: 15),
                      _label("Password"),
                      _inputField(
                        controller: _passwordController,
                        hint: "Enter your password here",
                        icon: Icons.lock,
                        isPassword: true,
                      ),
                      if (!isLogin) ...[
                        const SizedBox(height: 15),
                        _label("Confirm Password"),
                        _inputField(
                          controller: _confirmPasswordController,
                          hint: "Confirm your password",
                          icon: Icons.lock,
                          isPassword: true,
                        ),
                      ],
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: rememberMe,
                                activeColor:
                                    const Color.fromARGB(255, 56, 170, 39),
                                onChanged: (val) {
                                  setState(() {
                                    rememberMe = val!;
                                  });
                                },
                              ),
                              const Text("Remember me"),
                            ],
                          ),
                          if (isLogin)
                            const Text(
                              "Forgot Password?",
                              style: TextStyle(
                                  color: Color.fromRGBO(124, 33, 49, 1)),
                            ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xff1C2340),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 14),
                          ),
                          onPressed: _isLoading
                              ? null
                              : () async {
                                  setState(() => _isLoading = true);
                                  try {
                                    final data = await handleAuth();
                                    if (data != null && mounted) {
                                      // تخزين الاسم من الداتا بيس
                                      final storage =
                                          const FlutterSecureStorage();
                                      String nameFromDb = data['user']
                                              ?['full_name'] ??
                                          data['user']?['username'] ??
                                          'Admin';
                                      await storage.write(
                                          key: 'user_name', value: nameFromDb);

                                      if (!isLogin) {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => QuestionsPage()),
                                        );
                                      } else {
                                        String role =
                                            data['user']?['role'] ?? 'tourist';
                                        if (role == 'admin') {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    const AnalyticsScreen()),
                                          );
                                        } else {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => HomePage()),
                                          );
                                        }
                                      }
                                    }
                                  } catch (e) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(e
                                              .toString()
                                              .replaceAll("Exception: ", "")),
                                          backgroundColor: Colors.redAccent,
                                        ),
                                      );
                                    }
                                  } finally {
                                    if (mounted) {
                                      setState(() => _isLoading = false);
                                    }
                                  }
                                },
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2),
                                )
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      isLogin ? "Continue" : "Create account",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(width: 10),
                                    const Icon(Icons.arrow_forward),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton(String text, bool loginState) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => isLogin = loginState);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isLogin == loginState
                ? const Color.fromRGBO(124, 33, 49, 1)
                : const Color.fromARGB(0, 248, 248, 248),
            borderRadius: BorderRadius.circular(30),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: isLogin == loginState
                  ? Colors.white
                  : const Color.fromRGBO(124, 33, 49, 1),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _inputField({
    required String hint,
    required IconData icon,
    bool isPassword = false,
    TextEditingController? controller,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        suffixIcon: isPassword ? const Icon(Icons.visibility_off) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
