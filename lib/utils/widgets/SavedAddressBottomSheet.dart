import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../controllers/HomeController.dart';
import '../../utils/LocalStorage.dart';

var homeController = Get.find<HomeController>();
final _ls = LocalStorage();

class AddressPrefill {
  final String formatted;
  final String area;
  final String building;
  final String city;
  final String state;
  final String pinCode;
  final String landmark;
  final double lat;
  final double lng;

  AddressPrefill({
    required this.formatted,
    required this.area,
    required this.building,
    required this.city,
    required this.state,
    required this.pinCode,
    required this.landmark,
    required this.lat,
    required this.lng,
  });
}

// NEW: result object to pass back to previous screens
class AddressResult {
  final String address;
  final double lat;
  final double lng;

  AddressResult({required this.address, required this.lat, required this.lng});
}

Future<AddressResult?> showAddressBottomSheet(
    BuildContext context, {
      AddressPrefill? prefill,
    }) async {
  return await showModalBottomSheet<AddressResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => _AddressSheet(prefill: prefill),
  );
}

class _AddressSheet extends StatefulWidget {
  final AddressPrefill? prefill;
  const _AddressSheet({this.prefill});

  @override
  State<_AddressSheet> createState() => _AddressSheetState();
}

class _AddressSheetState extends State<_AddressSheet> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController(text: "divya@gmail.com");
  final _cityCtrl = TextEditingController();
  final _stateCtrl = TextEditingController();
  final _pinCodeCtrl = TextEditingController();
  final _areaCtrl = TextEditingController();
  final _buildingCtrl = TextEditingController();
  final _landmarkCtrl = TextEditingController();

  double? _lat;
  double? _lng;
  String? _formatted;

  @override
  void initState() {
    super.initState();

    // Prefill from LocalStorage (name & mobile)
    _nameCtrl.text = _ls.getStringValue(_ls.fullName);
    _phoneCtrl.text = _ls.getStringValue(_ls.mobileNumber);

    // Prefill from map selection
    final p = widget.prefill;
    if (p != null) {
      _formatted = p.formatted;
      _lat = p.lat;
      _lng = p.lng;

      if (p.area.isNotEmpty) _areaCtrl.text = p.area;
      if (p.building.isNotEmpty) _buildingCtrl.text = p.building;
      if (p.city.isNotEmpty) _cityCtrl.text = p.city;
      if (p.state.isNotEmpty) _stateCtrl.text = p.state;
      if (p.pinCode.isNotEmpty) _pinCodeCtrl.text = p.pinCode;
      if (p.landmark.isNotEmpty) _landmarkCtrl.text = p.landmark;
    }
  }

  InputDecoration _dec(String hint, {IconData? icon, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey.shade500),
      prefixIcon: icon == null ? null : Icon(icon),
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFFF6F7F9),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.grey, width: 1.2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final inset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: inset),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // drag + close
              Row(
                children: [
                  const Expanded(
                    child: Center(
                      child: SizedBox(
                        width: 38,
                        child: Divider(thickness: 3, color: Color(0xFFE4E6EA)),
                      ),
                    ),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                "Enter complete address",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),

              if (_formatted != null && _formatted!.isNotEmpty) ...[
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F7F9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE4E6EA)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.place, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _formatted!,
                          style: TextStyle(
                              fontSize: 12.5.sp, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 16),

              TextField(
                  controller: _areaCtrl,
                  decoration: _dec("Area / Sector / Locality",
                      icon: Icons.area_chart_outlined)),
              const SizedBox(height: 12),
              TextField(
                  controller: _buildingCtrl,
                  decoration: _dec("Building name / house no.",
                      icon: Icons.location_city_outlined)),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                      child: TextField(
                          controller: _cityCtrl,
                          decoration: _dec("City",
                              icon: Icons.location_city_outlined))),
                  const SizedBox(width: 10),
                  Expanded(
                      child: TextField(
                          controller: _stateCtrl,
                          decoration: _dec("State", icon: Icons.map_outlined))),
                ],
              ),

              const SizedBox(height: 12),
              TextField(
                  controller: _pinCodeCtrl,
                  keyboardType: TextInputType.number,
                  decoration: _dec("Pin code", icon: Icons.location_pin)),
              const SizedBox(height: 12),
              TextField(
                  controller: _landmarkCtrl,
                  decoration: _dec("Nearby landmark (optional)",
                      icon: Icons.flag_outlined)),

              const SizedBox(height: 16),
              Text("Enter your details",
                  style:
                  TextStyle(fontWeight: FontWeight.w500, fontSize: 15.sp)),
              const SizedBox(height: 10),
              TextField(
                  controller: _nameCtrl,
                  decoration: _dec("Your name", icon: Icons.person_outline)),
              const SizedBox(height: 12),
              TextField(
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  decoration:
                  _dec("Your phone number", icon: Icons.phone_outlined)),

              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    elevation: 0,
                  ),
                  onPressed: () async {
                    // Persist name & number
                    _ls.setStringValue(_ls.fullName, _nameCtrl.text.trim());
                    _ls.setStringValue(
                        _ls.mobileNumber, _phoneCtrl.text.trim());

                    // API call (await)
                    try {
                      await homeController.getSaveAddressApi(
                        _phoneCtrl.text.trim(),
                        "",
                        _buildingCtrl.text.trim(),
                        _landmarkCtrl.text.trim(),
                        _areaCtrl.text.trim(),
                        _pinCodeCtrl.text.trim(),
                        _cityCtrl.text.trim(),
                        _stateCtrl.text.trim(),
                      );
                    } catch (_) {
                      // optionally: show error snackbar
                    }

                    // Compose safe address (fallback if no formatted)
                    final composed = (_formatted != null && _formatted!.isNotEmpty)
                        ? _formatted!
                        : [
                      _buildingCtrl.text.trim(),
                      _areaCtrl.text.trim(),
                      _cityCtrl.text.trim(),
                      _stateCtrl.text.trim(),
                      _pinCodeCtrl.text.trim(),
                    ].where((e) => e.isNotEmpty).join(", ");

                    final res = AddressResult(
                      address: composed,
                      lat: _lat ?? 0.0,
                      lng: _lng ?? 0.0,
                    );

                    // Return result to SelectLocationScreen
                    Navigator.pop(context, res);
                  },
                  child: Text(
                    "Save address",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
