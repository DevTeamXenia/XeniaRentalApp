import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rental_app/src/core/api/dashboard_api.dart';
import 'package:rental_app/src/core/model/dashboard_model.dart';
import 'package:rental_app/src/core/storage/token_storage.dart';
import '../unit/unit_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();

  final List<String> _ads = [
    'assets/images/images.png',
    'assets/images/images2.png',
    'assets/images/images3.png',
  ];

  int _currentPage = 0;
  Timer? _timer;

  String _unitName = "";
  bool _isUnitSelected = false;

  DashboardModel? _dashboard;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUnitNameAndFlag();
    _loadDashboard();

    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      _currentPage = (_currentPage + 1) % _ads.length;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  Future<void> _loadUnitNameAndFlag() async {
    final savedName = await TokenStorage.getUnitName();
    final isSelected = await TokenStorage.getIsUnitSelected();

    setState(() {
      _unitName = savedName ?? "";
      _isUnitSelected = isSelected;
    });
  }

  Future<void> _loadDashboard() async {
    try {
      final unitId = await TokenStorage.getUnitId();
      if (unitId == null) throw Exception("UnitId missing");

      final data = await DashboardApi.fetchDashboard(unitId);

      setState(() {
        _dashboard = data;
        _loading = false;
      });
    } catch (e) {
      debugPrint("Dashboard error: $e");
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

 
    if (_dashboard == null) {
      return const Scaffold(
        body: Center(child: Text("No dashboard data")),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Welcome Back",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 2),
                      InkWell(
                        onTap: _isUnitSelected
                            ? null
                            : () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const UnitPage()),
                                ),
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 8),
                          child: Row(
                            children: [
                              const Icon(Icons.location_on,
                                  color: Colors.red, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                _unitName,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54,
                                ),
                              ),
                              if (!_isUnitSelected)
                                const Icon(Icons.keyboard_arrow_down,
                                    size: 18, color: Colors.black54),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 150,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                  ),
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _ads.length,
                    itemBuilder: (_, i) =>
                        Image.asset(_ads[i], fit: BoxFit.cover),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(18),
                  ),
                ),
                child: const TickerInfoMessage(
                  message:
                      "Info: Association Meeting scheduled on 15 February 2026. All members are requested to attend.",
                  speed: 40, 
                ),
              ),
              const SizedBox(height: 18),
              if (_dashboard!.nextUpcomingPayment != null) ...[
                const Text("Upcoming Payments",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                IntrinsicHeight(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F7F7),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Amount",
                                    style: TextStyle(color: Colors.black54)),
                                const SizedBox(height: 6),
                                Text(
                                  "Rs ${_dashboard!.nextUpcomingPayment!.amount.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.red),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Due Date\n${_dashboard!.nextUpcomingPayment!.date}",
                                  style: const TextStyle(color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 120,
                          child: SizedBox.expand(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(18),
                                    bottomRight: Radius.circular(18),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Payment feature coming soon 🚀",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    backgroundColor: Colors.black87,
                                    behavior: SnackBarBehavior.floating,
                                    margin: EdgeInsets.all(16),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                              child: const Text("PAY",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25),
              ],
              if (_dashboard!.previousUnpaidPayments.isNotEmpty) ...[
                const Text("Unpaid Payments",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                SizedBox(
                  height: 105,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _dashboard!.previousUnpaidPayments.length,
                    itemBuilder: (_, i) {
                      final p = _dashboard!.previousUnpaidPayments[i];
                      return _PaymentCard(
                        "Rs ${p.amount.toStringAsFixed(2)}",
                        p.date,
                        isPaid: false,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 25),
              ],
              if (_dashboard!.previousPaidPayments.isNotEmpty) ...[
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Previous Payment",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700)),
                    Text("See More  ->", style: TextStyle(color: Colors.red)),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 105,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _dashboard!.previousPaidPayments.length,
                    itemBuilder: (_, i) {
                      final p = _dashboard!.previousPaidPayments[i];
                      return _PaymentCard(
                        "Rs ${p.amount.toStringAsFixed(2)}",
                        p.date,
                        isPaid: true,
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  final String amount;
  final String date;
  final bool isPaid;

  const _PaymentCard(this.amount, this.date, {required this.isPaid});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 145,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Amount",
              style: TextStyle(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 4),
          Text(amount,
              style:
                  const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          const Spacer(),
          Text(
            isPaid ? "Paid" : "Unpaid",
            style: TextStyle(
              color: isPaid ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          Text(date, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class TickerInfoMessage extends StatefulWidget {
  final String message;
  final double speed; 

  const TickerInfoMessage({
    super.key,
    required this.message,
    this.speed = 50,
  });

  @override
  State<TickerInfoMessage> createState() => _TickerInfoMessageState();
}

class _TickerInfoMessageState extends State<TickerInfoMessage> {
  final ScrollController _scrollController = ScrollController();
  late double _textWidth;
  late double _containerWidth;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startScrolling());
  }

  void _startScrolling() async {
    while (mounted) {
      _textWidth = _scrollController.position.maxScrollExtent +
          _scrollController.position.viewportDimension;
      _containerWidth = _scrollController.position.viewportDimension;

      final duration = Duration(
        seconds: ((_textWidth + _containerWidth) / widget.speed).ceil(),
      );

      await _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: duration,
        curve: Curves.linear,
      );

      // Reset to start immediately for continuous loop
      _scrollController.jumpTo(0);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      child: Text(
        widget.message,
        style: const TextStyle(color: Colors.white, fontSize: 13),
      ),
    );
  }
}
