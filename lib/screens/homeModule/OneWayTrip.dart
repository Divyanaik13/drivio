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

  final googlePlaceApi = ConstStrings().placeApiKey;

  @override
  void initState() {
    phoneNumber.value = LocalStorage().getStringValue(LocalStorage().mobileNumber);
    homeController.searchHistoryListApi(phoneNumber.value, 1, 20);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Icon(Icons.arrow_back, color: Colors.black)),
        title: Text(
          "One-way trip ↻",
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
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
                    children: const [
                      SizedBox(height: 15),
                      Icon(Icons.circle, color: Colors.red, size: 18),
                      SizedBox(height: 18),
                      Icon(Icons.more_vert_rounded,
                          color: Colors.black, size: 18),
                      SizedBox(height: 18),
                      Icon(Icons.circle, color: Colors.green, size: 18),
                    ],
                  ),
                  const SizedBox(width: 10),

                  Column(
                    children: [
                      SizedBox(
                        width: 80.w,
                        child: GooglePlaceAutoCompleteTextField(
                          textEditingController: sourceController,
                          googleAPIKey: googlePlaceApi,
                          debounceTime: 400,
                          isLatLngRequired: true,
                          inputDecoration: InputDecoration(
                            hintText: "Where from?",
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
                                const EdgeInsets.only(left: 10, right: 10),
                          ),
                          boxDecoration: BoxDecoration(
                            color: ConstColors().whiteColor,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          getPlaceDetailWithLatLng: (prediction) async {
                            try {
                              print("prediction :--  $prediction");

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
                              /* Get.back(result: {
                                "latitude": latitude.value,
                                "longitude": longitude.value,
                                "location": location.value,
                                "placeId": placeId.value,
                              });*/
                            } catch (e, stacktrace) {
                              print("❌ Error in getPlaceDetailWithLatLng: $e");
                              print("📌 Stacktrace: $stacktrace");
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
                      SizedBox(
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
                            contentPadding:
                                const EdgeInsets.only(left: 10, right: 10),
                          ),
                          boxDecoration: BoxDecoration(
                            color: ConstColors().whiteColor,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          getPlaceDetailWithLatLng: (prediction) async {
                            try {
                              print("prediction :--  $prediction");

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

                              /// show calender
                              DateTime? selectedDateTime =
                                  await CommonFunctions().dateTimePicker(
                                      barrierDismissible: false);
                              print(
                                  "Select date and time :-- $selectedDateTime");
                              if (selectedDateTime != null) {
                                print(
                                    "Select date and time :-- $selectedDateTime");
                                await homeController.createSearchHistoryApi(
                                    LocalStorage().getStringValue(LocalStorage().mobileNumber),
                                    destinationLatitude.value,
                                    destinationLongitude.value,
                                    destinationController.text,
                                    selectedDateTime.toUtc().toIso8601String());

                                /// Navigate to next screen
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
                                    });
                              }
                            } catch (e, stacktrace) {
                              print("❌ Error in getPlaceDetailWithLatLng: $e");
                              print("📌 Stacktrace: $stacktrace");
                            }
                          },
                          itemClick: (prediction) {
                            destinationLocation.value = prediction.description!;
                            placeId.value = prediction.placeId!;
                            destinationController.text =
                                prediction.description!;
                          },
                          focusNode: destinationFocusNode,
                        ),
                      ),
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
              Obx((){
                return ListView.builder(
                    itemCount: homeController.searchHistoryList.length,
                    shrinkWrap: true,
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
                          /* Text(
                      "837 Howard St, india , CA 94103, Indore",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[600],
                      ),
                    ),*/
                          SizedBox(height: 20)
                        ],
                      );
                    });
              })
            ],
          ),
        ),
      ),
    );
  }
}
