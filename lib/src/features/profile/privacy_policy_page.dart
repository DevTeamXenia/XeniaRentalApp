import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

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
          "Privacy Policy",
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
                "Privacy Policy",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),

              Text(
                "We value your privacy and are committed to protecting your personal information. "
                "This Privacy Policy explains how we collect, use, and safeguard your data when you use our application.",
                style: TextStyle(fontSize: 14),
              ),

              SizedBox(height: 16),
              Text(
                "Information We Collect",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "• Phone number for authentication\n"
                "• Usage data for improving our services\n"
                "• Device-related information for security",
              ),

              SizedBox(height: 16),
              Text(
                "How We Use Your Information",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "We use your data to provide services, verify identity, improve app performance, "
                "and ensure a secure user experience.",
              ),

              SizedBox(height: 16),
              Text(
                "Data Security",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "We implement industry-standard security measures to protect your data. "
                "However, no method of transmission over the internet is 100% secure.",
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
