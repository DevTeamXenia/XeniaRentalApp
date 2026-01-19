import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rental_app/src/core/api/auth_api.dart';
import 'package:rental_app/src/core/storage/token_storage.dart';
import '../../unit/unit_page.dart';

class OtpPage extends StatefulWidget {
  final String phoneNumber;
  const OtpPage({super.key, required this.phoneNumber});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final int _otpLength = 6;

  late List<TextEditingController> _otpControllers;
  late List<FocusNode> _focusNodes;

  final ValueNotifier<int> _secondsRemaining = ValueNotifier<int>(30);
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _otpControllers =
        List.generate(_otpLength, (_) => TextEditingController());
    _focusNodes = List.generate(_otpLength, (_) => FocusNode());

    _startTimer();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNodes[0]);
    });
  }

  void _startTimer() {
    _secondsRemaining.value = 30;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining.value == 0) {
        timer.cancel();
      } else {
        _secondsRemaining.value--;
      }
    });
  }

  String _getOtpValue() {
    return _otpControllers.map((c) => c.text).join();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _secondsRemaining.dispose();
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // ✅ FIX 1 (NO UI CHANGE)
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Verify OTP",
          style: TextStyle(color: Colors.black87, fontSize: 16),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter Verification code.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "We’ve sent a 6-digit code to ${widget.phoneNumber}",
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(_otpLength, (index) {
                return SizedBox(
                  width: 48,
                  child: TextField(
                    controller: _otpControllers[index],
                    focusNode: _focusNodes[index],
                    autofocus: index == 0,
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    textInputAction: index == _otpLength - 1
                        ? TextInputAction.done
                        : TextInputAction.next,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      counterText: "",
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && index < _otpLength - 1) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          FocusScope.of(context)
                              .requestFocus(_focusNodes[index + 1]);
                        });
                      }
                    },
                    onTap: () {
                      FocusScope.of(context).requestFocus(_focusNodes[index]);
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                );
              }),
            ),

            const SizedBox(height: 16),

            Center(
              child: ValueListenableBuilder<int>(
                valueListenable: _secondsRemaining,
                builder: (context, seconds, _) {
                  return seconds > 0
                      ? Text(
                          "Resend OTP in ${seconds}s",
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black54),
                        )
                      : GestureDetector(
                          onTap: () async {
                            _startTimer();
                            await AuthApi.generateOtp(widget.phoneNumber);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("OTP resent")),
                            );
                          },
                          child: const Text(
                            "Resend OTP",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                },
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () async {
                  final otp = _getOtpValue();

                  if (otp.length != 6) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Enter valid OTP")),
                    );
                    return;
                  }

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) =>
                        const Center(child: CircularProgressIndicator()),
                  );

                  final token = await AuthApi.verifyOtp(
                    phone: widget.phoneNumber,
                    otp: otp,
                  );

                  Navigator.pop(context);

                  if (token != null) {
                    await TokenStorage.saveToken(token);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const UnitPage(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Invalid OTP")),
                    );
                  }
                },
                child: const Text(
                  "Verify & Continue",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
