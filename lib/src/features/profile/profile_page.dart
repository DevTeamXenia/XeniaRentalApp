import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rental_app/src/core/api/profile_api.dart';
import 'package:rental_app/src/core/storage/token_storage.dart';
import '../auth/presentation/login_page.dart';
import '../profile/privacy_policy_page.dart';
import '../profile/terms_conditions_page.dart';

class ProfilePage extends StatefulWidget {
  final VoidCallback onBackToHome;

  const ProfilePage({super.key, required this.onBackToHome});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String tenantName = "Loading...";
  String phoneNumber = "";

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

Future<void> _loadProfile() async {
  try {
    final data = await ProfileApi.fetchProfile();
    if (!mounted) return;
    final int? tenantId = data['TenantID'];
    if (tenantId != null) {
      await TokenStorage.saveTenantId(tenantId);
    }

    setState(() {
      tenantName = data['TenantName'] ?? "No Name";
      phoneNumber = data['PhoneNumber'] ?? "";
    });
  } catch (e) {
    if (mounted) {
      setState(() {
        tenantName = "Failed to load";
        phoneNumber = "";
      });
    }
  }
}



// Future<void> _deleteAccount() async {
//   try {
//     final tenantId = await TokenStorage.getTenantId();

//     if (tenantId == null) {
//       throw Exception("Tenant ID not found");
//     }

//     await ProfileApi.disableAccount(tenantId: tenantId,);

//     await TokenStorage.clearAll();

//   } catch (e) {
//     debugPrint("Delete account failed: $e");

//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Unable to delete account. Please try again."),
//         ),
//       );
//     }
//   }
// }




  @override
  Widget build(BuildContext context) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(255, 255, 229, 231),
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 10,
              bottom: 20,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFFFFEBEE),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(width: 7),
                    IconButton(
                      icon: Image.asset("assets/icons/ic_back_arrow.png"),
                      onPressed: widget.onBackToHome,
                    ),
                    const Text("Back", style: TextStyle(fontSize: 18)),
                  ],
                ),

                const CircleAvatar(
                  radius: 45,
                  backgroundImage: AssetImage('assets/images/ic_deafult.png'),
                ),

                const SizedBox(height: 10),

                Text(
                  tenantName,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),

                Text(
                  "+91 $phoneNumber",
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildMenuItem(
                  "Terms and Conditions",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TermsConditionsPage(),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  "Privacy Policy",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PrivacyPolicyPage(),
                      ),
                    );
                  },
                ),
                // _buildMenuItem("FAQ"),
                // _buildMenuItem("Help"),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () => _showLogoutDialog(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout),
                        SizedBox(width: 10),
                        Text(
                          "Log Out",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    
                  ),
                ),
                  const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _showDeleteAccountDialog(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 248, 209, 209),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.delete_forever),
                        SizedBox(width: 10),
                        Text(
                          "Delete Account",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildMenuItem(String title, {VoidCallback? onTap}) {
    return Column(
      children: [
        ListTile(
          title: Text(title),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: onTap,
        ),
        const Divider(height: 0),
      ],
    );
  }


  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Logout",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Do you want to logout?",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 255, 205, 205),
                          minimumSize: const Size(100, 40),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "No",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 255, 205, 205),
                          minimumSize: const Size(100, 40),
                        ),
                        onPressed: () async {
                          await TokenStorage.clearToken();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LoginPage()),
                            (_) => false,
                          );
                        },
                        child: const Text(
                          "Yes",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

void _showDeleteAccountDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.warning_amber_rounded,
                    color: Colors.red, size: 48),
                const SizedBox(height: 12),
                const Text(
                  "Delete Account",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
          const Text(
                  "To delete your account, please send an email to\n\n"
                  "xeniacare@spidertechnosoft.com\n\n"
                  "from your registered email address.\n\n"
                  "Your account data, payments, and profile information "
                  "will be permanently deleted and cannot be recovered.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),

                const SizedBox(height: 20),
                
                Row(
                  children: [
                    // Expanded(
                    //   child: TextButton(
                    //     style: TextButton.styleFrom(
                    //       backgroundColor: Colors.grey.shade300,
                    //       minimumSize: const Size(0, 45),
                    //     ),
                    //     onPressed: () => Navigator.pop(context),
                    //     child: const Text(
                    //       "Cancel",
                    //       style: TextStyle(fontWeight: FontWeight.bold),
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(width: 12),
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.red,
                          minimumSize: const Size(0, 45),
                        ),
                         onPressed: () => Navigator.pop(context),
                        // onPressed: () async {
                        //   await _deleteAccount();
                        //   if (!mounted) return;
                        //   Navigator.pushAndRemoveUntil(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (_) => const LoginPage()),
                        //     (_) => false,
                        //   );
                        // },
                        child: const Text(
                          "Ok",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}


}
