import 'package:drivio_sarthi/utils/CommonWidgets.dart';
import 'package:drivio_sarthi/utils/LocalStorage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../controllers/profileController.dart';

class AddNewCarScreen extends StatefulWidget {
  const AddNewCarScreen({super.key});

  @override
  State<AddNewCarScreen> createState() => _AddNewCarScreenState();
}

class _AddNewCarScreenState extends State<AddNewCarScreen> {
  var profileController = Get.find<ProfileController>();

  LocalStorage _ls = LocalStorage();

  // Colors
  static const Color _primary = Color(0xFFFF3B22);
  static const Color _textDark = Color(0xFF111111);
  static const Color _hint = Color(0xFF9E9E9E);
  static const double _radius = 28;

  // Controllers
  final _carNameController = TextEditingController();
  final _ownerController = TextEditingController();
  final _carNoController = TextEditingController();
  final _mobileNoController = TextEditingController();
  final _transmissionController = TextEditingController();

  String _transmission = "Automatic";

  final List<String> _transmissions = [
    "Automatic",
    "Manual",
  ];

@override
  void initState() {
  _mobileNoController.text = _ls.getStringValue(_ls.mobileNumber);
  print("_mobileNoController :-- ${_mobileNoController.text}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bg = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidgets.appBarWidget("Add new car"),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Car name (dropdown)
              _label("Car name", required: true),
              TextFormField(
                controller: _carNameController,
                decoration: _decoration(hint: "Enter your car name"),
                style: TextStyle(
                    fontSize: 14.5.sp,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2),
                textInputAction: TextInputAction.next,
              ),

              // Owner name
             /* _label("Owner name", required: true),
              TextFormField(
                controller: _ownerController,
                decoration: _decoration(hint: "Enter Car owner name"),
                style: TextStyle(
                    fontSize: 14.5.sp,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2),
                textInputAction: TextInputAction.next,
              ),

              // Car no
              _label("Car no", required: true),
              TextFormField(
                controller: _carNoController,
                decoration: _decoration(hint: "RJXXD0XXXX"),
                style: TextStyle(
                    fontSize: 14.5.sp,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2),
                textCapitalization: TextCapitalization.characters,
              ),*/

              // Transmission type (dropdown with gear icon)
              _label("Transmission type"),
              DropdownButtonFormField<String>(
                value: _transmission,
                items: _transmissions
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) =>
                    setState(() => _transmission = v ?? _transmission),
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                decoration: _decoration(
                  prefixIcon: Padding(
                    padding:
                        const EdgeInsetsDirectional.only(start: 12, end: 8),
                    child: Icon(Icons.settings_input_component_rounded,
                        size: 22, color: _primary),
                  ),
                ),
                style: TextStyle(
                    fontSize: 14.5.sp,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2,
                    color: Colors.black),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: SizedBox(
          height: 5.h,
          child: ElevatedButton(
            onPressed: () {
              profileController.addCarApi(
                  _carNameController.text,
                  "",
                  "",
                  _transmission,
                  _mobileNoController.text);
              print("_carNameController :-- ${_carNameController.text}");
              print("_ownerController :-- ${_ownerController.text}");
              print("_mobileNoController :-- ${_mobileNoController.text}");
              print("_transmission :-- ${_transmission}");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              elevation: 0,
            ),
            child: Text(
              "Add new car",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Common input border
  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(_radius),
    borderSide: BorderSide(color: color, width: 1),
  );

  Widget _label(String text, {bool required = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 16),
      child: RichText(
        text: TextSpan(
          text: text,
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
          children: required
              ? const [
            TextSpan(
              text: " *",
              style: TextStyle(
                  color: Colors.red, fontWeight: FontWeight.w700),
            ),
          ]
              : const [],
        ),
      ),
    );
  }

  InputDecoration _decoration({
    String? hint,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: hint,
      hintStyle: TextStyle(color: _hint, fontSize: 14.sp),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      enabledBorder: _border(const Color(0xFFE0E0E0)),
      focusedBorder: _border(_primary),
      errorBorder: _border(Colors.red),
      focusedErrorBorder: _border(Colors.red),
    );
  }

  @override
  void dispose() {
    _ownerController.dispose();
    _carNoController.dispose();
    super.dispose();
  }
}
