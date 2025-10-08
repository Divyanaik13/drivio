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
import '../../network/SocketService.dart';
import '../../utils/CommonFunctions.dart';
import '../../utils/LocalStorage.dart';
import '../../utils/widgets/DriverSearchingBootmSheet.dart';

class OneWayTripDetailScreen extends StatefulWidget {
  const OneWayTripDetailScreen({super.key});

  @override
  State<OneWayTripDetailScreen> createState() => _OneWayTripDetailScreenState();
}

class _OneWayTripDetailScreenState extends State<OneWayTripDetailScreen> {
  TextEditingController sourceController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  var homeController = Get.find<HomeController>();
 // String? selectedHour;
  final TextEditingController manualController = TextEditingController();

  String selectedHour = "2 hour";
  String? selectedDateTime;
  double? tripDistance;
  bool isNavigator = false;
  var userNme = "";
  var phoneNumber = "";
  var email = "";
  RxString selectedTransmission = "Manual".obs;

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
  }

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load user info

    final args = Get.arguments;

    print(args);
    print("args");
    if (args != null) {
      double sourceLat = args["sourceLatitude"];
      double sourceLong = args["sourceLongitude"];
      double destinationLat = args["destinationLatitude"];
      double destinationLong = args["destinationLongitude"];
      String sourceLoc = args["sourceLocation"];
      String destinationLoc = args["destinationLocation"];
      String tempDateTime = args["dateTime"];
      isNavigator = args["isNavigator"] ?? false;

      /*DateTime parsedDate = DateTime.parse(tempDateTime);
      selectedDateTime = DateFormat("d MMM, h:mm a").format(parsedDate);*/
      if (tempDateTime != null && tempDateTime.isNotEmpty) {
        try {
          DateTime parsedDate = DateTime.parse(tempDateTime);
          selectedDateTime = DateFormat("d MMM, h:mm a").format(parsedDate);
        } catch (_) {
          selectedDateTime = DateFormat("d MMM, h:mm a").format(DateTime.now());
        }
      } else {
        selectedDateTime = DateFormat("d MMM, h:mm a").format(DateTime.now());
      }

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
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          ),
        );
      }

    } else {
      /// Default pickup & drop
      sourceLocation.value = const LatLng(
          22.705313624334096, 75.90907346989012); // Lig square indore
      destinationLocation.value = const LatLng(
          22.738078356773574, 75.89032710201927); // Phoenix mall indore
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text(
          "One way trip ↻",
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
                height: 200,
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
                            children:  [
                              SizedBox(height: 15),
                              Icon(Icons.circle, color: Colors.red, size: 14),
                              isNavigator != true ? SizedBox(height: 15) : SizedBox(height: 15),
                              isNavigator != true ? Icon(Icons.more_vert,
                                  size: 20, color: Colors.black):SizedBox(width: 10,),
                              isNavigator != true ? SizedBox(height: 15) : SizedBox(height: 0),
                              isNavigator != true ? Icon(Icons.circle, color: Colors.green, size: 14) : SizedBox(width: 10)
                            ],
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              children: [
                                _customTextField(
                                     sourceController),
                                const SizedBox(height: 12),
                                if(isNavigator != true)
                                  _customTextField(
                                      destinationController),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// Today's vehicle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.access_time,
                            size: 18.sp, color: Colors.red),
                        SizedBox(width: 5),
                        Text(selectedDateTime!,
                            style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w400)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if(isNavigator != true) Text("Distance ${tripDistance?.toStringAsFixed(1)} km",
                        style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey)),
                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 45.w,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.black),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.directions_car,
                                  color: ConstColors().themeColor,
                                  size: 18.5.sp),
                              SizedBox(
                                width: 3.w,
                              ),
                              InkWell(
                                onTap: (){
                                  carDetailPopup();
                                },
                                child: Text("Xuv 700",
                                    style: TextStyle(
                                      fontSize: 14.5.sp,
                                      fontWeight: FontWeight.w700,
                                    )),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 45.w,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.black26),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.format_line_spacing,
                                  color: ConstColors().themeColor,
                                  size: 18.5.sp),
                              SizedBox(
                                width: 3.w,
                              ),
                              Text("Manual",
                                  style: TextStyle(
                                    fontSize: 14.5.sp,
                                    fontWeight: FontWeight.w700,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// Pay as you go
                    Text("Pay as you go",
                        style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey)),
                    const SizedBox(height: 10),
                    Container(
                      width: 100.w,
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          // Dropdown for selecting hour
                          Expanded(
                            flex: 1,
                            child: DropdownButtonFormField<String>(
                              value: selectedHour,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                labelText: 'Select Hour',
                              ),
                              items: List.generate(12, (index) {
                                final hour = '${index + 1} hour';
                                return DropdownMenuItem(
                                  value: hour,
                                  child: Text(hour),
                                );
                              }),
                              onChanged: (value) {
                                setState(() {
                                  selectedHour = value!;
                                  manualController.clear(); // clear manual input if dropdown selected
                                });
                              },
                            ),
                          ),
                        /*  SizedBox(width: 10),
                          // OR manual entry
                          Expanded(
                            flex: 1,
                            child: TextField(
                              controller: manualController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Enter Hour',
                                hintText: 'e.g. 5',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  selectedHour = ""; // clear dropdown if manual entered
                                });
                              },
                            ),
                          ),*/
                        ],
                      ),
                    ),
                   /* Container(
                      width: 100.w,
                      padding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          "2 hr",
                          "4 hr",
                          "6 hr",
                          "8 hr",
                        ].map((e) {
                          final isSelected = selectedHour == e;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedHour = e;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 10),
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.red.shade100
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.red
                                      : Colors.transparent,
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                e,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected ? Colors.red : Colors.black,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),*/

                    const SizedBox(height: 10),

                    /// Driver Info
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35),
                        border: Border.all(color: Colors.black),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.verified_user,
                              color: Colors.black, size: 20.sp),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Drivio",
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(height: 0.3.h),
                                Text(
                                  "Verified and Tested Driver",
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
                          Get.toNamed(
                            RouteHelper().getPaymentBreakdownScreen(),
                            arguments: breakdown,
                          );
                        },
                        child: Icon(Icons.info_outline, color: ConstColors().themeColor),
                      ),
                          SizedBox(width: 10,),
                          Text(
                            "₹100",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                fontSize: 17.sp),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// Offers
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.camera_rounded, color: Colors.black),
                            SizedBox(width: 18),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Offers",
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w700)),
                                Text("Latest offers",
                                    style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.grey)),
                              ],
                            ),
                          ],
                        ),
                        Text("Apply now",
                            style: TextStyle(
                                fontSize: 15.sp,
                                color: ConstColors().themeColor,
                                fontWeight: FontWeight.w700)),
                      ],
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

                // Date & Time
                DateTime selectedDT =
                DateFormat("d MMM, h:mm a").parse(selectedDateTime!);
                String startDate = DateFormat("yyyy-MM-dd").format(selectedDT);
                String startTime = DateFormat("HH:mm:ss").format(selectedDT);

                // Vehicle info
                String carName = "Xuv 700";
                String carType = "Manual";

                // Hours
                int expectedEnd = int.parse(selectedHour.split(" ")[0]);

                // Amount
                String amount = "300";

                // Call API
              /*  bool success = await homeController.createBookingApi(
                  userNme,
                  phoneNumber,
                  email,
                  "hourly",
                  pickUp,
                  expectedEnd,
                  300,
                  startDate,
                  startTime,
                  carName,
                  carType,
                );*/

               /* if (success) {
                  // Initialize Socket
                  SocketService().initSocket();
                  print(" Socket initialized successfully");
                  // Show Bottom Sheet
                  Get.bottomSheet(
                    const DriverSearchingBottomSheet(
                      statusText: "Searching for nearby drivers...",
                    ),
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                  );

                  // Listen for real-time updates from backend
                  SocketService().listenEvent('joinBooking', (eventData) {
                    print("Driver assigned event: $eventData");

                    // Update your UI or bottom sheet dynamically
                    Get.bottomSheet(
                      DriverSearchingBottomSheet(
                        statusText: eventData['status'] ?? "Driver assigned!",
                      ),
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                    );
                  });
                } else {
                  CommonFunctions().alertDialog(
                    "Booking Failed",
                    "Please try again later",
                    "OK",
                        () => Get.back(),
                  );
                }*/
                final bookingId = await homeController.createBookingApi(
                  userNme,
                  phoneNumber,
                  email,
                  "hourly",
                  pickUp,
                  expectedEnd,
                  300,
                  startDate,
                  startTime,
                  carName,
                  carType,
                );

                if (bookingId != null) {
                  print('Booking created successfully with ID: $bookingId');

                  // Initialize & connect socket
                  SocketService().initSocket(baseUrl: 'https://docapi.nuke.co.in');
                  SocketService().connect();

                  // Join the booking room using the correct ID
                  SocketService().joinBookingRoom(bookingId: bookingId);

                  // Show searching UI
                  Get.bottomSheet(
                    const DriverSearchingBottomSheet(
                      statusText: "Searching for nearby drivers...",
                    ),
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                  );

                  // Listen for assignment
                  SocketService().onDriverAssigned((eventData) {
                    print("Driver assigned: $eventData");
                    final driverName = eventData['driverName'] ?? "Unknown";
                    final status = eventData['bookingStatus'] ?? "pending";

                    Get.bottomSheet(
                      DriverSearchingBottomSheet(
                        statusText: "Driver $driverName ($status)",
                      ),
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                    );
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

  Widget _customTextField( TextEditingController controller) {
    return TextField(
      controller: controller,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
       // hintText: hint,
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

  Widget _chip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.black),
          const SizedBox(width: 6),
          Text(text,
              style:
              const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
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

    // Always show source marker
    markers.add(
      Marker(
        markerId: const MarkerId("source"),
        position: source,
        infoWindow: const InfoWindow(title: "Current Location"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    );

    if (isNavigator != true) {
      markers.add(
        Marker(
          markerId: const MarkerId("destination"),
          position: destination,
          infoWindow: const InfoWindow(title: "Drop"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
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

    // Adjust camera bounds based on mode
    if (isNavigator) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(source, 14),
      );
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

      _mapController?.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 50),
      );
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
    ) / 1000;
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

    // GST (18%)
    double gst = (basePrice * 0.18).roundToDouble();

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
    double total = basePrice + gst + lateNightCharges + platformFees;
    print("total :-- $total");

    return {
      "basePrice": basePrice,
      "gst": gst,
      "lateNightCharges": lateNightCharges,
      "platformFees": platformFees,
      "total": total,
      "hours": hours,
    };
  }


  Future carDetailPopup(){
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
                            onTap: () => setState(() => selectedTransmission = "Manual"),
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
                                      fontWeight: selectedTransmission == "Manual"
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
                            onTap: () =>
                                setState(() => selectedTransmission = "Automatic"),
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
                                      fontWeight: selectedTransmission == "Automatic"
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
                            onTap: () => setState(() => selectedCar = "Xuv 700"),
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
                                            child: const Icon(Icons.check_circle,
                                                size: 16, color: Colors.redAccent),
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
                                            child: const Icon(Icons.check_circle,
                                                size: 16, color: Colors.redAccent),
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
                                  Icon(Icons.add, size: 40, color: Colors.black45),
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
