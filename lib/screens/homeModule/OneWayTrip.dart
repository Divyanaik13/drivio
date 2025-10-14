import 'package:drivio_sarthi/utils/CommonWidgets.dart';
import 'package:drivio_sarthi/utils/ConstStrings.dart';
import 'package:drivio_sarthi/utils/LocalStorage.dart';
import 'package:drivio_sarthi/utils/RouteHelper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:sizer/sizer.dart';
import '../../controllers/HomeController.dart';
import '../../utils/CommonFunctions.dart';
import '../../utils/ConstColors.dart';
import '../../utils/widgets/SavedAddressBottomSheet.dart';

class OneWayTripScreen extends StatefulWidget {
  const OneWayTripScreen({super.key});

  @override
  State<OneWayTripScreen> createState() => _OneWayTripScreenState();
}

class _OneWayTripScreenState extends State<OneWayTripScreen> {
  TextEditingController sourceController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  late final FocusNode sourceFocusNode = FocusNode();
  late final FocusNode destinationFocusNode = FocusNode();
  var homeController = Get.find<HomeController>();

  var sourceLatitude = 0.0.obs;
  var sourceLongitude = 0.0.obs;
  var sourceLocation = "".obs;
  var destinationLatitude = 0.0.obs;
  var destinationLongitude = 0.0.obs;
  var destinationLocation = "".obs;
  var placeId = "".obs;
  var dateTime = DateTime.now().obs;
  var phoneNumber = "".obs;
  var isNavigator;

  final googlePlaceApi = ConstStrings().placeApiKey;

/*  @override
  void initState() {
    isNavigator = Get.arguments;
    phoneNumber.value =
        LocalStorage().getStringValue(LocalStorage().mobileNumber);
    homeController.searchHistoryListApi(phoneNumber.value, 1, 20);
    super.initState();

    // NEW: Prefill pickup with current location if available
    if (ConstStrings().location.value.isNotEmpty &&
        ConstStrings().latitude.value != 0.0 &&
        ConstStrings().longitude.value != 0.0) {
      sourceController.text = ConstStrings().location.value;
      sourceLocation.value = ConstStrings().location.value;
      sourceLatitude.value = ConstStrings().latitude.value;
      sourceLongitude.value = ConstStrings().longitude.value;
    }

    // NEW (optional but helpful): if location arrives a bit later, set it once
    ever<String>(ConstStrings().location, (loc) {
      if (sourceController.text.isEmpty &&
          loc.isNotEmpty &&
          ConstStrings().latitude.value != 0.0 &&
          ConstStrings().longitude.value != 0.0) {
        sourceController.text = loc;
        sourceLocation.value = loc;
        sourceLatitude.value = ConstStrings().latitude.value;
        sourceLongitude.value = ConstStrings().longitude.value;
      }
    });
  }*/

