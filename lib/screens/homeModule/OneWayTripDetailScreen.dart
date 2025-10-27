import 'package:drivio_sarthi/utils/ConstColors.dart';
import 'package:drivio_sarthi/utils/RouteHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../../controllers/HomeController.dart';
import '../../controllers/PaymentCalController.dart';
import '../../model/DriverInfoModel.dart';
import '../../network/SocketService.dart';
import '../../utils/CommonFunctions.dart';
import '../../utils/LocalStorage.dart';
import '../../utils/widgets/DriverSearchingBootmSheet.dart';

final GlobalKey<DriverSearchingBottomSheetState> bottomSheetKey =
    GlobalKey<DriverSearchingBottomSheetState>();

class OneWayTripDetailScreen extends StatefulWidget {
  const OneWayTripDetailScreen({super.key});

  @override
  State<OneWayTripDetailScreen> createState() => _OneWayTripDetailScreenState();
}

class _OneWayTripDetailScreenState extends State<OneWayTripDetailScreen> {
  TextEditingController sourceController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  var homeController = Get.find<HomeController>();
  var paymentController = Get.find<PaymentController>();
  // String? selectedHour;
  final TextEditingController manualController = TextEditingController();

  int _hours = 1;
  String selectedHour = "1";
  String? selectedDateTime;
  double? tripDistance;
  bool isNavigator = false;
  var userNme = "";
  var phoneNumber = "";
  var email = "";
  var userID = "";
  RxString selectedTransmission = "Manual".obs;
  RxString selectedCar = "Xuv 700".obs;
  RxList<String> carList = ["Xuv 700", "Ford", "Baleno"].obs;
  // Sentinel for Add New
  String kAddNewSentinel = "__ADD__";
  final startDateTime = Rxn<DateTime>();
  final endDateTime = Rxn<DateTime>();
  String startTime = "";
  String endTime = "";
  String extra = "";

  LocalStorage ls = LocalStorage();

  GoogleMapController? _mapController;
  Rxn<LatLng> sourceLocation = Rxn<LatLng>();
  Rxn<LatLng> destinationLocation = Rxn<LatLng>();
  Rxn<LatLng> currentLocation = Rxn<LatLng>();

  final Set<Marker> markers = {};
  final Set<Polyline> polylines = {};

  Future<void> _loadUserData() async {
    userNme = ls.getStringValue(ls.fullName) ?? "";
    email = ls.getStringValue(ls.email) ?? "";
    phoneNumber = ls.getStringValue(ls.mobileNumber) ?? "";
    userID = ls.getStringValue(ls.userId) ?? "";
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();

    final args = Get.arguments;

    print("args :-- $args");
    if (args != null) {
      double sourceLat = args["sourceLatitude"];
      double sourceLong = args["sourceLongitude"];
      double destinationLat = args["destinationLatitude"];
      double destinationLong = args["destinationLongitude"];
      String sourceLoc = args["sourceLocation"];
      String destinationLoc = args["destinationLocation"];
      isNavigator = args["isNavigator"] ?? false;

      sourceLocation.value = LatLng(sourceLat, sourceLong);
      destinationLocation.value = LatLng(destinationLat, destinationLong);

      sourceController.text = sourceLoc;
      destinationController.text = destinationLoc;

      tripDistance =
          calculateDistance(sourceLocation.value!, destinationLocation.value!);

      if (isNavigator) {
        setState(() {
          destinationController.clear();
        });
      }

      if (sourceLocation.value != null) {
        markers.add(
          Marker(
            markerId: const MarkerId("source"),
            position: sourceLocation.value!,
            infoWindow: const InfoWindow(title: "Current Location"),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
          ),
        );
      }
      _callPaymentApi();
    } else {
      /// Default pickup & drop
      sourceLocation.value = const LatLng(
          22.705313624334096, 75.90907346989012); // Lig square indore
      destinationLocation.value = const LatLng(
          22.738078356773574, 75.89032710201927); // Phoenix mall indore

      _callPaymentApi();
    }
  }

  void _incHour() {
    if (_hours < 12) {
      setState(() => _hours++);
      _syncSelectedHour();
      _callPaymentApi(); // API call after increasing hour
    }
  }

