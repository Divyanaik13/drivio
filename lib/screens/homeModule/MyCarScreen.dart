import 'package:flutter/material.dart';

class MyCarScreen extends StatefulWidget {
  const MyCarScreen({super.key});

  @override
  State<MyCarScreen> createState() => _MyCarScreenState();
}

class _MyCarScreenState extends State<MyCarScreen> {
  // Colors
  static const Color _primary = Color(0xFFFF3B22);
  static const Color _textDark = Color(0xFF111111);
  static const Color _hint = Color(0xFF9E9E9E);
  static const double _radius = 28;

  // Controllers
  final _ownerController = TextEditingController();
  final _carNoController = TextEditingController(text: "RJXXD0XXXX");

  // Dropdown values
  String? _carNickname;
  String _transmission = "Automatic";

  final List<String> _nicknames = [
    "Enter nick name of your car",
    "Beast",
    "Silver Arrow",
    "Road Runner",
    "Thunder",
  ];
  final List<String> _transmissions = ["Automatic", "Manual", "AMT", "CVT", "DCT"];

  // Common input border
  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(_radius),
    borderSide: BorderSide(color: color, width: 1),
  );

  Widget _label(String text, {bool required = false}) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 16),
      child: RichText(
        text: TextSpan(
          text: text,
          style: const TextStyle(
            fontSize: 12.5,
            color: _textDark,
            fontWeight: FontWeight.w600,
          ),
          children: required
              ? const [
            TextSpan(
              text: " *",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
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
      hintStyle: const TextStyle(color: _hint, fontSize: 13.5),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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

  @override
  Widget build(BuildContext context) {
    final bg = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bg,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
          onPressed: () => Navigator.of(context).maybePop(),
          tooltip: 'Back',
        ),
        title: const Text(
          "Add new car",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top car photo
              Container(
                width: 64,
                height: 64,
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      // Sample image; replace with your asset or picked image
                      "https://images.unsplash.com/photo-1549921296-3a6b3e75d216?q=80&w=400",
                    ),
                  ),
                ),
              ),

              // Car name (dropdown)
              _label("Car name", required: true),
              DropdownButtonFormField<String>(
                value: _carNickname ?? _nicknames.first,
                items: _nicknames
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) {
                  setState(() => _carNickname = v);
                },
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                decoration: _decoration(),
                style: const TextStyle(fontSize: 14, color: _textDark),
              ),

              // Owner name
              _label("Owner name", required: true),
              TextFormField(
                controller: _ownerController,
                decoration: _decoration(hint: "Enter Car owner name"),
                style: const TextStyle(fontSize: 14),
                textInputAction: TextInputAction.next,
              ),

              // Car no
              _label("Car no", required: true),
              TextFormField(
                controller: _carNoController,
                decoration: _decoration(hint: "RJXXD0XXXX"),
                style: const TextStyle(fontSize: 14, letterSpacing: 0.2),
                textCapitalization: TextCapitalization.characters,
              ),

              // Transmission type (dropdown with gear icon)
              _label("Transmission type"),
              DropdownButtonFormField<String>(
                value: _transmission,
                items: _transmissions
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => _transmission = v ?? _transmission),
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                decoration: _decoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsetsDirectional.only(start: 12, end: 8),
                    child: Icon(Icons.settings_input_component_rounded, size: 22, color: _primary),
                  ),
                ),
                style: const TextStyle(fontSize: 14, color: _textDark),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: SizedBox(
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              // TODO: handle submit
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Car added!")),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              elevation: 0,
            ),
            child: const Text(
              "Add new car",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