  @override
  void initState() {
    // Read args safely (can be bool or Map when returning from Edit)
    final args = Get.arguments;

    // Preserve your original behavior
    isNavigator = (args is Map) ? (args["isNavigator"] ?? false) : args;

    phoneNumber.value =
        LocalStorage().getStringValue(LocalStorage().mobileNumber);
    homeController.searchHistoryListApi(phoneNumber.value, 1, 20);

    // Prefill pickup with current location if available
    if (sourceController.text.isEmpty &&
        ConstStrings().location.value.isNotEmpty &&
        ConstStrings().latitude.value != 0.0 &&
        ConstStrings().longitude.value != 0.0) {
      sourceController.text = ConstStrings().location.value;
      sourceLocation.value  = ConstStrings().location.value;
      sourceLatitude.value  = ConstStrings().latitude.value;
      sourceLongitude.value = ConstStrings().longitude.value;
    }

    // If current location arrives a bit later, set it once
    ever<String>(ConstStrings().location, (loc) {
      if (sourceController.text.isEmpty &&
          loc.isNotEmpty &&
          ConstStrings().latitude.value != 0.0 &&
          ConstStrings().longitude.value != 0.0) {
        sourceController.text = loc;
        sourceLocation.value  = loc;
        sourceLatitude.value  = ConstStrings().latitude.value;
        sourceLongitude.value = ConstStrings().longitude.value;
      }
    });

    // Handle "Edit" flow from TripDetail screen (optional args)
    if (args is Map && args["editTarget"] != null) {
      final String target = args["editTarget"] as String; // "source" | "destination"
      final Map? pre      = args["prefill"] as Map?;

      if (pre != null) {
        final String addr = (pre["address"] ?? "") as String;
        final double lat  = ((pre["lat"] ?? 0.0) as num).toDouble();
        final double lng  = ((pre["lng"] ?? 0.0) as num).toDouble();

        if (target == "source") {
          sourceController.text = addr;
          sourceLocation.value  = addr;
          sourceLatitude.value  = lat;
          sourceLongitude.value = lng;

          Future.microtask(() {
            if (mounted) FocusScope.of(context).requestFocus(destinationFocusNode);
          });
        } else if (target == "destination") {
          destinationController.text = addr;
          destinationLocation.value  = addr;
          destinationLatitude.value  = lat;
          destinationLongitude.value = lng;

          Future.microtask(() {
            if (mounted) FocusScope.of(context).requestFocus(destinationFocusNode);
          });
        }
      } else {
        if (target == "source") {
          Future.microtask(() {
            if (mounted) FocusScope.of(context).requestFocus(destinationFocusNode);
          });
        } else if (target == "destination") {
          Future.microtask(() {
            if (mounted) FocusScope.of(context).requestFocus(destinationFocusNode);
          });
        }
      }
    }

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: CommonWidgets.appBarWidget(
        isNavigator == true ? "One-way trip" : "Out station trip",
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left side icons
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      const Icon(Icons.circle, color: Colors.red, size: 18),
                      const SizedBox(height: 18),
                      isNavigator != true
                          ? const Icon(Icons.more_vert_rounded,
                              color: Colors.black, size: 18)
                          : const SizedBox(width: 10),
                      const SizedBox(height: 18),
                      isNavigator != true
                          ? const Icon(Icons.circle,
                              color: Colors.green, size: 18)
                          : const SizedBox(width: 10),
                    ],
                  ),
                  const SizedBox(width: 10),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // === Pickup (GooglePlaceAutoCompleteTextField) remains SAME ===
                      SizedBox(
                        width: 80.w,
                        child: GooglePlaceAutoCompleteTextField(
                          textEditingController: sourceController,
                          googleAPIKey: googlePlaceApi,
                          debounceTime: 400,
                          isLatLngRequired: true,
                          inputDecoration: InputDecoration(
                            hintText: "Pickup location",
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15.px,
                              color: Colors.grey,
                            ),
                            filled: true,
                            fillColor: ConstColors().whiteColor,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    color: ConstColors().whiteColor,
                                    width: 2.px)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    color: ConstColors().whiteColor,
                                    width: 2.px)),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    color: ConstColors().whiteColor,
                                    width: 2.px)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    color: ConstColors().whiteColor,
                                    width: 2.px)),
                            contentPadding:
                                const EdgeInsets.only(left: 15, right: 15),
                          ),
                          boxDecoration: BoxDecoration(
                            color: ConstColors().whiteColor,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          getPlaceDetailWithLatLng: (prediction) async {
                            try {
                              sourceLatitude.value = double.parse(
                                double.parse(prediction.lat!)
                                    .toStringAsFixed(5),
                              );
                              sourceLongitude.value = double.parse(
                                double.parse(prediction.lng!)
                                    .toStringAsFixed(5),
                              );
                              placeId.value = prediction.placeId!;
                              sourceController.text = sourceLocation.value;

                              CommonWidgets.keyboardHide();

                              if (isNavigator == true) {
                                DateTime? selectedDateTime =
                                    await CommonFunctions().dateTimePicker(
                                        barrierDismissible: false);

                                if (selectedDateTime != null) {
                                  dateTime.value = selectedDateTime;

                                  Get.toNamed(
                                    RouteHelper().getOneWayTripDetailScreen(),
                                    arguments: {
                                      "sourceLatitude": sourceLatitude.value,
                                      "sourceLongitude": sourceLongitude.value,
                                      "destinationLatitude":
                                          destinationLatitude.value,
                                      "destinationLongitude":
                                          destinationLongitude.value,
                                      "sourceLocation": sourceController.text,
                                      "destinationLocation":
                                          destinationController.text,
                                      "dateTime": selectedDateTime.toString(),
                                      "isNavigator": isNavigator,
                                    },
                                  );
                                }
                              }
                            } catch (e, stacktrace) {
                              debugPrint(
                                  "Error in getPlaceDetailWithLatLng: $e");
                              debugPrint("Stacktrace: $stacktrace");
                            }
                          },
                          itemClick: (prediction) {
                            sourceLocation.value = prediction.description!;
                            placeId.value = prediction.placeId!;
                            sourceController.text = prediction.description!;
                          },
                          focusNode: sourceFocusNode,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // === Destination field (unchanged UI) ===
                      isNavigator != true
                          ? SizedBox(
                              width: 80.w,
                              child: GooglePlaceAutoCompleteTextField(
                                textEditingController: destinationController,
                                googleAPIKey: googlePlaceApi,
                                debounceTime: 400,
                                isLatLngRequired: true,
                                inputDecoration: InputDecoration(
                                  hintText: "to?",
                                  hintStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.px,
                                    color: Colors.grey,
                                  ),
                                  filled: true,
                                  fillColor: ConstColors().whiteColor,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(
                                          color: ConstColors().whiteColor,
                                          width: 2.px)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(
                                          color: ConstColors().whiteColor,
                                          width: 2.px)),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(
                                          color: ConstColors().whiteColor,
                                          width: 2.px)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(
                                          color: ConstColors().whiteColor,
                                          width: 2.px)),
                                  contentPadding: const EdgeInsets.only(
                                      left: 15, right: 15),
                                ),
                                boxDecoration: BoxDecoration(
                                  color: ConstColors().whiteColor,
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                getPlaceDetailWithLatLng: (prediction) async {
                                  try {
                                    destinationLatitude.value = double.parse(
                                      double.parse(prediction.lat!)
                                          .toStringAsFixed(5),
                                    );
                                    destinationLongitude.value = double.parse(
                                      double.parse(prediction.lng!)
                                          .toStringAsFixed(5),
                                    );
                                    placeId.value = prediction.placeId!;
                                    destinationController.text =
                                        destinationLocation.value;

                                    CommonWidgets.keyboardHide();

                                    DateTime? selectedDateTime =
                                        await CommonFunctions().dateTimePicker(
                                            barrierDismissible: false);
                                    if (selectedDateTime != null) {
                                      await homeController
                                          .createSearchHistoryApi(
                                              LocalStorage().getStringValue(
                                                  LocalStorage().mobileNumber),
                                              destinationLatitude.value,
                                              destinationLongitude.value,
                                              destinationController.text,
                                              selectedDateTime
                                                  .toUtc()
                                                  .toIso8601String());

                                      Get.toNamed(
                                          RouteHelper()
                                              .getOneWayTripDetailScreen(),
                                          arguments: {
                                            "sourceLatitude":
                                                sourceLatitude.value,
                                            "sourceLongitude":
                                                sourceLongitude.value,
                                            "destinationLatitude":
                                                destinationLatitude.value,
                                            "destinationLongitude":
                                                destinationLongitude.value,
                                            "sourceLocation":
                                                sourceController.text,
                                            "destinationLocation":
                                                destinationController.text,
                                            "dateTime":
                                                selectedDateTime.toString(),
                                            "isNavigator": isNavigator,
                                          });
                                    }
                                  } catch (e, stacktrace) {
                                    debugPrint(
                                        "Error in getPlaceDetailWithLatLng: $e");
                                    debugPrint("Stacktrace: $stacktrace");
                                  }
                                },
                                itemClick: (prediction) {
                                  destinationLocation.value =
                                      prediction.description!;
                                  placeId.value = prediction.placeId!;
                                  destinationController.text =
                                      prediction.description!;
                                },
                                focusNode: destinationFocusNode,
                              ),
                            ): SizedBox(),
                      SizedBox(height: isNavigator != true ? 12 : 0),
                      InkWell(
                        onTap: () async {
                          final bool fillDrop =
                              (isNavigator != true) &&
                                  (sourceController.text.trim().isNotEmpty) &&
                                  (destinationController.text.trim().isEmpty);

                          final picked = await Get.toNamed(RouteHelper().getSelectLocationScreen());

                          if (picked != null) {
                            try {
                              final double lat =
                              (picked is AddressResult) ? picked.lat : (picked['lat'] ?? 0.0);
                              final double lng =
                              (picked is AddressResult) ? picked.lng : (picked['lng'] ?? 0.0);
                              final String addr =
                              (picked is AddressResult) ? picked.address : (picked['address'] ?? "");

                              if (fillDrop) {
                                // ---- Set DROP (destination) ----
                                destinationLatitude.value  = lat;
                                destinationLongitude.value = lng;
                                destinationLocation.value  = addr;
                                destinationController.text = addr;

                                // (Optional) toast/snackbar
                                // Get.snackbar("Done", "Drop set from map");
                              } else {
                                // ---- Set PICKUP (source) ----
                                sourceLatitude.value  = lat;
                                sourceLongitude.value = lng;
                                sourceLocation.value  = addr;
                                sourceController.text = addr;

                                // (Optional) toast/snackbar
                                // Get.snackbar("Done", "Pickup set from map");
                              }
                            } catch (_) {
                              // ignore parse errors
                            }
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.pin_drop_outlined),
                              SizedBox(width: 8),
                              Text("Select on map", style: TextStyle(fontSize: 13.5.sp)),
                            ],
                          ),
                        ),
                      )

                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Text(
                "Search history",
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Obx(() {
                return Expanded(
                  child: ListView.builder(
                      itemCount: homeController.searchHistoryList.length,
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        var history = homeController.searchHistoryList[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              history.address,
                              style: TextStyle(
                                fontSize: 14.5.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 20)
                          ],
                        );
                      }),
                );
              }),
