import 'package:flutter/material.dart';
import 'auth_page.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  // Language State
  String selectedLanguage = 'English';
  List<String> languages = ['English', 'العربية'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          //bgImage
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/welcomebg.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: _buildLanguageSelector(),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //WELCOMETitle
                      _buildWelcomeTitle(),

                      SizedBox(height: 18),

                      // First text
                      Text(
                        "From visa to discovery — all in one place.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),

                      SizedBox(height: 50),

                      // Second text
                      Text(
                        "Plan, book, and explore Jordan with one digital pass.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),

                      SizedBox(height: 35),

                      //BUTTONS
                      //Sign In
                      _buildMainButton(
                        text: "Sign In",
                        color: Color(0xff7C2131),
                        textColor: Colors.white,
                        icon: Icons.login_outlined,
                        onPressed: () {
                          _navigateToAuth(isLogin: true);
                        },
                      ),

                      SizedBox(height: 15),

//create account
                      _buildMainButton(
                        text: "Create Account",
                        color: Colors.white,
                        textColor: Color(0xff7C2131),
                        icon: Icons.person_add_outlined,
                        onPressed: () {
                          _navigateToAuth(isLogin: false);
                        },
                      ),

                      SizedBox(height: 20),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // //WELCOMETitle fullcode
  Widget _buildWelcomeTitle() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(
            color: Colors.white, fontSize: 28.5, fontWeight: FontWeight.bold),
        children: [
          TextSpan(text: "WELCOME TO "),
          TextSpan(
            text: "RAHHAL",
            style: TextStyle(
              shadows: [
                Shadow(
                    color: Color(0xFF80152B),
                    offset: Offset(4, 4),
                    blurRadius: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //language switcher
  Widget _buildLanguageSelector() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedLanguage,
          dropdownColor: Colors.black.withOpacity(0.8),
          icon: Icon(Icons.expand_more, color: Colors.white),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          items: languages.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              selectedLanguage = newValue!;

              // I will Add logic here later
            });
          },
        ),
      ),
    );
  }

  Widget _buildMainButton({
    required String text,
    required Color color,
    required Color textColor,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(
          text,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  //  NAVIGATION logic
  void _navigateToAuth({required bool isLogin}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AuthPage(
          initialIsLogin: isLogin,
          selectedLanguage: this.selectedLanguage == 'English' ? 'en' : 'ar',
        ),
      ),
    );
  }
}
