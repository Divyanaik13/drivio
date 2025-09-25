import 'package:drivio_sarthi/utils/ConstColors.dart';
import 'package:drivio_sarthi/utils/RouteHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../utils/CommonFunctions.dart';

class OneWayTripDetailScreen extends StatefulWidget {
  const OneWayTripDetailScreen({super.key});

  @override
  State<OneWayTripDetailScreen> createState() => _OneWayTripDetailScreenState();
}

class _OneWayTripDetailScreenState extends State<OneWayTripDetailScreen> {
  TextEditingController sourceController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  String selectedHour = "2 hr";
  String? selectedDateTime;
  double? tripDistance;

  GoogleMapController? _mapController;
  Rxn<LatLng> sourceLocation = Rxn<LatLng>();
  Rxn<LatLng> destinationLocation = Rxn<LatLng>();
  Rxn<LatLng> currentLocation = Rxn<LatLng>();

  final Set<Marker> markers = {};
  final Set<Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args != null) {
      double sourceLat = args["sourceLatitude"];
      double sourceLong = args["sourceLongitude"];
      double destinationLat = args["destinationLatitude"];
      double destinationLong = args["destinationLongitude"];
      String sourceLoc = args["sourceLocation"];
      String destinationLoc = args["destinationLocation"];
      String tempDateTime = args["dateTime"];

      DateTime parsedDate = DateTime.parse(tempDateTime);
      selectedDateTime = DateFormat("d MMM, h:mm a").format(parsedDate);

      sourceLocation.value = LatLng(sourceLat, sourceLong);
      destinationLocation.value = LatLng(destinationLat, destinationLong);

      sourceController.text = sourceLoc;
      destinationController.text = destinationLoc;

      tripDistance =
          calculateDistance(sourceLocation.value!, destinationLocation.value!);
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
                height: 180,
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
                            children: const [
                              SizedBox(height: 15),
                              Icon(Icons.circle, color: Colors.red, size: 14),
                              SizedBox(height: 15),
                              Icon(Icons.more_vert,
                                  size: 20, color: Colors.black),
                              SizedBox(height: 15),
                              Icon(Icons.circle, color: Colors.green, size: 14),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              children: [
                                _customTextField(
                                    "Lig square indore", sourceController),
                                const SizedBox(height: 12),
                                _customTextField("Phoenix -mall indore",
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Today's vehicle",
                          style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey),
                        ),
                        Row(
                          children: [
                            Icon(Icons.access_time,
                                size: 18, color: Colors.red),
                            SizedBox(width: 5),
                            Text(selectedDateTime!,
                                style: TextStyle(
                                    fontSize: 14.5.sp,
                                    fontWeight: FontWeight.w400)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text("Distance ${tripDistance?.toStringAsFixed(1)} km",
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
                              Text("Xuv 700",
                                  style: TextStyle(
                                    fontSize: 14.5.sp,
                                    fontWeight: FontWeight.w700,
                                  )),
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
                    ),

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
              onPressed: () {
                Get.toNamed(RouteHelper().getCardScreen());
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

    markers.add(
      Marker(
        markerId: const MarkerId("source"),
        position: source,
        infoWindow: const InfoWindow(title: "Pickup"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    );

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
}
