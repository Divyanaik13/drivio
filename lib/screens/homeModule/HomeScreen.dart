import 'package:drivio_sarthi/utils/AssetsImages.dart';
import 'package:drivio_sarthi/utils/CommonFunctions.dart';
import 'package:drivio_sarthi/utils/LocalStorage.dart';
import 'package:drivio_sarthi/utils/RouteHelper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';
import '../../controllers/HomeController.dart';
import '../../controllers/profileController.dart';
import '../../utils/ConstColors.dart';
import '../../utils/ConstStrings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var profileController = Get.find<ProfileController>();
  TextEditingController searchController = TextEditingController();
  final PageController _pageController = PageController();
  var homeController = Get.find<HomeController>();
  var selectedTrip = "One Way".obs;
  var dateTime = DateTime.now().obs;
  var isSelected = "".obs;
  var isNavigator = false.obs;
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var location = "".obs;
  var placeId = "".obs;

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
      final savedImage = LocalStorage().getStringValue(LocalStorage().profileImg);
      if (savedImage.isNotEmpty) {
        profileController.profileImageUrl.value = savedImage;
      } else {
        profileController.updateProfileApi(profileController.profileImageUrl.value);
      }

    });

  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    print("state :-- $state");
    if (state == AppLifecycleState.resumed) {
      ConstStrings().isResumed.value = true;
      if (!ConstStrings().isOtherLocation.value) {
        await CommonFunctions().determinePosition();
        print("state :--- OnResume");
        Future.delayed(Duration.zero, () async {
          if (ConstStrings().latitude.value != 0.0 &&
              ConstStrings().longitude.value != 0.0) {
            latitude.value = ConstStrings().latitude.value;
            longitude.value = ConstStrings().longitude.value;
            location.value = ConstStrings().location.value;

            print("latitude.value 1111 >> ${latitude.value}");
            print("location.value 1111 >> ${location.value}");
           // await storeListApi();
          } else {
            print("on resume else");

            Future.delayed(const Duration(milliseconds: 300), () {
              if (ConstStrings().serviceEnabled.value == true) {
                latitude.value = ConstStrings().latitude.value;
                longitude.value = ConstStrings().longitude.value;
                location.value = ConstStrings().location.value;
                print("on resume else ${ConstStrings().location.value}");
               // storeListApi();
              }
            });
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      body: Padding(
        padding: const EdgeInsets.all(20),
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
                        InkWell(
                          onTap: (){
                            Get.toNamed(RouteHelper().getNotificationScreen());
                          },
                          child: const Icon(
                            Icons.notifications_none,
                            color: Colors.black,
                            size: 35,
                          ),
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
                      child: Obx(() {
                        if (profileController.profileImageUrl.value.isNotEmpty) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.network(
                              profileController.profileImageUrl.value,
                              height: 4.h,
                              width: 4.h,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(AssetsImages().profileImage, height: 4.h),
                            ),
                          );
                        } else {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.asset(
                              AssetsImages().profileImage,
                              height: 4.h,
                            ),
                          );
                        }
                      }),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
        Obx(() => Row(
              children: [
                Text(ConstStrings().location.value,
                    style: TextStyle(color: Colors.black54, fontSize: 14.sp, fontWeight: FontWeight.w400)),
              ],
            )),
            const SizedBox(height: 16),
            SizedBox(
              height: 30.h,
              width: double.infinity,
              child: Stack(
                children: [
                  Obx(() {
                    if (ConstStrings().isLocationLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(), // Loader until location fetched
                      );
                    }

                    if (ConstStrings().latitude.value == 0.0 ||
                        ConstStrings().longitude.value == 0.0) {
                      return const Center(
                        child: Text('Fetching location...'),
                      );
                    }

                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            ConstStrings().latitude.value,
                            ConstStrings().longitude.value,
                          ),
                          zoom: 15.0,
                        ),
                        mapType: MapType.normal,
                        onMapCreated: (GoogleMapController controller) {},
                        markers: {
                          Marker(
                            markerId: const MarkerId('source'),
                            position: LatLng(
                              ConstStrings().latitude.value,
                              ConstStrings().longitude.value,
                            ),
                            infoWindow: const InfoWindow(title: 'Current Location'),
                          ),
                        },
                      ),
                    );
                  }),
                ],
              )
              /*Stack(
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
              ),*/
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Trip Options
                    Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        tripButton("One Way", Icons.keyboard_arrow_down_outlined, (){
                          selectedTrip.value = "One Way";
                          Get.toNamed(RouteHelper().getOneWayTripScreen(), arguments: true);
                        },
                      selectedTrip.value == "One Way",),
                         SizedBox(width: 10.sp),
                        tripButton("OutStation", Icons.add_road, (){
                          selectedTrip.value = "OutStation";
                          Get.toNamed(RouteHelper().getOneWayTripScreen());
                        },
                          selectedTrip.value == "OutStation",),
                      ],
                    ) ),


                 /*   const SizedBox(height: 16),

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
                            "Booking",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Search bar with clock button
                        *//*  Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Get.toNamed(
                                        RouteHelper().getOneWayTripScreen());
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    height: 45,
                                    decoration: BoxDecoration(
                                      color: const Color(0xfff2f2f2),
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(
                                          color: Colors.black, width: 1),
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

                          const SizedBox(height: 16),*//*

                          // My Location
                          Obx(
                            () => Row(
                              children: [
                                const Icon(Icons.my_location,
                                    color: Colors.black),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "My Location ",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 15.sp),
                                        ),
                                        TextSpan(
                                          text: ConstStrings().location.value,
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 15.sp),
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
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 15.sp),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),*/

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
                                InkWell(
                                  onTap: (){
                                    Get.toNamed(RouteHelper().getVipCardScreen());
                          },
                                  child: serviceItem(
                                      AssetsImages().walletIcon, "Vip Card"),
                                ),
                                serviceItem(
                                    AssetsImages().handIcon, "Refer & Earn"),
                                InkWell(
                                  onTap: (){
                                    Get.toNamed(RouteHelper().getMyCoinsScreen());
                                  },
                                  child: serviceItem(
                                      AssetsImages().rupeesIcon, "My Coins"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 15.h,
                      width: double.infinity,
                      child: AspectRatio(
                        aspectRatio: 2.5,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: _pages.length,
                          onPageChanged: (index) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  _pages[index]["image"]!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 1.h,
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

  Widget tripButton(String text, IconData icon, VoidCallback onTap, bool isSelected) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
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
              width: 10.sp,
            ),
            Text(
              text,
              style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.5.sp),
            ),
          ],
        ),
      ),
    );
  }

  Widget serviceItem(String image, String title) {
    return SizedBox(
      height: 110.h,
      child: Column(
        children: [
          Container(
            width: 25.w,
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(horizontal: 7),
            decoration: BoxDecoration(
                color: Color(0xFFDDE3E3),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Image.asset(
              image,
              height: 6.5.h,
              width: 6.w,
            ),
          ),
          SizedBox(height: 1.h),
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
