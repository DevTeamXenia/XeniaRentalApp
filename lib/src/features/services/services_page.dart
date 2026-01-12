import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rental_app/src/core/api/service_api.dart';
import 'package:rental_app/src/core/model/service_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ServicesPage extends StatefulWidget {
  final VoidCallback onBackToHome;

  const ServicesPage({super.key, required this.onBackToHome});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  List<ServiceModel> services = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    try {
      final data = await ServiceApi.fetchServices();
      if (!mounted) return;
      setState(() {
        services = data;
        isLoading = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() => isLoading = false);
        _showSnackBar("Failed to load services");
      }
    }
  }

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
              top: MediaQuery.of(context).padding.top + 20,
              bottom: 16,
              left: 12,
              right: 16,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Image.asset("assets/icons/ic_back_arrow.png"),
                      onPressed: widget.onBackToHome,
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      "Back",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Center(
                  child: Text(
                    "Services",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child: Text(
                          "Essential Services",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Text(
                            "Call",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Text(
                            "WhatsApp",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Divider(thickness: 1),

                  Flexible(
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : services.isEmpty
                            ? const Center(child: Text("No services found"))
                            : ListView.separated(
                                padding: EdgeInsets.zero,
                                itemCount: services.length,
                                separatorBuilder: (_, __) =>
                                    const Divider(height: 1),
                                itemBuilder: (context, index) {
                                  return _serviceRow(
                                    services[index],
                                    isFirst: index == 0,
                                  );
                                },
                              ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _serviceRow(ServiceModel service, {bool isFirst = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isFirst ? 2 : 6),
      child: Row(
        children: [
          Expanded(
            flex: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.serviceName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  service.serviceType,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: IconButton(
                icon: Image.asset("assets/icons/ic_phno.png"),
                iconSize: 22,
                onPressed: () => _makeCall(service.servicePhoneNumber),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: IconButton(
                icon: Image.asset("assets/icons/ic_whatapp.png"),
                iconSize: 22,
                onPressed: () =>
                    _openWhatsApp(service.serviceWhatappNumber),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Future<void> _makeCall(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _showSnackBar("Cannot launch phone dialer");
    }
  }


  Future<void> _openWhatsApp(String number) async {
    final sanitized = number.replaceAll('+', '').replaceAll(' ', '');
    final uri = Uri.parse("https://wa.me/$sanitized");

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _showSnackBar("Cannot launch WhatsApp");
    }
  }

  void _showSnackBar(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }
}
