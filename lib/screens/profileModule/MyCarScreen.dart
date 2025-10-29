import 'package:drivio_sarthi/utils/CommonWidgets.dart';
import 'package:drivio_sarthi/utils/RouteHelper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../controllers/profileController.dart';

class MyCarScreen extends StatefulWidget {
  const MyCarScreen({super.key});

  @override
  State<MyCarScreen> createState() => _MyCarScreenState();
}

class _MyCarScreenState extends State<MyCarScreen> {
  final profileController = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
    profileController.getCarCollectionApi("6263934024");
  }

  @override
  Widget build(BuildContext context) {
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
                Text(
                  "My Cars",
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Manage all your vehicles below",
                  style: TextStyle(fontSize: 13.sp, color: Colors.black54),
                ),
                const SizedBox(height: 20),

                /// ✅ Car List
                Expanded(
                  child: Obx(() {
                    final cars =
                        profileController.calCollectionModel.value?.data.cars ??
                            [];

                    if (cars.isEmpty) {
                      return const Center(
                        child: Text("No cars added yet."),
                      );
                    }

                    return ListView.builder(
                      itemCount: cars.length,
                      itemBuilder: (context, index) {
                        final car = cars[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: Colors.black12, width: 1),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              )
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.directions_car,
                                  color: Colors.redAccent, size: 32),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      car.carname ?? "Unknown Car",
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      "${car.transmissionType ?? 'Manual'} • ${car.carNumber ?? '-'}",
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.black54),
                                    ),
                                  ],
                                ),
                              ),

                              // ✅ Edit Button
                              IconButton(
                                icon: const Icon(Icons.edit,
                                    color: Colors.grey, size: 22),
                                onPressed: () {
                                  Get.toNamed(
                                    RouteHelper().getAddNewCarScreen(),
                                    arguments: {
                                      "isEdit": true,
                                      "carData": car,
                                    },
                                  );
                                },
                              ),

                              // ✅ Delete Button
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.redAccent, size: 22),
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(16)),
                                        title: const Text(
                                          "Delete Car?",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700),
                                        ),
                                        content: const Text(
                                          "Are you sure you want to delete this car?",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: const Text("Cancel"),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: const Text(
                                              "Delete",
                                              style: TextStyle(
                                                  color: Colors.redAccent,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (confirm == true) {
                                    await profileController
                                        .deleteApi(car.id.toString());
                                    await profileController
                                        .getCarCollectionApi("6263934024");
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
                ),
                const SizedBox(height: 70),
              ],
            ),
          ),

          /// ✅ Bottom Add New Car Button
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
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text(
                    "Add new car",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
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
