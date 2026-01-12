import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(255, 255, 229, 231),
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Terms & Conditions",
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Terms & Conditions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),

              Text(
                "By accessing or using this application, you agree to be bound by these Terms and Conditions. "
                "If you do not agree, please do not use the app.",
                style: TextStyle(fontSize: 14),
              ),

              SizedBox(height: 16),
              Text(
                "Use of the Application",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "You agree to use this application only for lawful purposes and in accordance with applicable laws.",
              ),

              SizedBox(height: 16),
              Text(
                "User Responsibilities",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "You are responsible for maintaining the confidentiality of your account and OTP credentials.",
              ),

              SizedBox(height: 16),
              Text(
                "Limitation of Liability",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "We are not liable for any damages arising from the use or inability to use the application.",
              ),

              SizedBox(height: 24),
              Text(
                "Last updated: January 2026",
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