  void _decHour() {
    if (_hours > 1) {
      setState(() => _hours--);
      _syncSelectedHour();
      _callPaymentApi(); // API call after decreasing hour
    }
  }

  void _syncSelectedHour() {
    selectedHour = "${_hours}";
  }

// New method to call payment API
//   void _callPaymentApi() {
//     print("Calling Payment API with:");
//     print("Distance: ${tripDistance?.round() ?? 0} km");
//     print("Hours: $_hours");
//     print("Car Type: ${selectedCar.value}");
//     // Get current date and time for start time
//     DateTime? now = startDateTime.value ?? DateTime.now();
//
//     // Calculate end time based on selected hours
//     DateTime formattedendTime = now!.add(Duration(hours: _hours));
//
//     // Format dates for API
//     startTime = DateFormat("HH:mm:ss").format(now);
//     endTime = DateFormat("HH:mm:ss").format(formattedendTime);
//
//     extra = DateTime.now().isAfter(formattedendTime) ? "yes" : "no";
//
//     print("startDateTime.value ${startDateTime.value}");
//     print("StartTime $startTime");
//     print("EndTime $endTime");
//     print("selectedHour $selectedHour");
//     print("extra $extra");
//
//     // Call payment calculation API
//     paymentController.paymentCalApi(
//         "", "", "", startTime, endTime, selectedHour,isNavigator==true? "hourly":"outStation", extra, "");
//   }

  void _callPaymentApi() {
    print("Calling Payment API with:");
    print("Distance: ${tripDistance?.round() ?? 0} km");
    print("Hours: $_hours");
    print("Car Type: ${selectedCar.value}");

    // Get start time/date from picker (fallback to now)
    DateTime startDT = startDateTime.value ?? DateTime.now();
    DateTime endDT = endDateTime.value ?? startDT.add(Duration(hours: _hours));

    // Format for API
    String startDate = DateFormat("yyyy-MM-dd").format(startDT);
    String startTime = DateFormat("HH:mm:ss").format(startDT);
    String endDate = DateFormat("yyyy-MM-dd").format(endDT);
    String endTime = DateFormat("HH:mm:ss").format(endDT);

    // Extra condition
    extra = DateTime.now().isAfter(endDT) ? "yes" : "no";

    print("🕐 startDate: $startDate | startTime: $startTime");
    print("🕐 endDate: $endDate | endTime: $endTime");
    print("isNavigator: $isNavigator → type: ${isNavigator ? "hourly" : "outstation"}");
    print("Hours: $_hours | extra: $extra");

    // Decide body based on trip type
    if (isNavigator) {
      // HOURLY TRIP BODY
      final body = {
        "type": "hourly",
        "startTime": startTime,
        "endTime": endTime,
        "expectedEnd": _hours,
        "extra": extra,
      };
      print("📦 HOURLY Payload → $body");

      paymentController.paymentCalApi(
        "", // bookingId (if not required)
        "", // startDate (not needed for hourly)
        "", // endDate (not needed for hourly)
        startTime,
        endTime,
        "$_hours",
        "hourly",
        extra,
        "",
      );
    } else {
      // OUTSTATION TRIP BODY
      final body = {
        "type": "outstation",
        "startDate": startDate,
        "endDate": endDate,
        "startTime": startTime,
        "endTime": endTime,
        "extra": extra,
        "discount": "ADI666",
      };
      print("📦 OUTSTATION Payload → $body");

      paymentController.paymentCalApi(
        "",
        startDate,
        endDate,
        startTime,
        endTime,
        selectedHour,
        "outStation",
        extra,
        "ADI666",
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text(
          "Trip details",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Map Section
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 300,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: sourceLocation.value!,
                    zoom: 12,
                  ),
                  mapType: MapType.normal,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  onMapCreated: (controller) => _onMapCreated(
                    controller,
                    sourceLocation.value!,
                    destinationLocation.value!,
                  ),
                  markers: markers,
                  polylines: polylines,
                ),
              ),
            ),
            const SizedBox(height: 30),

