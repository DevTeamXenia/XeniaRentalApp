import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '..//auth/presentation/login_page.dart';
import 'package:rental_app/src/core/storage/token_storage.dart';
import '../unit/unit_page.dart';
import '../home/main_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _navigateNext();
  }

  Future<void> _navigateNext() async {
    await Future.delayed(const Duration(seconds: 3));

    final token = await TokenStorage.getToken();
    if (!mounted) return;
    if (token == null || token.isEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
      return;
    }

 
    final unitId = await TokenStorage.getUnitId();
    if (!mounted) return;

    if (unitId != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const UnitPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/images/top_splash_logo.png',
                fit: BoxFit.cover,
              ),
            ),

            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/splash_logo.png',
                width: 150,
                height: 150,
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Image.asset(
                  'assets/images/powered_logo.png',
                  height: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