/*
              // === Select location on Map -> await result & set pickup ===
              InkWell(
                onTap: () async {
                  final picked = await Get.toNamed(
                      RouteHelper().getSelectLocationScreen());

                  if (picked != null) {
                    try {
                      // typed (AddressResult) or dynamic—both handled
                      final double lat = (picked is AddressResult)
                          ? picked.lat
                          : (picked['lat'] ?? 0.0);
                      final double lng = (picked is AddressResult)
                          ? picked.lng
                          : (picked['lng'] ?? 0.0);
                      final String addr = (picked is AddressResult)
                          ? picked.address
                          : (picked['address'] ?? "");

                      sourceLatitude.value = lat;
                      sourceLongitude.value = lng;
                      sourceLocation.value = addr;
                      sourceController.text = addr;
                    } catch (_) {
                      // ignore parse errors
                    }
                  }
                },
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.add_location_sharp,
                      color: Colors.red,
                      size: 20,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      "Select location on Map",
                      style: TextStyle(
                          fontSize: 14.5.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.red),
                    ),
                  ],
                )),
              ),
              SizedBox(height: 1.h),*/
            ],
          ),
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
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () async {
                // Hide keyboard
                CommonWidgets.keyboardHide();

                // 1) Validate PICKUP
                if (sourceController.text.trim().isEmpty ||
                    sourceLatitude.value == 0.0 ||
                    sourceLongitude.value == 0.0) {
                  await CommonFunctions().alertDialog(
                    "Alert",
                    "Please select pickup location.",
                    "Ok",
                        () => Get.back(),
                  );
                  return;
                }

                // 2) If OutStation, validate DROP
                if (isNavigator != true) {
                  if (destinationController.text.trim().isEmpty ||
                      destinationLatitude.value == 0.0 ||
                      destinationLongitude.value == 0.0) {
                    await CommonFunctions().alertDialog(
                      "Alert",
                      "Please select drop location.",
                      "Ok",
                          () => Get.back(),
                    );
                    return;
                  }
                }

                // 3) Pick Date & Time (force user to pick if not already)
                final selectedDateTime =
                await CommonFunctions().dateTimePicker(barrierDismissible: false);
                if (selectedDateTime == null) {
                  // user cancelled
                  return;
                }

                // 4) Optional: Save destination in history for OutStation (same as your earlier flow)
                if (isNavigator != true) {
                  await homeController.createSearchHistoryApi(
                    LocalStorage().getStringValue(LocalStorage().mobileNumber),
                    destinationLatitude.value,
                    destinationLongitude.value,
                    destinationController.text,
                    selectedDateTime.toUtc().toIso8601String(),
                  );
                }

                // 5) Navigate to detail screen with all args
                Get.toNamed(
                  RouteHelper().getOneWayTripDetailScreen(),
                  arguments: {
                    "sourceLatitude":        sourceLatitude.value,
                    "sourceLongitude":       sourceLongitude.value,
                    "destinationLatitude":   isNavigator != true ? destinationLatitude.value  : 0.0,
                    "destinationLongitude":  isNavigator != true ? destinationLongitude.value : 0.0,
                    "sourceLocation":        sourceController.text,
                    "destinationLocation":   destinationController.text,
                    "dateTime":              selectedDateTime.toString(),
                    "isNavigator":           isNavigator,
                  },
                );
              },

              child: Text(
                "Confirm address",
                style: TextStyle(fontSize: 15.sp, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