            /// Pickup & Drop
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Today's vehicle
                    Row(
                      mainAxisAlignment: isNavigator != true
                          ? MainAxisAlignment.spaceBetween
                          : MainAxisAlignment.end,
                      children: [
                        if (isNavigator != true)
                          Text(
                              "Distance ${tripDistance?.toStringAsFixed(1)} km",
                              style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey)),
                      ],
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              SizedBox(height: 15),
                              Icon(Icons.circle, color: Colors.red, size: 14),
                              isNavigator != true
                                  ? SizedBox(height: 17)
                                  : SizedBox(height: 15),
                              isNavigator != true
                                  ? Icon(Icons.more_vert,
                                      size: 20, color: Colors.black)
                                  : SizedBox(
                                      width: 10,
                                    ),
                              isNavigator != true
                                  ? SizedBox(height: 17)
                                  : SizedBox(height: 0),
                              isNavigator != true
                                  ? Icon(Icons.circle,
                                      color: Colors.green, size: 14)
                                  : SizedBox(width: 10)
                            ],
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              children: [
                                _customTextField(sourceController),
                                const SizedBox(height: 12),
                                if (isNavigator != true)
                                  _customTextField(destinationController),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 1.h),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          /// ---- Car Dropdown ----
                          Expanded(
                            flex: 1,
                            child: Obx(
                              () => DropdownButtonFormField<String>(
                                value: selectedCar.value,
                                decoration: InputDecoration(
                                  labelText: 'Car name/type',
                                  labelStyle: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black54,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 16),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(
                                        color: Colors.black54, width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1.3),
                                  ),
                                ),
                                icon: const Icon(Icons.arrow_drop_down),
                                dropdownColor: Colors.white,
                                isExpanded: true,
                                items: [
                                  ...carList
                                      .map(
                                        (e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(
                                            e,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  const DropdownMenuItem(
                                    value: "__ADD__",
                                    child: Row(
                                      children: [
                                        Icon(Icons.add,
                                            color: Colors.redAccent, size: 18),
                                        SizedBox(width: 4),
                                        Text(
                                          "Add new car",
                                          style: TextStyle(
                                              color: Colors.redAccent,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                onChanged: (value) async {
                                  if (value == null) return;
                                  if (value == "__ADD__") {
                                    final newCarName = await Get.toNamed(
                                      RouteHelper().getAddNewCarScreen(),
                                      arguments: {
                                        "sourceLatitude":
                                            sourceLocation.value?.latitude,
                                        "sourceLongitude":
                                            sourceLocation.value?.longitude,
                                        "destinationLatitude":
                                            destinationLocation.value?.latitude,
                                        "destinationLongitude":
                                            destinationLocation
                                                .value?.longitude,
                                        "sourceLocation": sourceController.text,
                                        "destinationLocation":
                                            destinationController.text,
                                        "isNavigator": isNavigator,
                                      },
                                    );
                                    if (newCarName is String &&
                                        newCarName.trim().isNotEmpty) {
                                      final name = newCarName.trim();
                                      if (!carList.contains(name))
                                        carList.add(name);
                                      selectedCar.value = name;
                                    }
                                  } else {
                                    selectedCar.value = value;
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 0.5.h),

                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          // ---------------- START DATE & TIME ----------------
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                final DateTime? pickedDate =
                                    await showDatePicker(
                                  context: context,
                                  initialDate:
                                      startDateTime.value ?? DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100),
                                );

                                if (pickedDate != null) {
                                  final TimeOfDay? pickedTime =
                                      await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  );

                                  if (pickedTime != null) {
                                    startDateTime.value = DateTime(
                                      pickedDate.year,
                                      pickedDate.month,
                                      pickedDate.day,
                                      pickedTime.hour,
                                      pickedTime.minute,
                                    );
                                    _callPaymentApi();
                                  }
                                }
                              },
                              child: AbsorbPointer(
                                child: Obx(() => TextFormField(
                                      readOnly: true,
                                      decoration: InputDecoration(
                                        labelText: 'Select Pickup Date & Time',
                                        labelStyle: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black54,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 16),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          borderSide: const BorderSide(
                                              color: Colors.black, width: 1),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          borderSide: const BorderSide(
                                              color: Colors.black, width: 1.2),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        suffixIcon: const Icon(
                                            Icons.calendar_month_outlined,
                                            color: Colors.red),
                                      ),
                                      style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w600),
                                      controller: TextEditingController(
                                        text: startDateTime.value != null
                                            ? DateFormat("MMM d, h:mm a")
                                                .format(startDateTime.value!)
                                            : '',
                                      ),
                                    )),
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          // ---------------- END DATE & TIME ----------------
                          isNavigator != true
                              ? Expanded(
                                  child: GestureDetector(
                                    onTap: () async {
                                      final DateTime? pickedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: endDateTime.value ??
                                            startDateTime.value ??
                                            DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime(2100),
                                      );

                                      if (pickedDate != null) {
                                        final TimeOfDay? pickedTime =
                                            await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        );

                                        if (pickedTime != null) {
                                          endDateTime.value = DateTime(
                                            pickedDate.year,
                                            pickedDate.month,
                                            pickedDate.day,
                                            pickedTime.hour,
                                            pickedTime.minute,
                                          );
                                          _callPaymentApi();
                                        }
                                      }
                                    },
                                    child: AbsorbPointer(
                                      child: Obx(() => TextFormField(
                                            readOnly: true,
                                            decoration: InputDecoration(
                                              labelText:
                                                  'Select End Date & Time',
                                              labelStyle: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black54,
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 15),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                borderSide: const BorderSide(
                                                    color: Colors.black54,
                                                    width: 1),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                borderSide: const BorderSide(
                                                    color: Colors.black54,
                                                    width: 1.2),
                                              ),
                                              filled: true,
                                              fillColor: Colors.white,
                                              suffixIcon: const Icon(
                                                  Icons.access_time_outlined,
                                                  color: Colors.red),
                                            ),
                                            style: TextStyle(
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w600),
                                            controller: TextEditingController(
                                              text: endDateTime.value != null
                                                  ? DateFormat("MMM d, h:mm a")
                                                      .format(
                                                          endDateTime.value!)
                                                  : '',
                                            ),
                                          )),
                                    ),
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),

                    isNavigator == true
                        ? Container(
                            width: 100.w,
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.black, width: 1),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                /// LEFT — Label
                                Text(
                                  "Hours",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),

                                /// RIGHT — Stepper control
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // minus button
                                    InkWell(
                                      onTap: _decHour,
                                      borderRadius: BorderRadius.circular(8),
                                      child: const SizedBox(
                                        width: 36,
                                        height: 36,
                                        child: Center(
                                          child: Text(
                                            "−",
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // divider
                                    Container(
                                        width: 1,
                                        height: 28,
                                        color: Colors.black12),

                                    // value display
                                    SizedBox(
                                      width: 48,
                                      height: 36,
                                      child: Center(
                                        child: Text(
                                          "$_hours",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // divider
                                    Container(
                                        width: 1,
                                        height: 28,
                                        color: Colors.black12),

                                    // plus button
                                    InkWell(
                                      onTap: _incHour,
                                      borderRadius: BorderRadius.circular(8),
                                      child: const SizedBox(
                                        width: 36,
                                        height: 36,
                                        child: Center(
                                          child: Text(
                                            "+",
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : SizedBox(),
                    isNavigator == true ? SizedBox(height: 15) : SizedBox(),

                    /// Driver Info
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35),
                        border: Border.all(color: Colors.black),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.verified_user,
                              color: Colors.green, size: 20.sp),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "DRIVE-O-CALL",
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(height: 0.3.h),
                                Text(
                                  "Verified and tested driver",
                                  style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              final breakdown = _calculatePaymentBreakdown();

                              // String startDate = startDateTime.value != null
                              //     ? DateFormat("yyyy-MM-dd").format(startDateTime.value!)
                              //     : "";
                              // print("🕐 startDate: $startDate");
                              // String endDate = endDateTime.value != null
                              //     ? DateFormat("yyyy-MM-dd").format(endDateTime.value!)
                              //     : "";
                              // print("🕐 endDate: $endDate");

                              // ✅ Format start & end date/time directly from Rxn<DateTime>
                              String startDate = startDateTime.value != null
                                  ? DateFormat("yyyy-MM-dd").format(startDateTime.value!)
                                  : "";
                              String endDate = endDateTime.value != null
                                  ? DateFormat("yyyy-MM-dd").format(endDateTime.value!)
                                  : "";

                              String startTimeFormatted = startDateTime.value != null
                                  ? DateFormat("HH:mm:ss").format(startDateTime.value!)
                                  : "";
                              String endTimeFormatted = endDateTime.value != null
                                  ? DateFormat("HH:mm:ss").format(endDateTime.value!)
                                  : "";

                              print("🕐 startDate: $startDate | startTime: $startTimeFormatted");
                              print("🕐 endDate: $endDate | endTime: $endTimeFormatted");


                              Get.toNamed(
                                RouteHelper().getPaymentBreakdownScreen(),
                                arguments: {
                                  "type": isNavigator==true? "hourly":"outStation",
                                  "startDate": startDate,
                                  "endDate": endDate,
                                  // "startTime": startTime,
                                  // "endTime": endTime,
                                  "startTime": startTimeFormatted,
                                  "endTime": endTimeFormatted,
                                  "extra": extra,
                                  "discount": "ADI666",
                                  "expectedEnd": selectedHour
                                },
                              );
                            },
                            child: Icon(Icons.info_outline,
                                color: ConstColors().themeColor),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Obx(() => Text(
                                "₹${paymentController.totalAmount.value}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                    fontSize: 17.sp),
                              ))
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// Offers
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.camera_rounded,
                                color: Colors.red,
                                size: 35,
                              ),
                              SizedBox(width: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Offers",
                                      style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w700)),
                                  Text("Latest offers",
                                      style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey)),
                                ],
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              //Get.toNamed(RouteHelper().getAddNewCarScreen());
                            },
                            child: Text("Apply now",
                                style: TextStyle(
                                    fontSize: 15.sp,
                                    color: ConstColors().themeColor,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      /// Bottom Button
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
                // Load user data
                userNme = ls.getStringValue(ls.fullName) ?? "";
                email = ls.getStringValue(ls.email) ?? "";
                phoneNumber = ls.getStringValue(ls.mobileNumber) ?? "";

                // Pickup & Drop
                String pickUp = sourceController.text;
                String drop = isNavigator ? "" : destinationController.text;
                String startDate = "";
                String startTime = "";

                if (startDateTime.value != null) {
                  startDate = DateFormat("yyyy-MM-dd").format(startDateTime.value!);
                  startTime = DateFormat("HH:mm:ss").format(startDateTime.value!);
                  print("✅ Using selected startDateTime: $startDate $startTime");
                } else {
                  DateTime now = DateTime.now();
                  startDate = DateFormat("yyyy-MM-dd").format(now);
                  startTime = DateFormat("HH:mm:ss").format(now);
                  print("⚠️ startDateTime was null, using fallback current time: $startDate $startTime");
                }




                print("startDate :-- $startDate");
                print("startTime :-- $startTime");

                // Hours
                int expectedEnd = int.parse(selectedHour.split(" ")[0]);

                // Amount
                String amount = "300";
                print("selectedDateTime before parse: $selectedDateTime");

                final bookingId = await homeController.createBookingApi(
                  userNme,
                  phoneNumber,
                  email,
                  isNavigator == true ? "hourly" : "outStation",
                  pickUp,
                  expectedEnd,
                  paymentController.totalAmount.value,
                  startDate,
                  startTime,
                  selectedCar.value,
                  selectedTransmission.value,
                );

                if (bookingId != null) {
                  print('Booking created successfully with ID: $bookingId');

                  // Initialize & connect socket
                  SocketService()
                      .initSocket(baseUrl: 'https://docapi.nuke.co.in');
                  SocketService().connect();

                  // Join the booking room using the correct ID
                  SocketService().joinBookingRoom(bookingId: bookingId);

                  // Show searching UI
                  Get.bottomSheet(
                    DriverSearchingBottomSheet(
                      key: bottomSheetKey,
                      statusText: "Searching for nearby drivers...",
                    ),
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                  );

                  // Listen for assignment
                  SocketService().onDriverAssigned((eventData) {
                    debugPrint("Driver assigned: $eventData");
                    final driver = DriverInfo.fromMap(eventData);
                    bottomSheetKey.currentState?.showAssignedDriver(driver);
                  });
                } else {
                  CommonFunctions().alertDialog(
                    "Booking Failed",
                    "Please try again later",
                    "OK",
                    () => Get.back(),
                  );
                }
              },
              child: Text(
                "Request for Driver",
                style: TextStyle(fontSize: 16.sp, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _customTextField(TextEditingController controller) {
    return TextField(
      controller: controller,
      readOnly: true,
      style: TextStyle(fontSize: 14.sp, color: Colors.grey),
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: Colors.grey,
            )),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: Colors.grey,
            )),
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
        LengthLimitingTextInputFormatter(100),
      ],
    );
  }

  /// Get Current Location
  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      CommonFunctions().alertDialog(
        "Alert",
        "Location permission denied",
        "Ok",
        () => Get.back(),
      );
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    currentLocation.value = LatLng(position.latitude, position.longitude);

    if (mounted) {
      setState(() {
        markers.add(
          Marker(
            markerId: const MarkerId("currentLocation"),
            position: currentLocation.value!,
            infoWindow: const InfoWindow(title: "My Location"),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueBlue,
            ),
          ),
        );
      });
    }
  }

  /// Create Map with Polyline
  void _onMapCreated(
      GoogleMapController controller, LatLng source, LatLng destination) {
    _mapController = controller;

    markers.clear();
    polylines.clear();

    markers.add(
      Marker(
        markerId: const MarkerId("source"),
        position: source,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(
          title: "Pickup",
          snippet: "Tap to edit",
          onTap: () {
            // OneWayTripScreen
            Get.offNamed(
              RouteHelper().getOneWayTripScreen(),
              arguments: {
                "isNavigator": isNavigator,
                "editTarget": "source",
                "prefill": {
                  "address": sourceController.text,
                  "lat": source.latitude,
                  "lng": source.longitude,
                },
                "existingDrop": (destinationLocation.value != null)
                    ? {
                        "address": destinationController.text,
                        "lat": destinationLocation.value!.latitude,
                        "lng": destinationLocation.value!.longitude,
                      }
                    : null,
              },
            );
          },
        ),
        onTap: () {},
      ),
    );

    if (isNavigator != true) {
      // DROP marker with Edit action
      markers.add(
        Marker(
          markerId: const MarkerId("destination"),
          position: destination,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(
            title: "Drop",
            snippet: "Tap to edit",
            onTap: () {
              Get.offNamed(
                RouteHelper().getOneWayTripScreen(),
                arguments: {
                  "isNavigator": isNavigator,
                  "editTarget": "destination",
                  "prefill": {
                    "address": destinationController.text,
                    "lat": destination.latitude,
                    "lng": destination.longitude,
                  },
                },
              );
            },
          ),
        ),
      );

      polylines.add(
        Polyline(
          polylineId: const PolylineId("route"),
          color: Colors.black,
          width: 4,
          points: [source, destination],
        ),
      );
    }

    if (isNavigator) {
      _mapController?.animateCamera(CameraUpdate.newLatLngZoom(source, 14));
    } else {
      final bounds = LatLngBounds(
        southwest: LatLng(
          source.latitude <= destination.latitude
              ? source.latitude
              : destination.latitude,
          source.longitude <= destination.longitude
              ? source.longitude
              : destination.longitude,
        ),
        northeast: LatLng(
          source.latitude >= destination.latitude
              ? source.latitude
              : destination.latitude,
          source.longitude >= destination.longitude
              ? source.longitude
              : destination.longitude,
        ),
      );
      _mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    }

    setState(() {});
  }

  /// convert meters to km
  double calculateDistance(LatLng start, LatLng end) {
    return Geolocator.distanceBetween(
          start.latitude,
          start.longitude,
          end.latitude,
          end.longitude,
        ) /
        1000;
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  /// Calculate the payment for the ride
  Map<String, dynamic> _calculatePaymentBreakdown() {
    double hourlyRate = 188; // example base hourly rate
    int hours = int.parse(selectedHour.split(" ")[0]);
    double basePrice = hours * hourlyRate;
    // Late night charges (₹100 if pickup time between 9 PM and 4 AM)
    double lateNightCharges = 0;
    if (selectedDateTime != null) {
      DateTime selectedDT =
          DateFormat("d MMM, h:mm a").parse(selectedDateTime!);
      int hour = selectedDT.hour;
      if (hour >= 21 || hour < 4) {
        lateNightCharges = 100;
      }
    }

    // Platform fees (₹19 if base < 200)
    double platformFees = basePrice < 200 ? 19 : 0;

    // Total
    double total = basePrice + lateNightCharges + platformFees;
    print("total :-- $total");

    return {
      "basePrice": basePrice,
      "lateNightCharges": lateNightCharges,
      "platformFees": platformFees,
      "total": total,
      "hours": hours,
    };
  }

  Future carDetailPopup() {
    return showDialog(
      context: context,
      builder: (context) {
        String selectedTransmission = "Manual";
        String selectedCar = "Xuv 700";

        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Text(
                        "Select Car & Transmission",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "Transmission",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15.sp,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    // Transmission section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => selectedTransmission = "Manual"),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(
                                color: selectedTransmission == "Manual"
                                    ? Colors.red.shade50
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: selectedTransmission == "Manual"
                                      ? Colors.redAccent
                                      : Colors.transparent,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (selectedTransmission == "Manual")
                                    const Icon(Icons.check_circle,
                                        color: Colors.redAccent, size: 20),
                                  if (selectedTransmission == "Manual")
                                    const SizedBox(width: 6),
                                  Text(
                                    "Manual",
                                    style: TextStyle(
                                      color: selectedTransmission == "Manual"
                                          ? Colors.redAccent
                                          : Colors.black54,
                                      fontWeight:
                                          selectedTransmission == "Manual"
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(
                                () => selectedTransmission = "Automatic"),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(
                                color: selectedTransmission == "Automatic"
                                    ? Colors.red.shade50
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: selectedTransmission == "Automatic"
                                      ? Colors.redAccent
                                      : Colors.transparent,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (selectedTransmission == "Automatic")
                                    const Icon(Icons.check_circle,
                                        color: Colors.redAccent, size: 20),
                                  if (selectedTransmission == "Automatic")
                                    const SizedBox(width: 6),
                                  Text(
                                    "Automatic",
                                    style: TextStyle(
                                      color: selectedTransmission == "Automatic"
                                          ? Colors.redAccent
                                          : Colors.black54,
                                      fontWeight:
                                          selectedTransmission == "Automatic"
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 2.h),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "My car",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15.sp,
                        ),
                      ),
                    ),

                    SizedBox(height: 1.h),

                    // Car cards
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Car 1
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => selectedCar = "Xuv 700"),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                color: selectedCar == "Xuv 700"
                                    ? Colors.red.shade50
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: selectedCar == "Xuv 700"
                                      ? Colors.redAccent
                                      : Colors.transparent,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      Icon(Icons.directions_car,
                                          size: 40,
                                          color: selectedCar == "Xuv 700"
                                              ? Colors.redAccent
                                              : Colors.black45),
                                      if (selectedCar == "Xuv 700")
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                                Icons.check_circle,
                                                size: 16,
                                                color: Colors.redAccent),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text("Xuv 700",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: selectedCar == "Xuv 700"
                                            ? Colors.black
                                            : Colors.black54,
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Car 2
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => selectedCar = "Ford"),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: selectedCar == "Ford"
                                    ? Colors.red.shade50
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: selectedCar == "Ford"
                                      ? Colors.redAccent
                                      : Colors.transparent,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      Icon(Icons.directions_car,
                                          size: 40,
                                          color: selectedCar == "Ford"
                                              ? Colors.redAccent
                                              : Colors.black45),
                                      if (selectedCar == "Ford")
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                                Icons.check_circle,
                                                size: 16,
                                                color: Colors.redAccent),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text("Ford",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: selectedCar == "Ford"
                                            ? Colors.black
                                            : Colors.black54,
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Add button
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              // You can add your car adding logic here
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                children: const [
                                  Icon(Icons.add,
                                      size: 40, color: Colors.black45),
                                  SizedBox(height: 6),
                                  Text(
                                    "Add",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 3.h),

                    // Confirm Button
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                "Selected: $selectedTransmission - $selectedCar"),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            "Confirm",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 1.h),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
