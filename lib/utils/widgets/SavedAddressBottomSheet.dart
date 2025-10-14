import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../controllers/HomeController.dart';

var homeController = Get.find<HomeController>();

Future<void> showAddressBottomSheet(BuildContext context) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => const _AddressSheet(),
  );
}

class _AddressSheet extends StatefulWidget {
  const _AddressSheet();

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
              // drag handle + close
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
              const SizedBox(height: 16),
              // Address fields
              TextField(
                controller: _areaCtrl,
                decoration: _dec(
                  "Area / Sector / Locality",
                  icon: Icons.area_chart_outlined,
                  /*suffix: TextButton(
                    onPressed: () {}, // TODO: open location picker
                    child: const Text("Change"),
                  ),*/
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _buildingCtrl,
                decoration: _dec("Building name / house no.",
                    icon: Icons.location_city_outlined),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _cityCtrl,
                decoration:
                    _dec("City and state", icon: Icons.location_city_outlined),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _pinCodeCtrl,
                decoration: _dec("pin code", icon: Icons.location_pin),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _landmarkCtrl,
                decoration: _dec("Nearby landmark (optional)",
                    icon: Icons.flag_outlined),
              ),

              const SizedBox(height: 16),
              Text(
                "Enter your details",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.sp),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _nameCtrl,
                decoration: _dec("Your name", icon: Icons.person_outline),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration:
                    _dec("Your phone number", icon: Icons.phone_outlined),
              ),
              const SizedBox(height: 18),
              /*  TextField(
                controller: _emailCtrl,
                decoration: _dec("Your email", icon: Icons.email_outlined),
              ),

              const SizedBox(height: 18),*/
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    homeController.getSaveAddressApi(
                        _phoneCtrl.text,
                        "",
                        _buildingCtrl.text,
                        _landmarkCtrl.text,
                        _areaCtrl.text,
                        _pinCodeCtrl.text,
                        _cityCtrl.text,
                        "",
                        );
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
