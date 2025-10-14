import 'package:drivio_sarthi/utils/AssetsImages.dart';
import 'package:drivio_sarthi/utils/CommonWidgets.dart';
import 'package:drivio_sarthi/utils/RouteHelper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sizer/sizer.dart';

class MyCarScreen extends StatefulWidget {
  const MyCarScreen({super.key});

  @override
  State<MyCarScreen> createState() => _MyCarScreenState();
}

class _MyCarScreenState extends State<MyCarScreen> {
  @override
  Widget build(BuildContext context) {
    final cars = <CarItem>[
      CarItem(
        name: "Audi",
        plate: "RJXXD0XXXX",
        owner: "Ramash singh",
        imagePath: AssetsImages().carImage,
      ),
      // Add more items if needed
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidgets.appBarWidget("My Cars"),

      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text("My Cars",
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                 Text(
                  "Manage all your vehicles here – add new, edit details, or remove old ones",
                  style: TextStyle(fontSize: 13.sp, color: Colors.black54),
                ),
                const SizedBox(height: 16),

                // List
                Expanded(
                  child: ListView.separated(
                    itemCount: cars.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final car = cars[index];
                      return _CarTile(
                        car: car,
                        onTap: () {
                          // TODO: open car details
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 80), // space for bottom button
              ],
            ),
          ),

          // Bottom fixed button
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                   Get.toNamed(RouteHelper().getAddNewCarScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF3B1F), // bright red/orange
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Add new car",
                    style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 14.sp),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CarItem {
  final String name;
  final String plate;
  final String owner;
  final String imagePath;

  CarItem({
    required this.name,
    required this.plate,
    required this.owner,
    required this.imagePath,
  });
}

class _CarTile extends StatelessWidget {
  final CarItem car;
  final VoidCallback? onTap;

  const _CarTile({required this.car, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(12),
      elevation: 0.5,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Car image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  car.imagePath,
                  height: 56,
                  width: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),

              // Texts
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(car.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(car.plate,
                        style:
                        const TextStyle(fontSize: 12, color: Colors.black87)),
                    const SizedBox(height: 2),
                    Text(car.owner,
                        style:
                        const TextStyle(fontSize: 12, color: Colors.black54)),
                  ],
                ),
              ),

              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black87),
            ],
          ),
        ),
      ),
    );
  }

}

