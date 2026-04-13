import 'package:flutter/material.dart';
import 'home_page.dart';

class SelectTypePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEAE3D2),
       appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Color.fromRGBO(122, 31, 44, 1), size: 28,),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: Text(
          "Rahhal – Heritage Guide",
          style: TextStyle(
            color:  Color.fromRGBO(122, 31, 44, 1),
            fontSize: 14,
            fontWeight: FontWeight.w600, 
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            SizedBox(height: 20),

            // LOGO PLACEHOLDER
            CircleAvatar(
              radius: 50,
              backgroundColor: Color.fromARGB(198, 164, 157, 154),
              child: Text("add logo "),
            ),

            SizedBox(height: 15),

            Text(
              "RAHHAL",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(122, 31, 45, 0.904),
              ),
            ),

            SizedBox(height: 10),

            Text(
              "Your gateway to exploring Jordan.\nAll your travel needs in one place",
              textAlign: TextAlign.center,
              style: TextStyle(color:Color.fromRGBO(122, 31, 44, 0.6),)
            ),

            SizedBox(height: 30),

            Text(
              "How will you use Rahhal?",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 19,
                color: Color.fromRGBO(31, 33, 60, 1)
              ),
            ),

            SizedBox(height: 4),

            Text(
              "Select your profile to personalize your experience in Jordan",
              textAlign: TextAlign.center,
               style: TextStyle(color:Color.fromRGBO(35, 38, 77, 0.8),
               fontSize: 11,)

            ),

            SizedBox(height: 20),

            // BUTTONS
            _buildButton("Jordanian Resident", true),
            SizedBox(height: 15),
            _buildButton("International Tourist", false),

            SizedBox(height: 30),

            
            
            
             ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff1C2340), 
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: EdgeInsets.symmetric(horizontal: 27, vertical: 12),
                elevation: 4,
              ),
              onPressed: () {
                // go to SelectTypePage
                 Navigator.push(context, MaterialPageRoute(builder: (_) =>  RahhalApp()));
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Let’s Start",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(width: 12),
                  Icon(Icons.arrow_forward_outlined, size: 24),
                ],
              ),
            ),
          ],
          
        ),
      ),
    );
  }

  Widget _buildButton(String text, bool filled) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: filled ? Color.fromRGBO(122, 31, 44, 1) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color.fromRGBO(122, 31, 44, 1)),
      ),
      
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          color: filled ? Colors.white : Color.fromRGBO(122, 31, 44, 1),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}