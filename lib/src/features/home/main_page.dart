import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Add this for toast
import 'home_page.dart';
import '../profile/profile_page.dart';
import '../services/services_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  DateTime? _lastBackPressed; // For double back press

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color.fromARGB(255, 255, 229, 231),
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
  }

  late final List<Widget> _screens = [
    const HomePage(),
    ProfilePage(onBackToHome: () => _onTabSelected(0)),
    ServicesPage(onBackToHome: () => _onTabSelected(0)),
  ];

  void _onTabSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  Future<bool> _onWillPop() async {
    // If not on Home tab, go to Home tab first
    if (_selectedIndex != 0) {
      _onTabSelected(0);
      return false;
    }

    final now = DateTime.now();
    if (_lastBackPressed == null ||
        now.difference(_lastBackPressed!) > const Duration(seconds: 2)) {
      _lastBackPressed = now;
      Fluttertoast.showToast(
        msg: "Press back again to exit",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
      );
      return false;
    }
    return true; // Exit the app
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _screens[_selectedIndex],
        bottomNavigationBar: Container(
          padding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onTabSelected,
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.red,
            unselectedItemColor: const Color.fromARGB(255, 102, 102, 102),
            showUnselectedLabels: true,
            items: [
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/icons/ic_home.png',
                  width: 24,
                  height: 24,
                  color: _selectedIndex == 0 ? Colors.red : const Color.fromARGB(255, 102, 102, 102),
                ),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/icons/ic_user.png',
                  width: 24,
                  height: 24,
                  color: _selectedIndex == 1 ? Colors.red : const Color.fromARGB(255, 102, 102, 102),
                ),
                label: "Profile",
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/icons/ic_service.png',
                  width: 24,
                  height: 24,
                  color: _selectedIndex == 2 ? Colors.red : const Color.fromARGB(255, 102, 102, 102),
                ),
                label: "Services",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
