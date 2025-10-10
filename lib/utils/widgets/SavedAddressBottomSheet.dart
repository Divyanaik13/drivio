import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
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
  final _nameCtrl = TextEditingController(text: "Divya");
  final _phoneCtrl = TextEditingController(text: "+91 7642056753");
  final _emailCtrl = TextEditingController(text: "divya@gmail.com");
  final _cityCtrl = TextEditingController();
  final _pinCodeCtrl = TextEditingController();
  final _areaCtrl = TextEditingController(text: "Priyadarshini");
  final _landmarkCtrl = TextEditingController();

  String _orderingFor = "Myself";
  String _addressTag = "Home";

  InputDecoration _dec(String hint, {IconData? icon, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: icon == null ? null : Icon(icon),
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFFF6F7F9),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE6E8EB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE6E8EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF10A310), width: 1.2),
      ),
    );
  }

  Widget _chip(String label, IconData icon) {
    final selected = _addressTag == label;
    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
      selected: selected,
      onSelected: (_) => setState(() => _addressTag = label),
      selectedColor: const Color(0xFFE7F6E7),
      backgroundColor: const Color(0xFFF1F3F5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      labelStyle: TextStyle(
        color: selected ? const Color(0xFF0E8F0E) : Colors.black87,
        fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
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
                controller: _cityCtrl,
                decoration: _dec("City and state",
                    icon: Icons.location_city_outlined),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _pinCodeCtrl,
                decoration: _dec("pin code", icon: Icons.location_pin),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _landmarkCtrl,
                decoration:
                _dec("Nearby landmark (optional)", icon: Icons.flag_outlined),
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
              const SizedBox(height: 10),
              TextField(
                controller: _emailCtrl,
                decoration: _dec("Your email", icon: Icons.email_outlined),
              ),

              const SizedBox(height: 18),
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
                    homeController.getSaveAddressApi("","","","","","","","");
                  },
                  child: Text(
                    "Save address",
                    style: TextStyle(
                        color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.w600),
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

class _RadioPill<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T?> onChanged;
  const _RadioPill({required this.value, required this.groupValue, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final selected = value == groupValue;
    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE7F6E7) : const Color(0xFFF1F3F5),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? const Color(0xFF10A310) : const Color(0xFFE1E4E8),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<T>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              visualDensity: VisualDensity.compact,
              activeColor: const Color(0xFF10A310),
            ),
            Text(
              "$value",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: selected ? const Color(0xFF0E8F0E) : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
