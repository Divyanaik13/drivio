import 'package:drivio_sarthi/utils/CommonWidgets.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MyCoinsScreen extends StatelessWidget {
  const MyCoinsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidgets.appBarWidget("My Coins"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              const SizedBox(height: 20),

              // Balance Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello Ramesh",
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Your available balance",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "0.0",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Expanded(
                child: DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TabBar(
                          indicatorColor: Colors.white,
                          labelColor: Colors.white,
                          dividerColor: Colors.transparent,
                          unselectedLabelColor: Colors.white,
                          tabs: const <Widget>[
                            Tab(
                                text: "Transfer",
                                icon: Icon(Icons.compare_arrows)),
                            Tab(text: "Top up", icon: Icon(Icons.wallet)),
                            Tab(text: "History", icon: Icon(Icons.history)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          children: <Widget>[
                            Center(child: Text(" Transfer")),
                            Center(child: Text("Top up")),
                            Center(child: Text("History")),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
