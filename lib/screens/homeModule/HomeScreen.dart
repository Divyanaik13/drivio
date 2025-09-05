import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'ProfileScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  String selectedTrip = "One Way";
  bool isMapLoading = true;
  GoogleMapController? mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                const Text("Hello!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Stack(
                      children: [
                        const Icon(Icons.notifications_none, color: Colors.black, size: 35,),
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
                      onTap: (){
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const ProfileScreen()),
                        );
                        //
                      },
                      child: const CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://randomuser.me/api/portraits/men/1.jpg"),
                      ),
                    ),
                    const SizedBox(width: 15),
                  ],
                ),

              ],
            ),
            const Text("Ramesh",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
            const SizedBox(height: 4),
            Row(
              children: [
                const Text("Sit back, relax, we’ll ",
                    style: TextStyle(color: Colors.black54)),
                const Text(" drive.",
                    style: TextStyle(color: Colors.green)),
              ],
            ),

            const SizedBox(height: 16),

            // Search Bar
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Search here",
                      prefixIcon: const Icon(Icons.location_on_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                CircleAvatar(
                  backgroundColor: Colors.green,
                  child: IconButton(
                    icon: const Icon(Icons.tune, color: Colors.white),
                    onPressed: () {},
                  ),
                )
              ],
            ),

            const SizedBox(height: 10),
            const Row(
              children: [
                Icon(Icons.location_on, size: 16),
                SizedBox(width: 4),
                Text("Nearest available drivers"),
              ],
            ),

            const SizedBox(height: 16),

            // Trip Options
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                tripButton("One Way", Icons.repeat),
                tripButton("Round Trip", Icons.repeat),
                tripButton("OutStation", Icons.add_road),
              ],
            ),

            const SizedBox(height: 16),

            // Map Dummy (Just Container)
            SizedBox(
              height: 400,
              width: double.infinity,
              child: Stack(
                children: [
                  // Google Map
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: GoogleMap(
                      initialCameraPosition: const CameraPosition(
                        target: LatLng(22.7196, 75.8577), // Indore coordinates
                        zoom: 12,
                      ),
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      zoomControlsEnabled: false,
                      onMapCreated: (GoogleMapController controller) {
                        mapController = controller;
                        setState(() {
                          isMapLoading = false;
                        });
                      },
                    ),
                  ),
                  if (isMapLoading)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          const Center(
                            child: CircularProgressIndicator(color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),


            const SizedBox(height: 16),

            // Driver Card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      "https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?cs=srgb&dl=pexels-italo-melo-881954-2379004.jpg&fm=jpg",
                      height: 100,
                      width: 90,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.directions_car, size: 18),
                            SizedBox(width: 6),
                            Text("Shyam Singh",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: const [
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            Text(" 4.8 (120 rides) "),
                            Text("· 2.2 KM Away"),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text("5 yrs experience · Verified license"),
                        const SizedBox(height: 4),
                        const Text("₹250/hour  |  Available",
                            style: TextStyle(color: Colors.green)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text("Schedule"),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              onPressed: () {},
                              child: const Text("Hire Now"),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),

      // Bottom Nav
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor:Colors.green.shade50,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined, size: 30,), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.directions_car, size: 30,), label: "My Drive"),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined, size: 30,), label: "Wallet"),
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.black12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.black,
            ),
            SizedBox(width: 10,),
            Text(
              text,
              style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
