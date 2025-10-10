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

  @override
  void initState() {
    isNavigator = Get.arguments;
    phoneNumber.value = LocalStorage().getStringValue(LocalStorage().mobileNumber);
    homeController.searchHistoryListApi(phoneNumber.value, 1, 20);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Icon(Icons.arrow_back, color: Colors.black)),
        title: Text(
          isNavigator == true ?"One-way trip" : "Out station trip",
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w500,
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
                    children: [
                      SizedBox(height: 15),
                      Icon(Icons.circle, color: Colors.red, size: 18),
                      SizedBox(height: 18),
                      isNavigator != true
                          ? Icon(Icons.more_vert_rounded,
                              color: Colors.black, size: 18)
                          : SizedBox(
                              width: 10,
                            ),
                      SizedBox(height: 18),
                      isNavigator != true
                          ? Icon(Icons.circle, color: Colors.green, size: 18)
                          : SizedBox(
                              width: 10,
                            ),
                    ],
                  ),
                  const SizedBox(width: 10),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                const EdgeInsets.only(left: 15, right: 15),
                          ),
                          boxDecoration: BoxDecoration(
                            color: ConstColors().whiteColor,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          getPlaceDetailWithLatLng: (prediction) async {
                            try {
                              print("prediction :--  $prediction");

                              /*  CommonWidgets.keyboardHide();

                              /// show calender
                               DateTime? selectedDateTime =
                              await CommonFunctions().dateTimePicker(
                                  barrierDismissible: false);*/

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

                              // Show date-time picker only if isNavigator is true
                              if (isNavigator == true) {
                                DateTime? selectedDateTime =
                                    await CommonFunctions().dateTimePicker(
                                        barrierDismissible: false);

                                if (selectedDateTime != null) {
                                  print(
                                      "Selected date and time: $selectedDateTime");
                                  dateTime.value = selectedDateTime;

                                  Get.toNamed(
                                    RouteHelper().getOneWayTripDetailScreen(),
                                    arguments: {
                                      "sourceLatitude": sourceLatitude.value,
                                      "sourceLongitude": sourceLongitude.value,
                                      "destinationLatitude": destinationLatitude.value,
                                      "destinationLongitude": destinationLongitude.value,
                                      "sourceLocation": sourceController.text,
                                      "destinationLocation": destinationController.text,
                                      "dateTime": selectedDateTime.toString(),
                                      "isNavigator": isNavigator,
                                    },
                                  );
                                }
                              }
                            } catch (e, stacktrace) {
                              print("Error in getPlaceDetailWithLatLng: $e");
                              print("Stacktrace: $stacktrace");
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


                      /// Destination field
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

                                      /// Navigate to next screen
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
                                    print(
                                        "Error in getPlaceDetailWithLatLng: $e");
                                    print("Stacktrace: $stacktrace");
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
                            )
                          : InkWell(
                              onTap: () async {
                                CommonFunctions().showLoader();
                                try {
                                  var position = await CommonFunctions()
                                      .getCurrentLocation();
                                  if (position != null) {
                                    sourceLatitude.value = position.latitude;
                                    sourceLongitude.value = position.longitude;

                                    await CommonFunctions().getAddress(
                                        position.latitude, position.longitude);

                                    sourceLocation.value =
                                        ConstStrings().location.value;
                                    sourceController.text =
                                        ConstStrings().location.value;

                                    // Show date-time picker if isNavigator is true
                                    if (isNavigator == true) {
                                      CommonWidgets.keyboardHide();

                                      DateTime? selectedDateTime =
                                          await CommonFunctions()
                                              .dateTimePicker(
                                                  barrierDismissible: false);

                                      if (selectedDateTime != null) {
                                        print(
                                            "Selected date and time: $selectedDateTime");
                                        dateTime.value = selectedDateTime;


                                        /// Navigate to next screen
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
                                    }
                                  }
                                } catch (e) {
                                  print("current location error :-- $e");
                                } finally {
                                  CommonFunctions().hideLoader();
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: ConstColors().themeColor,
                                ),
                                child: Text(
                                  "Current location",
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                      SizedBox(height: 10,),
                      InkWell(
                        onTap: (){
                          showAddressBottomSheet(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: ConstColors().themeColor,
                          ),
                          child: Text(
                            "Add location manually",
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
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
              Obx(() {
                return Expanded(
                  child: ListView.builder(
                      itemCount: homeController.searchHistoryList.length,
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
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
                      }),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
