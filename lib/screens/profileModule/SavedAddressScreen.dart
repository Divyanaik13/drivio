import 'package:drivio_sarthi/utils/CommonWidgets.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SavedAddressScreen extends StatefulWidget {
  const SavedAddressScreen({super.key});

  @override
  State<SavedAddressScreen> createState() => _SavedAddressScreenState();
}

class _SavedAddressScreenState extends State<SavedAddressScreen> {
  final Map<String, dynamic> savedAddress = {
    "userNumber": "9876543210",
    "buildingName": "Green Apartment",
    "area": "Sector 5",
    "pincode": "462001",
    "city": "Bhopal",
    "state": "Madhya Pradesh",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets.appBarWidget("Saved Address"),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRow("Mobile Number", savedAddress["userNumber"]),
                _buildRow("Building Name", savedAddress["buildingName"]),
                _buildRow("Area", savedAddress["area"]),
                _buildRow("Pincode", savedAddress["pincode"]),
                _buildRow("City", savedAddress["city"]),
                _buildRow("State", savedAddress["state"]),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Handle edit or add new address
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    ),
                    icon: const Icon(Icons.edit_location_alt_rounded, color: Colors.white),
                    label: const Text(
                      "Edit / Add New Address",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$title:",
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.black87),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(fontSize: 13.sp, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}

