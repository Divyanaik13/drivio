import 'package:drivio_sarthi/utils/AssetsImages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class OneWayTripDetailScreen extends StatefulWidget {
  const OneWayTripDetailScreen({super.key});

  @override
  State<OneWayTripDetailScreen> createState() => _OneWayTripDetailScreenState();
}

class _OneWayTripDetailScreenState extends State<OneWayTripDetailScreen> {
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  String selectedHour = "2 hr";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: const Icon(Icons.arrow_back, color: Colors.black)),
        title: const Text(
          "One way trip ↻",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Map placeholder
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                AssetsImages().splashIcon,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            // Pickup & Drop
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: const [
                    Icon(Icons.circle, color: Colors.red, size: 16),
                    SizedBox(height: 8),
                    Icon(Icons.more_vert, size: 18, color: Colors.black),
                    SizedBox(height: 8),
                    Icon(Icons.circle, color: Colors.green, size: 16),
                  ],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    children: [
                      _customTextField("Lig square indore", fromController),
                      const SizedBox(height: 12),
                      _customTextField("Phoenix -mall indore", toController),
                    ],
                  ),
                )
              ],
            ),

            const SizedBox(height: 20),

            // Today's vehicle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Today's vehicle",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 18, color: Colors.red),
                    SizedBox(width: 5),
                    Text("2 sept, 5:00 am",
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w400)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text("Distance 20km",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400)),
            const SizedBox(height: 12),

            // Vehicle & Manual info
            Row(
              children: [
                _chip("Xuv 700"),
                const SizedBox(width: 12),
                _chip("Manual"),
              ],
            ),

            const SizedBox(height: 20),

            // Pay as you go
            const Text("Pay as you go",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: ["2 hr", "4 hr", "6 hr", "8 hr"]
                  .map((e) => ChoiceChip(
                        label: Text(e),
                        selected: selectedHour == e,
                        onSelected: (_) {
                          setState(() {
                            selectedHour = e;
                          });
                        },
                        selectedColor: Colors.red,
                        backgroundColor: Colors.white,
                        labelStyle: TextStyle(
                            color: selectedHour == e
                                ? Colors.white
                                : Colors.black),
                      ))
                  .toList(),
            ),

            const SizedBox(height: 20),

            // Driver Info Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.verified_user, color: Colors.red, size: 32),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      "Drivo\nVerified and Tested Driver",
                      style: TextStyle(fontSize: 13, height: 1.3),
                    ),
                  ),
                  const Text(
                    "₹100",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Offers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Row(
                  children: [
                    Icon(Icons.local_offer, color: Colors.black),
                    SizedBox(width: 8),
                    Text("Offers\nLatest offers",
                        style: TextStyle(fontSize: 13, height: 1.3)),
                  ],
                ),
                Text("Apply now",
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.red,
                        fontWeight: FontWeight.w500)),
              ],
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {},
              child: const Text(
                "Request for Driver",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _customTextField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.location_on_outlined, size: 20),
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
        LengthLimitingTextInputFormatter(100),
      ],
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
      ),
      child: Text(text,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
    );
  }
}
