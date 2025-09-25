import 'package:drivio_sarthi/utils/AssetsImages.dart';
import 'package:drivio_sarthi/utils/CommonFunctions.dart';
import 'package:drivio_sarthi/utils/LocalStorage.dart';
import 'package:drivio_sarthi/utils/RouteHelper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';
import '../../controllers/HomeController.dart';
import '../../utils/ConstColors.dart';
import '../../utils/ConstStrings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  final PageController _pageController = PageController();
  var homeController = Get.find<HomeController>();
  String selectedTrip = "One Way";
  var dateTime = DateTime.now().obs;

  /// For google map
  var isMapLoading = true.obs;
  GoogleMapController? _mapController;
  var sourceLat = 0.0.obs;
  var sourceLong = 0.0.obs;
  var destinationLat = 0.0.obs;
  var destinationLong = 0.0.obs;
  Rxn<LatLng> sourceLocation = Rxn<LatLng>();
  Rxn<LatLng> destinationLocation = Rxn<LatLng>();
  Rxn<LatLng> currentLocation = Rxn<LatLng>();
  final Set<Marker> markers = {};
  final Set<Polyline> polylines = {};
  int _currentIndex = 0;

  final List<Map<String, String>> _pages = [
    {
      "image": AssetsImages().homeScreenImage,
    },
    {
      "image": AssetsImages().homeScreenImage,
    },
    {
      "image": AssetsImages().homeScreenImage,
    }
  ];

  @override
  void initState() {
    super.initState();
    // sourceLocation.value = LatLng(22.705313624334096, 75.90907346989012);
    // destinationLocation.value = LatLng(22.738078356773574, 75.89032710201927);
    CommonFunctions().getCurrentLocation();
    Future.delayed(Duration.zero, () {
      homeController.searchHistoryListApi(
          LocalStorage().getStringValue(LocalStorage().mobileNumber), 1, 20);
    });
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
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                    children: [
                      TextSpan(
                        text: " Driver",
                        style: TextStyle(
                            fontSize: 18.sp,
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
                    const SizedBox(width: 7),
                    InkWell(
                      onTap: () {
                        Get.toNamed(RouteHelper().getProfileScreen());
                      },
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.asset(
                            AssetsImages().profileImage,
                            height: 4.h,
                          )),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text("103, Kesar Bagh Road, Indore",
                    style: TextStyle(color: Colors.black54, fontSize: 14.sp)),
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
                            fontSize: 15.sp)),
                  ],
                ),
                Text("10 km",
                    style: TextStyle(
                        color: ConstColors().blackColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.5.sp)),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 30.h,
              width: double.infinity,
              child: Stack(
                children: [
                  // Google Map
                  Obx(
                        () => ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: ConstStrings().latitude.value != 0.0
                              ? LatLng(ConstStrings().latitude.value,
                              ConstStrings().longitude.value)
                              : LatLng(22.721354881593992, 75.86108525441043),
                          zoom: 15.0,
                        ),
                        mapType: MapType.normal,
                        onMapCreated: (GoogleMapController controller) {},
                        markers: {
                          Marker(
                            markerId: MarkerId('source'),
                            position: ConstStrings().latitude.value != 0.0
                                ? LatLng(ConstStrings().latitude.value,
                                ConstStrings().longitude.value)
                                : LatLng(22.721354881593992, 75.86108525441043),
                            infoWindow: InfoWindow(title: 'Source Location'),
                          ),
                        },
                      ),
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
                  Text(
                    "Start Booking",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Search bar with clock button
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Get.toNamed(RouteHelper().getOneWayTripScreen());
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            height: 45,
                            decoration: BoxDecoration(
                              color: const Color(0xfff2f2f2),
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(color: Colors.black, width: 1),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.search,
                                    color: Colors.grey, size: 26),
                                SizedBox(width: 8),
                                Text(
                                  "Find driver from?",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () {
                          CommonFunctions().dateTimePicker();
                        },
                        child: Container(
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
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // My Location
                  Obx(
                        () => Row(
                      children: [
                        const Icon(Icons.my_location, color: Colors.black),
                        const SizedBox(width: 8),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "My Location ",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 15.sp),
                                ),
                                TextSpan(
                                  text: ConstStrings().location.value,
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 15.sp),
                                ),
                              ],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Recent Location
                  Obx(
                        () => Row(
                      children: [
                        Icon(Icons.access_time, color: Colors.black),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            homeController.lastSearch.value,
                            style:
                            TextStyle(color: Colors.grey, fontSize: 15.sp),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
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
                      Text(
                        "Services",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "See all",
                        style: TextStyle(
                          fontSize: 14.sp,
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
                        serviceItem(AssetsImages().rupeesIcon, "Mv Coins"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
                height: 14.h,
                width: 100.w,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    Image.asset(
                      _pages[index]["image"]!,
                      width: 100.w,
                      fit: BoxFit.cover,
                    );
                  },
                )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                    (index) => Container(
                  margin: const EdgeInsets.all(4),
                  width: _currentIndex == index ? 12 : 8,
                  height: _currentIndex == index ? 12 : 8,
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? Colors.red
                        : Colors.grey.shade400,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
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
                  fontSize: 14.sp),
            ),
          ],
        ),
      ),
    );
  }

  Widget serviceItem(String image, String title) {
    return SizedBox(
      height: 110,
      child: Column(
        children: [
          Container(
            width: 25.w,
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.symmetric(horizontal: 7),
            decoration: BoxDecoration(
                color: Color(0xFFDDE3E3),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Image.asset(
              image,
              height: 60,
              width: 50,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
