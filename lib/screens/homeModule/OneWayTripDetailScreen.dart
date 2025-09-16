import 'package:drivio_sarthi/utils/ConstColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../utils/CommonFunctions.dart';

class OneWayTripDetailScreen extends StatefulWidget {
  const OneWayTripDetailScreen({super.key});

  @override
  State<OneWayTripDetailScreen> createState() => _OneWayTripDetailScreenState();
}

class _OneWayTripDetailScreenState extends State<OneWayTripDetailScreen> {
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  String selectedHour = "2 hr";

  GoogleMapController? _mapController;
  Rxn<LatLng> sourceLocation = Rxn<LatLng>();
  Rxn<LatLng> destinationLocation = Rxn<LatLng>();
  Rxn<LatLng> currentLocation = Rxn<LatLng>();

  final Set<Marker> markers = {};
  final Set<Polyline> polylines = {};

  @override
  void initState() {
    super.initState();

    /// Default pickup & drop
    sourceLocation.value = const LatLng(22.705313624334096, 75.90907346989012); // Lig square indore
    destinationLocation.value = const LatLng(22.738078356773574, 75.89032710201927); // Phoenix mall indore

    _getCurrentLocation();
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
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: const [
                              SizedBox(height: 15),
                              Icon(Icons.circle, color: Colors.red, size: 14),
                              SizedBox(height: 15),
                              Icon(Icons.more_vert, size: 20, color: Colors.black),
                              SizedBox(height: 15),
                              Icon(Icons.circle, color: Colors.green, size: 14),
                            ],
                          ),
                          const SizedBox(width: 12),
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
                    ),
                    const SizedBox(height: 20),
                    /// Today's vehicle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Today's vehicle",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
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

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          decoration:BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.black),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.directions_car, color: ConstColors().themeColor,),
                              SizedBox(width: 10,),
                              Text("Xuv 700")
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          decoration:BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.black26),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.format_line_spacing, color: ConstColors().themeColor,),
                              SizedBox(width: 10,),
                              Text("Manual")
                            ],
                          ),
                        ),
                        
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// Pay as you go
                    const Text("Pay as you go",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                      child: Wrap(
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
                            fontSize: 13,
                            color: selectedHour == e ? Colors.white : Colors.black,
                          ),
                        ))
                            .toList(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// Driver Info
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.black12),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.verified_user, color: Colors.red, size: 32),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "Drivo\nVerified and Tested Driver",
                              style: TextStyle(fontSize: 13, height: 1.3),
                            ),
                          ),
                          Text(
                            "₹100",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// Offers
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
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );

    markers.add(
      Marker(
        markerId: const MarkerId("destination"),
        position: destination,
        infoWindow: const InfoWindow(title: "Drop"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
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

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
