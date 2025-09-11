import 'package:drivio_sarthi/utils/AssetsImages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';
import '../../utils/ConstColors.dart';
import 'ProfileScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  String selectedTrip = "One Way";

  /// For google map
  var isMapLoading = true.obs;
  GoogleMapController? _mapController;
  var sourceLat = 0.0.obs;
  var sourceLong = 0.0.obs;
  var destinationLat = 0.0.obs;
  var destinationLong = 0.0.obs;
  Rxn<LatLng> sourceLocation = Rxn<LatLng>();
  Rxn<LatLng> destinationLocation = Rxn<LatLng>();
  var markers = <Marker>{}.obs;
  var polylines = <Polyline>{}.obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sourceLocation.value = LatLng(22.705313624334096, 75.90907346989012);
    destinationLocation.value = LatLng(22.738078356773574, 75.89032710201927);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    text: "Book",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                    children: [
                      TextSpan(
                        text: " Driver",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: ConstColors().themeColor),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Stack(
                      children: [
                        const Icon(
                          Icons.notifications_none,
                          color: Colors.black,
                          size: 35,
                        ),
                        Positioned(
                          right: 6,
                          top: 3,
                          child: Container(
                            height: 10,
                            width: 10,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ProfileScreen()),
                        );
                      },
                      child: const CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://randomuser.me/api/portraits/men/1.jpg"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Text("103, Kesar Bagh Road, Indore",
                    style: TextStyle(color: Colors.black54)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16),
                    SizedBox(width: 4),
                    Text("Nearest available drivers",
                        style: TextStyle(
                            color: ConstColors().blackColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 15)),
                  ],
                ),
                Text("10 km",
                    style: TextStyle(
                        color: ConstColors().blackColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 15)),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 30.h,
              width: double.infinity,
              child: Stack(
                children: [
                  // Google Map
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          (sourceLat.value + destinationLat.value.toDouble()) /
                              2,
                          (sourceLong.value +
                                  destinationLong.value.toDouble()) /
                              2,
                        ),
                        zoom: 12.0,
                      ),
                      mapType: MapType.normal,
                      onMapCreated: (controller) => onMapCreated(
                        controller,
                        sourceLocation.value!,
                        destinationLocation.value!,
                      ),
                      markers: markers,
                      polylines: polylines,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            /// Trip Options
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  tripButton("One Way", Icons.repeat),
                  const SizedBox(width: 10),
                  tripButton("Round Trip", Icons.repeat),
                  const SizedBox(width: 10),
                  tripButton("OutStation", Icons.add_road),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  const Text(
                    "Start Booking",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Search bar with clock button
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          height: 45,
                          decoration: BoxDecoration(
                            color: const Color(0xfff2f2f2),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.search, color: Colors.grey, size: 26),
                              SizedBox(width: 8),
                              Text(
                                "Find driver from?",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        //height: 50,

                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.access_time,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // My Location
                  Row(
                    children: [
                      const Icon(Icons.my_location, color: Colors.black),
                      const SizedBox(width: 8),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "My Location ",
                              style: TextStyle(color: Colors.red, fontSize: 16),
                            ),
                            TextSpan(
                              text: "103, Kesar Bagh Road, Indore",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Recent Location
                  const Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.black),
                      SizedBox(width: 8),
                      Text(
                        "Pheneix Citadel , Indore",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Services",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "See all",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Horizontal List
                  SizedBox(
                    height: 130,
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: [
                        serviceItem(AssetsImages().walletIcon, "Vip Card"),
                        serviceItem(AssetsImages().handIcon, "Refer & Earn"),
                        serviceItem(AssetsImages().rupees, "Mv Coins"),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),

      // Bottom Nav
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xfff5f5f5),
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
                size: 30,
              ),
              label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.directions_car,
                size: 30,
              ),
              label: "My Drive"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.account_balance_wallet_outlined,
                size: 30,
              ),
              label: "Wallet"),
        ],
      ),
    );
  }

  Widget tripButton(String text, IconData icon) {
    bool isSelected = selectedTrip == text;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTrip = text;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? ConstColors().themeColor : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.black12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.black,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              text,
              style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget serviceItem(String image, String title) {
    return Container(
      // margin: const EdgeInsets.only(right: 16),
      height: 110,
      child: Column(
        children: [
          Container(
            width: 25.w,
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Image.asset(image, color: ConstColors().themeColor),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  /// For showing map
  void onMapCreated(
      GoogleMapController controller, LatLng source, LatLng destination) {
    _mapController = controller;

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

  /// For showing map
  void _addMarker() {
    setState(() {
      markers.addAll([
        Marker(
          markerId: const MarkerId('source'),
          position: sourceLocation.value!,
          infoWindow: const InfoWindow(title: 'Pickup Location'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
        Marker(
          markerId: const MarkerId('destination'),
          position: destinationLocation.value!,
          infoWindow: const InfoWindow(title: 'Delivery Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      ]);

      polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          visible: true,
          points: [sourceLocation.value!, destinationLocation.value!],
          width: 5,
          color: ConstColors().blackColor,
          patterns: [PatternItem.dot, PatternItem.gap(5)],
        ),
      );
    });
  }
}
