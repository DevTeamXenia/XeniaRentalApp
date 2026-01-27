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
                "Privacy Policy – Rental App",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "Effective Date: 01 January 2026\nLast Updated: 01 January 2026",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              SizedBox(height: 16),

              Text(
                "1. Who We Are",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                "Company: Xenia Technologies\nApp Name: Rental\nSupport Email: xeniacare@spidertechnosoft.com",
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 16),

              Text(
                "2. Information We Collect",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                "We collect only the data required to provide rental management and authentication services.",
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 8),
              Text(
                "a. Personal Information\n• Phone Number – Used for OTP-based login and user identification.\n\n"
                "b. Location Information\n• Approximate or device location – Used to identify the rental property, service area, and for operational and security purposes.\n\n"
                "c. Device and Usage Data\n• Device model, operating system, app version\n• IP address, log files, crash reports, and usage activity\nThis information is used to improve app stability, performance, and security.",
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 16),

              Text(
                "3. How We Use Your Information",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                "• Phone number – OTP verification, account login, and user identification\n"
                "• Location data – Property identification, service delivery, and fraud prevention\n"
                "• Device & usage data – App performance, debugging, and security\n\nWe do not use your data for advertising or marketing.",
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 16),

              Text(
                "4. Payments",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                "At present, the app does not process payments.\nWhen a payment gateway is enabled in future releases, payment processing will be handled by a secure third-party payment provider. "
                "We will not store your card, UPI, or bank details on our servers.\nThis Privacy Policy will be updated before payment features go live.",
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 16),

              Text(
                "5. Data Sharing",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                "We do not sell, rent, or trade your personal data.\n\nYour information may be shared only:\n"
                "• When required by law\n"
                "• With service providers involved in OTP delivery, hosting, or security\n"
                "• To protect our legal rights or prevent fraud\n\nAll partners are contractually required to protect your data.",
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 16),

              Text(
                "6. Data Retention",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                "We retain your data only as long as:\n"
                "• Your account is active\n"
                "• It is required to provide services\n"
                "• It is required by law\n\nWhen your account is deleted, your personal data is permanently removed or anonymized.",
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 16),

              Text(
                "7. Data Security",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                "We use industry-standard safeguards including encrypted data transmission, secure servers, and access control and authentication. "
                "However, no system is 100% secure. We continuously improve our security practices.",
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 16),

              Text(
                "8. Your Rights",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                "You have the right to access your personal data, request correction, and request deletion of your account and data.\n"
                "To make a request, email: xeniacare@spidertechnosoft.com",
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 16),

              Text(
                "9. Children’s Privacy",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                "The Rental app is not intended for users under 13 years of age. We do not knowingly collect data from children.",
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 16),

              Text(
                "10. Changes to This Policy",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                "We may update this Privacy Policy from time to time. Updates will be published within the app or on our website.",
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 16),

              Text(
                "11. Contact Us",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                "For any questions regarding this policy:\n\n"
                "Xenia Technologies\nEmail: xeniacare@spidertechnosoft.com",
                style: TextStyle(fontSize: 14),
              ),

              SizedBox(height: 24),
              Text(
                "Last Updated: 01 January 2026",
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
