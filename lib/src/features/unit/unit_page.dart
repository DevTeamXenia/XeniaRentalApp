import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../home/main_page.dart';
import 'package:rental_app/src/core/api/property_api.dart';
import 'package:rental_app/src/core/model/property_model.dart';
import 'package:rental_app/src/core/storage/token_storage.dart';

class UnitPage extends StatefulWidget {
  const UnitPage({super.key});

  @override
  State<UnitPage> createState() => _UnitPageState();
}

class _UnitPageState extends State<UnitPage> {
  PropertyModel? selectedProperty;
  UnitModel? selectedUnit;

  bool showPropertyList = false;
  bool showUnitList = false;

  List<PropertyModel> properties = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProperties();
  }

  Future<void> _loadProperties() async {
    try {
      final data = await PropertyApi.fetchProperties();
      if (!mounted) return;

      if (data.length == 1 && data.first.units.length == 1) {
        final property = data.first;
        final unit = property.units.first;

        await _saveSelection(
          propertyId: property.id,
          propertyName: property.name,
          unitId: unit.id,
          unitName: unit.name,
          isUnitSelected: true,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainPage()),
        );
        return;
      }

      setState(() {
        properties = data;
        isLoading = false;
      });

 
      await _restorePreviousSelection(data);

      await TokenStorage.saveIsUnitSelected(false);
    } catch (_) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load properties")),
      );
    }
  }

 
  Future<void> _restorePreviousSelection(List<PropertyModel> data) async {
    final savedPropertyId = await TokenStorage.getPropertyId();
    final savedUnitId = await TokenStorage.getUnitId();

    if (savedPropertyId == null || savedUnitId == null) return;

    try {
      final property =
          data.firstWhere((p) => p.id == savedPropertyId);
      final unit =
          property.units.firstWhere((u) => u.id == savedUnitId);

      setState(() {
        selectedProperty = property;
        selectedUnit = unit;
      });
    } catch (_) {
      // Ignore if not found
    }
  }

  
  Future<void> _saveSelection({
    required int propertyId,
    required String propertyName,
    required int unitId,
    required String unitName,
    required bool isUnitSelected,
  }) async {
    await TokenStorage.savePropertyId(propertyId);
    await TokenStorage.savePropertyName(propertyName);
    await TokenStorage.saveUnitId(unitId);
    await TokenStorage.saveUnitName(unitName);
    await TokenStorage.saveIsUnitSelected(isUnitSelected);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFFFE5E7),
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 20, bottom: 40),
                decoration: const BoxDecoration(
                  color: Color(0xFFFEF2F3),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Text("Back", style: TextStyle(fontSize: 18)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Image.asset(
                      "assets/images/splash_logo.png",
                      width: 150,
                      height: 150,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),


              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    /// PROPERTY
                    const Text(
                      "Choose Your Property",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),

                    GestureDetector(
                      onTap: () =>
                          setState(() => showPropertyList = !showPropertyList),
                      child: _dropdownBox(
                        selectedProperty?.name ?? "Select Property",
                        showPropertyList,
                      ),
                    ),

                    if (showPropertyList)
                      _radioListContainer<PropertyModel>(
                        items: properties,
                        selectedValue: selectedProperty,
                        titleBuilder: (p) => p.name,
                        onChanged: (property) {
                          setState(() {
                            selectedProperty = property;
                            selectedUnit = null;
                            showPropertyList = false;
                          });
                        },
                      ),

                    const SizedBox(height: 20),

              
                    const Text(
                      "Choose Your Unit",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),

                    GestureDetector(
                      onTap: selectedProperty == null
                          ? null
                          : () => setState(() => showUnitList = !showUnitList),
                      child: _dropdownBox(
                        selectedUnit?.name ?? "Select Unit",
                        showUnitList,
                      ),
                    ),

                    if (showUnitList && selectedProperty != null)
                      _radioListContainer<UnitModel>(
                        items: selectedProperty!.units,
                        selectedValue: selectedUnit,
                        titleBuilder: (u) => u.name,
                        onChanged: (unit) {
                          setState(() {
                            selectedUnit = unit;
                            showUnitList = false;
                          });
                        },
                      ),

                
                    if (selectedUnit != null) ...[
                      const SizedBox(height: 30),
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFC41C2D),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () async {
                            await _saveSelection(
                              propertyId: selectedProperty!.id,
                              propertyName: selectedProperty!.name,
                              unitId: selectedUnit!.id,
                              unitName: selectedUnit!.name,
                              isUnitSelected: false,
                            );

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const MainPage()),
                            );
                          },
                          child: const Text(
                            "Let’s Get Started",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dropdownBox(String text, bool expanded) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text),
          Icon(expanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
        ],
      ),
    );
  }


  Widget _radioListContainer<T>({
    required List<T> items,
    required T? selectedValue,
    required String Function(T) titleBuilder,
    required Function(T) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE6E8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: List.generate(items.length, (index) {
          final item = items[index];
          return Column(
            children: [
              InkWell(
                onTap: () => onChanged(item),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  child: Row(
                    children: [
                      Radio<T>(
                        value: item,
                        groupValue: selectedValue,
                        activeColor: Colors.red,
                        onChanged: (val) => onChanged(val as T),
                      ),
                      Expanded(
                        child: Text(titleBuilder(item)),
                      ),
                    ],
                  ),
                ),
              ),
              if (index != items.length - 1)
                const Divider(height: 1),
            ],
          );
        }),
      ),
    );
  }
}
